import { BadRequestException, HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { OtpPurpose } from '@prisma/client';
import { createHash, randomInt, timingSafeEqual } from 'crypto';
import { SmsService } from '../../common/sms/sms.service';
import { env } from '../../config/env';
import { PrismaService } from '../../prisma/prisma.service';

const RESEND_COOLDOWN_MS = 60_000;

function hash(code: string, destination: string) {
  // Le hachage inclut la destination : un code volé ne sert à rien ailleurs.
  return createHash('sha256').update(`${destination}:${code}:${env.jwt.accessSecret}`).digest('hex');
}

/**
 * Codes à usage unique stockés hachés en base, avec expiration,
 * nombre d'essais limité et délai minimal entre deux envois.
 */
@Injectable()
export class OtpService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly sms: SmsService,
  ) {}

  async issue(destination: string, purpose: OtpPurpose, userId?: string): Promise<{ devCode?: string }> {
    const last = await this.prisma.otpCode.findFirst({
      where: { destination, purpose },
      orderBy: { createdAt: 'desc' },
    });
    if (last && Date.now() - last.createdAt.getTime() < RESEND_COOLDOWN_MS) {
      throw new HttpException(
        { code: 'OTP_COOLDOWN', message: 'Veuillez patienter une minute avant de demander un nouveau code' },
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }

    // Invalide les codes précédents encore actifs.
    await this.prisma.otpCode.updateMany({
      where: { destination, purpose, consumedAt: null },
      data: { consumedAt: new Date() },
    });

    const code = randomInt(0, 1_000_000).toString().padStart(6, '0');
    await this.prisma.otpCode.create({
      data: {
        destination,
        purpose,
        userId,
        codeHash: hash(code, destination),
        expiresAt: new Date(Date.now() + env.otp.ttlSeconds * 1000),
      },
    });

    await this.sms.send(destination, `UniParent AFRAM : votre code est ${code}. Il expire dans ${Math.round(env.otp.ttlSeconds / 60)} min. Ne le partagez jamais.`);
    return env.otp.devEcho ? { devCode: code } : {};
  }

  async verify(destination: string, purpose: OtpPurpose, code: string): Promise<void> {
    const otp = await this.prisma.otpCode.findFirst({
      where: { destination, purpose, consumedAt: null },
      orderBy: { createdAt: 'desc' },
    });
    if (!otp || otp.expiresAt < new Date()) {
      throw new BadRequestException({ code: 'OTP_EXPIRED', message: 'Code expiré ou introuvable, demandez-en un nouveau' });
    }
    if (otp.attempts >= env.otp.maxAttempts) {
      throw new BadRequestException({ code: 'OTP_LOCKED', message: "Trop d'essais. Demandez un nouveau code" });
    }

    const expected = Buffer.from(otp.codeHash, 'hex');
    const given = Buffer.from(hash(code, destination), 'hex');
    if (!timingSafeEqual(expected, given)) {
      await this.prisma.otpCode.update({ where: { id: otp.id }, data: { attempts: { increment: 1 } } });
      throw new BadRequestException({ code: 'OTP_INVALID', message: 'Code incorrect' });
    }

    await this.prisma.otpCode.update({ where: { id: otp.id }, data: { consumedAt: new Date() } });
  }
}

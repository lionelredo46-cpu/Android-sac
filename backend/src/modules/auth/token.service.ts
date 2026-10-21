import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { User } from '@prisma/client';
import { createHash, randomBytes, randomUUID } from 'crypto';
import { env } from '../../config/env';
import { PrismaService } from '../../prisma/prisma.service';

export interface SessionMeta {
  ip?: string | null;
  userAgent?: string | null;
}

export interface TokenPair {
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
}

const sha256 = (v: string) => createHash('sha256').update(v).digest('hex');

/**
 * Jetons : accès JWT court (15 min) + refresh opaque rotatif stocké haché.
 * Réutiliser un refresh déjà consommé révoque toute la famille de sessions
 * (détection de vol de jeton).
 */
@Injectable()
export class TokenService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly jwt: JwtService,
  ) {}

  async issue(user: Pick<User, 'id' | 'role'>, meta: SessionMeta, familyId: string = randomUUID()): Promise<TokenPair> {
    const secret = randomBytes(48).toString('base64url');
    const session = await this.prisma.userSession.create({
      data: {
        userId: user.id,
        familyId,
        tokenHash: sha256(secret),
        expiresAt: new Date(Date.now() + env.jwt.refreshTtlDays * 86_400_000),
        adresseIp: meta.ip ?? null,
        userAgent: meta.userAgent?.slice(0, 255) ?? null,
      },
    });

    const accessToken = this.jwt.sign(
      { sub: user.id, role: user.role, sid: session.id },
      { secret: env.jwt.accessSecret, expiresIn: env.jwt.accessTtl },
    );
    const decoded = this.jwt.decode(accessToken) as { exp: number; iat: number };
    return { accessToken, refreshToken: secret, expiresIn: decoded.exp - decoded.iat };
  }

  async rotate(refreshToken: string, meta: SessionMeta) {
    const session = await this.prisma.userSession.findUnique({
      where: { tokenHash: sha256(refreshToken) },
      include: { user: true },
    });
    if (!session) throw new UnauthorizedException({ code: 'REFRESH_INVALID', message: 'Session invalide' });

    if (session.revokedAt) {
      // Jeton déjà utilisé : on coupe toute la chaîne.
      await this.revokeFamily(session.familyId);
      throw new UnauthorizedException({ code: 'REFRESH_REUSED', message: 'Session compromise, reconnectez-vous' });
    }
    if (session.expiresAt < new Date()) {
      throw new UnauthorizedException({ code: 'REFRESH_EXPIRED', message: 'Session expirée, reconnectez-vous' });
    }
    if (session.user.status !== 'ACTIVE' || session.user.deletedAt) {
      throw new UnauthorizedException({ code: 'ACCOUNT_INACTIVE', message: "Ce compte n'est pas actif" });
    }

    const pair = await this.issue(session.user, meta, session.familyId);
    const next = await this.prisma.userSession.findUnique({
      where: { tokenHash: sha256(pair.refreshToken) },
      select: { id: true },
    });
    await this.prisma.userSession.update({
      where: { id: session.id },
      data: { revokedAt: new Date(), replacedBy: next?.id },
    });
    return { pair, user: session.user };
  }

  revokeSession(sessionId: string) {
    return this.prisma.userSession.updateMany({
      where: { id: sessionId, revokedAt: null },
      data: { revokedAt: new Date() },
    });
  }

  revokeFamily(familyId: string) {
    return this.prisma.userSession.updateMany({
      where: { familyId, revokedAt: null },
      data: { revokedAt: new Date() },
    });
  }

  revokeAll(userId: string) {
    return this.prisma.userSession.updateMany({
      where: { userId, revokedAt: null },
      data: { revokedAt: new Date() },
    });
  }
}

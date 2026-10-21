import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { OtpPurpose, Prisma, UserRole, UserStatus } from '@prisma/client';
import * as bcrypt from 'bcrypt';
import { authenticator } from 'otplib';
import { AuditContext, AuditService } from '../../common/audit/audit.service';
import { PrismaService } from '../../prisma/prisma.service';
import {
  ActivateAccountDto,
  ChangePasswordDto,
  LoginDto,
  ResetPasswordDto,
  VerifyOtpDto,
} from './dto/auth.dto';
import { OtpService } from './otp.service';
import { TokenService } from './token.service';

const MAX_FAILED_ATTEMPTS = 5;
const LOCK_MINUTES = 15;
const BCRYPT_ROUNDS = 12;
// Hash factice : la vérification coûte le même temps que le compte existe ou non.
const DUMMY_HASH = bcrypt.hashSync('uniparent-timing-guard', BCRYPT_ROUNDS);

/** Rôles pour lesquels la 2FA est obligatoire (cahier des charges, module 1). */
export const TWO_FACTOR_REQUIRED_ROLES: UserRole[] = [
  UserRole.SUPER_ADMIN,
  UserRole.DIRECTION,
  UserRole.SCOLARITE,
  UserRole.COMPTABLE,
];

const userInclude = {
  parentProfile: true,
  studentProfile: { include: { group: { include: { program: true } } } },
  teacherProfile: true,
} satisfies Prisma.UserInclude;

type FullUser = Prisma.UserGetPayload<{ include: typeof userInclude }>;

function maskPhone(phone?: string | null) {
  if (!phone) return null;
  return phone.slice(0, 4) + '•'.repeat(Math.max(0, phone.length - 6)) + phone.slice(-2);
}

@Injectable()
export class AuthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly tokens: TokenService,
    private readonly otp: OtpService,
    private readonly audit: AuditService,
  ) {}

  // ---------------------------------------------------------------- Connexion
  async login(dto: LoginDto, ctx: AuditContext) {
    const identifier = dto.identifier.trim().toLowerCase();
    const user = await this.prisma.user.findFirst({
      where: { deletedAt: null, OR: [{ email: identifier }, { telephone: dto.identifier.trim() }] },
      include: userInclude,
    });

    // Même message et même coût (bcrypt) qu'il existe ou non : pas d'énumération de comptes.
    if (!user || !user.passwordHash) {
      await bcrypt.compare(dto.password, DUMMY_HASH);
      throw new UnauthorizedException({ code: 'INVALID_CREDENTIALS', message: 'Identifiants incorrects' });
    }

    this.assertNotLocked(user);
    if (user.status === UserStatus.PENDING_ACTIVATION) {
      throw new ForbiddenException({ code: 'ACCOUNT_NOT_ACTIVATED', message: "Ce compte n'est pas encore activé" });
    }
    if (user.status !== UserStatus.ACTIVE) {
      throw new ForbiddenException({ code: 'ACCOUNT_INACTIVE', message: 'Ce compte est suspendu ou archivé' });
    }

    const ok = await bcrypt.compare(dto.password, user.passwordHash);
    if (!ok) {
      await this.registerFailure(user.id, user.failedAttempts, ctx);
      throw new UnauthorizedException({ code: 'INVALID_CREDENTIALS', message: 'Identifiants incorrects' });
    }

    if (user.twoFactorEnabled) {
      if (!dto.totpCode) {
        throw new UnauthorizedException({ code: 'TWO_FACTOR_REQUIRED', message: 'Code de double authentification requis' });
      }
      if (!user.twoFactorSecret || !authenticator.verify({ token: dto.totpCode, secret: user.twoFactorSecret })) {
        await this.registerFailure(user.id, user.failedAttempts, ctx);
        throw new UnauthorizedException({ code: 'TWO_FACTOR_INVALID', message: 'Code de double authentification invalide' });
      }
    }

    return this.completeLogin(user, ctx, 'LOGIN_PASSWORD');
  }

  async sendLoginOtp(phone: string) {
    const user = await this.prisma.user.findFirst({
      where: { telephone: phone, deletedAt: null, status: UserStatus.ACTIVE },
    });
    // Réponse identique si le numéro est inconnu (anti-énumération).
    const res = user ? await this.otp.issue(phone, OtpPurpose.LOGIN, user.id) : {};
    return { success: true, message: 'Si ce numéro est enregistré, un code a été envoyé', ...res };
  }

  async verifyLoginOtp(dto: VerifyOtpDto, ctx: AuditContext) {
    await this.otp.verify(dto.phone, OtpPurpose.LOGIN, dto.code);
    const user = await this.prisma.user.findFirst({
      where: { telephone: dto.phone, deletedAt: null },
      include: userInclude,
    });
    if (!user || user.status !== UserStatus.ACTIVE) {
      throw new UnauthorizedException({ code: 'ACCOUNT_INACTIVE', message: 'Aucun compte actif pour ce numéro' });
    }
    this.assertNotLocked(user);
    if (TWO_FACTOR_REQUIRED_ROLES.includes(user.role)) {
      // Les comptes d'administration ne se connectent pas par OTP SMS seul.
      throw new ForbiddenException({ code: 'PASSWORD_LOGIN_REQUIRED', message: 'Connexion par mot de passe + 2FA requise pour ce compte' });
    }
    return this.completeLogin(user, ctx, 'LOGIN_OTP');
  }

  // ---------------------------------------------------------------- Activation (parcours P1)
  async startActivation(activationCode: string) {
    const user = await this.findPendingByCode(activationCode);
    if (!user.telephone) {
      throw new BadRequestException('Aucun numéro de téléphone associé. Contactez la scolarité.');
    }
    const res = await this.otp.issue(user.telephone, OtpPurpose.ACTIVATION, user.id);
    return {
      success: true,
      maskedPhone: maskPhone(user.telephone),
      prenom: user.parentProfile?.prenom ?? user.studentProfile?.prenom ?? null,
      ...res,
    };
  }

  async activateAccount(dto: ActivateAccountDto, ctx: AuditContext) {
    const pending = await this.findPendingByCode(dto.activationCode);
    await this.otp.verify(pending.telephone!, OtpPurpose.ACTIVATION, dto.otpCode);

    const user = await this.prisma.user.update({
      where: { id: pending.id },
      data: {
        passwordHash: await bcrypt.hash(dto.newPassword, BCRYPT_ROUNDS),
        status: UserStatus.ACTIVE,
        activationToken: null,
        failedAttempts: 0,
        lockedUntil: null,
      },
      include: userInclude,
    });
    await this.audit.log({ ...ctx, userId: user.id }, 'ACCOUNT_ACTIVATED', 'User', user.id, { status: pending.status }, { status: user.status });
    return this.completeLogin(user, ctx, 'LOGIN_ACTIVATION');
  }

  // ---------------------------------------------------------------- Jetons
  async refresh(refreshToken: string, ctx: AuditContext) {
    const { pair } = await this.tokens.rotate(refreshToken, ctx);
    return pair;
  }

  async logout(sessionId: string, userId: string, ctx: AuditContext) {
    await this.tokens.revokeSession(sessionId);
    await this.audit.log(ctx, 'LOGOUT', 'User', userId);
    return { success: true };
  }

  async logoutAll(userId: string, ctx: AuditContext) {
    await this.tokens.revokeAll(userId);
    await this.prisma.deviceToken.deleteMany({ where: { userId } });
    await this.audit.log(ctx, 'LOGOUT_ALL_DEVICES', 'User', userId);
    return { success: true, message: 'Déconnecté de tous les appareils' };
  }

  // ---------------------------------------------------------------- Mot de passe
  async forgotPassword(identifier: string) {
    const user = await this.findByIdentifier(identifier);
    let res = {};
    if (user?.telephone && user.status === UserStatus.ACTIVE) {
      res = await this.otp.issue(user.telephone, OtpPurpose.RESET_PASSWORD, user.id);
    }
    return { success: true, message: 'Si ce compte existe, un code de réinitialisation a été envoyé', ...res };
  }

  async resetPassword(dto: ResetPasswordDto, ctx: AuditContext) {
    const user = await this.findByIdentifier(dto.identifier);
    if (!user?.telephone) throw new BadRequestException({ code: 'OTP_INVALID', message: 'Code incorrect' });
    await this.otp.verify(user.telephone, OtpPurpose.RESET_PASSWORD, dto.code);

    await this.prisma.user.update({
      where: { id: user.id },
      data: { passwordHash: await bcrypt.hash(dto.newPassword, BCRYPT_ROUNDS), failedAttempts: 0, lockedUntil: null },
    });
    await this.tokens.revokeAll(user.id);
    await this.audit.log({ ...ctx, userId: user.id }, 'PASSWORD_RESET', 'User', user.id);
    return { success: true, message: 'Mot de passe réinitialisé. Reconnectez-vous.' };
  }

  async changePassword(userId: string, dto: ChangePasswordDto, ctx: AuditContext) {
    const user = await this.prisma.user.findUniqueOrThrow({ where: { id: userId } });
    if (!(await bcrypt.compare(dto.currentPassword, user.passwordHash))) {
      throw new BadRequestException({ code: 'INVALID_PASSWORD', message: 'Mot de passe actuel incorrect' });
    }
    await this.prisma.user.update({
      where: { id: userId },
      data: { passwordHash: await bcrypt.hash(dto.newPassword, BCRYPT_ROUNDS) },
    });
    await this.audit.log(ctx, 'PASSWORD_CHANGED', 'User', userId);
    return { success: true };
  }

  // ---------------------------------------------------------------- 2FA (TOTP)
  async setupTwoFactor(userId: string) {
    const user = await this.prisma.user.findUniqueOrThrow({ where: { id: userId } });
    if (user.twoFactorEnabled) throw new BadRequestException('La double authentification est déjà active');
    const secret = authenticator.generateSecret();
    await this.prisma.user.update({ where: { id: userId }, data: { twoFactorSecret: secret } });
    const label = user.email ?? user.telephone ?? userId;
    return { secret, otpauthUrl: authenticator.keyuri(label, 'UniParent AFRAM', secret) };
  }

  async enableTwoFactor(userId: string, code: string, ctx: AuditContext) {
    const user = await this.prisma.user.findUniqueOrThrow({ where: { id: userId } });
    if (!user.twoFactorSecret || !authenticator.verify({ token: code, secret: user.twoFactorSecret })) {
      throw new BadRequestException({ code: 'TWO_FACTOR_INVALID', message: 'Code invalide' });
    }
    await this.prisma.user.update({ where: { id: userId }, data: { twoFactorEnabled: true } });
    await this.audit.log(ctx, 'TWO_FACTOR_ENABLED', 'User', userId);
    return { success: true };
  }

  async disableTwoFactor(userId: string, code: string, ctx: AuditContext) {
    const user = await this.prisma.user.findUniqueOrThrow({ where: { id: userId } });
    if (TWO_FACTOR_REQUIRED_ROLES.includes(user.role)) {
      throw new ForbiddenException('La double authentification est obligatoire pour ce rôle');
    }
    if (!user.twoFactorSecret || !authenticator.verify({ token: code, secret: user.twoFactorSecret })) {
      throw new BadRequestException({ code: 'TWO_FACTOR_INVALID', message: 'Code invalide' });
    }
    await this.prisma.user.update({ where: { id: userId }, data: { twoFactorEnabled: false, twoFactorSecret: null } });
    await this.audit.log(ctx, 'TWO_FACTOR_DISABLED', 'User', userId);
    return { success: true };
  }

  // ---------------------------------------------------------------- Interne
  private async completeLogin(user: FullUser, ctx: AuditContext, action: string) {
    await this.prisma.user.update({
      where: { id: user.id },
      data: { failedAttempts: 0, lockedUntil: null, lastLoginAt: new Date() },
    });
    await this.audit.log({ ...ctx, userId: user.id }, action, 'User', user.id);
    const pair = await this.tokens.issue(user, ctx);
    return {
      ...pair,
      user: this.toPublicUser(user),
      twoFactorSetupRequired: TWO_FACTOR_REQUIRED_ROLES.includes(user.role) && !user.twoFactorEnabled,
    };
  }

  toPublicUser(user: FullUser) {
    return {
      id: user.id,
      email: user.email,
      telephone: user.telephone,
      role: user.role,
      status: user.status,
      preferredLocale: user.preferredLocale,
      twoFactorEnabled: user.twoFactorEnabled,
      parentProfile: user.parentProfile,
      studentProfile: user.studentProfile
        ? {
            id: user.studentProfile.id,
            matricule: user.studentProfile.matricule,
            nom: user.studentProfile.nom,
            prenom: user.studentProfile.prenom,
            groupe: user.studentProfile.group?.nom,
            filiere: user.studentProfile.group?.program?.nom,
          }
        : null,
      teacherProfile: user.teacherProfile,
    };
  }

  private assertNotLocked(user: { lockedUntil: Date | null }) {
    if (user.lockedUntil && user.lockedUntil > new Date()) {
      const minutes = Math.ceil((user.lockedUntil.getTime() - Date.now()) / 60_000);
      throw new ForbiddenException({
        code: 'ACCOUNT_LOCKED',
        message: `Compte temporairement bloqué. Réessayez dans ${minutes} minute(s).`,
      });
    }
  }

  private async registerFailure(userId: string, previous: number, ctx: AuditContext) {
    const attempts = previous + 1;
    const lock = attempts >= MAX_FAILED_ATTEMPTS;
    await this.prisma.user.update({
      where: { id: userId },
      data: {
        failedAttempts: lock ? 0 : attempts,
        lockedUntil: lock ? new Date(Date.now() + LOCK_MINUTES * 60_000) : null,
      },
    });
    if (lock) {
      await this.audit.log({ ...ctx, userId }, 'ACCOUNT_LOCKED', 'User', userId, null, { minutes: LOCK_MINUTES });
      throw new ForbiddenException({
        code: 'ACCOUNT_LOCKED',
        message: `Compte bloqué ${LOCK_MINUTES} minutes après ${MAX_FAILED_ATTEMPTS} tentatives infructueuses.`,
      });
    }
  }

  private async findPendingByCode(code: string) {
    const user = await this.prisma.user.findFirst({
      where: { activationToken: code.trim(), status: UserStatus.PENDING_ACTIVATION, deletedAt: null },
      include: { parentProfile: true, studentProfile: true },
    });
    if (!user) {
      throw new BadRequestException({ code: 'ACTIVATION_INVALID', message: "Code d'activation invalide ou déjà utilisé" });
    }
    return user;
  }

  private findByIdentifier(identifier: string) {
    const id = identifier.trim();
    return this.prisma.user.findFirst({
      where: { deletedAt: null, OR: [{ email: id.toLowerCase() }, { telephone: id }] },
    });
  }
}

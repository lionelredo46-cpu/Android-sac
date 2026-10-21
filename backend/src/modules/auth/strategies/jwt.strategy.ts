import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { UserStatus } from '@prisma/client';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { AuthUser } from '../../../common/access/child-access.service';
import { env } from '../../../config/env';
import { PrismaService } from '../../../prisma/prisma.service';

export interface JwtPayload {
  sub: string;
  role: string;
  sid: string; // identifiant de session (révocation côté serveur)
}

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private readonly prisma: PrismaService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: env.jwt.accessSecret,
    });
  }

  async validate(payload: JwtPayload): Promise<AuthUser> {
    const [user, session] = await Promise.all([
      this.prisma.user.findFirst({
        where: { id: payload.sub, deletedAt: null },
        include: { parentProfile: true, studentProfile: true, teacherProfile: true },
      }),
      this.prisma.userSession.findUnique({ where: { id: payload.sid } }),
    ]);

    if (!user) throw new UnauthorizedException('Utilisateur introuvable');
    // Session révoquée (déconnexion, déconnexion globale, réutilisation de refresh token).
    if (!session || session.revokedAt || session.userId !== user.id) {
      throw new UnauthorizedException('Session révoquée');
    }
    if (user.status !== UserStatus.ACTIVE) {
      throw new UnauthorizedException("Ce compte n'est pas actif");
    }
    if (user.lockedUntil && user.lockedUntil > new Date()) {
      throw new UnauthorizedException('Compte temporairement verrouillé');
    }

    return {
      id: user.id,
      email: user.email,
      telephone: user.telephone,
      role: user.role,
      parentId: user.parentProfile?.id ?? null,
      studentId: user.studentProfile?.id ?? null,
      teacherId: user.teacherProfile?.id ?? null,
      sessionId: session.id,
    };
  }
}

import { CanActivate, ExecutionContext, ForbiddenException, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { UserRole } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { IS_PUBLIC_KEY, PERMISSIONS_KEY, ROLES_KEY } from '../decorators/roles.decorator';

const CACHE_TTL_MS = 60_000;

/**
 * Garde RBAC global : vérifie à la fois les rôles (@Roles) et les permissions
 * granulaires (@RequirePermissions) lues en base (table RolePermission).
 */
@Injectable()
export class RolesGuard implements CanActivate {
  private cache = new Map<UserRole, { perms: Set<string>; at: number }>();

  constructor(
    private readonly reflector: Reflector,
    private readonly prisma: PrismaService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const targets = [context.getHandler(), context.getClass()];
    if (this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, targets)) return true;

    const roles = this.reflector.getAllAndOverride<UserRole[]>(ROLES_KEY, targets);
    const perms = this.reflector.getAllAndOverride<string[]>(PERMISSIONS_KEY, targets);
    if ((!roles || roles.length === 0) && (!perms || perms.length === 0)) return true;

    const { user } = context.switchToHttp().getRequest();
    if (!user?.role) throw new ForbiddenException('Accès refusé : rôle introuvable');
    if (user.role === UserRole.SUPER_ADMIN) return true;

    if (roles?.length && !roles.includes(user.role)) {
      throw new ForbiddenException('Accès refusé : rôle non autorisé');
    }

    if (perms?.length) {
      const granted = await this.permissionsFor(user.role);
      const missing = perms.filter((p) => !granted.has(p));
      if (missing.length) {
        throw new ForbiddenException(`Accès refusé : permission manquante (${missing.join(', ')})`);
      }
    }
    return true;
  }

  async permissionsFor(role: UserRole): Promise<Set<string>> {
    const hit = this.cache.get(role);
    if (hit && Date.now() - hit.at < CACHE_TTL_MS) return hit.perms;
    const rows = await this.prisma.rolePermission.findMany({ where: { role } });
    const perms = new Set(rows.map((r) => r.permission));
    this.cache.set(role, { perms, at: Date.now() });
    return perms;
  }

  invalidate() {
    this.cache.clear();
  }
}

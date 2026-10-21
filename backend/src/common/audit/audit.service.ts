import { Global, Injectable, Module } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

export interface AuditContext {
  userId?: string | null;
  ip?: string | null;
  userAgent?: string | null;
}

type Tx = Prisma.TransactionClient | PrismaService;

/** Convertit les BigInt et dates pour un stockage JSON sûr. */
function toJson(value: unknown): Prisma.InputJsonValue | undefined {
  if (value === undefined || value === null) return undefined;
  return JSON.parse(
    JSON.stringify(value, (_k, v) => (typeof v === 'bigint' ? v.toString() : v)),
  );
}

/**
 * Journal d'audit en écriture seule. La table est protégée par un trigger
 * PostgreSQL qui interdit UPDATE et DELETE (voir migration init).
 */
@Injectable()
export class AuditService {
  constructor(private readonly prisma: PrismaService) {}

  async log(
    ctx: AuditContext,
    action: string,
    entite: string,
    entiteId: string,
    avant?: unknown,
    apres?: unknown,
    tx?: Tx,
  ) {
    const client = tx ?? this.prisma;
    await client.auditLog.create({
      data: {
        userId: ctx.userId ?? null,
        action,
        entite,
        entiteId,
        avant: toJson(avant),
        apres: toJson(apres),
        adresseIp: ctx.ip ?? null,
        userAgent: ctx.userAgent ?? null,
      },
    });
  }
}

@Global()
@Module({
  providers: [AuditService],
  exports: [AuditService],
})
export class AuditModule {}

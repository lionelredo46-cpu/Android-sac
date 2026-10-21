import { Request } from 'express';
import { AuditContext } from '../audit/audit.service';

export function auditCtx(req: Request, userId?: string | null): AuditContext {
  return {
    userId: userId ?? (req as any).user?.id ?? null,
    ip: (req.headers['x-forwarded-for'] as string)?.split(',')[0]?.trim() || req.ip || null,
    userAgent: (req.headers['user-agent'] as string) ?? null,
  };
}

export interface CursorPage<T> {
  items: T[];
  nextCursor: string | null;
}

/** Pagination par curseur (id) : on demande `take + 1` éléments pour savoir s'il y a une suite. */
export function toCursorPage<T extends { id: string }>(rows: T[], take: number): CursorPage<T> {
  const hasMore = rows.length > take;
  const items = hasMore ? rows.slice(0, take) : rows;
  return { items, nextCursor: hasMore ? items[items.length - 1].id : null };
}

export function clampTake(take?: number | string, max = 100, fallback = 20) {
  const n = Number(take);
  if (!Number.isFinite(n) || n <= 0) return fallback;
  return Math.min(Math.floor(n), max);
}

/** Formatage XAF : les montants sont stockés en entiers (unité = 1 FCFA). */
export function formatXaf(amount: bigint | number): string {
  return `${Number(amount).toLocaleString('fr-FR').replace(/ | /g, ' ')} FCFA`;
}

'use client';

import useSWR, { SWRConfiguration } from 'swr';

export class ApiError extends Error {
  constructor(
    message: string,
    public status: number,
    public code?: string,
  ) {
    super(message);
  }
}

/** Appel de l'API via le proxy serveur (/api/backend/...). */
export async function api<T = unknown>(path: string, init: RequestInit & { json?: unknown } = {}): Promise<T> {
  const { json, ...rest } = init;
  const res = await fetch(`/api/backend/${path.replace(/^\//, '')}`, {
    ...rest,
    headers: json !== undefined ? { 'Content-Type': 'application/json', ...(rest.headers ?? {}) } : rest.headers,
    body: json !== undefined ? JSON.stringify(json) : rest.body,
  });
  if (res.status === 401 && typeof window !== 'undefined') {
    window.location.href = `/login?next=${encodeURIComponent(window.location.pathname)}`;
  }
  const isJson = res.headers.get('content-type')?.includes('json');
  const body = isJson ? await res.json() : await res.text();
  if (!res.ok) {
    const b = body as { message?: string; code?: string };
    throw new ApiError(b?.message ?? `Erreur ${res.status}`, res.status, b?.code);
  }
  return body as T;
}

export function useApi<T>(path: string | null, config?: SWRConfiguration) {
  return useSWR<T>(path, (p: string) => api<T>(p), { revalidateOnFocus: false, ...config });
}

export const fmtMoney = (n: number | null | undefined, devise = 'XAF') =>
  `${new Intl.NumberFormat('fr-FR').format(Math.round(n ?? 0)).replace(/ | /g, ' ')} ${devise === 'XAF' ? 'FCFA' : devise}`;

export const fmtDate = (d: string | Date | null | undefined, withTime = false) =>
  d
    ? new Intl.DateTimeFormat('fr-FR', { dateStyle: 'medium', ...(withTime ? { timeStyle: 'short' } : {}), timeZone: 'Africa/Libreville' }).format(new Date(d))
    : '—';

export interface Page<T> {
  items: T[];
  nextCursor: string | null;
}

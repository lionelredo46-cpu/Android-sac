import { cookies } from 'next/headers';

export const API_URL = process.env.API_URL ?? 'http://127.0.0.1:3000';
export const ACCESS_COOKIE = 'up_access';
export const REFRESH_COOKIE = 'up_refresh';

/** Rôles autorisés dans le back-office (familles exclues). */
export const STAFF_ROLES = ['SUPER_ADMIN', 'DIRECTION', 'SCOLARITE', 'COMPTABLE', 'ENSEIGNANT', 'SUPPORT'];

const secure = process.env.NODE_ENV === 'production';

/** Les jetons ne sont jamais exposés au JavaScript du navigateur (cookies httpOnly). */
export async function setSessionCookies(accessToken: string, refreshToken: string, accessMaxAge = 900) {
  const jar = await cookies();
  jar.set(ACCESS_COOKIE, accessToken, { httpOnly: true, secure, sameSite: 'strict', path: '/', maxAge: accessMaxAge });
  jar.set(REFRESH_COOKIE, refreshToken, { httpOnly: true, secure, sameSite: 'strict', path: '/', maxAge: 60 * 60 * 24 * 30 });
}

export async function clearSessionCookies() {
  const jar = await cookies();
  jar.delete(ACCESS_COOKIE);
  jar.delete(REFRESH_COOKIE);
}

/** Rafraîchit la session à partir du refresh token (rotation côté API). */
export async function refreshSession(): Promise<string | null> {
  const jar = await cookies();
  const refresh = jar.get(REFRESH_COOKIE)?.value;
  if (!refresh) return null;
  const res = await fetch(`${API_URL}/api/v1/auth/refresh`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ refreshToken: refresh }),
    cache: 'no-store',
  });
  if (!res.ok) {
    await clearSessionCookies();
    return null;
  }
  const data = (await res.json()) as { accessToken: string; refreshToken: string; expiresIn: number };
  await setSessionCookies(data.accessToken, data.refreshToken, data.expiresIn);
  return data.accessToken;
}

import { NextResponse } from 'next/server';
import { API_URL, setSessionCookies, STAFF_ROLES } from '@/lib/session';

export async function POST(req: Request) {
  const body = await req.json();
  const res = await fetch(`${API_URL}/api/v1/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'X-Forwarded-For': req.headers.get('x-forwarded-for') ?? '' },
    body: JSON.stringify({ identifier: body.identifier, password: body.password, totpCode: body.totpCode || undefined }),
    cache: 'no-store',
  });
  const data = await res.json();
  if (!res.ok) return NextResponse.json(data, { status: res.status });

  if (!STAFF_ROLES.includes(data.user?.role)) {
    // Un compte parent/étudiant ne doit pas ouvrir de session dans le back-office.
    await fetch(`${API_URL}/api/v1/auth/logout`, { method: 'POST', headers: { Authorization: `Bearer ${data.accessToken}` } });
    return NextResponse.json({ code: 'FORBIDDEN', message: 'Accès réservé au personnel de l’AFRAM' }, { status: 403 });
  }

  await setSessionCookies(data.accessToken, data.refreshToken, data.expiresIn);
  return NextResponse.json({ user: data.user, twoFactorSetupRequired: data.twoFactorSetupRequired });
}

import { cookies } from 'next/headers';
import { NextResponse } from 'next/server';
import { ACCESS_COOKIE, API_URL, clearSessionCookies } from '@/lib/session';

export async function POST() {
  const token = (await cookies()).get(ACCESS_COOKIE)?.value;
  if (token) {
    await fetch(`${API_URL}/api/v1/auth/logout`, { method: 'POST', headers: { Authorization: `Bearer ${token}` } }).catch(() => undefined);
  }
  await clearSessionCookies();
  return NextResponse.json({ success: true });
}

import { cookies } from 'next/headers';
import { NextRequest, NextResponse } from 'next/server';
import { ACCESS_COOKIE, API_URL, refreshSession } from '@/lib/session';

/**
 * Proxy authentifié vers l'API : le navigateur ne voit jamais le JWT.
 * /api/backend/admin/stats/overview → {API_URL}/api/v1/admin/stats/overview
 */
async function forward(req: NextRequest, path: string[], token: string | undefined) {
  const url = `${API_URL}/api/v1/${path.map(encodeURIComponent).join('/')}${req.nextUrl.search}`;
  const headers = new Headers();
  const contentType = req.headers.get('content-type');
  if (contentType) headers.set('content-type', contentType);
  if (token) headers.set('authorization', `Bearer ${token}`);
  headers.set('x-forwarded-for', req.headers.get('x-forwarded-for') ?? '');
  headers.set('user-agent', req.headers.get('user-agent') ?? 'uniparent-admin');

  const hasBody = !['GET', 'HEAD'].includes(req.method);
  return fetch(url, {
    method: req.method,
    headers,
    body: hasBody ? await req.clone().arrayBuffer() : undefined,
    cache: 'no-store',
  });
}

async function handler(req: NextRequest, ctx: { params: Promise<{ path: string[] }> }) {
  const { path } = await ctx.params;
  let token = (await cookies()).get(ACCESS_COOKIE)?.value;
  if (!token) token = (await refreshSession()) ?? undefined;
  if (!token) return NextResponse.json({ code: 'UNAUTHORIZED', message: 'Session expirée' }, { status: 401 });

  let res = await forward(req, path, token);
  if (res.status === 401) {
    const fresh = await refreshSession();
    if (!fresh) return NextResponse.json({ code: 'UNAUTHORIZED', message: 'Session expirée' }, { status: 401 });
    res = await forward(req, path, fresh);
  }

  const out = new NextResponse(res.body, { status: res.status });
  for (const h of ['content-type', 'content-disposition', 'content-length']) {
    const v = res.headers.get(h);
    if (v) out.headers.set(h, v);
  }
  out.headers.set('cache-control', 'no-store');
  return out;
}

export { handler as GET, handler as POST, handler as PUT, handler as PATCH, handler as DELETE };

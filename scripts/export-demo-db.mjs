// Exporte les données de démonstration de l'API vers la base locale embarquée dans l'application
// (assets/demo/demo_db.json), utilisée par le mode « démo autonome » (sans serveur).
// Prérequis : base seedée (cd backend && npm run prisma:seed) + API démarrée.
// Usage : node scripts/export-demo-db.mjs [http://localhost:3000]
// Attention : le parcours d'activation de Clarisse est joué → relancer le seed ensuite.
import { mkdirSync, writeFileSync } from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const B = `${process.argv[2] ?? 'http://localhost:3000'}/api/v1`;
const PASSWORD = 'Afram2026!';
const ACTIVATION_CODE = 'AFRAM-2026-ACTIVATE';
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

async function call(method, p, { token, body } = {}) {
  for (let attempt = 0; ; attempt++) {
    const r = await fetch(B + p, {
      method,
      headers: { ...(body ? { 'Content-Type': 'application/json' } : {}), ...(token ? { Authorization: `Bearer ${token}` } : {}) },
      body: body ? JSON.stringify(body) : undefined,
    });
    // Limitation de débit de l'API (120 req/min, 5 connexions/min) : on patiente.
    if (r.status === 429 && attempt < 20) { await sleep(5000); continue; }
    const ct = r.headers.get('content-type') ?? '';
    if (ct.includes('json')) return { status: r.status, type: 'json', body: await r.json() };
    if (ct.includes('pdf')) return { status: r.status, type: 'pdf', body: Buffer.from(await r.arrayBuffer()).toString('base64') };
    return { status: r.status, type: 'text', body: await r.text() };
  }
}

/** Collecte toutes les réponses GET d'un compte, indexées par chemin (+ requête). */
async function collect(token) {
  const responses = {};
  const get = async (p) => {
    const r = await call('GET', p, { token });
    responses[p] = r;
    return r.status < 300 ? r.body : null;
  };

  await get('/me');
  const children = (await get('/me/children')) ?? [];
  await get('/payments/providers');
  await get('/calendar/events');
  await get('/announcements?take=50');
  await get('/appointments');
  await get('/appointments/hosts');
  await get('/notifications?take=200');
  await get('/notifications/unread-count');
  await get('/notification-preferences');
  const convs = await get('/conversations?take=100');
  for (const c of convs?.items ?? []) await get(`/conversations/${c.id}/messages`);

  for (const child of children) {
    const c = `/children/${child.id}`;
    await get(`${c}/dashboard`);
    for (const inv of (await get(`${c}/invoices`)) ?? []) await get(`/invoices/${inv.id}`);
    for (const p of (await get(`${c}/payments`)) ?? []) if (p.receipt) await get(`/receipts/${p.receipt.id}/pdf`);
    await get(`${c}/finance/summary`);
    await get(`${c}/payment-certificate.pdf`);
    await get(`${c}/attendance`);
    await get(`${c}/attendance/stats`);
    await get(`${c}/grades`);
    for (const s of (await get(`${c}/grades/history`)) ?? []) {
      const id = s.semesterId ?? s.id;
      await get(`${c}/grades?semesterId=${id}`);
      await get(`${c}/transcripts/${id}/pdf`);
    }
    await get(`${c}/grade-disputes`);
    // Emploi du temps : les semaines générées par le seed (de S-4 à S+1).
    const now = new Date();
    const monday = new Date(now.getFullYear(), now.getMonth(), now.getDate() - ((now.getDay() + 6) % 7));
    const from = new Date(monday.getTime() - 5 * 7 * 86_400_000).toISOString();
    const to = new Date(monday.getTime() + 3 * 7 * 86_400_000).toISOString();
    responses[`${c}/timetable`] = await call('GET', `${c}/timetable?from=${from}&to=${to}`, { token });
    await get(`${c}/timetable.ics`);
    for (const d of (await get(`${c}/documents`)) ?? []) await get(`/documents/${d.id}/download`);
    await get(`${c}/certificates/enrollment.pdf`);
    for (const r of (await get(`${c}/requests`)) ?? []) if (r.statut === 'DELIVRE' || r.documentDisponible) await get(`/requests/${r.id}/document`);
    await get(`${c}/discipline`);
  }
  return responses;
}

async function exportAccount(identifier) {
  const login = await call('POST', '/auth/login', { body: { identifier, password: PASSWORD } });
  if (login.status >= 300) throw new Error(`Connexion impossible pour ${identifier} : ${JSON.stringify(login.body)}`);
  const { accessToken, refreshToken, ...rest } = login.body;
  console.log(`→ ${identifier}`);
  return { identifier, login: rest, responses: await collect(accessToken) };
}

const accounts = [];
for (const id of ['parent@aframgabon.com', 'alexandre.obiang@etudiant.afram.ga', 'grace.obiang@etudiant.afram.ga', 'etudiant1@etudiant.afram.ga']) {
  accounts.push(await exportAccount(id));
}

// Parcours d'activation (Clarisse) : on le joue pour capturer les réponses réelles.
const start = await call('POST', '/auth/activate/start', { body: { activationCode: ACTIVATION_CODE } });
const activated = await call('POST', '/auth/activate', { body: { activationCode: ACTIVATION_CODE, otpCode: start.body.devCode, newPassword: PASSWORD } });
if (activated.status >= 300) throw new Error(`Activation impossible : ${JSON.stringify(activated.body)}`);
const { accessToken, refreshToken, ...activatedRest } = activated.body;
console.log('→ activation Clarisse');
const clarisse = { identifier: activatedRest.user.email ?? activatedRest.user.telephone, login: activatedRest, responses: await collect(accessToken) };
const { devCode, ...startRest } = start.body;

const db = {
  version: 1,
  exportedAt: new Date().toISOString(),
  password: PASSWORD,
  accounts,
  activation: { code: ACTIVATION_CODE, start: startRest, account: clarisse },
};
const out = path.join(ROOT, 'assets', 'demo', 'demo_db.json');
mkdirSync(path.dirname(out), { recursive: true });
writeFileSync(out, JSON.stringify(db));
const n = [...accounts, clarisse].reduce((s, a) => s + Object.keys(a.responses).length, 0);
console.log(`OK : ${n} réponses → ${path.relative(ROOT, out)} (${(JSON.stringify(db).length / 1024).toFixed(0)} Ko)`);

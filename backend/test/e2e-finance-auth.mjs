// Prérequis : base seedée (npm run prisma:seed) + API démarrée (npm run start:prod) + AUTH_RATE_LIMIT élevé en dev.
// Test de fumée de l'API UniParent (Node 24, fetch natif)
const B = 'http://localhost:3000/api/v1';
let fails = 0;
const ok = (cond, msg) => { console.log(`${cond ? 'OK ' : 'ERR'} ${msg}`); if (!cond) fails++; };
const j = async (method, path, { token, body, headers = {} } = {}) => {
  const r = await fetch(B + path, {
    method,
    headers: { 'Content-Type': 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}), ...headers },
    body: body ? JSON.stringify(body) : undefined,
  });
  const ct = r.headers.get('content-type') ?? '';
  return { status: r.status, data: ct.includes('json') ? await r.json() : await r.arrayBuffer(), ct };
};

const login = await j('POST', '/auth/login', { body: { identifier: 'parent@aframgabon.com', password: 'Afram2026!' } });
ok(login.status === 200 && login.data.accessToken, `login parent (${login.status})`);
const T = login.data.accessToken;

const bad = await j('POST', '/auth/login', { body: { identifier: 'parent@aframgabon.com', password: 'mauvais' } });
ok(bad.status === 401 && bad.data.code === 'INVALID_CREDENTIALS', `mauvais mot de passe -> 401 (${bad.data.code})`);

const kids = await j('GET', '/me/children', { token: T });
ok(kids.status === 200 && kids.data.length === 2, `2 enfants rattachés (${kids.data.length})`);
const alex = kids.data.find((k) => k.prenom === 'Alexandre');

const dash = await j('GET', `/children/${alex.id}/dashboard`, { token: T });
ok(dash.status === 200, `dashboard (${dash.status})`);
console.log('    finances:', JSON.stringify(dash.data.finances));
console.log('    presence:', dash.data.presence?.tauxAssiduiteMois, '% · moyenne', dash.data.resultats?.moyenneGenerale, '· alertes', dash.data.alertes?.map((a) => a.type).join(','));
ok(dash.data.finances.statut === 'EN_RETARD', 'tranche en retard détectée');

// IDOR : un étudiant d'une autre famille
const other = await j('POST', '/auth/login', { body: { identifier: 'etudiant1@etudiant.afram.ga', password: 'Afram2026!' } });
const idor = await j('GET', `/children/${alex.id}/dashboard`, { token: other.data.accessToken });
ok(idor.status === 403, `IDOR bloqué pour un autre étudiant (${idor.status})`);
const idorPay = await j('GET', `/children/${alex.id}/invoices`, { token: other.data.accessToken });
ok(idorPay.status === 403, `IDOR factures bloqué (${idorPay.status})`);

const inv = await j('GET', `/children/${alex.id}/invoices`, { token: T });
const late = inv.data.find((i) => i.statut === 'EN_RETARD');
ok(!!late && late.soldeRestant === 130000, `facture en retard, solde 130000 (${late?.soldeRestant})`);

const hist = await j('GET', `/children/${alex.id}/payments`, { token: T });
ok(hist.data.length === 2 && hist.data.some((p) => !p.enLigne && p.payeurType === 'ETUDIANT'), `historique avec versement guichet de l'étudiant (${hist.data.length})`);

// Paiement : idempotence + webhook sandbox signé
const key = crypto.randomUUID();
const noKey = await j('POST', '/payments/initiate', { token: T, body: { invoiceId: late.id, montant: 50000, canal: 'ONLINE_MOBILE_MONEY', provider: 'SANDBOX' } });
ok(noKey.status === 400, `paiement sans Idempotency-Key refusé (${noKey.status})`);
const tooMuch = await j('POST', '/payments/initiate', { token: T, headers: { 'Idempotency-Key': crypto.randomUUID() }, body: { invoiceId: late.id, montant: 999999, canal: 'ONLINE_MOBILE_MONEY', provider: 'SANDBOX' } });
ok(tooMuch.status === 400, `montant supérieur au solde refusé (${tooMuch.status})`);
const p1 = await j('POST', '/payments/initiate', { token: T, headers: { 'Idempotency-Key': key }, body: { invoiceId: late.id, montant: 50000, canal: 'ONLINE_MOBILE_MONEY', provider: 'SANDBOX' } });
const p2 = await j('POST', '/payments/initiate', { token: T, headers: { 'Idempotency-Key': key }, body: { invoiceId: late.id, montant: 50000, canal: 'ONLINE_MOBILE_MONEY', provider: 'SANDBOX' } });
ok(p1.status === 201 && p1.data.statut === 'EN_ATTENTE', `paiement initié EN_ATTENTE (${p1.status} ${p1.data.statut})`);
ok(p1.data.paymentId === p2.data.paymentId, 'double clic -> même paiement (idempotence)');

const fakeHook = await fetch(`${B}/payments/webhook/sandbox`, { method: 'POST', headers: { 'Content-Type': 'application/json', 'x-sandbox-signature': 'deadbeef' }, body: JSON.stringify({ reference: p1.data.reference, status: 'SUCCESS' }) });
ok(fakeHook.status === 403, `webhook à signature invalide rejeté (${fakeHook.status})`);

const conf = await j('POST', `/payments/${p1.data.paymentId}/sandbox/confirm`, { token: T, body: { success: true } });
ok(conf.data.statut === 'VALIDE' && conf.data.receipt?.id, `paiement validé avec reçu (${conf.data.statut})`);
const again = await j('POST', `/payments/${p1.data.paymentId}/sandbox/confirm`, { token: T, body: { success: true } });
const inv2 = await j('GET', `/invoices/${late.id}`, { token: T });
ok(inv2.data.soldeRestant === 80000, `solde 80000 après paiement, pas de double crédit (${inv2.data.soldeRestant})`);

const pdf = await j('GET', `/receipts/${conf.data.receipt.id}/pdf`, { token: T });
ok(pdf.status === 200 && pdf.ct.includes('pdf') && pdf.data.byteLength > 2000, `reçu PDF (${pdf.data.byteLength} octets)`);
const pdfIdor = await j('GET', `/receipts/${conf.data.receipt.id}/pdf`, { token: other.data.accessToken });
ok(pdfIdor.status === 403, `reçu inaccessible à un tiers (${pdfIdor.status})`);

const notifs = await j('GET', '/notifications/unread-count', { token: T });
ok(notifs.data.count >= 1, `notification de versement (${notifs.data.count} non lues)`);

// Refresh rotatif + détection de réutilisation
const r1 = await j('POST', '/auth/refresh', { body: { refreshToken: login.data.refreshToken } });
ok(r1.status === 200, `refresh (${r1.status})`);
const reuse = await j('POST', '/auth/refresh', { body: { refreshToken: login.data.refreshToken } });
ok(reuse.status === 401 && reuse.data.code === 'REFRESH_REUSED', `réutilisation détectée (${reuse.data.code})`);
const afterReuse = await j('GET', '/me', { token: r1.data.accessToken });
ok(afterReuse.status === 401, `famille révoquée après réutilisation (${afterReuse.status})`);

// RBAC : un parent ne peut pas saisir un paiement guichet
const p = await j('POST', '/auth/login', { body: { identifier: '+241066701184', password: 'Afram2026!' } });
const cash = await j('POST', '/admin/finance/payments/cash', { token: p.data.accessToken, body: { invoiceId: late.id, montant: 1000, canal: 'GUICHET_ESPECES', payeurType: 'PARENT' } });
ok(cash.status === 403, `parent -> saisie guichet interdite (${cash.status})`);

// Activation (P1)
const st = await j('POST', '/auth/activate/start', { body: { activationCode: 'AFRAM-2026-ACTIVATE' } });
ok(st.status === 200 && st.data.devCode, `activation : OTP envoyé à ${st.data.maskedPhone}`);
const act = await j('POST', '/auth/activate', { body: { activationCode: 'AFRAM-2026-ACTIVATE', otpCode: st.data.devCode, newPassword: 'Clarisse2026' } });
ok(act.status === 200 && act.data.accessToken, `compte activé (${act.status})`);
const ck = await j('GET', '/me/children', { token: act.data.accessToken });
ok(ck.data.length === 1 && ck.data[0].estPayeur === false, 'la mère voit son enfant (non payeuse)');
const motherPay = await j('POST', '/payments/initiate', { token: act.data.accessToken, headers: { 'Idempotency-Key': crypto.randomUUID() }, body: { invoiceId: late.id, montant: 1000, canal: 'ONLINE_MOBILE_MONEY', provider: 'SANDBOX' } });
ok(motherPay.status === 403, `tuteur non payeur ne peut pas payer (${motherPay.status})`);

console.log(fails ? `\n${fails} ÉCHEC(S)` : '\nTOUS LES TESTS PASSENT');
process.exit(fails ? 1 : 0);

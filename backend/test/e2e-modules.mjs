// Prérequis : base seedée (npm run prisma:seed) + API démarrée (npm run start:prod) + AUTH_RATE_LIMIT élevé en dev.
// Tests de bout en bout des modules 5 à 13
const B = 'http://localhost:3000/api/v1';
let fails = 0;
const ok = (c, m) => { console.log(`${c ? 'OK ' : 'ERR'} ${m}`); if (!c) fails++; };
const j = async (method, path, { token, body, form } = {}) => {
  const r = await fetch(B + path, {
    method,
    headers: { ...(form ? {} : { 'Content-Type': 'application/json' }), ...(token ? { Authorization: `Bearer ${token}` } : {}) },
    body: form ?? (body ? JSON.stringify(body) : undefined),
  });
  const ct = r.headers.get('content-type') ?? '';
  return { status: r.status, data: ct.includes('json') ? await r.json() : await r.text(), ct };
};
const login = async (id) => (await j('POST', '/auth/login', { body: { identifier: id, password: 'Afram2026!' } })).data.accessToken;
for (let i = 0; i < 30; i++) { try { if ((await fetch(B + '/health')).ok) break; } catch {} await new Promise((r) => setTimeout(r, 1000)); }

const P = await login('parent@aframgabon.com');
const kids = (await j('GET', '/me/children', { token: P })).data;
const alex = kids.find((k) => k.prenom === 'Alexandre');

// ---- Module 5 : présences
const att = await j('GET', `/children/${alex.id}/attendance`, { token: P });
ok(att.status === 200 && att.data.length > 20, `présences détaillées (${att.data.length})`);
const stats = await j('GET', `/children/${alex.id}/attendance/stats`, { token: P });
ok(stats.data.tauxGlobal > 80 && stats.data.parMatiere.length >= 5, `stats assiduité ${stats.data.tauxGlobal}% (${stats.data.parMatiere.length} matières)`);
const absence = att.data.find((a) => a.justifiable && a.statut === 'ABSENT');
const fd = new FormData();
fd.append('motif', 'Rendez-vous médical');
fd.append('fichier', new Blob([Buffer.from('%PDF-1.4 test')], { type: 'application/pdf' }), 'certif.pdf');
const just = await j('POST', `/absences/${absence.id}/justify`, { token: P, form: fd });
ok(just.status === 201 && just.data.statut === 'EN_ATTENTE', `justificatif envoyé (${just.status})`);
const bad = new FormData();
bad.append('motif', 'x');
bad.append('fichier', new Blob(['MZ'], { type: 'application/x-msdownload' }), 'virus.exe');
const badUp = await j('POST', `/absences/${absence.id}/justify`, { token: P, form: bad });
ok(badUp.status === 400, `fichier exécutable refusé (${badUp.status})`);

const SCO = await login('scolarite@aframgabon.com');
const pend = await j('GET', '/admin/justifications', { token: SCO });
ok(pend.data.length >= 1, `scolarité voit ${pend.data.length} justificatif(s) en attente`);
const rev = await j('PATCH', `/admin/justifications/${just.data.id}`, { token: SCO, body: { decision: 'VALIDE', commentaire: 'OK' } });
ok(rev.data.statut === 'VALIDE', 'justificatif validé');
const parentRev = await j('GET', '/admin/justifications', { token: P });
ok(parentRev.status === 403, `parent exclu du back-office (${parentRev.status})`);

// Enseignant : appel + QR
const ENS = await login('p.ndong@aframgabon.com');
const today = await j('GET', '/teacher/slots', { token: ENS });
ok(today.status === 200, `séances du jour enseignant (${today.data.length})`);
const tt = await j('GET', `/children/${alex.id}/timetable`, { token: P });
const futureSlot = tt.data.creneaux.find((c) => c.statut === 'PLANIFIE');
const ens2 = await j('GET', `/teacher/slots/${futureSlot.id}/roster`, { token: ENS });
ok(ens2.status === 200 || ens2.status === 403, `roster (${ens2.status})`);
const qr = await j('POST', `/teacher/slots/${futureSlot.id}/qr`, { token: ENS });
const STU = await login('alexandre.obiang@etudiant.afram.ga');
if (qr.status === 201) {
  const tampered = qr.data.code.slice(0, -2) + 'xx';
  const scanBad = await j('POST', '/attendance/scan', { token: STU, body: { code: tampered } });
  ok(scanBad.status === 400, `QR falsifié refusé (${scanBad.status})`);
  const scan = await j('POST', '/attendance/scan', { token: STU, body: { code: qr.data.code } });
  ok(scan.status === 201, `scan QR étudiant (${scan.status} ${scan.data.statut ?? scan.data.message})`);
} else {
  ok(qr.status === 403, `QR : séance d'un autre enseignant refusée (${qr.status})`);
}

// ---- Module 6 : notes
const grades = await j('GET', `/children/${alex.id}/grades`, { token: P });
ok(grades.status === 200 && grades.data.moyenneGenerale > 0, `moyenne S5 ${grades.data.moyenneGenerale} · rang ${grades.data.rang}/${grades.data.effectif} · ${grades.data.matieres.length} matières`);
const hasDraft = grades.data.matieres.some((m) => m.code === 'INF304' || m.code === 'INF303');
ok(!hasDraft, 'notes brouillon / non publiées invisibles au parent');
const hist = await j('GET', `/children/${alex.id}/grades/history`, { token: P });
ok(hist.data.length >= 2, `historique semestres (${hist.data.map((h) => `${h.code}:${h.moyenne}`).join(' ')})`);
const bulletin = await fetch(`${B}/children/${alex.id}/transcripts/${grades.data.semestre.id}/pdf`, { headers: { Authorization: `Bearer ${P}` } });
ok(bulletin.status === 200 && bulletin.headers.get('content-type').includes('pdf'), `bulletin PDF (${bulletin.status})`);
const gradeId = grades.data.matieres[0].notes[0].id;
const disp = await j('POST', `/grades/${gradeId}/dispute`, { token: P, body: { motif: 'Erreur de report suspectée' } });
ok(disp.status === 201, `réclamation de note (${disp.status})`);

const assessments = await j('GET', '/admin/assessments?statut=VALIDE_SCOLARITE', { token: SCO });
const toPublish = assessments.data[0];
const enterBlocked = await j('PUT', `/teacher/assessments/${toPublish.id}/grades`, { token: ENS, body: { grades: [{ studentId: alex.id, valeur: 20 }] } });
ok(enterBlocked.status === 403, `enseignant bloqué sur une note validée (${enterBlocked.status})`);
const noMotif = await j('PUT', `/teacher/assessments/${toPublish.id}/grades`, { token: SCO, body: { grades: [{ studentId: alex.id, valeur: 12.5 }] } });
ok(noMotif.status === 400, `correction sans motif refusée (${noMotif.status})`);
const fix = await j('PUT', `/teacher/assessments/${toPublish.id}/grades`, { token: SCO, body: { grades: [{ studentId: alex.id, valeur: 12.5 }], motif: 'Erreur de saisie' } });
ok(fix.data.modifiees === 1, 'correction avec motif historisée');
const pub = await j('POST', `/admin/assessments/${toPublish.id}/publish`, { token: SCO });
ok(pub.data.statut === 'PUBLIE', 'publication des notes');
const grades2 = await j('GET', `/children/${alex.id}/grades`, { token: P });
ok(grades2.data.matieres.length === grades.data.matieres.length + 1, 'la note publiée devient visible au parent');
const pubAgain = await j('POST', `/admin/assessments/${toPublish.id}/publish`, { token: SCO });
ok(pubAgain.status === 400, `transition PUBLIE→PUBLIE interdite (${pubAgain.status})`);

// ---- Module 7 : emploi du temps & calendrier
ok(tt.data.creneaux.length >= 8, `emploi du temps semaine (${tt.data.creneaux.length} créneaux)`);
const ics = await j('GET', `/children/${alex.id}/timetable.ics`, { token: P });
ok(ics.ct.includes('calendar') && ics.data.includes('BEGIN:VEVENT'), 'export ICS');
const cal = await j('GET', '/calendar/events', { token: P });
ok(cal.data.length >= 5, `calendrier académique (${cal.data.length})`);
const cancel = await j('PATCH', `/admin/timetable/slots/${futureSlot.id}`, { token: SCO, body: { statut: 'ANNULE', motif: 'Grève des transports' } });
ok(cancel.data.statut === 'ANNULE', 'annulation de cours (familles notifiées)');

// ---- Module 8 : messagerie, annonces, rendez-vous
const ticket = await j('POST', '/conversations', { token: P, body: { sujet: 'Question bourse', service: 'SCOLARITE', studentId: alex.id, message: 'Bonjour, comment demander une bourse ?' } });
ok(ticket.status === 201 && ticket.data.numeroTicket, `ticket créé ${ticket.data.numeroTicket}`);
const scoList = await j('GET', '/conversations', { token: SCO });
ok(scoList.data.items.some((c) => c.id === ticket.data.id), 'la scolarité voit le ticket');
const COMPTA = await login('comptable@aframgabon.com');
const comptaView = await j('GET', `/conversations/${ticket.data.id}/messages`, { token: COMPTA });
ok(comptaView.status === 404, `comptable ne voit pas un ticket scolarité (${comptaView.status})`);
await j('POST', `/conversations/${ticket.data.id}/messages`, { token: SCO, body: { contenu: 'Remplissez la demande dans Documents > Démarches.' } });
const thread = await j('GET', `/conversations/${ticket.data.id}/messages`, { token: P });
ok(thread.data.messages.length === 2 && thread.data.statut === 'EN_COURS', 'réponse reçue, statut EN_COURS');
await j('PATCH', `/conversations/${ticket.data.id}`, { token: SCO, body: { statut: 'RESOLU' } });
const rate = await j('POST', `/conversations/${ticket.data.id}/rate`, { token: P, body: { satisfaction: 5 } });
ok(rate.data.statut === 'CLOTURE', 'évaluation de satisfaction → clôture');
const ann = await j('GET', '/announcements', { token: P });
ok(ann.data.items.length >= 3, `annonces ciblées (${ann.data.items.length})`);
const OTHER = await login('etudiant1@etudiant.afram.ga');
const ADMIN = await login('admin@aframgabon.com');
const annPub = await j('POST', '/admin/announcements', { token: ADMIN, body: { titre: 'Info L1 MGO', contenu: 'Visite d’entreprise jeudi.', targetType: 'GROUP', targetId: kids.find((k) => k.prenom === 'Grâce').group.id } });
ok(annPub.status === 201 && annPub.data.destinataires >= 2, `annonce ciblée groupe → ${annPub.data.destinataires} destinataires`);
const otherAnn = await j('GET', '/announcements', { token: OTHER });
ok(!otherAnn.data.items.some((a) => a.titre === 'Info L1 MGO'), 'annonce invisible hors cible');
const hosts = await j('GET', '/appointments/hosts', { token: P });
const host = hosts.data.find((h) => h.role === 'SCOLARITE');
const d = new Date(Date.now() + 3 * 86400000); d.setHours(10, 0, 0, 0);
const rdv = await j('POST', '/appointments', { token: P, body: { hoteId: host.id, objet: 'Orientation master', debut: d.toISOString(), fin: new Date(d.getTime() + 1800000).toISOString() } });
ok(rdv.status === 201, `rendez-vous demandé (${rdv.status})`);
const conf = await j('PATCH', `/appointments/${rdv.data.id}`, { token: SCO, body: { statut: 'CONFIRME', lieu: 'Bureau scolarité, Batterie IV' } });
ok(conf.data.statut === 'CONFIRME', 'rendez-vous confirmé');

// ---- Module 9 : documents & démarches
const vault = await j('GET', `/children/${alex.id}/documents`, { token: P });
const reglement = vault.data.find((v) => v.aSigner);
ok(!!reglement, 'règlement intérieur à signer');
const dl = await fetch(`${B}/documents/${reglement.id}/download`, { headers: { Authorization: `Bearer ${P}` } });
ok(dl.status === 200, `téléchargement document (${dl.status})`);
const sign = await j('POST', `/documents/${reglement.id}/sign`, { token: P });
ok(sign.data.estSigne && sign.data.signatureMetadata.sha256, 'signature électronique horodatée');
const req = await j('POST', '/requests', { token: P, body: { studentId: alex.id, type: 'CERTIFICAT_SCOLARITE', motif: 'CAF' } });
ok(req.status === 201, 'demande de certificat');
const dup = await j('POST', '/requests', { token: P, body: { studentId: alex.id, type: 'CERTIFICAT_SCOLARITE' } });
ok(dup.status === 400, 'doublon de demande refusé');
const ready = await j('PATCH', `/admin/requests/${req.data.id}`, { token: SCO, body: { statut: 'PRETE' } });
ok(!!ready.data.documentGenereUrl, 'document généré automatiquement');
const cert = await fetch(`${B}/requests/${req.data.id}/document`, { headers: { Authorization: `Bearer ${P}` } });
ok(cert.status === 200, `certificat téléchargeable (${cert.status})`);
const certIdor = await fetch(`${B}/requests/${req.data.id}/document`, { headers: { Authorization: `Bearer ${OTHER}` } });
ok(certIdor.status === 403, `certificat inaccessible à un tiers (${certIdor.status})`);

// ---- Module 10 : discipline
const disc = await j('GET', `/children/${alex.id}/discipline`, { token: P });
const conv = disc.data.find((x) => x.accuseRequis);
ok(!!conv, 'convocation à accuser');
const ack = await j('POST', `/discipline/${conv.id}/acknowledge`, { token: P });
ok(ack.data.accuseReception === true, 'accusé de réception enregistré');

// ---- Module 11 : notifications
const notifs = await j('GET', '/notifications?take=50', { token: P });
const cats = new Set(notifs.data.items.map((n) => n.categorie));
ok(['PRESENCE', 'NOTES', 'EMPLOI_DU_TEMPS', 'MESSAGERIE'].every((c) => cats.has(c)), `notifications multi-catégories (${[...cats].join(',')})`);
const prefs = await j('PUT', '/notification-preferences', { token: P, body: { items: [{ categorie: 'FINANCE', push: true, sms: true, email: false }] } });
ok(prefs.data.find((p) => p.categorie === 'FINANCE').sms === true, 'préférences de notification');

// ---- Module 13 : back-office
const ov = await j('GET', '/admin/stats/overview', { token: ADMIN });
ok(ov.status === 200 && ov.data.inscrits >= 6, `tableau de bord admin : ${ov.data.inscrits} inscrits, recouvrement ${ov.data.finances.tauxRecouvrement}%`);
const ovDenied = await j('GET', '/admin/stats/overview', { token: COMPTA });
ok(ovDenied.status === 200, 'comptable : stats autorisées');
const auditDenied = await j('GET', '/admin/audit-logs', { token: COMPTA });
ok(auditDenied.status === 403, `comptable : audit interdit (${auditDenied.status})`);
const audit = await j('GET', '/admin/audit-logs?take=5', { token: ADMIN });
ok(audit.data.items.length === 5, 'journal d’audit consultable');
const csv = 'matricule;nom;prenom;dateNaissance;groupe;parentNom;parentPrenom;parentTelephone;lien\nAFRAMSIL0999;KOUMBA;Paul;2005-03-02;L3 SIL;KOUMBA;Marie;+241066990011;MERE\nX1;;;bad;L9;A;B;123;ONCLE\n';
const imp = new FormData();
imp.append('fichier', new Blob([csv], { type: 'text/csv' }), 'import.csv');
const dry = await j('POST', '/admin/students/import?dryRun=true', { token: SCO, form: imp });
ok(dry.data.valides === 1 && dry.data.erreurs === 1, `import CSV prévisualisé : ${dry.data.valides} valide, ${dry.data.erreurs} erreur`);
const imp2 = new FormData();
imp2.append('fichier', new Blob([csv], { type: 'text/csv' }), 'import.csv');
const real = await j('POST', '/admin/students/import?dryRun=false', { token: SCO, form: imp2 });
ok(real.data.crees === 1, 'import CSV réel : 1 étudiant + parent invité');
const perms = await j('PUT', '/admin/permissions/SUPPORT', { token: ADMIN, body: { permissions: ['messages.send_to_parent', 'stats.read'] } });
ok(perms.data.matrice.SUPPORT.includes('stats.read'), 'matrice RBAC modifiable');
const SUP = await login('support@aframgabon.com');
const supStats = await j('GET', '/admin/stats/overview', { token: SUP });
ok(supStats.status === 200, `permission appliquée immédiatement (${supStats.status})`);

console.log(fails ? `\n${fails} ÉCHEC(S)` : '\nTOUS LES TESTS PASSENT');
process.exit(fails ? 1 : 0);

/* eslint-disable no-console */
/**
 * Données de démonstration UniParent AFRAM.
 * Les dates sont calculées par rapport à aujourd'hui pour que la démo reste vivante.
 * ATTENTION : vide toutes les tables (interdit en production).
 */
import 'dotenv/config';
import {
  AnnouncementTarget,
  AssessmentType,
  AttendanceStatus,
  CalendarEventType,
  DisciplineRecordType,
  DocumentRequestStatus,
  DocumentRequestType,
  GradeStatus,
  InvoiceLineType,
  InvoiceStatus,
  JustificationStatus,
  NotificationCategory,
  ParentRelationType,
  PayerType,
  PaymentChannel,
  PaymentProviderType,
  PaymentStatus,
  Prisma,
  PrismaClient,
  SlotStatus,
  StudentStatus,
  TicketPriority,
  TicketService,
  TicketStatus,
  UserRole,
  UserStatus,
} from '@prisma/client';
import * as bcrypt from 'bcrypt';
import { mkdirSync, writeFileSync } from 'fs';
import * as path from 'path';
import PDFDocument = require('pdfkit');
import { createHmac, randomUUID } from 'crypto';
import { DEFAULT_ROLE_PERMISSIONS } from '../src/common/guards/permissions';

const prisma = new PrismaClient();
const DEMO_PASSWORD = 'Afram2026!';

// ----------------------------------------------------------------- utilitaires de dates
const now = new Date();
const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
const addDays = (d: Date, n: number) => new Date(d.getTime() + n * 86_400_000);
const at = (d: Date, h: number, m = 0) => new Date(d.getFullYear(), d.getMonth(), d.getDate(), h, m);
const monday = addDays(today, -((today.getDay() + 6) % 7));
// Année académique : commence en octobre.
const startYear = now.getMonth() >= 8 ? now.getFullYear() : now.getFullYear() - 1;
const yearLabel = `${startYear}-${startYear + 1}`;

const receiptToken = (id: string) =>
  createHmac('sha256', process.env.RECEIPT_SIGNING_SECRET!).update(id).digest('base64url').slice(0, 32);
let seq = 1000;
const ref = (p: string) => `${p}-${startYear}-${(seq++).toString().padStart(6, '0')}`;

/** Crée un PDF de démonstration dans le stockage local. */
function demoPdf(key: string, title: string, paragraphs: string[]) {
  return new Promise<void>((resolve) => {
    const full = path.resolve(process.env.STORAGE_LOCAL_DIR ?? './storage', key);
    mkdirSync(path.dirname(full), { recursive: true });
    const doc = new PDFDocument({ size: 'A4', margin: 60 });
    const chunks: Buffer[] = [];
    doc.on('data', (c: Buffer) => chunks.push(c));
    doc.on('end', () => {
      writeFileSync(full, Buffer.concat(chunks));
      resolve();
    });
    doc.font('Helvetica-Bold').fontSize(16).fillColor('#0B3D91').text(title, { align: 'center' }).moveDown(1.5);
    doc.font('Helvetica').fontSize(11).fillColor('#1F2937');
    paragraphs.forEach((p, i) => doc.text(`${i + 1}. ${p}`, { align: 'justify' }).moveDown(0.6));
    doc.end();
  });
}

async function wipe() {
  if (process.env.NODE_ENV === 'production') throw new Error('Seed interdit en production');
  const tables = await prisma.$queryRaw<{ tablename: string }[]>`
    SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename <> '_prisma_migrations'`;
  // TRUNCATE ne déclenche pas les triggers d'immutabilité (réservés à UPDATE/DELETE).
  await prisma.$executeRawUnsafe(`TRUNCATE ${tables.map((t) => `"${t.tablename}"`).join(', ')} CASCADE`);
}

async function main() {
  console.log('--- Seed UniParent AFRAM ---');
  await wipe();
  const hash = await bcrypt.hash(DEMO_PASSWORD, 12);

  // ----------------------------------------------------------------- RBAC & paramètres
  await prisma.rolePermission.createMany({
    data: Object.entries(DEFAULT_ROLE_PERMISSIONS).flatMap(([role, perms]) =>
      perms.map((permission) => ({ role: role as UserRole, permission })),
    ),
  });
  await prisma.appSetting.createMany({
    data: [
      { key: 'attendance.alertThreshold', value: 3 },
      { key: 'finance.studentCanPay', value: false },
      { key: 'grades.showRank', value: true },
      { key: 'notifications.quietHours', value: { enabled: true, start: 21, end: 7 } },
      { key: 'branding', value: { primaryColor: '#0B3D91', accentColor: '#C9A227', appName: 'UniParent AFRAM' } },
    ],
  });

  // ----------------------------------------------------------------- Institution
  const institution = await prisma.institution.create({
    data: {
      code: 'AFRAM',
      nom: 'Académie Franco-Américaine de Management',
      sigle: 'AFRAM',
      deviseParDefaut: 'XAF',
      siteWeb: 'https://aframgabon.com/',
      telephone: '+241 066 70 11 84',
      whatsapp: '+241 074 00 00 43',
      emailContact: 'aframilesmail@aframgabon.com',
    },
  });
  const batterie = await prisma.campus.create({
    data: { institutionId: institution.id, nom: 'Batterie IV', adresse: "Rue André MINTSA – Batterie IV, près de l'École Conventionnée Gros Bouquet 1" },
  });
  const louis = await prisma.campus.create({ data: { institutionId: institution.id, nom: 'Louis', adresse: 'Quartier Louis, Libreville' } });
  const rooms = await Promise.all([
    prisma.room.create({ data: { campusId: batterie.id, code: 'S101', capacite: 40, equipements: ['vidéoprojecteur', 'climatisation'] } }),
    prisma.room.create({ data: { campusId: batterie.id, code: 'S104', capacite: 35, equipements: ['tableau numérique', 'climatisation'] } }),
    prisma.room.create({ data: { campusId: batterie.id, code: 'LABO-INFO', capacite: 30, equipements: ['30 postes', 'vidéoprojecteur'] } }),
    prisma.room.create({ data: { campusId: louis.id, code: 'AMPHI-A', capacite: 120, equipements: ['sonorisation', 'vidéoprojecteur'] } }),
  ]);

  // ----------------------------------------------------------------- Années & semestres
  const prevYear = await prisma.academicYear.create({
    data: { institutionId: institution.id, libelle: `${startYear - 1}-${startYear}`, dateDebut: new Date(startYear - 1, 9, 6), dateFin: new Date(startYear, 6, 15) },
  });
  const year = await prisma.academicYear.create({
    data: { institutionId: institution.id, libelle: yearLabel, dateDebut: new Date(startYear, 9, 5), dateFin: new Date(startYear + 1, 6, 15), estActif: true },
  });
  const s4 = await prisma.semester.create({
    data: { academicYearId: prevYear.id, code: 'S4', libelle: 'Semestre 4', dateDebut: new Date(startYear, 1, 16), dateFin: new Date(startYear, 6, 15) },
  });
  const s5 = await prisma.semester.create({
    data: { academicYearId: year.id, code: 'S5', libelle: 'Semestre 5', dateDebut: new Date(startYear, 8, 1), dateFin: new Date(startYear + 1, 1, 15), estActif: true },
  });
  await prisma.semester.create({
    data: { academicYearId: year.id, code: 'S6', libelle: 'Semestre 6', dateDebut: new Date(startYear + 1, 1, 16), dateFin: new Date(startYear + 1, 6, 15) },
  });

  // ----------------------------------------------------------------- Filières, groupes, cours
  const sil = await prisma.program.create({ data: { code: 'SIL', nom: 'Systèmes Informatiques et Logiciels', niveau: 'LICENCE' } });
  const mgo = await prisma.program.create({ data: { code: 'MGO', nom: 'Management et Gestion des Organisations', niveau: 'LICENCE' } });
  await prisma.program.createMany({
    data: [
      { code: 'DROIT', nom: 'Droit', niveau: 'LICENCE' },
      { code: 'QHSE', nom: 'QHSE Management', niveau: 'LICENCE' },
      { code: 'MTSI', nom: 'Master Technologies et Systèmes d’Information', niveau: 'MASTER' },
    ],
  });
  const l3sil = await prisma.group.create({ data: { programId: sil.id, nom: 'L3 SIL', anneeNiveau: 3 } });
  const l1mgo = await prisma.group.create({ data: { programId: mgo.id, nom: 'L1 MGO', anneeNiveau: 1 } });

  const courseDefs = [
    { code: 'INF301', nom: 'Développement mobile (Flutter)', coefficient: 3, creditsEcts: 6 },
    { code: 'INF302', nom: 'Réseaux & Télécoms', coefficient: 2, creditsEcts: 4 },
    { code: 'INF303', nom: 'Bases de données avancées', coefficient: 2, creditsEcts: 4 },
    { code: 'INF304', nom: 'Génie logiciel', coefficient: 2, creditsEcts: 4 },
    { code: 'ANG301', nom: 'Anglais professionnel', coefficient: 1, creditsEcts: 2 },
    { code: 'MGT301', nom: 'Entrepreneuriat', coefficient: 1, creditsEcts: 2 },
  ];
  const courses = await Promise.all(courseDefs.map((c) => prisma.course.create({ data: { ...c, programId: sil.id } })));
  const mgoCourses = await Promise.all(
    [
      { code: 'GES101', nom: 'Comptabilité générale', coefficient: 3, creditsEcts: 6 },
      { code: 'ECO101', nom: 'Microéconomie', coefficient: 2, creditsEcts: 4 },
    ].map((c) => prisma.course.create({ data: { ...c, programId: mgo.id } })),
  );

  // ----------------------------------------------------------------- Utilisateurs administratifs
  const staff = async (email: string, telephone: string, role: UserRole) =>
    prisma.user.create({ data: { email, telephone, passwordHash: hash, role, status: UserStatus.ACTIVE } });
  const admin = await staff('admin@aframgabon.com', '+241011000001', UserRole.SUPER_ADMIN);
  const scolarite = await staff('scolarite@aframgabon.com', '+241011000002', UserRole.SCOLARITE);
  const comptable = await staff('comptable@aframgabon.com', '+241011000003', UserRole.COMPTABLE);
  await staff('direction@aframgabon.com', '+241011000004', UserRole.DIRECTION);
  const support = await staff('support@aframgabon.com', '+241011000005', UserRole.SUPPORT);

  const teacherDefs = [
    { email: 'p.ndong@aframgabon.com', tel: '+241011000101', nom: 'NDONG', prenom: 'Patrick', specialite: 'Génie logiciel' },
    { email: 's.moussavou@aframgabon.com', tel: '+241011000102', nom: 'MOUSSAVOU', prenom: 'Sylvie', specialite: 'Réseaux' },
    { email: 'k.johnson@aframgabon.com', tel: '+241011000103', nom: 'JOHNSON', prenom: 'Kevin', specialite: 'Anglais' },
  ];
  const teachers = [];
  for (const [i, t] of teacherDefs.entries()) {
    const u = await prisma.user.create({
      data: {
        email: t.email,
        telephone: t.tel,
        passwordHash: hash,
        role: UserRole.ENSEIGNANT,
        status: UserStatus.ACTIVE,
        teacherProfile: { create: { matricule: `ENS-00${i + 1}`, nom: t.nom, prenom: t.prenom, specialite: t.specialite } },
      },
      include: { teacherProfile: true },
    });
    teachers.push(u.teacherProfile!);
  }

  // ----------------------------------------------------------------- Parents & étudiants
  const parentUser = await prisma.user.create({
    data: {
      email: 'parent@aframgabon.com',
      telephone: '+241066701184',
      passwordHash: hash,
      role: UserRole.PARENT,
      status: UserStatus.ACTIVE,
      parentProfile: {
        create: { nom: 'OBIANG', prenom: 'Jean-Marc', profession: 'Ingénieur', adresse: 'Batterie IV, Libreville', contactUrgence: '+241074000043' },
      },
    },
    include: { parentProfile: true },
  });
  const pendingMother = await prisma.user.create({
    data: {
      email: 'clarisse.obiang@gmail.com',
      telephone: '+241066112233',
      passwordHash: '',
      role: UserRole.PARENT,
      status: UserStatus.PENDING_ACTIVATION,
      activationToken: 'AFRAM-2026-ACTIVATE',
      parentProfile: { create: { nom: 'OBIANG', prenom: 'Clarisse', profession: 'Médecin' } },
    },
    include: { parentProfile: true },
  });

  const mkStudent = async (s: { email: string; tel: string; matricule: string; nom: string; prenom: string; naissance: string; groupId: string; statut?: StudentStatus }) =>
    prisma.user.create({
      data: {
        email: s.email,
        telephone: s.tel,
        passwordHash: hash,
        role: UserRole.ETUDIANT,
        status: UserStatus.ACTIVE,
        studentProfile: {
          create: {
            matricule: s.matricule,
            nom: s.nom,
            prenom: s.prenom,
            dateNaissance: new Date(s.naissance),
            groupId: s.groupId,
            statut: s.statut ?? StudentStatus.INSCRIT,
            dateInscription: new Date(startYear - 2, 9, 3),
            responsablePeda: 'Dr Patrick NDONG',
          },
        },
      },
      include: { studentProfile: true },
    });

  const alexandre = (await mkStudent({ email: 'alexandre.obiang@etudiant.afram.ga', tel: '+241077889900', matricule: 'AFRAMSIL0102', nom: 'OBIANG', prenom: 'Alexandre', naissance: '2004-05-14', groupId: l3sil.id })).studentProfile!;
  const grace = (await mkStudent({ email: 'grace.obiang@etudiant.afram.ga', tel: '+241077889901', matricule: 'AFRAMMGO0417', nom: 'OBIANG', prenom: 'Grâce', naissance: '2007-02-03', groupId: l1mgo.id, statut: StudentStatus.EN_ATTENTE_DOCUMENTS })).studentProfile!;
  const classmates = [];
  for (const [i, n] of [['MBA', 'Lucie'], ['NZE', 'Brice'], ['ONDO', 'Carine'], ['ESSONO', 'Fabrice']].entries()) {
    const u = await mkStudent({ email: `etudiant${i + 1}@etudiant.afram.ga`, tel: `+24107700000${i}`, matricule: `AFRAMSIL01${10 + i}`, nom: n[0], prenom: n[1], naissance: '2004-01-01', groupId: l3sil.id });
    classmates.push(u.studentProfile!);
  }

  const validatedAt = new Date(startYear, 9, 1);
  await prisma.parentStudent.createMany({
    data: [
      { parentId: parentUser.parentProfile!.id, studentId: alexandre.id, relationType: ParentRelationType.PERE, estPayeur: true, validePar: scolarite.id, valideLe: validatedAt },
      { parentId: parentUser.parentProfile!.id, studentId: grace.id, relationType: ParentRelationType.PERE, estPayeur: true, validePar: scolarite.id, valideLe: validatedAt },
      // Rattachement validé : la mère verra ses enfants dès l'activation (parcours P1).
      { parentId: pendingMother.parentProfile!.id, studentId: alexandre.id, relationType: ParentRelationType.MERE, estPayeur: false, validePar: scolarite.id, valideLe: validatedAt },
    ],
  });

  // ----------------------------------------------------------------- Emploi du temps (6 semaines) + présences
  // Gabarit hebdomadaire L3 SIL : [jour (0=lundi), heure début, durée h, cours, enseignant, salle]
  const pattern: [number, number, number, number, number, number][] = [
    [0, 8, 3, 0, 0, 2],
    [0, 14, 3, 1, 1, 1],
    [1, 8, 3, 2, 0, 2],
    [1, 14, 2, 4, 2, 0],
    [2, 8, 3, 3, 0, 1],
    [3, 9, 3, 0, 0, 2],
    [3, 14, 3, 1, 1, 1],
    [4, 8, 2, 5, 2, 3],
  ];
  const allSil = [alexandre, ...classmates];
  let slotCount = 0;
  for (let w = -4; w <= 1; w++) {
    for (const [day, h, dur, ci, ti, ri] of pattern) {
      const date = addDays(monday, w * 7 + day);
      const debut = at(date, h);
      const fin = at(date, h + dur);
      const cancelled = w === 1 && day === 1 && h === 14;
      const slot = await prisma.timetableSlot.create({
        data: {
          semesterId: s5.id,
          courseId: courses[ci].id,
          groupId: l3sil.id,
          teacherId: teachers[ti].id,
          roomId: rooms[ri].id,
          dateDebut: debut,
          dateFin: fin,
          statut: cancelled ? SlotStatus.ANNULE : fin < now ? SlotStatus.TERMINE : SlotStatus.PLANIFIE,
          motifAnnulation: cancelled ? 'Enseignant en déplacement — cours reporté' : null,
        },
      });
      slotCount++;
      if (fin >= now || cancelled) continue;
      for (const st of allSil) {
        let statut: AttendanceStatus = AttendanceStatus.PRESENT;
        let minutesRetard = 0;
        if (st.id === alexandre.id) {
          if (w === -1 && day === 0 && h === 14) statut = AttendanceStatus.ABSENT;
          if (w === -2 && day === 3 && h === 9) statut = AttendanceStatus.ABSENT;
          if (w === 0 && day === 0 && h === 8 && fin < now) { statut = AttendanceStatus.RETARD; minutesRetard = 20; }
          if (w === -3 && day === 4) statut = AttendanceStatus.EXCUSE;
        } else if ((slotCount + st.matricule.length) % 11 === 0) {
          statut = AttendanceStatus.ABSENT;
        }
        const rec = await prisma.attendanceRecord.create({
          data: { slotId: slot.id, studentId: st.id, statut, minutesRetard, saisiParId: teachers[ti].userId },
        });
        if (st.id === alexandre.id && statut === AttendanceStatus.ABSENT && w === -2) {
          await prisma.absenceJustification.create({
            data: { attendanceRecordId: rec.id, motif: 'Consultation médicale', documentUrl: 'justificatifs/demo-certificat.pdf', statut: JustificationStatus.VALIDE, decisionParId: scolarite.id, decisionDate: addDays(today, -10), commentaire: 'Certificat conforme' },
          });
        }
      }
    }
  }

  // ----------------------------------------------------------------- Notes S5 (workflow) + S4 (historique)
  const mkAssessment = async (courseIdx: number, type: AssessmentType, titre: string, statut: GradeStatus, coefficient: number, values: number[], semesterId = s5.id) => {
    const a = await prisma.assessment.create({
      data: { semesterId, courseId: courses[courseIdx].id, groupId: l3sil.id, type, titre, coefficient, bareme: 20, statut, saisiParId: teachers[0].userId, datePublication: statut === GradeStatus.PUBLIE ? addDays(now, -4) : null },
    });
    for (const [i, st] of allSil.entries()) {
      const g = await prisma.grade.create({ data: { assessmentId: a.id, studentId: st.id, valeur: values[i], statut } });
      await prisma.gradeAuditLog.create({ data: { gradeId: g.id, nouvelleValeur: values[i], modifieParId: teachers[0].userId, motif: 'Saisie initiale' } });
    }
    return a;
  };
  await mkAssessment(0, AssessmentType.CONTROLE_CONTINU, 'Contrôle continu n°1', GradeStatus.PUBLIE, 1, [15, 12, 9.5, 17, 11]);
  await mkAssessment(0, AssessmentType.TRAVAUX_PRATIQUES, 'TP — Application Riverpod', GradeStatus.PUBLIE, 1, [16.5, 13, 10, 18, 12]);
  await mkAssessment(1, AssessmentType.CONTROLE_CONTINU, 'Contrôle — Modèle OSI', GradeStatus.PUBLIE, 1, [13, 14, 8, 15, 10.5]);
  await mkAssessment(4, AssessmentType.CONTROLE_CONTINU, 'Oral — Présentation', GradeStatus.PUBLIE, 1, [14, 16, 12, 13, 11]);
  await mkAssessment(2, AssessmentType.DEVOIR_SUR_TABLE, 'Devoir — Normalisation', GradeStatus.VALIDE_SCOLARITE, 1, [12, 11, 7, 16, 9]);
  await mkAssessment(3, AssessmentType.CONTROLE_CONTINU, 'Contrôle — UML', GradeStatus.BROUILLON, 1, [14, 10, 9, 15, 12]);
  // Semestre précédent (historique pour la comparaison)
  await mkAssessment(0, AssessmentType.EXAMEN_FINAL, 'Examen final S4 — Programmation', GradeStatus.PUBLIE, 2, [13.5, 12, 10, 16, 11], s4.id);
  await mkAssessment(1, AssessmentType.EXAMEN_FINAL, 'Examen final S4 — Systèmes', GradeStatus.PUBLIE, 2, [12, 13, 9, 14, 10], s4.id);

  // Grâce (L1 MGO) : une note publiée
  const ga = await prisma.assessment.create({
    data: { semesterId: s5.id, courseId: mgoCourses[0].id, groupId: l1mgo.id, type: AssessmentType.CONTROLE_CONTINU, titre: 'Contrôle — Bilan', coefficient: 1, statut: GradeStatus.PUBLIE, saisiParId: teachers[0].userId, datePublication: addDays(now, -6) },
  });
  await prisma.grade.create({ data: { assessmentId: ga.id, studentId: grace.id, valeur: 14.5, statut: GradeStatus.PUBLIE } });

  // ----------------------------------------------------------------- Finances (montants entiers XAF)
  const tranches = [
    { titre: 'Frais d’inscription', type: InvoiceLineType.INSCRIPTION, montant: 95_000n, date: new Date(startYear, 9, 5) },
    { titre: 'Scolarité — 1re tranche', type: InvoiceLineType.SCOLARITE_TRANCHE, montant: 330_000n, date: addDays(today, -6) },
    { titre: 'Scolarité — 2e tranche', type: InvoiceLineType.SCOLARITE_TRANCHE, montant: 330_000n, date: new Date(startYear + 1, 0, 15) },
    { titre: 'Scolarité — 3e tranche', type: InvoiceLineType.SCOLARITE_TRANCHE, montant: 330_000n, date: new Date(startYear + 1, 3, 15) },
    { titre: 'Frais d’examen', type: InvoiceLineType.EXAMEN, montant: 25_000n, date: addDays(today, 7) },
  ];
  const mkInvoices = async (studentId: string, paid: bigint[]) => {
    const out = [];
    for (const [i, t] of tranches.entries()) {
      const p = paid[i] ?? 0n;
      const solde = t.montant - p;
      const statut = solde === 0n ? InvoiceStatus.PAYE : t.date < today ? InvoiceStatus.EN_RETARD : p > 0n ? InvoiceStatus.PARTIELLEMENT_PAYE : InvoiceStatus.A_PAYER;
      out.push(
        await prisma.invoice.create({
          data: {
            studentId,
            academicYearId: year.id,
            numeroFacture: ref('FAC'),
            montantTotal: t.montant,
            montantPaye: p,
            soldeRestant: solde,
            statut,
            dateEcheance: t.date,
            lines: { create: { titre: t.titre, type: t.type, montant: t.montant, dateLimite: t.date } },
          },
        }),
      );
    }
    return out;
  };
  const alexInv = await mkInvoices(alexandre.id, [95_000n, 200_000n]);
  const graceInv = await mkInvoices(grace.id, [95_000n, 330_000n]);

  const mkPayment = async (o: {
    invoiceId: string; montant: bigint; canal: PaymentChannel; provider: PaymentProviderType; payeurType: PayerType;
    payeParUserId?: string; parentId?: string; enregistreParId?: string; payeurNom?: string; date: Date; externe?: string;
  }) => {
    const p = await prisma.payment.create({
      data: {
        invoiceId: o.invoiceId,
        montant: o.montant,
        canal: o.canal,
        provider: o.provider,
        payeurType: o.payeurType,
        payeParUserId: o.payeParUserId,
        parentId: o.parentId,
        enregistreParId: o.enregistreParId,
        reference: ref(o.enregistreParId ? 'GUI' : 'PAY'),
        idempotencyKey: randomUUID(),
        referenceExterne: o.externe,
        statut: PaymentStatus.VALIDE,
        metadata: { payeurNom: o.payeurNom ?? null },
        createdAt: o.date,
      },
    });
    const id = randomUUID();
    await prisma.receipt.create({
      data: { id, paymentId: p.id, numeroRecu: ref('REC'), pdfUrl: `/api/v1/receipts/${id}/pdf`, qrTokenVerification: receiptToken(id), createdAt: o.date },
    });
    await prisma.auditLog.create({
      data: { userId: o.enregistreParId ?? o.payeParUserId, action: 'PAYMENT_VALIDATED', entite: 'Invoice', entiteId: o.invoiceId, apres: { montant: o.montant.toString(), canal: o.canal } },
    });
  };
  // Alexandre : inscription payée au guichet par l'étudiant lui-même (le parent le voit — parcours P3)
  await mkPayment({ invoiceId: alexInv[0].id, montant: 95_000n, canal: PaymentChannel.GUICHET_ESPECES, provider: PaymentProviderType.MANUAL_GUICHET, payeurType: PayerType.ETUDIANT, enregistreParId: comptable.id, payeurNom: 'Alexandre OBIANG', date: new Date(startYear, 9, 3, 10, 12) });
  // 1re tranche partiellement payée en ligne par le père (Airtel Money via CinetPay)
  await mkPayment({ invoiceId: alexInv[1].id, montant: 200_000n, canal: PaymentChannel.ONLINE_MOBILE_MONEY, provider: PaymentProviderType.CINETPAY, payeurType: PayerType.PARENT, payeParUserId: parentUser.id, parentId: parentUser.parentProfile!.id, externe: 'CP-8841207', date: addDays(today, -12) });
  await mkPayment({ invoiceId: graceInv[0].id, montant: 95_000n, canal: PaymentChannel.GUICHET_VIREMENT, provider: PaymentProviderType.MANUAL_GUICHET, payeurType: PayerType.PARENT, enregistreParId: comptable.id, payeurNom: 'Jean-Marc OBIANG', externe: 'BGFI-VIR-55120', date: new Date(startYear, 9, 4, 9, 30) });
  await mkPayment({ invoiceId: graceInv[1].id, montant: 330_000n, canal: PaymentChannel.ONLINE_CARD, provider: PaymentProviderType.STRIPE, payeurType: PayerType.PARENT, payeParUserId: parentUser.id, parentId: parentUser.parentProfile!.id, externe: 'cs_demo_7781', date: addDays(today, -9) });

  // Factures des camarades (pour les statistiques)
  for (const c of classmates) await mkInvoices(c.id, [95_000n, 330_000n]);

  // ----------------------------------------------------------------- Messagerie, annonces, calendrier
  await prisma.conversation.create({
    data: {
      numeroTicket: `TCK-${startYear}-0001`,
      sujet: 'Reçu de la 1re tranche',
      service: TicketService.FINANCES,
      priorite: TicketPriority.NORMALE,
      statut: TicketStatus.EN_COURS,
      creeParUserId: parentUser.id,
      assigneAUserId: comptable.id,
      studentId: alexandre.id,
      slaDueAt: addDays(now, 1),
      messages: {
        create: [
          { auteurId: parentUser.id, contenu: 'Bonjour, j’ai payé 200 000 FCFA par Airtel Money. Pouvez-vous confirmer la réception ?', createdAt: addDays(now, -2), estLu: true, luLe: addDays(now, -2) },
          { auteurId: comptable.id, contenu: 'Bonjour M. OBIANG, le versement est bien enregistré. Le reçu est disponible dans l’onglet Finances. Il reste 130 000 FCFA sur la 1re tranche.', createdAt: addDays(now, -1) },
        ],
      },
    },
  });
  await prisma.conversation.create({
    data: {
      numeroTicket: `TCK-${startYear}-0002`,
      sujet: 'Dossier d’inscription de Grâce',
      service: TicketService.SCOLARITE,
      statut: TicketStatus.RESOLU,
      satisfaction: 5,
      creeParUserId: parentUser.id,
      assigneAUserId: scolarite.id,
      studentId: grace.id,
      messages: { create: [
        { auteurId: parentUser.id, contenu: 'Quelles pièces manquent au dossier de ma fille ?', createdAt: addDays(now, -20), estLu: true },
        { auteurId: scolarite.id, contenu: 'Il manque la copie légalisée du baccalauréat. Vous pouvez la téléverser dans l’onglet Documents.', createdAt: addDays(now, -19), estLu: true },
      ] },
    },
  });

  await prisma.announcement.createMany({
    data: [
      { titre: `Rentrée académique ${yearLabel}`, contenu: 'Bienvenue à tous nos étudiants. Les cours ont repris sur les campus Batterie IV et Louis.', targetType: AnnouncementTarget.ALL, creeParId: scolarite.id, datePublication: new Date(startYear, 9, 5) },
      { titre: 'Réunion parents-enseignants', contenu: `Les parents sont conviés le ${addDays(today, 12).toLocaleDateString('fr-FR')} à 16h, amphi A (campus Louis).`, targetType: AnnouncementTarget.ALL, creeParId: admin.id, datePublication: addDays(now, -1) },
      { titre: 'L3 SIL : salle LABO-INFO', contenu: 'Les TP de Développement mobile se tiennent désormais au LABO-INFO.', targetType: AnnouncementTarget.GROUP, targetId: l3sil.id, creeParId: scolarite.id, datePublication: addDays(now, -3) },
    ],
  });

  await prisma.calendarEvent.createMany({
    data: [
      { titre: 'Rentrée académique', type: CalendarEventType.RENTREE, debut: new Date(startYear, 9, 5), fin: new Date(startYear, 9, 5, 23) },
      { titre: 'Échéance 2e tranche', type: CalendarEventType.ECHEANCE_PAIEMENT, debut: new Date(startYear + 1, 0, 15), fin: new Date(startYear + 1, 0, 15, 23) },
      { titre: 'Réunion parents-enseignants', type: CalendarEventType.REUNION_PARENTS, debut: at(addDays(today, 12), 16), fin: at(addDays(today, 12), 18) },
      { titre: 'Examens du semestre 5', type: CalendarEventType.EXAMEN, debut: new Date(startYear + 1, 0, 26), fin: new Date(startYear + 1, 1, 6) },
      { titre: 'Vacances de fin d’année', type: CalendarEventType.VACANCES, debut: new Date(startYear, 11, 20), fin: new Date(startYear + 1, 0, 4) },
      { titre: 'Fête de l’Indépendance', type: CalendarEventType.FERIE, debut: new Date(startYear + 1, 7, 17), fin: new Date(startYear + 1, 7, 17, 23) },
    ],
  });

  // ----------------------------------------------------------------- Discipline, documents, notifications
  await prisma.disciplineRecord.createMany({
    data: [
      { studentId: alexandre.id, type: DisciplineRecordType.FELICITATION, motif: 'Excellent projet Flutter présenté en TP', dateIncident: addDays(today, -15), enregistreParId: teachers[0].userId },
      { studentId: alexandre.id, type: DisciplineRecordType.CONVOCATION_PARENT, motif: 'Retards répétés en début de matinée', sanction: 'Entretien avec le responsable pédagogique', dateIncident: addDays(today, -2), convocationDate: at(addDays(today, 5), 10), enregistreParId: scolarite.id },
    ],
  });
  await prisma.documentRequest.createMany({
    data: [
      { studentId: alexandre.id, type: DocumentRequestType.ATTESTATION_INSCRIPTION, motif: 'Dossier de bourse', statut: DocumentRequestStatus.PRETE, traiteParId: scolarite.id },
      { studentId: grace.id, type: DocumentRequestType.CERTIFICAT_SCOLARITE, motif: 'Allocations familiales', statut: DocumentRequestStatus.EN_TRAITEMENT },
    ],
  });
  await prisma.documentVault.createMany({
    data: [
      { studentId: alexandre.id, titre: 'Règlement intérieur AFRAM', categorie: 'REGLEMENT', fichierUrl: 'vault/reglement-interieur.pdf', estSigne: false },
      { studentId: alexandre.id, titre: `Contrat d'inscription ${yearLabel}`, categorie: 'CONTRAT', fichierUrl: 'vault/contrat-inscription.pdf', estSigne: true, signatureMetadata: { signePar: 'Jean-Marc OBIANG', le: new Date(startYear, 9, 2).toISOString() } },
      { studentId: grace.id, titre: 'Règlement intérieur AFRAM', categorie: 'REGLEMENT', fichierUrl: 'vault/reglement-interieur.pdf', estSigne: false },
    ],
  });

  await prisma.notification.createMany({
    data: [
      { userId: parentUser.id, titre: 'Absence signalée', corps: 'Alexandre était absent au cours de Réseaux & Télécoms.', categorie: NotificationCategory.PRESENCE, dataPayload: { studentId: alexandre.id } as Prisma.InputJsonValue, createdAt: addDays(now, -7) },
      { userId: parentUser.id, titre: 'Nouvelles notes disponibles', corps: 'Une nouvelle note a été publiée en Développement mobile (Flutter).', categorie: NotificationCategory.NOTES, dataPayload: { studentId: alexandre.id } as Prisma.InputJsonValue, createdAt: addDays(now, -4) },
      { userId: parentUser.id, titre: 'Paiement en retard', corps: 'Retard : 130 000 FCFA restent dus pour Alexandre OBIANG.', categorie: NotificationCategory.FINANCE, dataPayload: { studentId: alexandre.id } as Prisma.InputJsonValue, createdAt: addDays(now, -1) },
    ],
  });

  await demoPdf('vault/reglement-interieur.pdf', 'Règlement intérieur — AFRAM', [
    "L'étudiant est tenu d'assister à l'ensemble des enseignements inscrits à son emploi du temps.",
    'Toute absence doit être justifiée dans un délai de 72 heures via l’application UniParent ou auprès de la scolarité.',
    'Trois absences non justifiées dans une même matière peuvent entraîner une convocation des parents.',
    'Les frais de scolarité sont payables selon l’échéancier communiqué à l’inscription. Tout retard peut entraîner des pénalités.',
    'Le respect des personnes, des locaux et du matériel est exigé sur l’ensemble des campus.',
  ]);
  await demoPdf('vault/contrat-inscription.pdf', `Contrat d'inscription ${yearLabel}`, [
    'Le présent contrat lie l’étudiant, son représentant légal et l’AFRAM pour l’année académique en cours.',
    'L’AFRAM s’engage à dispenser les enseignements prévus au programme de la filière.',
    'Le représentant légal s’engage au règlement des frais selon l’échéancier.',
  ]);
  await demoPdf('justificatifs/demo-certificat.pdf', 'Certificat médical', ['Certificat médical de démonstration (données fictives).']);

  console.log('--- Seed terminé ---');
  console.log(`Mot de passe de tous les comptes de démo : ${DEMO_PASSWORD}`);
  console.log('Parent : parent@aframgabon.com / +241066701184 (2 enfants)');
  console.log('Activation : code AFRAM-2026-ACTIVATE (Clarisse OBIANG, +241066112233)');
  console.log('Étudiant : alexandre.obiang@etudiant.afram.ga');
  console.log('Admin : admin@aframgabon.com · scolarite@ · comptable@ · direction@ · support@');
  console.log('Enseignant : p.ndong@aframgabon.com');
  console.log(`Créneaux générés : ${slotCount} · Support : ${support.email}`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());

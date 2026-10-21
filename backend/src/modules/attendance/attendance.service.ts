import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import {
  AttendanceStatus,
  JustificationStatus,
  NotificationCategory,
  SlotStatus,
  UserRole,
} from '@prisma/client';
import { createHmac, randomBytes, timingSafeEqual } from 'crypto';
import { AuthUser, ChildAccessService } from '../../common/access/child-access.service';
import { AuditContext, AuditService } from '../../common/audit/audit.service';
import { StorageService } from '../../common/storage/storage.service';
import { env } from '../../config/env';
import { PrismaService } from '../../prisma/prisma.service';
import { NotificationsService } from '../notifications/notifications.service';

const QR_VALIDITY_MINUTES = 10;
const LATE_AFTER_MINUTES = 15;

export interface RollCallEntry {
  studentId: string;
  statut: AttendanceStatus;
  minutesRetard?: number;
}

const fmt = (d: Date) =>
  d.toLocaleString('fr-FR', { timeZone: 'Africa/Libreville', weekday: 'long', day: 'numeric', month: 'long', hour: '2-digit', minute: '2-digit' });

/** Taux d'assiduité : présent, retard et excusé comptent comme présence. */
export function attendanceRate(counts: Partial<Record<AttendanceStatus, number>>): number | null {
  const total = Object.values(counts).reduce((s, n) => s + (n ?? 0), 0);
  if (!total) return null;
  const present = (counts.PRESENT ?? 0) + (counts.RETARD ?? 0) + (counts.EXCUSE ?? 0);
  return Math.round((present / total) * 1000) / 10;
}

@Injectable()
export class AttendanceService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly access: ChildAccessService,
    private readonly audit: AuditService,
    private readonly notifications: NotificationsService,
    private readonly storage: StorageService,
  ) {}

  // ------------------------------------------------------------------ Côté parent / étudiant
  async list(user: AuthUser, studentId: string, from?: string, to?: string) {
    await this.access.assertCanAccess(user, studentId);
    const range = this.range(from, to);
    const rows = await this.prisma.attendanceRecord.findMany({
      where: { studentId, slot: { dateDebut: { gte: range.from, lte: range.to } } },
      orderBy: { slot: { dateDebut: 'desc' } },
      include: {
        justification: { select: { id: true, motif: true, statut: true, commentaire: true, createdAt: true } },
        slot: {
          select: {
            dateDebut: true,
            dateFin: true,
            course: { select: { id: true, code: true, nom: true } },
            teacher: { select: { nom: true, prenom: true } },
            room: { select: { code: true } },
          },
        },
      },
    });
    return rows.map((r) => ({
      id: r.id,
      statut: r.statut,
      minutesRetard: r.minutesRetard,
      date: r.slot.dateDebut,
      fin: r.slot.dateFin,
      dureeMinutes: Math.round((r.slot.dateFin.getTime() - r.slot.dateDebut.getTime()) / 60_000),
      cours: r.slot.course,
      enseignant: `${r.slot.teacher.prenom} ${r.slot.teacher.nom}`,
      salle: r.slot.room.code,
      justification: r.justification,
      justifiable:
        (r.statut === AttendanceStatus.ABSENT || r.statut === AttendanceStatus.RETARD) &&
        (!r.justification || r.justification.statut === JustificationStatus.REJETE),
    }));
  }

  async stats(user: AuthUser, studentId: string, from?: string, to?: string) {
    await this.access.assertCanAccess(user, studentId);
    const range = this.range(from, to);
    const rows = await this.prisma.attendanceRecord.findMany({
      where: { studentId, slot: { dateDebut: { gte: range.from, lte: range.to } } },
      select: {
        statut: true,
        justification: { select: { statut: true } },
        slot: { select: { dateDebut: true, course: { select: { id: true, nom: true } } } },
      },
    });

    const global: Partial<Record<AttendanceStatus, number>> = {};
    const byCourse = new Map<string, { courseId: string; nom: string; counts: Partial<Record<AttendanceStatus, number>> }>();
    const byWeek = new Map<string, { semaine: string; absences: number; retards: number }>();
    let nonJustifiees = 0;

    for (const r of rows) {
      global[r.statut] = (global[r.statut] ?? 0) + 1;
      const c = byCourse.get(r.slot.course.id) ?? { courseId: r.slot.course.id, nom: r.slot.course.nom, counts: {} };
      c.counts[r.statut] = (c.counts[r.statut] ?? 0) + 1;
      byCourse.set(r.slot.course.id, c);

      const d = r.slot.dateDebut;
      const monday = new Date(d.getFullYear(), d.getMonth(), d.getDate() - ((d.getDay() + 6) % 7));
      const key = monday.toISOString().slice(0, 10);
      const w = byWeek.get(key) ?? { semaine: key, absences: 0, retards: 0 };
      if (r.statut === AttendanceStatus.ABSENT) w.absences++;
      if (r.statut === AttendanceStatus.RETARD) w.retards++;
      byWeek.set(key, w);

      if (r.statut === AttendanceStatus.ABSENT && r.justification?.statut !== JustificationStatus.VALIDE) nonJustifiees++;
    }

    return {
      periode: range,
      tauxGlobal: attendanceRate(global),
      totaux: { seances: rows.length, ...global, absencesNonJustifiees: nonJustifiees },
      parMatiere: [...byCourse.values()].map((c) => ({
        courseId: c.courseId,
        matiere: c.nom,
        taux: attendanceRate(c.counts),
        absences: c.counts.ABSENT ?? 0,
        retards: c.counts.RETARD ?? 0,
      })),
      parSemaine: [...byWeek.values()].sort((a, b) => a.semaine.localeCompare(b.semaine)),
    };
  }

  async justify(user: AuthUser, attendanceId: string, motif: string, file: Express.Multer.File | undefined, ctx: AuditContext) {
    const record = await this.prisma.attendanceRecord.findUnique({
      where: { id: attendanceId },
      include: { justification: true, student: { select: { prenom: true, nom: true } }, slot: { select: { dateDebut: true, course: { select: { nom: true } } } } },
    });
    if (!record) throw new NotFoundException('Absence introuvable');
    await this.access.assertCanAccess(user, record.studentId);
    if (user.role !== UserRole.PARENT && user.role !== UserRole.ETUDIANT) {
      throw new ForbiddenException('Seuls le parent ou l’étudiant peuvent justifier');
    }
    if (record.statut !== AttendanceStatus.ABSENT && record.statut !== AttendanceStatus.RETARD) {
      throw new BadRequestException('Seules les absences et retards peuvent être justifiés');
    }
    if (record.justification && record.justification.statut !== JustificationStatus.REJETE) {
      throw new BadRequestException('Un justificatif est déjà en cours d’examen ou validé');
    }
    this.storage.validateUpload(file);
    const stored = await this.storage.put('justificatifs-absence', file!.buffer, file!.mimetype);

    const data = { motif, documentUrl: stored.key, statut: JustificationStatus.EN_ATTENTE, commentaire: null, decisionParId: null, decisionDate: null };
    const justification = record.justification
      ? await this.prisma.absenceJustification.update({ where: { id: record.justification.id }, data })
      : await this.prisma.absenceJustification.create({ data: { ...data, attendanceRecordId: record.id } });
    await this.audit.log(ctx, 'ABSENCE_JUSTIFIED', 'AbsenceJustification', justification.id, null, { motif, fichier: stored.key, sha256: stored.sha256 });

    const scolarite = await this.prisma.user.findMany({ where: { role: UserRole.SCOLARITE, status: 'ACTIVE' }, select: { id: true } });
    await this.notifications.notify(scolarite.map((u) => u.id), {
      categorie: NotificationCategory.PRESENCE,
      titre: 'Nouveau justificatif d’absence',
      corps: `${record.student.prenom} ${record.student.nom} — ${record.slot.course.nom} (${fmt(record.slot.dateDebut)})`,
      data: { type: 'JUSTIFICATION_SUBMITTED', justificationId: justification.id },
    });
    return justification;
  }

  async justificationFile(user: AuthUser, attendanceId: string) {
    const record = await this.prisma.attendanceRecord.findUnique({ where: { id: attendanceId }, include: { justification: true } });
    if (!record?.justification) throw new NotFoundException('Justificatif introuvable');
    await this.access.assertCanAccess(user, record.studentId);
    return { buffer: await this.storage.get(record.justification.documentUrl), key: record.justification.documentUrl };
  }

  // ------------------------------------------------------------------ Côté enseignant
  async teacherSlots(user: AuthUser, date?: string) {
    const day = date ? new Date(date) : new Date();
    const start = new Date(day.getFullYear(), day.getMonth(), day.getDate());
    const end = new Date(start.getTime() + 86_400_000);
    return this.prisma.timetableSlot.findMany({
      where: { dateDebut: { gte: start, lt: end }, ...(this.isStaff(user) ? {} : { teacherId: user.teacherId ?? '__none__' }) },
      orderBy: { dateDebut: 'asc' },
      include: {
        course: { select: { code: true, nom: true } },
        group: { select: { id: true, nom: true, _count: { select: { students: true } } } },
        room: { select: { code: true } },
        _count: { select: { attendanceRecords: true } },
      },
    });
  }

  async roster(user: AuthUser, slotId: string) {
    const slot = await this.ownSlot(user, slotId);
    const [students, records] = await Promise.all([
      this.prisma.student.findMany({
        where: { groupId: slot.groupId, deletedAt: null },
        orderBy: [{ nom: 'asc' }, { prenom: 'asc' }],
        select: { id: true, matricule: true, nom: true, prenom: true, photoUrl: true },
      }),
      this.prisma.attendanceRecord.findMany({ where: { slotId } }),
    ]);
    const byStudent = new Map(records.map((r) => [r.studentId, r]));
    return {
      slot: { id: slot.id, debut: slot.dateDebut, fin: slot.dateFin, statut: slot.statut },
      etudiants: students.map((s) => ({ ...s, statut: byStudent.get(s.id)?.statut ?? null, minutesRetard: byStudent.get(s.id)?.minutesRetard ?? 0 })),
    };
  }

  async rollCall(user: AuthUser, slotId: string, entries: RollCallEntry[], ctx: AuditContext) {
    const slot = await this.ownSlot(user, slotId);
    if (slot.statut === SlotStatus.ANNULE) throw new BadRequestException('Séance annulée');
    if (slot.dateDebut.getTime() - Date.now() > 30 * 60_000) throw new BadRequestException('L’appel ne peut pas être fait plus de 30 minutes avant la séance');

    const groupStudents = new Set(
      (await this.prisma.student.findMany({ where: { groupId: slot.groupId }, select: { id: true } })).map((s) => s.id),
    );
    const existing = new Map((await this.prisma.attendanceRecord.findMany({ where: { slotId } })).map((r) => [r.studentId, r]));
    const changed: { studentId: string; statut: AttendanceStatus; minutesRetard: number }[] = [];

    await this.prisma.$transaction(async (tx) => {
      for (const e of entries) {
        if (!groupStudents.has(e.studentId)) throw new BadRequestException('Étudiant hors du groupe de la séance');
        const minutesRetard = e.statut === AttendanceStatus.RETARD ? Math.max(1, e.minutesRetard ?? 0) : 0;
        const prev = existing.get(e.studentId);
        if (prev && prev.statut === e.statut && prev.minutesRetard === minutesRetard) continue;
        await tx.attendanceRecord.upsert({
          where: { slotId_studentId: { slotId, studentId: e.studentId } },
          create: { slotId, studentId: e.studentId, statut: e.statut, minutesRetard, saisiParId: user.id },
          update: { statut: e.statut, minutesRetard, saisiParId: user.id },
        });
        await this.audit.log(ctx, prev ? 'ATTENDANCE_UPDATED' : 'ATTENDANCE_RECORDED', 'AttendanceRecord', `${slotId}:${e.studentId}`, prev ? { statut: prev.statut } : null, { statut: e.statut, minutesRetard }, tx);
        changed.push({ studentId: e.studentId, statut: e.statut, minutesRetard });
      }
      if (slot.statut === SlotStatus.PLANIFIE) await tx.timetableSlot.update({ where: { id: slotId }, data: { statut: SlotStatus.EN_COURS } });
    });

    await this.notifyChanges(slotId, changed);
    return { enregistres: changed.length };
  }

  /** QR de séance : code signé, valable 10 minutes, affiché par l'enseignant. */
  async generateQr(user: AuthUser, slotId: string) {
    const slot = await this.ownSlot(user, slotId);
    const expires = Date.now() + QR_VALIDITY_MINUTES * 60_000;
    const nonce = randomBytes(6).toString('base64url');
    const payload = `${slot.id}.${expires}.${nonce}`;
    const code = `${payload}.${this.sign(payload)}`;
    await this.prisma.timetableSlot.update({ where: { id: slot.id }, data: { sessionCodeQr: code } });
    return { code, expiresAt: new Date(expires) };
  }

  async scan(user: AuthUser, code: string, ctx: AuditContext) {
    if (user.role !== UserRole.ETUDIANT || !user.studentId) throw new ForbiddenException('Réservé aux étudiants');
    const parts = code.split('.');
    if (parts.length !== 4) throw new BadRequestException('QR code invalide');
    const [slotId, expires, nonce, sig] = parts;
    const expected = this.sign(`${slotId}.${expires}.${nonce}`);
    if (sig.length !== expected.length || !timingSafeEqual(Buffer.from(sig), Buffer.from(expected))) throw new BadRequestException('QR code invalide');
    if (Number(expires) < Date.now()) throw new BadRequestException('QR code expiré, demandez-en un nouveau à l’enseignant');

    const slot = await this.prisma.timetableSlot.findUnique({ where: { id: slotId } });
    if (!slot || slot.sessionCodeQr !== code) throw new BadRequestException('QR code révoqué');
    const student = await this.prisma.student.findUniqueOrThrow({ where: { id: user.studentId } });
    if (student.groupId !== slot.groupId) throw new ForbiddenException('Cette séance ne concerne pas votre groupe');

    const lateBy = Math.floor((Date.now() - slot.dateDebut.getTime()) / 60_000);
    const statut = lateBy > LATE_AFTER_MINUTES ? AttendanceStatus.RETARD : AttendanceStatus.PRESENT;
    await this.prisma.attendanceRecord.upsert({
      where: { slotId_studentId: { slotId, studentId: student.id } },
      create: { slotId, studentId: student.id, statut, minutesRetard: statut === AttendanceStatus.RETARD ? lateBy : 0, saisiParId: user.id },
      update: { statut, minutesRetard: statut === AttendanceStatus.RETARD ? lateBy : 0, saisiParId: user.id },
    });
    await this.audit.log(ctx, 'ATTENDANCE_QR_SCAN', 'AttendanceRecord', `${slotId}:${student.id}`, null, { statut });
    if (statut === AttendanceStatus.RETARD) await this.notifyChanges(slotId, [{ studentId: student.id, statut, minutesRetard: lateBy }]);
    return { statut, minutesRetard: statut === AttendanceStatus.RETARD ? lateBy : 0 };
  }

  // ------------------------------------------------------------------ Côté scolarité
  pendingJustifications() {
    return this.prisma.absenceJustification.findMany({
      where: { statut: JustificationStatus.EN_ATTENTE },
      orderBy: { createdAt: 'asc' },
      include: {
        attendanceRecord: {
          select: {
            id: true,
            statut: true,
            student: { select: { id: true, matricule: true, nom: true, prenom: true, group: { select: { nom: true } } } },
            slot: { select: { dateDebut: true, course: { select: { nom: true } } } },
          },
        },
      },
    });
  }

  async review(user: AuthUser, justificationId: string, decision: 'VALIDE' | 'REJETE', commentaire: string | undefined, ctx: AuditContext) {
    const j = await this.prisma.absenceJustification.findUnique({
      where: { id: justificationId },
      include: { attendanceRecord: { include: { slot: { include: { course: true } } } } },
    });
    if (!j) throw new NotFoundException('Justificatif introuvable');
    if (j.statut !== JustificationStatus.EN_ATTENTE) throw new BadRequestException('Justificatif déjà traité');
    const updated = await this.prisma.absenceJustification.update({
      where: { id: justificationId },
      data: { statut: decision, commentaire, decisionParId: user.id, decisionDate: new Date() },
    });
    await this.audit.log(ctx, 'JUSTIFICATION_REVIEWED', 'AbsenceJustification', justificationId, { statut: j.statut }, { statut: decision, commentaire });
    const rec = j.attendanceRecord;
    await this.notifications.notify(await this.access.stakeholderUserIds(rec.studentId), {
      categorie: NotificationCategory.PRESENCE,
      titre: decision === 'VALIDE' ? 'Absence justifiée' : 'Justificatif refusé',
      corps: `${rec.slot.course.nom} (${fmt(rec.slot.dateDebut)}) : ${decision === 'VALIDE' ? 'le justificatif a été accepté' : 'le justificatif a été refusé'}${commentaire ? ` — ${commentaire}` : ''}.`,
      data: { type: 'JUSTIFICATION_REVIEWED', attendanceId: rec.id, studentId: rec.studentId },
    });
    return updated;
  }

  async groupStats(groupId: string, from?: string, to?: string) {
    const range = this.range(from, to);
    const rows = await this.prisma.attendanceRecord.groupBy({
      by: ['studentId', 'statut'],
      where: { slot: { groupId, dateDebut: { gte: range.from, lte: range.to } } },
      _count: true,
    });
    const students = await this.prisma.student.findMany({ where: { groupId }, select: { id: true, matricule: true, nom: true, prenom: true } });
    return students.map((s) => {
      const counts = Object.fromEntries(rows.filter((r) => r.studentId === s.id).map((r) => [r.statut, r._count])) as Partial<Record<AttendanceStatus, number>>;
      return { ...s, taux: attendanceRate(counts), absences: counts.ABSENT ?? 0, retards: counts.RETARD ?? 0 };
    });
  }

  // ------------------------------------------------------------------ Interne
  private async notifyChanges(slotId: string, changed: { studentId: string; statut: AttendanceStatus; minutesRetard: number }[]) {
    const relevant = changed.filter((c) => c.statut === AttendanceStatus.ABSENT || c.statut === AttendanceStatus.RETARD);
    if (!relevant.length) return;
    const slot = await this.prisma.timetableSlot.findUniqueOrThrow({ where: { id: slotId }, include: { course: true } });
    const threshold = await this.threshold();
    for (const c of relevant) {
      const student = await this.prisma.student.findUniqueOrThrow({ where: { id: c.studentId }, select: { prenom: true, nom: true } });
      const who = `${student.prenom} ${student.nom}`;
      const recipients = await this.access.stakeholderUserIds(c.studentId);
      await this.notifications.notify(recipients, {
        categorie: NotificationCategory.PRESENCE,
        titre: c.statut === AttendanceStatus.ABSENT ? 'Absence signalée' : 'Retard signalé',
        corps:
          c.statut === AttendanceStatus.ABSENT
            ? `${who} est absent(e) au cours de ${slot.course.nom} (${fmt(slot.dateDebut)}).`
            : `${who} est arrivé(e) avec ${c.minutesRetard} min de retard en ${slot.course.nom}.`,
        data: { type: 'ATTENDANCE', slotId, studentId: c.studentId },
      });

      if (c.statut === AttendanceStatus.ABSENT) {
        const unjustified = await this.prisma.attendanceRecord.count({
          where: {
            studentId: c.studentId,
            statut: AttendanceStatus.ABSENT,
            OR: [{ justification: null }, { justification: { statut: { not: JustificationStatus.VALIDE } } }],
            slot: { dateDebut: { gte: new Date(Date.now() - 30 * 86_400_000) } },
          },
        });
        if (unjustified === threshold) {
          const scolarite = await this.prisma.user.findMany({ where: { role: UserRole.SCOLARITE, status: 'ACTIVE' }, select: { id: true } });
          await this.notifications.notify([...recipients, ...scolarite.map((u) => u.id)], {
            categorie: NotificationCategory.PRESENCE,
            titre: 'Alerte assiduité',
            corps: `${who} cumule ${unjustified} absences non justifiées sur 30 jours.`,
            data: { type: 'ATTENDANCE_THRESHOLD', studentId: c.studentId },
            forceSms: true,
          });
        }
      }
    }
  }

  private async threshold() {
    const s = await this.prisma.appSetting.findUnique({ where: { key: 'attendance.alertThreshold' } });
    return typeof s?.value === 'number' ? s.value : 3;
  }

  private isStaff(user: AuthUser) {
    return user.role === UserRole.SCOLARITE || user.role === UserRole.SUPER_ADMIN;
  }

  private async ownSlot(user: AuthUser, slotId: string) {
    const slot = await this.prisma.timetableSlot.findUnique({ where: { id: slotId } });
    if (!slot) throw new NotFoundException('Séance introuvable');
    if (!this.isStaff(user) && slot.teacherId !== user.teacherId) throw new ForbiddenException('Cette séance ne vous est pas attribuée');
    return slot;
  }

  private sign(payload: string) {
    return createHmac('sha256', env.jwt.accessSecret).update(`qr:${payload}`).digest('base64url').slice(0, 22);
  }

  private range(from?: string, to?: string) {
    const now = new Date();
    return {
      from: from ? new Date(from) : new Date(now.getFullYear(), now.getMonth() - 3, 1),
      to: to ? new Date(to) : now,
    };
  }
}

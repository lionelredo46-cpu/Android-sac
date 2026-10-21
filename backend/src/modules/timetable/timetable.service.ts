import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { AnnouncementTarget, CalendarEventType, NotificationCategory, SlotStatus } from '@prisma/client';
import { AuthUser, ChildAccessService } from '../../common/access/child-access.service';
import { AuditContext, AuditService } from '../../common/audit/audit.service';
import { PrismaService } from '../../prisma/prisma.service';
import { ChildrenService } from '../children/children.service';
import { targetFilter } from '../messaging/targeting';
import { NotificationsService } from '../notifications/notifications.service';

const icsDate = (d: Date) => d.toISOString().replace(/[-:]/g, '').replace(/\.\d{3}/, '');
const icsEscape = (s: string) => s.replace(/\\/g, '\\\\').replace(/;/g, '\\;').replace(/,/g, '\\,').replace(/\n/g, '\\n');
const fmt = (d: Date) => d.toLocaleString('fr-FR', { timeZone: 'Africa/Libreville', weekday: 'long', day: 'numeric', month: 'long', hour: '2-digit', minute: '2-digit' });

@Injectable()
export class TimetableService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly access: ChildAccessService,
    private readonly children: ChildrenService,
    private readonly audit: AuditService,
    private readonly notifications: NotificationsService,
  ) {}

  private weekRange(from?: string, to?: string) {
    const now = new Date();
    const monday = new Date(now.getFullYear(), now.getMonth(), now.getDate() - ((now.getDay() + 6) % 7));
    return { from: from ? new Date(from) : monday, to: to ? new Date(to) : new Date(monday.getTime() + 7 * 86_400_000) };
  }

  async forStudent(user: AuthUser, studentId: string, from?: string, to?: string) {
    const student = await this.access.assertCanAccess(user, studentId);
    const range = this.weekRange(from, to);
    if (range.to.getTime() - range.from.getTime() > 62 * 86_400_000) throw new BadRequestException('Période limitée à 2 mois');
    const slots = await this.prisma.timetableSlot.findMany({
      where: { groupId: student.groupId, dateDebut: { gte: range.from, lt: range.to } },
      orderBy: { dateDebut: 'asc' },
      include: {
        course: { select: { code: true, nom: true } },
        teacher: { select: { nom: true, prenom: true } },
        room: { select: { code: true, campus: { select: { nom: true } } } },
      },
    });
    return {
      periode: range,
      creneaux: slots.map((s) => ({
        id: s.id,
        debut: s.dateDebut,
        fin: s.dateFin,
        statut: s.statut,
        motif: s.motifAnnulation,
        matiere: s.course.nom,
        code: s.course.code,
        enseignant: `${s.teacher.prenom} ${s.teacher.nom}`,
        salle: s.room.code,
        campus: s.room.campus.nom,
      })),
    };
  }

  async ics(user: AuthUser, studentId: string) {
    const student = await this.access.assertCanAccess(user, studentId);
    const now = new Date();
    const [slots, events] = await Promise.all([
      this.prisma.timetableSlot.findMany({
        where: { groupId: student.groupId, dateDebut: { gte: new Date(now.getTime() - 7 * 86_400_000), lte: new Date(now.getTime() + 120 * 86_400_000) } },
        include: { course: true, room: { include: { campus: true } }, teacher: true },
      }),
      this.calendarEvents(user),
    ]);
    const lines = ['BEGIN:VCALENDAR', 'VERSION:2.0', 'PRODID:-//UniParent AFRAM//FR', 'CALSCALE:GREGORIAN', 'X-WR-CALNAME:AFRAM — Emploi du temps', 'X-WR-TIMEZONE:Africa/Libreville'];
    for (const s of slots) {
      lines.push(
        'BEGIN:VEVENT',
        `UID:${s.id}@uniparent.afram`,
        `DTSTAMP:${icsDate(now)}`,
        `DTSTART:${icsDate(s.dateDebut)}`,
        `DTEND:${icsDate(s.dateFin)}`,
        `SUMMARY:${icsEscape(`${s.statut === SlotStatus.ANNULE ? '[ANNULÉ] ' : ''}${s.course.nom}`)}`,
        `LOCATION:${icsEscape(`${s.room.code} — Campus ${s.room.campus.nom}`)}`,
        `DESCRIPTION:${icsEscape(`Enseignant : ${s.teacher.prenom} ${s.teacher.nom}`)}`,
        `STATUS:${s.statut === SlotStatus.ANNULE ? 'CANCELLED' : 'CONFIRMED'}`,
        'END:VEVENT',
      );
    }
    for (const e of events) {
      lines.push('BEGIN:VEVENT', `UID:${e.id}@uniparent.afram`, `DTSTAMP:${icsDate(now)}`, `DTSTART:${icsDate(e.debut)}`, `DTEND:${icsDate(e.fin)}`, `SUMMARY:${icsEscape(e.titre)}`, `CATEGORIES:${e.type}`, 'END:VEVENT');
    }
    lines.push('END:VCALENDAR');
    return lines.join('\r\n');
  }

  async calendarEvents(user: AuthUser, from?: string, to?: string) {
    const audience = await this.children.audienceFor(user);
    return this.prisma.calendarEvent.findMany({
      where: {
        AND: [targetFilter(audience)],
        ...(from || to ? { debut: { ...(from ? { gte: new Date(from) } : {}), ...(to ? { lte: new Date(to) } : {}) } } : {}),
      },
      orderBy: { debut: 'asc' },
    });
  }

  // ------------------------------------------------------------------ Administration
  async createSlot(dto: { semesterId: string; courseId: string; groupId: string; teacherId: string; roomId: string; debut: string; fin: string }, ctx: AuditContext) {
    const debut = new Date(dto.debut);
    const fin = new Date(dto.fin);
    if (fin <= debut) throw new BadRequestException('La fin doit être après le début');
    await this.assertNoConflict(dto.roomId, dto.teacherId, dto.groupId, debut, fin);
    const slot = await this.prisma.timetableSlot.create({
      data: { semesterId: dto.semesterId, courseId: dto.courseId, groupId: dto.groupId, teacherId: dto.teacherId, roomId: dto.roomId, dateDebut: debut, dateFin: fin },
    });
    await this.audit.log(ctx, 'SLOT_CREATED', 'TimetableSlot', slot.id, null, dto);
    return slot;
  }

  async updateSlot(id: string, dto: { statut: 'ANNULE' | 'REPORTE' | 'PLANIFIE'; motif?: string; debut?: string; fin?: string; roomId?: string }, ctx: AuditContext) {
    const slot = await this.prisma.timetableSlot.findUnique({ where: { id }, include: { course: true, room: true } });
    if (!slot) throw new NotFoundException('Créneau introuvable');
    const debut = dto.debut ? new Date(dto.debut) : slot.dateDebut;
    const fin = dto.fin ? new Date(dto.fin) : slot.dateFin;
    if (dto.statut === 'REPORTE' && (!dto.debut || !dto.fin)) throw new BadRequestException('Nouvelles dates requises pour un report');
    if (dto.debut || dto.roomId) await this.assertNoConflict(dto.roomId ?? slot.roomId, slot.teacherId, slot.groupId, debut, fin, id);

    const updated = await this.prisma.timetableSlot.update({
      where: { id },
      data: { statut: dto.statut as SlotStatus, motifAnnulation: dto.motif ?? null, dateDebut: debut, dateFin: fin, roomId: dto.roomId ?? slot.roomId },
      include: { room: true },
    });
    await this.audit.log(ctx, `SLOT_${dto.statut}`, 'TimetableSlot', id, { statut: slot.statut, debut: slot.dateDebut, salle: slot.room.code }, { statut: dto.statut, debut, salle: updated.room.code, motif: dto.motif });

    const students = await this.prisma.student.findMany({ where: { groupId: slot.groupId, deletedAt: null }, select: { id: true } });
    const recipients = (await Promise.all(students.map((s) => this.access.stakeholderUserIds(s.id)))).flat();
    const corps =
      dto.statut === 'ANNULE'
        ? `${slot.course.nom} du ${fmt(slot.dateDebut)} est annulé.${dto.motif ? ` Motif : ${dto.motif}` : ''}`
        : dto.statut === 'REPORTE'
          ? `${slot.course.nom} est reporté au ${fmt(debut)} (salle ${updated.room.code}).`
          : `${slot.course.nom} du ${fmt(debut)} : changement de salle (${updated.room.code}).`;
    await this.notifications.notify(recipients, {
      categorie: NotificationCategory.EMPLOI_DU_TEMPS,
      titre: dto.statut === 'ANNULE' ? 'Cours annulé' : dto.statut === 'REPORTE' ? 'Cours reporté' : 'Changement d’emploi du temps',
      corps,
      data: { type: 'SLOT_CHANGED', slotId: id },
    });
    return updated;
  }

  async createEvent(dto: { titre: string; description?: string; type: CalendarEventType; debut: string; fin: string; targetType?: AnnouncementTarget; targetId?: string }, ctx: AuditContext) {
    const e = await this.prisma.calendarEvent.create({
      data: { ...dto, debut: new Date(dto.debut), fin: new Date(dto.fin), targetType: dto.targetType ?? AnnouncementTarget.ALL },
    });
    await this.audit.log(ctx, 'CALENDAR_EVENT_CREATED', 'CalendarEvent', e.id, null, dto);
    return e;
  }

  private async assertNoConflict(roomId: string, teacherId: string, groupId: string, debut: Date, fin: Date, excludeId?: string) {
    const conflict = await this.prisma.timetableSlot.findFirst({
      where: {
        id: excludeId ? { not: excludeId } : undefined,
        statut: { not: SlotStatus.ANNULE },
        dateDebut: { lt: fin },
        dateFin: { gt: debut },
        OR: [{ roomId }, { teacherId }, { groupId }],
      },
      include: { course: true, room: true },
    });
    if (conflict) {
      throw new BadRequestException(`Conflit avec « ${conflict.course.nom} » (${conflict.room.code}, ${fmt(conflict.dateDebut)})`);
    }
  }
}

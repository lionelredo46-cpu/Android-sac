import { BadRequestException, ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import {
  AnnouncementTarget,
  AppointmentStatus,
  NotificationCategory,
  Prisma,
  TicketPriority,
  TicketService,
  TicketStatus,
  UserRole,
} from '@prisma/client';
import { randomBytes } from 'crypto';
import { AuthUser, ChildAccessService, STAFF_READ_ROLES } from '../../common/access/child-access.service';
import { AuditContext, AuditService } from '../../common/audit/audit.service';
import { StorageService } from '../../common/storage/storage.service';
import { clampTake, toCursorPage } from '../../common/utils/http';
import { PrismaService } from '../../prisma/prisma.service';
import { ChildrenService } from '../children/children.service';
import { NotificationsService } from '../notifications/notifications.service';
import { targetFilter } from './targeting';

/** Délai de réponse cible (SLA) par priorité, en heures. */
const SLA_HOURS: Record<TicketPriority, number> = { URGENTE: 4, HAUTE: 24, NORMALE: 48, BASSE: 72 };

/** Services traités par chaque rôle administratif. */
const SERVICES_BY_ROLE: Partial<Record<UserRole, TicketService[]>> = {
  COMPTABLE: [TicketService.FINANCES],
  SCOLARITE: [TicketService.SCOLARITE, TicketService.PEDAGOGIE, TicketService.DISCIPLINE],
  SUPPORT: [TicketService.SUPPORT_TECHNIQUE, TicketService.FINANCES, TicketService.SCOLARITE, TicketService.PEDAGOGIE, TicketService.DISCIPLINE],
  DIRECTION: Object.values(TicketService),
  SUPER_ADMIN: Object.values(TicketService),
};

const ROLES_BY_SERVICE: Record<TicketService, UserRole[]> = {
  FINANCES: [UserRole.COMPTABLE, UserRole.SUPPORT],
  SCOLARITE: [UserRole.SCOLARITE, UserRole.SUPPORT],
  PEDAGOGIE: [UserRole.SCOLARITE],
  DISCIPLINE: [UserRole.SCOLARITE],
  SUPPORT_TECHNIQUE: [UserRole.SUPPORT],
};

const isFamily = (u: AuthUser) => u.role === UserRole.PARENT || u.role === UserRole.ETUDIANT;

@Injectable()
export class MessagingService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly access: ChildAccessService,
    private readonly children: ChildrenService,
    private readonly audit: AuditService,
    private readonly notifications: NotificationsService,
    private readonly storage: StorageService,
  ) {}

  // ------------------------------------------------------------------ Tickets / conversations
  private visibleWhere(user: AuthUser): Prisma.ConversationWhereInput {
    if (isFamily(user)) return { creeParUserId: user.id };
    if (user.role === UserRole.ENSEIGNANT) return { OR: [{ assigneAUserId: user.id }, { creeParUserId: user.id }] };
    const services = SERVICES_BY_ROLE[user.role] ?? [];
    return { OR: [{ service: { in: services } }, { assigneAUserId: user.id }, { creeParUserId: user.id }] };
  }

  async list(user: AuthUser, statut?: TicketStatus, cursor?: string, take?: number) {
    const n = clampTake(take);
    const rows = await this.prisma.conversation.findMany({
      where: { ...this.visibleWhere(user), ...(statut ? { statut } : {}) },
      orderBy: [{ updatedAt: 'desc' }, { id: 'desc' }],
      take: n + 1,
      ...(cursor ? { cursor: { id: cursor }, skip: 1 } : {}),
      include: {
        student: { select: { id: true, prenom: true, nom: true } },
        creePar: { select: { id: true, role: true, parentProfile: { select: { nom: true, prenom: true } } } },
        assigneA: { select: { id: true, email: true, role: true } },
        messages: { orderBy: { createdAt: 'desc' }, take: 1, select: { contenu: true, createdAt: true, auteurId: true } },
      },
    });
    const ids = rows.map((r) => r.id);
    const unread = await this.prisma.message.groupBy({
      by: ['conversationId'],
      where: { conversationId: { in: ids }, estLu: false, auteurId: { not: user.id } },
      _count: true,
    });
    const unreadMap = new Map(unread.map((u) => [u.conversationId, u._count]));
    const page = toCursorPage(rows, n);
    return {
      ...page,
      items: page.items.map(({ messages, ...c }) => ({ ...c, dernierMessage: messages[0] ?? null, nonLus: unreadMap.get(c.id) ?? 0, slaDepasse: !!c.slaDueAt && c.slaDueAt < new Date() && c.statut !== TicketStatus.RESOLU && c.statut !== TicketStatus.CLOTURE })),
    };
  }

  async create(
    user: AuthUser,
    dto: { sujet: string; service: TicketService; priorite?: TicketPriority; studentId?: string; message: string },
    file: Express.Multer.File | undefined,
    ctx: AuditContext,
  ) {
    if (dto.studentId) await this.access.assertCanAccess(user, dto.studentId);
    const attachments = file ? [await this.saveAttachment(file)] : [];
    const priorite = dto.priorite ?? TicketPriority.NORMALE;
    const count = await this.prisma.conversation.count();
    const conv = await this.prisma.conversation.create({
      data: {
        numeroTicket: `TCK-${new Date().getFullYear()}-${String(count + 1).padStart(4, '0')}-${randomBytes(2).toString('hex').toUpperCase()}`,
        sujet: dto.sujet,
        service: dto.service,
        priorite,
        studentId: dto.studentId,
        creeParUserId: user.id,
        slaDueAt: new Date(Date.now() + SLA_HOURS[priorite] * 3_600_000),
        messages: { create: { auteurId: user.id, contenu: dto.message, piecesJointes: attachments } },
      },
    });
    await this.audit.log(ctx, 'TICKET_CREATED', 'Conversation', conv.id, null, { service: dto.service, priorite });
    const staff = await this.prisma.user.findMany({ where: { role: { in: ROLES_BY_SERVICE[dto.service] }, status: 'ACTIVE' }, select: { id: true } });
    await this.notifications.notify(staff.map((s) => s.id), {
      categorie: NotificationCategory.MESSAGERIE,
      titre: `Nouveau ticket ${conv.numeroTicket}`,
      corps: dto.sujet,
      data: { type: 'TICKET_CREATED', conversationId: conv.id },
    });
    return conv;
  }

  /** L'administration écrit à un parent (permission messages.send_to_parent). */
  async staffStart(user: AuthUser, dto: { studentId: string; sujet: string; service: TicketService; message: string; destinataire: 'PARENTS' | 'ETUDIANT' }, ctx: AuditContext) {
    await this.access.assertCanAccess(user, dto.studentId);
    const student = await this.prisma.student.findUniqueOrThrow({
      where: { id: dto.studentId },
      include: { parentLinks: { where: { valideLe: { not: null } }, include: { parent: true } } },
    });
    const targets = dto.destinataire === 'ETUDIANT' ? [student.userId] : student.parentLinks.map((l) => l.parent.userId);
    if (!targets.length) throw new BadRequestException('Aucun destinataire rattaché');
    const created = [];
    for (const target of targets) {
      const conv = await this.prisma.conversation.create({
        data: {
          numeroTicket: `MSG-${new Date().getFullYear()}-${randomBytes(3).toString('hex').toUpperCase()}`,
          sujet: dto.sujet,
          service: dto.service,
          studentId: dto.studentId,
          creeParUserId: target, // la famille reste « propriétaire » du fil pour le voir dans sa messagerie
          assigneAUserId: user.id,
          statut: TicketStatus.EN_COURS,
          messages: { create: { auteurId: user.id, contenu: dto.message } },
        },
      });
      created.push(conv);
    }
    await this.audit.log(ctx, 'STAFF_MESSAGE_SENT', 'Student', dto.studentId, null, { sujet: dto.sujet, destinataires: targets.length });
    await this.notifications.notify(targets, {
      categorie: NotificationCategory.MESSAGERIE,
      titre: `Message de l’administration : ${dto.sujet}`,
      corps: dto.message.slice(0, 140),
      data: { type: 'MESSAGE', conversationId: created[0].id },
    });
    return created;
  }

  async get(user: AuthUser, id: string) {
    const conv = await this.prisma.conversation.findFirst({
      where: { id, ...this.visibleWhere(user) },
      include: {
        student: { select: { id: true, prenom: true, nom: true } },
        assigneA: { select: { id: true, email: true, role: true } },
        messages: {
          orderBy: { createdAt: 'asc' },
          include: { auteur: { select: { id: true, role: true, parentProfile: { select: { prenom: true, nom: true } }, studentProfile: { select: { prenom: true, nom: true } }, teacherProfile: { select: { prenom: true, nom: true } } } } },
        },
      },
    });
    if (!conv) throw new NotFoundException('Conversation introuvable');
    // Accusé de lecture : les messages des autres deviennent lus.
    await this.prisma.message.updateMany({ where: { conversationId: id, auteurId: { not: user.id }, estLu: false }, data: { estLu: true, luLe: new Date() } });
    return {
      ...conv,
      messages: conv.messages.map((m) => {
        const p = m.auteur.parentProfile ?? m.auteur.studentProfile ?? m.auteur.teacherProfile;
        return {
          id: m.id,
          contenu: m.contenu,
          createdAt: m.createdAt,
          estLu: m.estLu,
          luLe: m.luLe,
          piecesJointes: m.piecesJointes.length,
          moi: m.auteurId === user.id,
          auteur: p ? `${p.prenom} ${p.nom}` : this.serviceLabel(m.auteur.role),
          auteurRole: m.auteur.role,
        };
      }),
    };
  }

  async reply(user: AuthUser, id: string, contenu: string, file: Express.Multer.File | undefined, ctx: AuditContext) {
    const conv = await this.prisma.conversation.findFirst({ where: { id, ...this.visibleWhere(user) } });
    if (!conv) throw new NotFoundException('Conversation introuvable');
    if (conv.statut === TicketStatus.CLOTURE) throw new BadRequestException('Ce ticket est clôturé');
    const attachments = file ? [await this.saveAttachment(file)] : [];
    const msg = await this.prisma.message.create({ data: { conversationId: id, auteurId: user.id, contenu, piecesJointes: attachments } });

    const fromFamily = isFamily(user);
    await this.prisma.conversation.update({
      where: { id },
      data: {
        updatedAt: new Date(),
        ...(fromFamily
          ? { statut: conv.statut === TicketStatus.RESOLU ? TicketStatus.OUVERT : conv.statut }
          : { statut: conv.statut === TicketStatus.OUVERT ? TicketStatus.EN_COURS : conv.statut, assigneAUserId: conv.assigneAUserId ?? user.id }),
      },
    });

    const recipients = fromFamily
      ? conv.assigneAUserId
        ? [conv.assigneAUserId]
        : (await this.prisma.user.findMany({ where: { role: { in: ROLES_BY_SERVICE[conv.service] }, status: 'ACTIVE' }, select: { id: true } })).map((u) => u.id)
      : [conv.creeParUserId];
    await this.notifications.notify(recipients, {
      categorie: NotificationCategory.MESSAGERIE,
      titre: fromFamily ? `Réponse sur ${conv.numeroTicket}` : 'Nouvelle réponse de l’administration',
      corps: contenu.slice(0, 140),
      data: { type: 'MESSAGE', conversationId: id },
    });
    await this.audit.log(ctx, 'MESSAGE_SENT', 'Conversation', id, null, { messageId: msg.id, pieceJointe: attachments.length > 0 });
    return msg;
  }

  async updateStatus(user: AuthUser, id: string, dto: { statut?: TicketStatus; assigneAUserId?: string; priorite?: TicketPriority }, ctx: AuditContext) {
    if (isFamily(user)) throw new ForbiddenException();
    const conv = await this.prisma.conversation.findFirst({ where: { id, ...this.visibleWhere(user) } });
    if (!conv) throw new NotFoundException('Conversation introuvable');
    const updated = await this.prisma.conversation.update({ where: { id }, data: dto });
    await this.audit.log(ctx, 'TICKET_UPDATED', 'Conversation', id, { statut: conv.statut, assigne: conv.assigneAUserId }, dto);
    if (dto.statut === TicketStatus.RESOLU) {
      await this.notifications.notify([conv.creeParUserId], {
        categorie: NotificationCategory.MESSAGERIE,
        titre: `Ticket ${conv.numeroTicket} résolu`,
        corps: 'Votre demande a été traitée. Donnez votre avis en une touche.',
        data: { type: 'TICKET_RESOLVED', conversationId: id },
      });
    }
    return updated;
  }

  async rate(user: AuthUser, id: string, satisfaction: number) {
    const conv = await this.prisma.conversation.findFirst({ where: { id, creeParUserId: user.id } });
    if (!conv) throw new NotFoundException('Conversation introuvable');
    if (conv.statut !== TicketStatus.RESOLU && conv.statut !== TicketStatus.CLOTURE) throw new BadRequestException('Le ticket doit être résolu pour être évalué');
    return this.prisma.conversation.update({ where: { id }, data: { satisfaction, statut: TicketStatus.CLOTURE } });
  }

  async attachment(user: AuthUser, messageId: string, index: number) {
    const msg = await this.prisma.message.findUnique({ where: { id: messageId } });
    if (!msg) throw new NotFoundException();
    const conv = await this.prisma.conversation.findFirst({ where: { id: msg.conversationId, ...this.visibleWhere(user) } });
    if (!conv || !msg.piecesJointes[index]) throw new NotFoundException('Pièce jointe introuvable');
    const key = msg.piecesJointes[index];
    return { key, buffer: await this.storage.get(key) };
  }

  private async saveAttachment(file: Express.Multer.File) {
    this.storage.validateUpload(file);
    return (await this.storage.put('messagerie', file.buffer, file.mimetype)).key;
  }

  private serviceLabel(role: UserRole) {
    return ({ COMPTABLE: 'Service Comptabilité', SCOLARITE: 'Service Scolarité', SUPPORT: 'Accueil / Support', DIRECTION: 'Direction', SUPER_ADMIN: 'Administration', ENSEIGNANT: 'Enseignant' } as Record<string, string>)[role] ?? 'AFRAM';
  }

  // ------------------------------------------------------------------ Annonces
  async announcements(user: AuthUser, cursor?: string, take?: number) {
    const n = clampTake(take);
    const now = new Date();
    const where: Prisma.AnnouncementWhereInput = STAFF_READ_ROLES.includes(user.role)
      ? {}
      : {
          // AND explicite : le filtre de ciblage et celui d'expiration utilisent tous deux OR.
          AND: [targetFilter(await this.children.audienceFor(user)), { OR: [{ dateExpiration: null }, { dateExpiration: { gte: now } }] }],
          datePublication: { lte: now },
        };
    const rows = await this.prisma.announcement.findMany({
      where,
      orderBy: [{ datePublication: 'desc' }, { id: 'desc' }],
      take: n + 1,
      ...(cursor ? { cursor: { id: cursor }, skip: 1 } : {}),
    });
    return toCursorPage(rows, n);
  }

  async publishAnnouncement(user: AuthUser, dto: { titre: string; contenu: string; targetType: AnnouncementTarget; targetId?: string; dateExpiration?: string }, ctx: AuditContext) {
    if (dto.targetType !== AnnouncementTarget.ALL && !dto.targetId) throw new BadRequestException('Cible requise');
    const a = await this.prisma.announcement.create({
      data: { ...dto, dateExpiration: dto.dateExpiration ? new Date(dto.dateExpiration) : null, creeParId: user.id },
    });
    await this.audit.log(ctx, 'ANNOUNCEMENT_PUBLISHED', 'Announcement', a.id, null, dto);
    const recipients = await this.audienceUserIds(dto.targetType, dto.targetId);
    await this.notifications.notify(recipients, {
      categorie: NotificationCategory.MESSAGERIE,
      titre: dto.titre,
      corps: dto.contenu.slice(0, 160),
      data: { type: 'ANNOUNCEMENT', announcementId: a.id },
    });
    return { ...a, destinataires: recipients.length };
  }

  private async audienceUserIds(target: AnnouncementTarget, targetId?: string): Promise<string[]> {
    if (target === AnnouncementTarget.PARENT) {
      const p = await this.prisma.parent.findUnique({ where: { id: targetId } });
      return p ? [p.userId] : [];
    }
    const where: Prisma.StudentWhereInput = { deletedAt: null };
    if (target === AnnouncementTarget.PROGRAM) where.group = { programId: targetId };
    if (target === AnnouncementTarget.GROUP) where.groupId = targetId;
    if (target === AnnouncementTarget.STUDENT) where.id = targetId;
    const students = await this.prisma.student.findMany({
      where,
      select: { userId: true, parentLinks: { where: { valideLe: { not: null } }, select: { parent: { select: { userId: true } } } } },
    });
    return [...new Set(students.flatMap((s) => [s.userId, ...s.parentLinks.map((l) => l.parent.userId)]))];
  }

  // ------------------------------------------------------------------ Rendez-vous
  hosts() {
    return this.prisma.user.findMany({
      where: { role: { in: [UserRole.SCOLARITE, UserRole.COMPTABLE, UserRole.DIRECTION, UserRole.ENSEIGNANT] }, status: 'ACTIVE' },
      select: { id: true, role: true, email: true, teacherProfile: { select: { nom: true, prenom: true, specialite: true } } },
    });
  }

  appointments(user: AuthUser) {
    return this.prisma.appointment.findMany({
      where: { OR: [{ demandeurId: user.id }, { hoteId: user.id }] },
      orderBy: { debut: 'asc' },
      include: {
        hote: { select: { role: true, email: true, teacherProfile: { select: { nom: true, prenom: true } } } },
        demandeur: { select: { role: true, parentProfile: { select: { nom: true, prenom: true } } } },
      },
    });
  }

  async requestAppointment(user: AuthUser, dto: { hoteId: string; objet: string; debut: string; fin: string }, ctx: AuditContext) {
    const debut = new Date(dto.debut);
    const fin = new Date(dto.fin);
    if (debut < new Date() || fin <= debut) throw new BadRequestException('Créneau invalide');
    const host = await this.prisma.user.findFirst({ where: { id: dto.hoteId, role: { notIn: [UserRole.PARENT, UserRole.ETUDIANT] } } });
    if (!host) throw new NotFoundException('Interlocuteur introuvable');
    const busy = await this.prisma.appointment.findFirst({
      where: { hoteId: dto.hoteId, statut: { in: [AppointmentStatus.DEMANDE, AppointmentStatus.CONFIRME] }, debut: { lt: fin }, fin: { gt: debut } },
    });
    if (busy) throw new BadRequestException('Ce créneau est déjà réservé');
    const a = await this.prisma.appointment.create({ data: { demandeurId: user.id, hoteId: dto.hoteId, objet: dto.objet, debut, fin } });
    await this.audit.log(ctx, 'APPOINTMENT_REQUESTED', 'Appointment', a.id, null, dto);
    await this.notifications.notify([dto.hoteId], {
      categorie: NotificationCategory.MESSAGERIE,
      titre: 'Demande de rendez-vous',
      corps: `${dto.objet} — ${debut.toLocaleString('fr-FR', { timeZone: 'Africa/Libreville' })}`,
      data: { type: 'APPOINTMENT', appointmentId: a.id },
    });
    return a;
  }

  async updateAppointment(user: AuthUser, id: string, statut: AppointmentStatus, lieu: string | undefined, ctx: AuditContext) {
    const a = await this.prisma.appointment.findUnique({ where: { id } });
    if (!a || (a.demandeurId !== user.id && a.hoteId !== user.id)) throw new NotFoundException('Rendez-vous introuvable');
    if (a.demandeurId === user.id && a.hoteId !== user.id && statut !== AppointmentStatus.ANNULE) {
      throw new ForbiddenException('Le demandeur peut uniquement annuler');
    }
    const updated = await this.prisma.appointment.update({ where: { id }, data: { statut, ...(lieu ? { lieu } : {}) } });
    await this.audit.log(ctx, `APPOINTMENT_${statut}`, 'Appointment', id, { statut: a.statut }, { statut, lieu });
    await this.notifications.notify([a.demandeurId === user.id ? a.hoteId : a.demandeurId], {
      categorie: NotificationCategory.MESSAGERIE,
      titre: statut === AppointmentStatus.CONFIRME ? 'Rendez-vous confirmé' : statut === AppointmentStatus.ANNULE ? 'Rendez-vous annulé' : 'Rendez-vous mis à jour',
      corps: `${a.objet} — ${a.debut.toLocaleString('fr-FR', { timeZone: 'Africa/Libreville' })}${lieu ? ` (${lieu})` : ''}`,
      data: { type: 'APPOINTMENT', appointmentId: id },
    });
    return updated;
  }
}

import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import {
  AttendanceStatus,
  GradeStatus,
  InvoiceStatus,
  ParentRelationType,
  Prisma,
  TicketStatus,
  UserRole,
  UserStatus,
} from '@prisma/client';
import { randomBytes } from 'crypto';
import { AuthUser } from '../../common/access/child-access.service';
import { AuditContext, AuditService } from '../../common/audit/audit.service';
import { PERMISSIONS } from '../../common/guards/permissions';
import { RolesGuard } from '../../common/guards/roles.guard';
import { SmsService } from '../../common/sms/sms.service';
import { clampTake, toCursorPage } from '../../common/utils/http';
import { env } from '../../config/env';
import { PrismaService } from '../../prisma/prisma.service';
import { computeSemester } from '../grades/grade-calculator';

export interface NewStudentInput {
  matricule: string;
  nom: string;
  prenom: string;
  dateNaissance: string;
  groupId: string;
  email?: string;
  telephone?: string;
  parents: {
    nom: string;
    prenom: string;
    telephone: string;
    email?: string;
    relationType: ParentRelationType;
    estPayeur: boolean;
  }[];
}

const activationCode = () => `AFR-${randomBytes(4).toString('hex').toUpperCase()}`;
const STAFF_ROLES: UserRole[] = [UserRole.SUPER_ADMIN, UserRole.DIRECTION, UserRole.SCOLARITE, UserRole.COMPTABLE, UserRole.ENSEIGNANT, UserRole.SUPPORT];

@Injectable()
export class AdminService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
    private readonly sms: SmsService,
    private readonly roles: RolesGuard,
  ) {}

  // ------------------------------------------------------------------ Tableau de bord décisionnel
  async overview() {
    const now = new Date();
    const since = new Date(now.getTime() - 30 * 86_400_000);
    const [students, parentsActive, parentsTotal, invoices, attendance, openTickets, overdue, grades, pendingJustif, pendingRequests] = await Promise.all([
      this.prisma.student.count({ where: { deletedAt: null, statut: { in: ['INSCRIT', 'EN_ATTENTE_DOCUMENTS'] } } }),
      this.prisma.user.count({ where: { role: UserRole.PARENT, status: UserStatus.ACTIVE, lastLoginAt: { gte: since } } }),
      this.prisma.user.count({ where: { role: UserRole.PARENT, deletedAt: null } }),
      this.prisma.invoice.aggregate({ where: { statut: { not: InvoiceStatus.ANNULE } }, _sum: { montantTotal: true, montantPaye: true, soldeRestant: true } }),
      this.prisma.attendanceRecord.groupBy({ by: ['statut'], where: { slot: { dateDebut: { gte: since } } }, _count: true }),
      this.prisma.conversation.count({ where: { statut: { in: [TicketStatus.OUVERT, TicketStatus.EN_COURS] } } }),
      this.prisma.invoice.aggregate({ where: { statut: { not: InvoiceStatus.ANNULE }, soldeRestant: { gt: 0n }, dateEcheance: { lt: now } }, _sum: { soldeRestant: true }, _count: true }),
      this.prisma.grade.findMany({
        where: { statut: GradeStatus.PUBLIE, assessment: { semester: { estActif: true } } },
        select: { valeur: true, studentId: true, assessment: { select: { bareme: true, coefficient: true, course: { select: { id: true, code: true, nom: true, coefficient: true, creditsEcts: true } } } } },
      }),
      this.prisma.absenceJustification.count({ where: { statut: 'EN_ATTENTE' } }),
      this.prisma.documentRequest.count({ where: { statut: { in: ['SOUMISE', 'EN_TRAITEMENT'] } } }),
    ]);
    const counts = Object.fromEntries(attendance.map((a) => [a.statut, a._count])) as Partial<Record<AttendanceStatus, number>>;
    const total = Object.values(counts).reduce((s, n) => s + (n ?? 0), 0);
    const byStudent = new Map<string, typeof grades>();
    for (const g of grades) byStudent.set(g.studentId, [...(byStudent.get(g.studentId) ?? []), g]);
    const averages = [...byStudent.values()]
      .map((list) =>
        computeSemester(list.map((g) => ({ valeur: g.valeur, bareme: g.assessment.bareme, assessmentCoefficient: g.assessment.coefficient, courseId: g.assessment.course.id, courseCode: g.assessment.course.code, courseNom: g.assessment.course.nom, courseCoefficient: g.assessment.course.coefficient, courseCredits: g.assessment.course.creditsEcts }))).moyenneGenerale,
      )
      .filter((m): m is number => m !== null);
    const facture = invoices._sum.montantTotal ?? 0n;
    const paye = invoices._sum.montantPaye ?? 0n;

    return {
      inscrits: students,
      adoption: { parentsActifs30j: parentsActive, parentsTotal, taux: parentsTotal ? Math.round((parentsActive / parentsTotal) * 1000) / 10 : null },
      finances: {
        totalFacture: facture,
        totalEncaisse: paye,
        resteARecouvrer: invoices._sum.soldeRestant ?? 0n,
        tauxRecouvrement: facture > 0n ? Number((paye * 1000n) / facture) / 10 : null,
        impayesEnRetard: { montant: overdue._sum.soldeRestant ?? 0n, factures: overdue._count },
      },
      assiduite30j: total ? Math.round((((counts.PRESENT ?? 0) + (counts.RETARD ?? 0) + (counts.EXCUSE ?? 0)) / total) * 1000) / 10 : null,
      moyenneGeneraleSemestre: averages.length ? Math.round((averages.reduce((a, b) => a + b, 0) / averages.length) * 100) / 100 : null,
      ticketsOuverts: openTickets,
      aTraiter: { justificatifs: pendingJustif, demandesDocuments: pendingRequests },
    };
  }

  // ------------------------------------------------------------------ Utilisateurs
  async users(q: { role?: UserRole; search?: string; cursor?: string; take?: number }) {
    const n = clampTake(q.take);
    const s = q.search?.trim();
    const rows = await this.prisma.user.findMany({
      where: {
        deletedAt: null,
        ...(q.role ? { role: q.role } : {}),
        ...(s
          ? {
              OR: [
                { email: { contains: s, mode: 'insensitive' } },
                { telephone: { contains: s } },
                { parentProfile: { OR: [{ nom: { contains: s, mode: 'insensitive' } }, { prenom: { contains: s, mode: 'insensitive' } }] } },
                { studentProfile: { OR: [{ nom: { contains: s, mode: 'insensitive' } }, { prenom: { contains: s, mode: 'insensitive' } }, { matricule: { contains: s, mode: 'insensitive' } }] } },
              ],
            }
          : {}),
      },
      orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
      take: n + 1,
      ...(q.cursor ? { cursor: { id: q.cursor }, skip: 1 } : {}),
      select: {
        id: true, email: true, telephone: true, role: true, status: true, lastLoginAt: true, twoFactorEnabled: true, createdAt: true,
        parentProfile: { select: { id: true, nom: true, prenom: true } },
        studentProfile: { select: { id: true, nom: true, prenom: true, matricule: true, group: { select: { nom: true } } } },
        teacherProfile: { select: { id: true, nom: true, prenom: true } },
      },
    });
    return toCursorPage(rows, n);
  }

  async createStaff(actor: AuthUser, dto: { email: string; telephone: string; role: UserRole; nom?: string; prenom?: string; specialite?: string }, ctx: AuditContext) {
    if (!STAFF_ROLES.includes(dto.role)) throw new BadRequestException('Rôle administratif attendu');
    if (dto.role === UserRole.SUPER_ADMIN && actor.role !== UserRole.SUPER_ADMIN) throw new BadRequestException('Seul un super administrateur peut en créer un autre');
    const code = activationCode();
    const user = await this.prisma.user.create({
      data: {
        email: dto.email.toLowerCase(),
        telephone: dto.telephone,
        passwordHash: '',
        role: dto.role,
        status: UserStatus.PENDING_ACTIVATION,
        activationToken: code,
        ...(dto.role === UserRole.ENSEIGNANT
          ? { teacherProfile: { create: { matricule: `ENS-${randomBytes(3).toString('hex').toUpperCase()}`, nom: dto.nom ?? '', prenom: dto.prenom ?? '', specialite: dto.specialite } } }
          : {}),
      },
    });
    await this.audit.log(ctx, 'STAFF_CREATED', 'User', user.id, null, { email: dto.email, role: dto.role });
    await this.sendInvitation(dto.telephone, code);
    return { id: user.id, activationCode: env.isProd ? undefined : code };
  }

  async setStatus(actor: AuthUser, userId: string, status: UserStatus, ctx: AuditContext) {
    if (userId === actor.id) throw new BadRequestException('Vous ne pouvez pas modifier votre propre statut');
    const u = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!u) throw new NotFoundException('Utilisateur introuvable');
    const updated = await this.prisma.user.update({ where: { id: userId }, data: { status } });
    if (status !== UserStatus.ACTIVE) {
      await this.prisma.userSession.updateMany({ where: { userId, revokedAt: null }, data: { revokedAt: new Date() } });
      await this.prisma.deviceToken.deleteMany({ where: { userId } });
    }
    await this.audit.log(ctx, 'USER_STATUS_CHANGED', 'User', userId, { status: u.status }, { status });
    return { id: updated.id, status: updated.status };
  }

  async resendInvitation(userId: string, ctx: AuditContext) {
    const u = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!u || u.status !== UserStatus.PENDING_ACTIVATION || !u.telephone) throw new BadRequestException('Compte non éligible');
    const code = u.activationToken ?? activationCode();
    if (!u.activationToken) await this.prisma.user.update({ where: { id: userId }, data: { activationToken: code } });
    await this.sendInvitation(u.telephone, code);
    await this.audit.log(ctx, 'INVITATION_RESENT', 'User', userId);
    return { success: true, activationCode: env.isProd ? undefined : code };
  }

  private sendInvitation(telephone: string, code: string) {
    return this.sms.send(
      telephone,
      `AFRAM : votre espace UniParent est prêt. Installez l’application et activez votre compte avec le code ${code} (lien : ${env.publicUrl}/activer?code=${code}).`,
    );
  }

  // ------------------------------------------------------------------ Étudiants & rattachements
  async createStudent(actor: AuthUser, dto: NewStudentInput, ctx: AuditContext, tx?: Prisma.TransactionClient) {
    const run = async (db: Prisma.TransactionClient) => {
      const group = await db.group.findUnique({ where: { id: dto.groupId } });
      if (!group) throw new BadRequestException(`Groupe introuvable`);
      if (await db.student.findUnique({ where: { matricule: dto.matricule } })) throw new ConflictException(`Matricule ${dto.matricule} déjà utilisé`);

      const studentCode = activationCode();
      const studentUser = await db.user.create({
        data: {
          email: dto.email?.toLowerCase() || null,
          telephone: dto.telephone || null,
          passwordHash: '',
          role: UserRole.ETUDIANT,
          status: UserStatus.PENDING_ACTIVATION,
          activationToken: studentCode,
          studentProfile: { create: { matricule: dto.matricule, nom: dto.nom.toUpperCase(), prenom: dto.prenom, dateNaissance: new Date(dto.dateNaissance), groupId: dto.groupId } },
        },
        include: { studentProfile: true },
      });

      const invitations: { telephone: string; code: string }[] = [];
      if (dto.telephone) invitations.push({ telephone: dto.telephone, code: studentCode });
      for (const p of dto.parents) {
        // Un parent déjà connu (même téléphone) est réutilisé : un parent, plusieurs enfants.
        let parentUser = await db.user.findFirst({ where: { telephone: p.telephone, role: UserRole.PARENT }, include: { parentProfile: true } });
        if (!parentUser) {
          const code = activationCode();
          parentUser = await db.user.create({
            data: {
              telephone: p.telephone,
              email: p.email?.toLowerCase() || null,
              passwordHash: '',
              role: UserRole.PARENT,
              status: UserStatus.PENDING_ACTIVATION,
              activationToken: code,
              parentProfile: { create: { nom: p.nom.toUpperCase(), prenom: p.prenom } },
            },
            include: { parentProfile: true },
          });
          invitations.push({ telephone: p.telephone, code });
        }
        await db.parentStudent.create({
          data: {
            parentId: parentUser.parentProfile!.id,
            studentId: studentUser.studentProfile!.id,
            relationType: p.relationType,
            estPayeur: p.estPayeur,
            validePar: actor.id,
            valideLe: new Date(),
          },
        });
      }
      await this.audit.log(ctx, 'STUDENT_ENROLLED', 'Student', studentUser.studentProfile!.id, null, { matricule: dto.matricule, parents: dto.parents.length }, db);
      return { studentId: studentUser.studentProfile!.id, invitations };
    };

    const result = tx ? await run(tx) : await this.prisma.$transaction(run);
    if (!tx) for (const i of result.invitations) await this.sendInvitation(i.telephone, i.code);
    return { studentId: result.studentId, invitationsEnvoyees: result.invitations.length };
  }

  /** Import CSV (séparateur ; ou ,). dryRun = prévisualisation sans écriture. */
  async importStudents(actor: AuthUser, csv: string, dryRun: boolean, ctx: AuditContext) {
    const lines = csv.replace(/^﻿/, '').split(/\r?\n/).filter((l) => l.trim());
    if (lines.length < 2) throw new BadRequestException('Fichier vide');
    const sep = lines[0].includes(';') ? ';' : ',';
    const headers = lines[0].split(sep).map((h) => h.trim().toLowerCase());
    const required = ['matricule', 'nom', 'prenom', 'datenaissance', 'groupe', 'parentnom', 'parentprenom', 'parenttelephone'];
    const missing = required.filter((r) => !headers.includes(r));
    if (missing.length) throw new BadRequestException(`Colonnes manquantes : ${missing.join(', ')}`);

    const groups = new Map((await this.prisma.group.findMany()).map((g) => [g.nom.toLowerCase(), g.id]));
    const report: { ligne: number; matricule?: string; statut: 'OK' | 'ERREUR'; message?: string }[] = [];
    const valid: NewStudentInput[] = [];

    lines.slice(1).forEach((line, i) => {
      const cells = line.split(sep).map((c) => c.trim());
      const row = Object.fromEntries(headers.map((h, j) => [h, cells[j] ?? '']));
      const errors: string[] = [];
      const groupId = groups.get(row.groupe?.toLowerCase());
      if (!row.matricule) errors.push('matricule manquant');
      if (!row.nom || !row.prenom) errors.push('nom/prénom manquant');
      if (Number.isNaN(Date.parse(row.datenaissance))) errors.push('date de naissance invalide (AAAA-MM-JJ)');
      if (!groupId) errors.push(`groupe « ${row.groupe} » inconnu`);
      if (!/^\+?[0-9]{8,15}$/.test(row.parenttelephone)) errors.push('téléphone parent invalide');
      const relation = (row.lien?.toUpperCase() || 'TUTEUR_LEGAL') as ParentRelationType;
      if (!Object.values(ParentRelationType).includes(relation)) errors.push('lien invalide (PERE, MERE, TUTEUR_LEGAL, SPONSOR)');
      if (valid.some((v) => v.matricule === row.matricule)) errors.push('matricule en double dans le fichier');
      if (errors.length) {
        report.push({ ligne: i + 2, matricule: row.matricule, statut: 'ERREUR', message: errors.join(' ; ') });
        return;
      }
      valid.push({
        matricule: row.matricule,
        nom: row.nom,
        prenom: row.prenom,
        dateNaissance: row.datenaissance,
        groupId: groupId!,
        email: row.email || undefined,
        telephone: row.telephone || undefined,
        parents: [{ nom: row.parentnom, prenom: row.parentprenom, telephone: row.parenttelephone, email: row.parentemail || undefined, relationType: relation, estPayeur: row.payeur?.toLowerCase() !== 'non' }],
      });
      report.push({ ligne: i + 2, matricule: row.matricule, statut: 'OK' });
    });

    const existing = new Set((await this.prisma.student.findMany({ where: { matricule: { in: valid.map((v) => v.matricule) } }, select: { matricule: true } })).map((s) => s.matricule));
    for (const r of report) {
      if (r.statut === 'OK' && existing.has(r.matricule!)) Object.assign(r, { statut: 'ERREUR', message: 'matricule déjà enregistré' });
    }
    const toCreate = valid.filter((v) => !existing.has(v.matricule));
    if (dryRun) return { dryRun: true, total: report.length, valides: toCreate.length, erreurs: report.filter((r) => r.statut === 'ERREUR').length, rapport: report };

    let created = 0;
    for (const s of toCreate) {
      try {
        await this.createStudent(actor, s, ctx);
        created++;
      } catch (e) {
        const r = report.find((x) => x.matricule === s.matricule);
        if (r) Object.assign(r, { statut: 'ERREUR', message: (e as Error).message });
      }
    }
    await this.audit.log(ctx, 'STUDENTS_IMPORTED', 'Student', 'import', null, { crees: created, lignes: report.length });
    return { dryRun: false, total: report.length, crees: created, erreurs: report.filter((r) => r.statut === 'ERREUR').length, rapport: report };
  }

  async link(actor: AuthUser, dto: { parentUserId: string; studentId: string; relationType: ParentRelationType; estPayeur: boolean; peutConsulter?: boolean }, ctx: AuditContext) {
    const parent = await this.prisma.parent.findUnique({ where: { userId: dto.parentUserId } });
    if (!parent) throw new NotFoundException('Parent introuvable');
    const link = await this.prisma.parentStudent.upsert({
      where: { parentId_studentId: { parentId: parent.id, studentId: dto.studentId } },
      create: { parentId: parent.id, studentId: dto.studentId, relationType: dto.relationType, estPayeur: dto.estPayeur, peutConsulter: dto.peutConsulter ?? true, validePar: actor.id, valideLe: new Date() },
      update: { relationType: dto.relationType, estPayeur: dto.estPayeur, peutConsulter: dto.peutConsulter ?? true, validePar: actor.id, valideLe: new Date() },
    });
    await this.audit.log(ctx, 'PARENT_LINK_VALIDATED', 'ParentStudent', link.id, null, dto);
    return link;
  }

  async unlink(parentUserId: string, studentId: string, ctx: AuditContext) {
    const parent = await this.prisma.parent.findUnique({ where: { userId: parentUserId } });
    if (!parent) throw new NotFoundException('Parent introuvable');
    await this.prisma.parentStudent.delete({ where: { parentId_studentId: { parentId: parent.id, studentId } } });
    await this.audit.log(ctx, 'PARENT_LINK_REMOVED', 'ParentStudent', `${parent.id}:${studentId}`);
    return { success: true };
  }

  async student(studentId: string) {
    const s = await this.prisma.student.findUnique({
      where: { id: studentId },
      include: {
        user: { select: { id: true, email: true, telephone: true, status: true, lastLoginAt: true } },
        group: { include: { program: true } },
        parentLinks: { include: { parent: { include: { user: { select: { id: true, telephone: true, email: true, status: true } } } } } },
      },
    });
    if (!s) throw new NotFoundException('Étudiant introuvable');
    return s;
  }

  // ------------------------------------------------------------------ Structure académique
  async structure() {
    const [programs, groups, courses, rooms, teachers, years] = await Promise.all([
      this.prisma.program.findMany({ orderBy: { code: 'asc' } }),
      this.prisma.group.findMany({ orderBy: { nom: 'asc' }, include: { program: { select: { code: true } }, _count: { select: { students: true } } } }),
      this.prisma.course.findMany({ orderBy: { code: 'asc' }, include: { program: { select: { code: true } } } }),
      this.prisma.room.findMany({ orderBy: { code: 'asc' }, include: { campus: { select: { nom: true } } } }),
      this.prisma.teacher.findMany({ orderBy: { nom: 'asc' } }),
      this.prisma.academicYear.findMany({ orderBy: { dateDebut: 'desc' }, include: { semesters: { orderBy: { dateDebut: 'asc' } } } }),
    ]);
    return { programs, groups, courses, rooms, teachers, years };
  }

  async createEntity(kind: 'program' | 'group' | 'course' | 'room' | 'academicYear' | 'semester', data: Record<string, unknown>, ctx: AuditContext) {
    const delegate = {
      program: this.prisma.program,
      group: this.prisma.group,
      course: this.prisma.course,
      room: this.prisma.room,
      academicYear: this.prisma.academicYear,
      semester: this.prisma.semester,
    }[kind] as unknown as { create: (args: { data: unknown }) => Promise<{ id: string }> };
    const created = await delegate.create({ data });
    await this.audit.log(ctx, `${kind.toUpperCase()}_CREATED`, kind, created.id, null, data);
    return created;
  }

  // ------------------------------------------------------------------ Audit, paramètres, permissions
  async auditLogs(q: { entite?: string; entiteId?: string; userId?: string; action?: string; from?: string; to?: string; cursor?: string; take?: number }) {
    const n = clampTake(q.take, 200, 50);
    const rows = await this.prisma.auditLog.findMany({
      where: {
        ...(q.entite ? { entite: q.entite } : {}),
        ...(q.entiteId ? { entiteId: q.entiteId } : {}),
        ...(q.userId ? { userId: q.userId } : {}),
        ...(q.action ? { action: { contains: q.action } } : {}),
        ...(q.from || q.to ? { createdAt: { ...(q.from ? { gte: new Date(q.from) } : {}), ...(q.to ? { lte: new Date(q.to) } : {}) } } : {}),
      },
      orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
      take: n + 1,
      ...(q.cursor ? { cursor: { id: q.cursor }, skip: 1 } : {}),
      include: { user: { select: { email: true, telephone: true, role: true } } },
    });
    return toCursorPage(rows, n);
  }

  settings() {
    return this.prisma.appSetting.findMany({ orderBy: { key: 'asc' } });
  }

  async setSetting(key: string, value: Prisma.InputJsonValue, ctx: AuditContext) {
    const prev = await this.prisma.appSetting.findUnique({ where: { key } });
    const s = await this.prisma.appSetting.upsert({ where: { key }, create: { key, value }, update: { value } });
    await this.audit.log(ctx, 'SETTING_CHANGED', 'AppSetting', key, prev?.value, value);
    return s;
  }

  async permissions() {
    const rows = await this.prisma.rolePermission.findMany();
    return {
      catalogue: Object.values(PERMISSIONS),
      matrice: Object.fromEntries(Object.values(UserRole).map((r) => [r, rows.filter((x) => x.role === r).map((x) => x.permission)])),
    };
  }

  async setPermissions(role: UserRole, permissions: string[], ctx: AuditContext) {
    if (role === UserRole.SUPER_ADMIN) throw new BadRequestException('Les droits du super administrateur ne sont pas modifiables');
    const catalogue = new Set<string>(Object.values(PERMISSIONS));
    const unknown = permissions.filter((p) => !catalogue.has(p));
    if (unknown.length) throw new BadRequestException(`Permissions inconnues : ${unknown.join(', ')}`);
    const before = (await this.prisma.rolePermission.findMany({ where: { role } })).map((r) => r.permission);
    await this.prisma.$transaction([
      this.prisma.rolePermission.deleteMany({ where: { role } }),
      this.prisma.rolePermission.createMany({ data: permissions.map((permission) => ({ role, permission })) }),
    ]);
    this.roles.invalidate();
    await this.audit.log(ctx, 'PERMISSIONS_CHANGED', 'RolePermission', role, before, permissions);
    return this.permissions();
  }
}

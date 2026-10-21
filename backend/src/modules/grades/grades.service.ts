import { BadRequestException, ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { AssessmentType, DisputeStatus, GradeStatus, NotificationCategory, Prisma, UserRole } from '@prisma/client';
import { AuthUser, ChildAccessService } from '../../common/access/child-access.service';
import { AuditContext, AuditService } from '../../common/audit/audit.service';
import { PrismaService } from '../../prisma/prisma.service';
import { NotificationsService } from '../notifications/notifications.service';
import { BRAND, PdfService } from '../pdf/pdf.service';
import { computeSemester, GradeInput, rankOf, round2 } from './grade-calculator';

const gradeSelect = {
  id: true,
  valeur: true,
  studentId: true,
  updatedAt: true,
  assessment: {
    select: {
      id: true,
      titre: true,
      type: true,
      bareme: true,
      coefficient: true,
      datePublication: true,
      course: { select: { id: true, code: true, nom: true, coefficient: true, creditsEcts: true } },
    },
  },
} satisfies Prisma.GradeSelect;
type GradeRow = Prisma.GradeGetPayload<{ select: typeof gradeSelect }>;

const toInput = (g: GradeRow): GradeInput => ({
  valeur: g.valeur,
  bareme: g.assessment.bareme,
  assessmentCoefficient: g.assessment.coefficient,
  courseId: g.assessment.course.id,
  courseCode: g.assessment.course.code,
  courseNom: g.assessment.course.nom,
  courseCoefficient: g.assessment.course.coefficient,
  courseCredits: g.assessment.course.creditsEcts,
});

export interface GradeEntry {
  studentId: string;
  valeur: number;
}

@Injectable()
export class GradesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly access: ChildAccessService,
    private readonly audit: AuditService,
    private readonly notifications: NotificationsService,
    private readonly pdf: PdfService,
  ) {}

  // ------------------------------------------------------------------ Parent / étudiant (notes PUBLIÉES uniquement)
  private publishedFor(studentIds: string[], semesterId: string) {
    return this.prisma.grade.findMany({
      where: { studentId: { in: studentIds }, statut: GradeStatus.PUBLIE, assessment: { semesterId, statut: GradeStatus.PUBLIE } },
      select: gradeSelect,
      orderBy: { assessment: { createdAt: 'asc' } },
    });
  }

  async semesterResults(user: AuthUser, studentId: string, semesterId?: string) {
    const student = await this.access.assertCanAccess(user, studentId);
    const semester = semesterId
      ? await this.prisma.semester.findUnique({ where: { id: semesterId } })
      : await this.prisma.semester.findFirst({ where: { estActif: true } });
    if (!semester) throw new NotFoundException('Semestre introuvable');

    const classmates = (await this.prisma.student.findMany({ where: { groupId: student.groupId, deletedAt: null }, select: { id: true } })).map((s) => s.id);
    const all = await this.publishedFor(classmates, semester.id);
    const mine = all.filter((g) => g.studentId === studentId);
    const result = computeSemester(mine.map(toInput));

    // Moyennes de classe et rang (activables par l'administration).
    const showRank = (await this.prisma.appSetting.findUnique({ where: { key: 'grades.showRank' } }))?.value === true;
    const perStudent = classmates
      .map((id) => computeSemester(all.filter((g) => g.studentId === id).map(toInput)))
      .filter((r) => r.moyenneGenerale !== null);
    const classAvgByCourse = new Map<string, number>();
    for (const m of result.matieres) {
      const vals = perStudent.map((r) => r.matieres.find((x) => x.courseId === m.courseId)?.moyenne).filter((v): v is number => v !== undefined);
      if (vals.length) classAvgByCourse.set(m.courseId, round2(vals.reduce((a, b) => a + b, 0) / vals.length));
    }
    const generalAverages = perStudent.map((r) => r.moyenneGenerale!) ;

    return {
      semestre: { id: semester.id, code: semester.code, libelle: semester.libelle },
      moyenneGenerale: result.moyenneGenerale,
      moyenneClasse: generalAverages.length ? round2(generalAverages.reduce((a, b) => a + b, 0) / generalAverages.length) : null,
      rang: showRank && result.moyenneGenerale !== null ? rankOf(result.moyenneGenerale, generalAverages) : null,
      effectif: showRank ? generalAverages.length : null,
      creditsAcquis: result.creditsAcquis,
      creditsTotal: result.creditsTotal,
      mention: result.mention,
      decision: result.decision,
      matieres: result.matieres.map((m) => ({
        ...m,
        moyenneClasse: classAvgByCourse.get(m.courseId) ?? null,
        notes: mine
          .filter((g) => g.assessment.course.id === m.courseId)
          .map((g) => ({
            id: g.id,
            evaluation: g.assessment.titre,
            type: g.assessment.type,
            valeur: g.valeur,
            bareme: g.assessment.bareme,
            coefficient: g.assessment.coefficient,
            date: g.assessment.datePublication ?? g.updatedAt,
          })),
      })),
    };
  }

  /** Moyennes de chaque semestre (graphique d'évolution et comparaison). */
  async history(user: AuthUser, studentId: string) {
    await this.access.assertCanAccess(user, studentId);
    const semesters = await this.prisma.semester.findMany({ orderBy: { dateDebut: 'asc' }, include: { academicYear: { select: { libelle: true } } } });
    const grades = await this.prisma.grade.findMany({
      where: { studentId, statut: GradeStatus.PUBLIE },
      select: { ...gradeSelect, assessment: { select: { ...gradeSelect.assessment.select, semesterId: true } } },
    });
    return semesters
      .map((s) => {
        const r = computeSemester(grades.filter((g) => g.assessment.semesterId === s.id).map((g) => toInput(g as unknown as GradeRow)));
        return { semesterId: s.id, code: s.code, libelle: s.libelle, annee: s.academicYear.libelle, moyenne: r.moyenneGenerale, creditsAcquis: r.creditsAcquis, estActif: s.estActif };
      })
      .filter((s) => s.moyenne !== null || s.estActif);
  }

  async bulletinPdf(user: AuthUser, studentId: string, semesterId: string) {
    const r = await this.semesterResults(user, studentId, semesterId);
    const s = await this.prisma.student.findUniqueOrThrow({ where: { id: studentId }, include: { group: { include: { program: true } } } });
    const buffer = await this.pdf.render((doc) => {
      this.pdf.row(doc, 'Étudiant', `${s.prenom} ${s.nom}`);
      this.pdf.row(doc, 'Matricule', s.matricule);
      this.pdf.row(doc, 'Filière / groupe', `${s.group.program.nom} — ${s.group.nom}`);
      this.pdf.row(doc, 'Semestre', r.semestre.libelle);
      doc.moveDown(0.6);
      this.pdf.table(
        doc,
        ['Code', 'Matière', 'Coef.', 'ECTS', 'Moyenne', 'Classe', 'Acquis'],
        r.matieres.map((m) => [m.code, m.nom, String(m.coefficient), String(m.credits), m.moyenne.toFixed(2), m.moyenneClasse?.toFixed(2) ?? '—', m.creditsAcquis ? 'Oui' : 'Non']),
        [50, 175, 40, 40, 65, 60, 65],
      );
      doc.moveDown(0.4);
      this.pdf.row(doc, 'Moyenne générale', r.moyenneGenerale !== null ? `${r.moyenneGenerale.toFixed(2)} / 20` : '—');
      if (r.moyenneClasse !== null) this.pdf.row(doc, 'Moyenne de la classe', `${r.moyenneClasse.toFixed(2)} / 20`);
      if (r.rang) this.pdf.row(doc, 'Rang', `${r.rang} / ${r.effectif}`);
      this.pdf.row(doc, 'Crédits ECTS acquis', `${r.creditsAcquis} / ${r.creditsTotal}`);
      this.pdf.row(doc, 'Mention', r.mention ?? '—');
      this.pdf.row(doc, 'Décision', r.decision ?? '—');
      doc.moveDown(1.2);
      doc.font('Helvetica-Oblique').fontSize(9).fillColor(BRAND.muted).text('Seules les notes validées et publiées par la scolarité figurent sur ce bulletin. Le relevé officiel signé est délivré sur demande.', { align: 'left' });
    }, 'Bulletin de notes');
    return { filename: `bulletin-${s.matricule}-${r.semestre.code}.pdf`, buffer };
  }

  async dispute(user: AuthUser, gradeId: string, motif: string, ctx: AuditContext) {
    const g = await this.prisma.grade.findUnique({ where: { id: gradeId }, include: { assessment: { include: { course: true } } } });
    if (!g || g.statut !== GradeStatus.PUBLIE) throw new NotFoundException('Note introuvable');
    await this.access.assertCanAccess(user, g.studentId);
    const open = await this.prisma.gradeDispute.findFirst({ where: { gradeId, statut: { in: [DisputeStatus.OUVERTE, DisputeStatus.EN_EXAMEN] } } });
    if (open) throw new BadRequestException('Une réclamation est déjà en cours pour cette note');
    const d = await this.prisma.gradeDispute.create({ data: { gradeId, studentId: g.studentId, demandeParId: user.id, motif } });
    await this.audit.log(ctx, 'GRADE_DISPUTED', 'Grade', gradeId, null, { motif });
    const scolarite = await this.prisma.user.findMany({ where: { role: UserRole.SCOLARITE, status: 'ACTIVE' }, select: { id: true } });
    await this.notifications.notify(scolarite.map((u) => u.id), {
      categorie: NotificationCategory.NOTES,
      titre: 'Nouvelle réclamation de note',
      corps: `${g.assessment.course.nom} — ${g.assessment.titre}`,
      data: { type: 'GRADE_DISPUTE', disputeId: d.id },
    });
    return d;
  }

  myDisputes(user: AuthUser, studentId: string) {
    return this.access.assertCanAccess(user, studentId).then(() =>
      this.prisma.gradeDispute.findMany({
        where: { studentId },
        orderBy: { createdAt: 'desc' },
        include: { grade: { select: { valeur: true, assessment: { select: { titre: true, course: { select: { nom: true } } } } } } },
      }),
    );
  }

  // ------------------------------------------------------------------ Enseignant
  async teacherCourses(user: AuthUser) {
    const slots = await this.prisma.timetableSlot.findMany({
      where: user.role === UserRole.ENSEIGNANT ? { teacherId: user.teacherId ?? '__none__' } : {},
      distinct: ['courseId', 'groupId'],
      select: { course: { select: { id: true, code: true, nom: true } }, group: { select: { id: true, nom: true } }, semesterId: true },
    });
    return slots;
  }

  async createAssessment(
    user: AuthUser,
    dto: { courseId: string; groupId: string; semesterId: string; type: AssessmentType; titre: string; bareme: number; coefficient: number },
    ctx: AuditContext,
  ) {
    await this.assertTeaches(user, dto.courseId, dto.groupId);
    const a = await this.prisma.assessment.create({ data: { ...dto, saisiParId: user.id } });
    await this.audit.log(ctx, 'ASSESSMENT_CREATED', 'Assessment', a.id, null, dto);
    return a;
  }

  async assessmentsFor(user: AuthUser, filters: { courseId?: string; groupId?: string; statut?: GradeStatus }) {
    return this.prisma.assessment.findMany({
      where: {
        ...(filters.courseId ? { courseId: filters.courseId } : {}),
        ...(filters.groupId ? { groupId: filters.groupId } : {}),
        ...(filters.statut ? { statut: filters.statut } : {}),
        ...(user.role === UserRole.ENSEIGNANT ? { saisiParId: user.id } : {}),
      },
      orderBy: { createdAt: 'desc' },
      include: { course: { select: { code: true, nom: true } }, group: { select: { nom: true } }, semester: { select: { code: true } }, _count: { select: { grades: true } } },
    });
  }

  async assessmentSheet(user: AuthUser, assessmentId: string) {
    const a = await this.loadAssessment(user, assessmentId);
    const students = a.groupId
      ? await this.prisma.student.findMany({ where: { groupId: a.groupId, deletedAt: null }, orderBy: [{ nom: 'asc' }, { prenom: 'asc' }], select: { id: true, matricule: true, nom: true, prenom: true } })
      : [];
    const grades = await this.prisma.grade.findMany({ where: { assessmentId } });
    const byStudent = new Map(grades.map((g) => [g.studentId, g]));
    return {
      ...a,
      lignes: students.map((s) => ({ ...s, gradeId: byStudent.get(s.id)?.id ?? null, valeur: byStudent.get(s.id)?.valeur ?? null })),
    };
  }

  /**
   * Saisie / correction des notes. L'enseignant ne modifie que les brouillons ;
   * après validation, seule la scolarité corrige, avec un motif obligatoire.
   * Chaque changement est historisé dans GradeAuditLog (table immuable).
   */
  async saveGrades(user: AuthUser, assessmentId: string, entries: GradeEntry[], motif: string | undefined, ctx: AuditContext) {
    const a = await this.loadAssessment(user, assessmentId);
    const isScolarite = user.role === UserRole.SCOLARITE || user.role === UserRole.SUPER_ADMIN;
    if (a.statut !== GradeStatus.BROUILLON && !isScolarite) {
      throw new ForbiddenException('Évaluation validée : seule la scolarité peut corriger les notes');
    }
    if (a.statut !== GradeStatus.BROUILLON && !motif) {
      throw new BadRequestException('Un motif est obligatoire pour corriger une note validée ou publiée');
    }
    const groupStudents = a.groupId
      ? new Set((await this.prisma.student.findMany({ where: { groupId: a.groupId }, select: { id: true } })).map((s) => s.id))
      : null;

    let changed = 0;
    await this.prisma.$transaction(async (tx) => {
      for (const e of entries) {
        if (e.valeur < 0 || e.valeur > a.bareme) throw new BadRequestException(`Note hors barème (0 – ${a.bareme})`);
        if (groupStudents && !groupStudents.has(e.studentId)) throw new BadRequestException('Étudiant hors du groupe évalué');
        const prev = await tx.grade.findUnique({ where: { assessmentId_studentId: { assessmentId, studentId: e.studentId } } });
        if (prev && prev.valeur === e.valeur) continue;
        const g = await tx.grade.upsert({
          where: { assessmentId_studentId: { assessmentId, studentId: e.studentId } },
          create: { assessmentId, studentId: e.studentId, valeur: e.valeur, statut: a.statut },
          update: { valeur: e.valeur },
        });
        await tx.gradeAuditLog.create({
          data: { gradeId: g.id, ancienneValeur: prev?.valeur ?? null, nouvelleValeur: e.valeur, modifieParId: user.id, motif: motif ?? (prev ? 'Correction' : 'Saisie initiale'), adresseIp: ctx.ip ?? null },
        });
        changed++;
      }
    });
    if (changed && a.statut === GradeStatus.PUBLIE) {
      await this.notifyPublication(assessmentId, 'Note corrigée');
    }
    return { modifiees: changed };
  }

  // ------------------------------------------------------------------ Scolarité : validation et publication
  async transition(user: AuthUser, assessmentId: string, target: 'VALIDE_SCOLARITE' | 'PUBLIE' | 'BROUILLON', ctx: AuditContext) {
    const a = await this.prisma.assessment.findUnique({ where: { id: assessmentId }, include: { _count: { select: { grades: true } } } });
    if (!a) throw new NotFoundException('Évaluation introuvable');
    const allowed: Record<GradeStatus, GradeStatus[]> = {
      BROUILLON: [GradeStatus.VALIDE_SCOLARITE],
      VALIDE_SCOLARITE: [GradeStatus.PUBLIE, GradeStatus.BROUILLON],
      PUBLIE: [],
    };
    if (!allowed[a.statut].includes(target as GradeStatus)) {
      throw new BadRequestException(`Transition ${a.statut} → ${target} interdite`);
    }
    if (target !== 'BROUILLON' && a._count.grades === 0) throw new BadRequestException('Aucune note saisie');

    await this.prisma.$transaction([
      this.prisma.assessment.update({ where: { id: assessmentId }, data: { statut: target, ...(target === 'PUBLIE' ? { datePublication: new Date() } : {}) } }),
      this.prisma.grade.updateMany({ where: { assessmentId }, data: { statut: target } }),
    ]);
    await this.audit.log(ctx, `ASSESSMENT_${target}`, 'Assessment', assessmentId, { statut: a.statut }, { statut: target });
    if (target === 'PUBLIE') await this.notifyPublication(assessmentId, 'Nouvelles notes disponibles');
    return { id: assessmentId, statut: target };
  }

  disputes(statut?: DisputeStatus) {
    return this.prisma.gradeDispute.findMany({
      where: statut ? { statut } : {},
      orderBy: { createdAt: 'asc' },
      include: {
        student: { select: { matricule: true, nom: true, prenom: true } },
        grade: { select: { id: true, valeur: true, assessment: { select: { titre: true, bareme: true, course: { select: { nom: true } } } } } },
      },
    });
  }

  async reviewDispute(user: AuthUser, id: string, dto: { statut: DisputeStatus; reponse: string; nouvelleValeur?: number }, ctx: AuditContext) {
    const d = await this.prisma.gradeDispute.findUnique({ where: { id }, include: { grade: { include: { assessment: true } } } });
    if (!d) throw new NotFoundException('Réclamation introuvable');
    if (d.statut === DisputeStatus.ACCEPTEE || d.statut === DisputeStatus.REJETEE) throw new BadRequestException('Réclamation déjà clôturée');
    if (dto.nouvelleValeur !== undefined && dto.statut === DisputeStatus.ACCEPTEE) {
      await this.saveGrades(user, d.grade.assessmentId, [{ studentId: d.studentId, valeur: dto.nouvelleValeur }], `Réclamation acceptée : ${dto.reponse}`, ctx);
    }
    const updated = await this.prisma.gradeDispute.update({ where: { id }, data: { statut: dto.statut, reponse: dto.reponse, traiteParId: user.id } });
    await this.audit.log(ctx, 'GRADE_DISPUTE_REVIEWED', 'GradeDispute', id, { statut: d.statut }, dto);
    await this.notifications.notify([d.demandeParId], {
      categorie: NotificationCategory.NOTES,
      titre: 'Réponse à votre réclamation',
      corps: `${d.grade.assessment.titre} : ${dto.reponse}`,
      data: { type: 'GRADE_DISPUTE_REVIEWED', disputeId: id, studentId: d.studentId },
    });
    return updated;
  }

  async gradeHistory(gradeId: string) {
    return this.prisma.gradeAuditLog.findMany({ where: { gradeId }, orderBy: { createdAt: 'asc' } });
  }

  // ------------------------------------------------------------------ Interne
  private async notifyPublication(assessmentId: string, titre: string) {
    const a = await this.prisma.assessment.findUniqueOrThrow({ where: { id: assessmentId }, include: { course: true, grades: { select: { studentId: true } } } });
    for (const g of a.grades) {
      await this.notifications.notify(await this.access.stakeholderUserIds(g.studentId), {
        categorie: NotificationCategory.NOTES,
        titre,
        corps: `${a.course.nom} — ${a.titre}`,
        data: { type: 'GRADES_PUBLISHED', assessmentId, studentId: g.studentId },
      });
    }
  }

  private async loadAssessment(user: AuthUser, assessmentId: string) {
    const a = await this.prisma.assessment.findUnique({ where: { id: assessmentId }, include: { course: { select: { code: true, nom: true } }, group: { select: { nom: true } } } });
    if (!a) throw new NotFoundException('Évaluation introuvable');
    if (user.role === UserRole.ENSEIGNANT && a.saisiParId !== user.id) throw new ForbiddenException('Cette évaluation ne vous appartient pas');
    return a;
  }

  private async assertTeaches(user: AuthUser, courseId: string, groupId: string) {
    if (user.role !== UserRole.ENSEIGNANT) return;
    const slot = await this.prisma.timetableSlot.findFirst({ where: { teacherId: user.teacherId ?? '__none__', courseId, groupId } });
    if (!slot) throw new ForbiddenException('Vous n’enseignez pas cette matière à ce groupe');
  }
}

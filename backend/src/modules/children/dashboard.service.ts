import { Injectable } from '@nestjs/common';
import {
  AttendanceStatus,
  DisciplineRecordType,
  DocumentRequestStatus,
  GradeStatus,
  InvoiceStatus,
  StudentStatus,
} from '@prisma/client';
import { AuthUser, ChildAccessService } from '../../common/access/child-access.service';
import { formatXaf } from '../../common/utils/http';
import { PrismaService } from '../../prisma/prisma.service';
import { computeSemester } from '../grades/grade-calculator';
import { targetFilter } from '../messaging/targeting';
import { ChildrenService } from './children.service';

const DOC_LABEL: Record<string, string> = {
  ATTESTATION_INSCRIPTION: "attestation d'inscription",
  CERTIFICAT_SCOLARITE: 'certificat de scolarité',
  RELEVE_NOTES_OFFICIEL: 'relevé de notes officiel',
  DUPLICATA_CARTE: "duplicata de carte d'étudiant",
  CHANGEMENT_FILIERE: 'changement de filière',
  CONGE_ACADEMIQUE: 'congé académique',
};

export interface DashboardAlert {
  type: 'IMPAYE' | 'ABSENCES_REPETEES' | 'CONVOCATION' | 'DOCUMENT_MANQUANT' | 'DOCUMENT_PRET';
  niveau: 'danger' | 'warning' | 'info';
  message: string;
  refId?: string;
}

/**
 * Vue « l'œil du parent » : une seule requête côté mobile, agrégée ici.
 * Le parent ne voit que les notes publiées.
 */
@Injectable()
export class DashboardService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly access: ChildAccessService,
    private readonly children: ChildrenService,
  ) {}

  async forStudent(user: AuthUser, studentId: string) {
    const student = await this.access.assertCanAccess(user, studentId);
    const now = new Date();
    const monthStart = new Date(now.getFullYear(), now.getMonth(), 1);
    const dayStart = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const dayEnd = new Date(dayStart.getTime() + 86_400_000);
    const [year, semester] = await Promise.all([this.children.currentAcademicYear(), this.children.currentSemester()]);

    const [invoices, monthAttendance, lastAbsences, grades, todaySlots, convocations, readyRequests, profile, audience, threshold] =
      await Promise.all([
        this.prisma.invoice.findMany({
          where: { studentId, statut: { not: InvoiceStatus.ANNULE }, ...(year ? { academicYearId: year.id } : {}) },
          select: { id: true, montantTotal: true, montantPaye: true, soldeRestant: true, dateEcheance: true, statut: true, devise: true },
        }),
        this.prisma.attendanceRecord.groupBy({
          by: ['statut'],
          where: { studentId, slot: { dateDebut: { gte: monthStart, lte: now } } },
          _count: true,
        }),
        this.prisma.attendanceRecord.findMany({
          where: { studentId, statut: { in: [AttendanceStatus.ABSENT, AttendanceStatus.RETARD] } },
          orderBy: { slot: { dateDebut: 'desc' } },
          take: 3,
          select: {
            id: true,
            statut: true,
            minutesRetard: true,
            justification: { select: { statut: true } },
            slot: { select: { dateDebut: true, course: { select: { nom: true } } } },
          },
        }),
        this.prisma.grade.findMany({
          where: {
            studentId,
            statut: GradeStatus.PUBLIE,
            ...(semester ? { assessment: { semesterId: semester.id } } : {}),
          },
          orderBy: { updatedAt: 'desc' },
          select: {
            id: true,
            valeur: true,
            updatedAt: true,
            assessment: {
              select: {
                titre: true,
                bareme: true,
                coefficient: true,
                course: { select: { id: true, code: true, nom: true, coefficient: true, creditsEcts: true } },
              },
            },
          },
        }),
        this.prisma.timetableSlot.findMany({
          where: { groupId: student.groupId, dateDebut: { gte: dayStart, lt: dayEnd } },
          orderBy: { dateDebut: 'asc' },
          select: {
            id: true,
            dateDebut: true,
            dateFin: true,
            statut: true,
            course: { select: { nom: true } },
            room: { select: { code: true, campus: { select: { nom: true } } } },
            teacher: { select: { nom: true, prenom: true } },
          },
        }),
        this.prisma.disciplineRecord.findMany({
          where: { studentId, type: DisciplineRecordType.CONVOCATION_PARENT, accuseReception: false },
          select: { id: true, motif: true, convocationDate: true },
        }),
        this.prisma.documentRequest.findMany({
          where: { studentId, statut: DocumentRequestStatus.PRETE },
          select: { id: true, type: true },
        }),
        this.prisma.student.findUniqueOrThrow({ where: { id: studentId }, select: { statut: true } }),
        this.children.audienceFor(user),
        this.absenceThreshold(),
      ]);

    // ---- Finances (montants entiers)
    const total = invoices.reduce((s, i) => s + i.montantTotal, 0n);
    const paye = invoices.reduce((s, i) => s + i.montantPaye, 0n);
    const reste = invoices.reduce((s, i) => s + i.soldeRestant, 0n);
    const prochaine = invoices
      .filter((i) => i.soldeRestant > 0n)
      .sort((a, b) => a.dateEcheance.getTime() - b.dateEcheance.getTime())[0];
    const enRetard = invoices.filter((i) => i.soldeRestant > 0n && i.dateEcheance < now);

    // ---- Assiduité du mois
    const counts = Object.fromEntries(monthAttendance.map((r) => [r.statut, r._count])) as Partial<Record<AttendanceStatus, number>>;
    const totalSeances = Object.values(counts).reduce((s, n) => s + (n ?? 0), 0);
    const presents = (counts.PRESENT ?? 0) + (counts.RETARD ?? 0) + (counts.EXCUSE ?? 0);
    const tauxAssiduite = totalSeances ? Math.round((presents / totalSeances) * 1000) / 10 : null;

    // ---- Résultats (notes publiées uniquement)
    const result = computeSemester(
      grades.map((g) => ({
        valeur: g.valeur,
        bareme: g.assessment.bareme,
        assessmentCoefficient: g.assessment.coefficient,
        courseId: g.assessment.course.id,
        courseCode: g.assessment.course.code,
        courseNom: g.assessment.course.nom,
        courseCoefficient: g.assessment.course.coefficient,
        courseCredits: g.assessment.course.creditsEcts,
      })),
    );

    // ---- Alertes
    const alerts: DashboardAlert[] = [];
    if (enRetard.length) {
      const montant = enRetard.reduce((s, i) => s + i.soldeRestant, 0n);
      alerts.push({ type: 'IMPAYE', niveau: 'danger', message: `${enRetard.length} échéance(s) en retard : ${formatXaf(montant)} à régler` });
    }
    const unjustified = await this.prisma.attendanceRecord.count({
      where: {
        studentId,
        statut: AttendanceStatus.ABSENT,
        OR: [{ justification: null }, { justification: { statut: { not: 'VALIDE' } } }],
        slot: { dateDebut: { gte: new Date(now.getTime() - 30 * 86_400_000) } },
      },
    });
    if (unjustified >= threshold) {
      alerts.push({ type: 'ABSENCES_REPETEES', niveau: 'warning', message: `${unjustified} absences non justifiées sur les 30 derniers jours` });
    }
    for (const c of convocations) {
      alerts.push({ type: 'CONVOCATION', niveau: 'danger', message: `Convocation : ${c.motif}`, refId: c.id });
    }
    if (profile.statut === StudentStatus.EN_ATTENTE_DOCUMENTS) {
      alerts.push({ type: 'DOCUMENT_MANQUANT', niveau: 'warning', message: 'Des pièces du dossier sont manquantes' });
    }
    for (const r of readyRequests) {
      alerts.push({ type: 'DOCUMENT_PRET', niveau: 'info', message: `Document prêt : ${DOC_LABEL[r.type] ?? r.type}`, refId: r.id });
    }

    const news = await this.prisma.announcement.findMany({
      where: {
        AND: [targetFilter(audience), { OR: [{ dateExpiration: null }, { dateExpiration: { gte: now } }] }],
        datePublication: { lte: now },
      },
      orderBy: { datePublication: 'desc' },
      take: 3,
      select: { id: true, titre: true, contenu: true, datePublication: true },
    });

    return {
      generatedAt: now,
      finances: {
        devise: invoices[0]?.devise ?? 'XAF',
        totalDu: total,
        totalPaye: paye,
        resteAPayer: reste,
        prochaineEcheance: prochaine ? { invoiceId: prochaine.id, date: prochaine.dateEcheance, montant: prochaine.soldeRestant } : null,
        statut: enRetard.length ? 'EN_RETARD' : reste > 0n ? 'A_PAYER' : 'A_JOUR',
      },
      presence: {
        tauxAssiduiteMois: tauxAssiduite,
        seancesMois: totalSeances,
        absencesMois: counts.ABSENT ?? 0,
        retardsMois: counts.RETARD ?? 0,
        dernieresAbsences: lastAbsences.map((a) => ({
          id: a.id,
          statut: a.statut,
          date: a.slot.dateDebut,
          cours: a.slot.course.nom,
          minutesRetard: a.minutesRetard,
          justification: a.justification?.statut ?? null,
        })),
      },
      resultats: {
        semestre: semester ? { id: semester.id, code: semester.code, libelle: semester.libelle } : null,
        moyenneGenerale: result.moyenneGenerale,
        creditsAcquis: result.creditsAcquis,
        dernieresNotes: grades.slice(0, 3).map((g) => ({
          id: g.id,
          matiere: g.assessment.course.nom,
          evaluation: g.assessment.titre,
          valeur: g.valeur,
          bareme: g.assessment.bareme,
          date: g.updatedAt,
        })),
      },
      aujourdhui: todaySlots.map((s) => ({
        id: s.id,
        debut: s.dateDebut,
        fin: s.dateFin,
        statut: s.statut,
        matiere: s.course.nom,
        salle: s.room.code,
        campus: s.room.campus.nom,
        enseignant: `${s.teacher.prenom} ${s.teacher.nom}`,
      })),
      alertes: alerts,
      actualites: news,
    };
  }

  private async absenceThreshold(): Promise<number> {
    const s = await this.prisma.appSetting.findUnique({ where: { key: 'attendance.alertThreshold' } });
    return typeof s?.value === 'number' ? s.value : 3;
  }
}

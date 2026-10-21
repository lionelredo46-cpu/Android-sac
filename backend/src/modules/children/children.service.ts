import { Injectable } from '@nestjs/common';
import { UserRole } from '@prisma/client';
import { AuthUser, ChildAccessService } from '../../common/access/child-access.service';
import { PrismaService } from '../../prisma/prisma.service';
import { AudienceContext } from '../messaging/targeting';

const studentCard = {
  id: true,
  matricule: true,
  nom: true,
  prenom: true,
  photoUrl: true,
  statut: true,
  dateNaissance: true,
  dateInscription: true,
  responsablePeda: true,
  group: {
    select: {
      id: true,
      nom: true,
      anneeNiveau: true,
      program: { select: { id: true, code: true, nom: true, niveau: true } },
    },
  },
} as const;

@Injectable()
export class ChildrenService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly access: ChildAccessService,
  ) {}

  /** Enfants rattachés (parent) ou propre dossier (étudiant), avec les droits du lien. */
  async myChildren(user: AuthUser) {
    if (user.role === UserRole.ETUDIANT && user.studentId) {
      const s = await this.prisma.student.findUniqueOrThrow({ where: { id: user.studentId }, select: studentCard });
      return [{ ...s, relation: 'SOI', estPayeur: false, peutConsulter: true }];
    }
    if (user.role !== UserRole.PARENT || !user.parentId) return [];
    const links = await this.prisma.parentStudent.findMany({
      where: { parentId: user.parentId, peutConsulter: true, valideLe: { not: null }, student: { deletedAt: null } },
      include: { student: { select: studentCard } },
      orderBy: { createdAt: 'asc' },
    });
    return links.map((l) => ({
      ...l.student,
      relation: l.relationType,
      estPayeur: l.estPayeur,
      peutConsulter: l.peutConsulter,
    }));
  }

  async profile(user: AuthUser, studentId: string) {
    await this.access.assertCanAccess(user, studentId);
    const student = await this.prisma.student.findUniqueOrThrow({
      where: { id: studentId },
      select: {
        ...studentCard,
        parentLinks: {
          where: { valideLe: { not: null } },
          select: {
            relationType: true,
            estPayeur: true,
            parent: { select: { nom: true, prenom: true, user: { select: { telephone: true } } } },
          },
        },
      },
    });
    const semester = await this.currentSemester();
    return { ...student, semestreCourant: semester ? { id: semester.id, code: semester.code, libelle: semester.libelle } : null };
  }

  currentSemester() {
    const now = new Date();
    return this.prisma.semester.findFirst({
      where: { OR: [{ estActif: true }, { dateDebut: { lte: now }, dateFin: { gte: now } }] },
      orderBy: [{ estActif: 'desc' }, { dateDebut: 'desc' }],
    });
  }

  currentAcademicYear() {
    return this.prisma.academicYear.findFirst({ orderBy: [{ estActif: 'desc' }, { dateDebut: 'desc' }] });
  }

  /** Audience (filières, groupes, étudiants) pour le ciblage des annonces et du calendrier. */
  async audienceFor(user: AuthUser): Promise<AudienceContext> {
    const studentIds = await this.access.accessibleStudentIds(user);
    const students = studentIds.length
      ? await this.prisma.student.findMany({
          where: { id: { in: studentIds } },
          select: { groupId: true, group: { select: { programId: true } } },
        })
      : [];
    return {
      studentIds,
      groupIds: [...new Set(students.map((s) => s.groupId))],
      programIds: [...new Set(students.map((s) => s.group.programId))],
      parentId: user.parentId,
    };
  }
}

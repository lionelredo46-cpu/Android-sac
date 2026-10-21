import { ForbiddenException, Global, Injectable, Module, NotFoundException } from '@nestjs/common';
import { UserRole } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

export interface AuthUser {
  id: string;
  role: UserRole;
  email?: string | null;
  telephone?: string | null;
  parentId?: string | null;
  studentId?: string | null;
  teacherId?: string | null;
  sessionId?: string;
}

/** Rôles administratifs ayant un droit de consultation des dossiers étudiants. */
export const STAFF_READ_ROLES: UserRole[] = [
  UserRole.SUPER_ADMIN,
  UserRole.DIRECTION,
  UserRole.SCOLARITE,
  UserRole.COMPTABLE,
  UserRole.SUPPORT,
];

export const ADMIN_ROLES: UserRole[] = [
  UserRole.SUPER_ADMIN,
  UserRole.DIRECTION,
  UserRole.SCOLARITE,
  UserRole.COMPTABLE,
  UserRole.SUPPORT,
  UserRole.ENSEIGNANT,
];

export interface AccessOptions {
  /** Exige le droit « payeur » sur le lien parent-enfant. */
  requirePayer?: boolean;
}

/**
 * Point unique de contrôle d'autorisation au niveau objet (anti-IDOR).
 * Chaque service métier qui manipule un étudiant passe par ici.
 */
@Injectable()
export class ChildAccessService {
  constructor(private readonly prisma: PrismaService) {}

  async assertCanAccess(user: AuthUser, studentId: string, opts: AccessOptions = {}) {
    const student = await this.prisma.student.findFirst({
      where: { id: studentId, deletedAt: null },
      select: { id: true, userId: true, groupId: true },
    });
    if (!student) throw new NotFoundException('Étudiant introuvable');

    if (STAFF_READ_ROLES.includes(user.role)) return student;

    if (user.role === UserRole.ETUDIANT) {
      if (user.studentId !== studentId) {
        throw new ForbiddenException('Vous ne pouvez consulter que votre propre dossier');
      }
      return student;
    }

    if (user.role === UserRole.PARENT) {
      if (!user.parentId) throw new ForbiddenException('Profil parent introuvable');
      const link = await this.prisma.parentStudent.findUnique({
        where: { parentId_studentId: { parentId: user.parentId, studentId } },
      });
      if (!link || !link.peutConsulter || !link.valideLe) {
        throw new ForbiddenException("Vous n'êtes pas autorisé à accéder aux données de cet étudiant");
      }
      if (opts.requirePayer && !link.estPayeur) {
        throw new ForbiddenException("Votre rattachement ne permet pas d'effectuer des paiements");
      }
      return student;
    }

    if (user.role === UserRole.ENSEIGNANT && user.teacherId) {
      // Un enseignant n'accède qu'aux étudiants des groupes où il enseigne.
      const teaches = await this.prisma.timetableSlot.findFirst({
        where: { teacherId: user.teacherId, groupId: student.groupId },
        select: { id: true },
      });
      if (teaches) return student;
    }

    throw new ForbiddenException('Accès non autorisé pour ce profil');
  }

  /** Liste des étudiants visibles par un parent ou un étudiant. */
  async accessibleStudentIds(user: AuthUser): Promise<string[]> {
    if (user.role === UserRole.ETUDIANT && user.studentId) return [user.studentId];
    if (user.role === UserRole.PARENT && user.parentId) {
      const links = await this.prisma.parentStudent.findMany({
        where: { parentId: user.parentId, peutConsulter: true, valideLe: { not: null } },
        select: { studentId: true },
      });
      return links.map((l) => l.studentId);
    }
    return [];
  }

  /** Utilisateurs (parents rattachés + étudiant) à notifier pour un étudiant. */
  async stakeholderUserIds(studentId: string, opts: { payersOnly?: boolean } = {}) {
    const student = await this.prisma.student.findUnique({
      where: { id: studentId },
      select: {
        userId: true,
        parentLinks: {
          where: { valideLe: { not: null }, ...(opts.payersOnly ? { estPayeur: true } : {}) },
          select: { parent: { select: { userId: true } } },
        },
      },
    });
    if (!student) return [];
    return [student.userId, ...student.parentLinks.map((l) => l.parent.userId)];
  }
}

@Global()
@Module({
  providers: [ChildAccessService],
  exports: [ChildAccessService],
})
export class ChildAccessModule {}

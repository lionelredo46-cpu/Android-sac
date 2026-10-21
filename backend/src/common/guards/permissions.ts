import { UserRole } from '@prisma/client';

/**
 * Catalogue des permissions et matrice par défaut (cahier des charges §2.2).
 * La matrice est copiée en base au seed ; le super administrateur peut ensuite
 * la modifier depuis le back-office sans redéploiement.
 */
export const PERMISSIONS = {
  FINANCE_READ: 'finance.read',
  FINANCE_PAY: 'finance.pay',
  FINANCE_CASH_RECORD: 'finance.cash.record',
  FINANCE_MANAGE: 'finance.manage',
  ATTENDANCE_READ: 'attendance.read',
  ATTENDANCE_RECORD: 'attendance.record',
  ATTENDANCE_JUSTIFY_REVIEW: 'attendance.justify.review',
  GRADES_READ: 'grades.read',
  GRADES_ENTER: 'grades.enter',
  GRADES_VALIDATE: 'grades.validate',
  GRADES_PUBLISH: 'grades.publish',
  GRADES_DISPUTE_REVIEW: 'grades.dispute.review',
  MESSAGES_SEND_TO_PARENT: 'messages.send_to_parent',
  ANNOUNCEMENTS_PUBLISH: 'announcements.publish',
  TIMETABLE_MANAGE: 'timetable.manage',
  DOCUMENTS_MANAGE: 'documents.manage',
  DISCIPLINE_MANAGE: 'discipline.manage',
  USERS_MANAGE: 'users.manage',
  USERS_MANAGE_STUDENTS: 'users.manage.students',
  STATS_READ: 'stats.read',
  AUDIT_READ: 'audit.read',
  SETTINGS_MANAGE: 'settings.manage',
} as const;

export type Permission = (typeof PERMISSIONS)[keyof typeof PERMISSIONS];

const P = PERMISSIONS;

export const DEFAULT_ROLE_PERMISSIONS: Record<UserRole, Permission[]> = {
  SUPER_ADMIN: Object.values(P),
  PARENT: [P.FINANCE_READ, P.FINANCE_PAY, P.ATTENDANCE_READ, P.GRADES_READ],
  ETUDIANT: [P.FINANCE_READ, P.ATTENDANCE_READ, P.GRADES_READ],
  ENSEIGNANT: [
    P.ATTENDANCE_READ,
    P.ATTENDANCE_RECORD,
    P.GRADES_READ,
    P.GRADES_ENTER,
    P.MESSAGES_SEND_TO_PARENT,
  ],
  SCOLARITE: [
    P.FINANCE_READ,
    P.ATTENDANCE_READ,
    P.ATTENDANCE_RECORD,
    P.ATTENDANCE_JUSTIFY_REVIEW,
    P.GRADES_READ,
    P.GRADES_ENTER,
    P.GRADES_VALIDATE,
    P.GRADES_PUBLISH,
    P.GRADES_DISPUTE_REVIEW,
    P.MESSAGES_SEND_TO_PARENT,
    P.ANNOUNCEMENTS_PUBLISH,
    P.TIMETABLE_MANAGE,
    P.DOCUMENTS_MANAGE,
    P.DISCIPLINE_MANAGE,
    P.USERS_MANAGE_STUDENTS,
    P.STATS_READ,
  ],
  COMPTABLE: [
    P.FINANCE_READ,
    P.FINANCE_CASH_RECORD,
    P.FINANCE_MANAGE,
    P.MESSAGES_SEND_TO_PARENT,
    P.STATS_READ,
  ],
  DIRECTION: [
    P.FINANCE_READ,
    P.ATTENDANCE_READ,
    P.GRADES_READ,
    P.MESSAGES_SEND_TO_PARENT,
    P.ANNOUNCEMENTS_PUBLISH,
    P.STATS_READ,
    P.AUDIT_READ,
  ],
  SUPPORT: [P.MESSAGES_SEND_TO_PARENT],
};

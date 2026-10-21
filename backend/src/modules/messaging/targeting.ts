import { AnnouncementTarget, Prisma } from '@prisma/client';

export interface AudienceContext {
  studentIds: string[];
  groupIds: string[];
  programIds: string[];
  parentId?: string | null;
}

/** Filtre Prisma des annonces / événements visibles par une audience donnée. */
export function targetFilter(ctx: AudienceContext) {
  const or: { targetType: AnnouncementTarget; targetId?: string | { in: string[] } }[] = [
    { targetType: AnnouncementTarget.ALL },
  ];
  if (ctx.programIds.length) or.push({ targetType: AnnouncementTarget.PROGRAM, targetId: { in: ctx.programIds } });
  if (ctx.groupIds.length) or.push({ targetType: AnnouncementTarget.GROUP, targetId: { in: ctx.groupIds } });
  if (ctx.studentIds.length) or.push({ targetType: AnnouncementTarget.STUDENT, targetId: { in: ctx.studentIds } });
  if (ctx.parentId) or.push({ targetType: AnnouncementTarget.PARENT, targetId: ctx.parentId });
  return { OR: or } satisfies Prisma.AnnouncementWhereInput;
}

import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import {
  InstallmentStatus,
  InvoiceLineType,
  InvoiceStatus,
  NotificationCategory,
  PaymentChannel,
  PaymentStatus,
  Prisma,
  UserRole,
} from '@prisma/client';
import { randomBytes } from 'crypto';
import { AuthUser, ChildAccessService } from '../../common/access/child-access.service';
import { AuditContext, AuditService } from '../../common/audit/audit.service';
import { formatXaf } from '../../common/utils/http';
import { PrismaService } from '../../prisma/prisma.service';
import { NotificationsService } from '../notifications/notifications.service';

export type LineStatus = 'PAYE' | 'PARTIELLEMENT_PAYE' | 'A_PAYER' | 'EN_RETARD' | 'ANNULE';

/**
 * Répartit le montant payé sur les lignes par ordre d'échéance (cascade)
 * pour donner un statut par ligne (cahier des charges §4.1).
 */
export function allocateLines<T extends { montant: bigint; dateLimite: Date }>(
  lines: T[],
  paid: bigint,
  invoiceCancelled = false,
  now = new Date(),
) {
  let remaining = paid;
  return [...lines]
    .sort((a, b) => a.dateLimite.getTime() - b.dateLimite.getTime())
    .map((l) => {
      if (l.montant <= 0n) return { ...l, montantPaye: 0n, resteAPayer: 0n, statut: 'PAYE' as LineStatus };
      const applied = remaining >= l.montant ? l.montant : remaining > 0n ? remaining : 0n;
      remaining -= applied;
      const reste = l.montant - applied;
      let statut: LineStatus = reste === 0n ? 'PAYE' : applied > 0n ? 'PARTIELLEMENT_PAYE' : 'A_PAYER';
      if (reste > 0n && l.dateLimite < now) statut = 'EN_RETARD';
      if (invoiceCancelled) statut = 'ANNULE';
      return { ...l, montantPaye: applied, resteAPayer: reste, statut };
    });
}

export interface BulkInvoiceLine {
  titre: string;
  type: InvoiceLineType;
  montant: number;
  dateLimite: string;
}

@Injectable()
export class FinanceService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly access: ChildAccessService,
    private readonly audit: AuditService,
    private readonly notifications: NotificationsService,
  ) {}

  // ------------------------------------------------------------------ Consultation
  async invoices(user: AuthUser, studentId: string, filters: { statut?: InvoiceStatus; academicYearId?: string }) {
    await this.access.assertCanAccess(user, studentId);
    const rows = await this.prisma.invoice.findMany({
      where: { studentId, ...(filters.statut ? { statut: filters.statut } : {}), ...(filters.academicYearId ? { academicYearId: filters.academicYearId } : {}) },
      orderBy: { dateEcheance: 'asc' },
      include: { lines: true, academicYear: { select: { id: true, libelle: true } } },
    });
    return rows.map((inv) => ({
      ...inv,
      lines: allocateLines(inv.lines, inv.montantPaye, inv.statut === InvoiceStatus.ANNULE),
    }));
  }

  async invoice(user: AuthUser, invoiceId: string) {
    const inv = await this.prisma.invoice.findUnique({
      where: { id: invoiceId },
      include: {
        lines: true,
        academicYear: { select: { id: true, libelle: true } },
        student: { select: { id: true, nom: true, prenom: true, matricule: true } },
        payments: {
          where: { statut: { in: [PaymentStatus.VALIDE, PaymentStatus.EN_ATTENTE, PaymentStatus.REMBOURSE] } },
          orderBy: { createdAt: 'desc' },
          include: this.paymentInclude(),
        },
        installmentRequests: { orderBy: { createdAt: 'desc' } },
      },
    });
    if (!inv) throw new NotFoundException('Facture introuvable');
    await this.access.assertCanAccess(user, inv.studentId);
    return {
      ...inv,
      lines: allocateLines(inv.lines, inv.montantPaye, inv.statut === InvoiceStatus.ANNULE),
      payments: inv.payments.map((p) => this.toPaymentView(p)),
    };
  }

  async payments(
    user: AuthUser,
    studentId: string,
    f: { from?: string; to?: string; canal?: 'ONLINE' | 'GUICHET'; academicYearId?: string },
  ) {
    await this.access.assertCanAccess(user, studentId);
    const channels =
      f.canal === 'ONLINE'
        ? [PaymentChannel.ONLINE_CARD, PaymentChannel.ONLINE_MOBILE_MONEY]
        : f.canal === 'GUICHET'
          ? [PaymentChannel.GUICHET_ESPECES, PaymentChannel.GUICHET_CHEQUE, PaymentChannel.GUICHET_VIREMENT]
          : undefined;
    const rows = await this.prisma.payment.findMany({
      where: {
        invoice: { studentId, ...(f.academicYearId ? { academicYearId: f.academicYearId } : {}) },
        statut: { in: [PaymentStatus.VALIDE, PaymentStatus.REMBOURSE] },
        ...(channels ? { canal: { in: channels } } : {}),
        ...(f.from || f.to ? { createdAt: { ...(f.from ? { gte: new Date(f.from) } : {}), ...(f.to ? { lte: new Date(f.to) } : {}) } } : {}),
      },
      orderBy: { createdAt: 'desc' },
      include: this.paymentInclude(),
    });
    return rows.map((p) => this.toPaymentView(p));
  }

  async summary(user: AuthUser, studentId: string) {
    await this.access.assertCanAccess(user, studentId);
    const [invoices, payments] = await Promise.all([
      this.prisma.invoice.findMany({
        where: { studentId, statut: { not: InvoiceStatus.ANNULE } },
        include: { academicYear: { select: { id: true, libelle: true } } },
      }),
      this.prisma.payment.findMany({
        where: { invoice: { studentId }, statut: PaymentStatus.VALIDE },
        orderBy: { createdAt: 'asc' },
        select: { montant: true, createdAt: true },
      }),
    ]);

    const byYear = new Map<string, { academicYearId: string; libelle: string; total: bigint; paye: bigint; reste: bigint }>();
    for (const inv of invoices) {
      const y = byYear.get(inv.academicYearId) ?? { academicYearId: inv.academicYearId, libelle: inv.academicYear.libelle, total: 0n, paye: 0n, reste: 0n };
      y.total += inv.montantTotal;
      y.paye += inv.montantPaye;
      y.reste += inv.soldeRestant;
      byYear.set(inv.academicYearId, y);
    }

    // Évolution cumulée des versements par mois (graphique).
    const monthly = new Map<string, bigint>();
    for (const p of payments) {
      const key = `${p.createdAt.getFullYear()}-${String(p.createdAt.getMonth() + 1).padStart(2, '0')}`;
      monthly.set(key, (monthly.get(key) ?? 0n) + p.montant);
    }
    let cumul = 0n;
    const evolution = [...monthly.entries()].map(([mois, montant]) => {
      cumul += montant;
      return { mois, montant, cumul };
    });

    return { parAnnee: [...byYear.values()], evolution };
  }

  private paymentInclude() {
    return {
      receipt: { select: { id: true, numeroRecu: true } },
      payeParUser: { select: { role: true, parentProfile: { select: { nom: true, prenom: true } }, studentProfile: { select: { nom: true, prenom: true } } } },
      cashier: { select: { email: true } },
    } satisfies Prisma.PaymentInclude;
  }

  private toPaymentView(p: Prisma.PaymentGetPayload<{ include: ReturnType<FinanceService['paymentInclude']> }>) {
    const profile = p.payeParUser?.parentProfile ?? p.payeParUser?.studentProfile;
    const meta = (p.metadata ?? {}) as Record<string, string | null>;
    const auteur = profile ? `${profile.prenom} ${profile.nom}` : (meta.payeurNom ?? null);
    return {
      id: p.id,
      reference: p.reference,
      date: p.createdAt,
      montant: p.montant,
      devise: p.devise,
      statut: p.statut,
      canal: p.canal,
      enLigne: p.canal === PaymentChannel.ONLINE_CARD || p.canal === PaymentChannel.ONLINE_MOBILE_MONEY,
      fournisseur: p.provider,
      referenceExterne: p.referenceExterne,
      payeurType: p.payeurType,
      auteur,
      enregistrePar: p.cashier?.email ?? null,
      invoiceId: p.invoiceId,
      receipt: p.receipt,
    };
  }

  // ------------------------------------------------------------------ Échelonnement
  async requestInstallment(user: AuthUser, dto: { invoiceId: string; nombreTranches: number; motif: string }, ctx: AuditContext) {
    const inv = await this.prisma.invoice.findUnique({ where: { id: dto.invoiceId }, include: { student: true } });
    if (!inv) throw new NotFoundException('Facture introuvable');
    await this.access.assertCanAccess(user, inv.studentId, { requirePayer: user.role === UserRole.PARENT });
    if (inv.soldeRestant <= 0n) throw new BadRequestException('Cette facture est déjà soldée');
    const pending = await this.prisma.installmentRequest.findFirst({ where: { invoiceId: inv.id, statut: InstallmentStatus.SOUMISE } });
    if (pending) throw new BadRequestException('Une demande est déjà en cours pour cette facture');

    const req = await this.prisma.installmentRequest.create({
      data: { invoiceId: inv.id, studentId: inv.studentId, demandeParId: user.id, nombreTranches: dto.nombreTranches, motif: dto.motif },
    });
    await this.audit.log(ctx, 'INSTALLMENT_REQUESTED', 'InstallmentRequest', req.id, null, dto);
    const comptables = await this.prisma.user.findMany({ where: { role: UserRole.COMPTABLE, status: 'ACTIVE' }, select: { id: true } });
    await this.notifications.notify(comptables.map((c) => c.id), {
      categorie: NotificationCategory.FINANCE,
      titre: "Demande d'échelonnement",
      corps: `${inv.student.prenom} ${inv.student.nom} — ${inv.numeroFacture} en ${dto.nombreTranches} tranches`,
      data: { type: 'INSTALLMENT_REQUEST', id: req.id },
    });
    return req;
  }

  installmentRequests(statut?: InstallmentStatus) {
    return this.prisma.installmentRequest.findMany({
      where: { statut: statut ?? InstallmentStatus.SOUMISE },
      orderBy: { createdAt: 'asc' },
      include: {
        student: { select: { matricule: true, nom: true, prenom: true } },
        invoice: { select: { numeroFacture: true, soldeRestant: true, dateEcheance: true } },
      },
    });
  }

  async reviewInstallment(admin: AuthUser, id: string, dto: { accepter: boolean; reponse?: string }, ctx: AuditContext) {
    const req = await this.prisma.installmentRequest.findUnique({ where: { id } });
    if (!req) throw new NotFoundException('Demande introuvable');
    if (req.statut !== InstallmentStatus.SOUMISE) throw new BadRequestException('Demande déjà traitée');
    const updated = await this.prisma.installmentRequest.update({
      where: { id },
      data: { statut: dto.accepter ? InstallmentStatus.ACCEPTEE : InstallmentStatus.REFUSEE, reponse: dto.reponse, traiteParId: admin.id },
    });
    await this.audit.log(ctx, 'INSTALLMENT_REVIEWED', 'InstallmentRequest', id, { statut: req.statut }, { statut: updated.statut, reponse: dto.reponse });
    await this.notifications.notify([req.demandeParId], {
      categorie: NotificationCategory.FINANCE,
      titre: dto.accepter ? 'Échelonnement accepté' : 'Échelonnement refusé',
      corps: dto.reponse ?? (dto.accepter ? 'Votre demande a été acceptée par la comptabilité.' : 'Votre demande a été refusée.'),
      data: { type: 'INSTALLMENT_REVIEWED', id, studentId: req.studentId },
    });
    return updated;
  }

  // ------------------------------------------------------------------ Back-office comptabilité
  async createInvoice(
    admin: AuthUser,
    dto: { studentId: string; academicYearId: string; devise?: string; lines: BulkInvoiceLine[] },
    ctx: AuditContext,
    tx: Prisma.TransactionClient | PrismaService = this.prisma,
  ) {
    if (!dto.lines.length) throw new BadRequestException('Au moins une ligne est requise');
    const lines = dto.lines.map((l) => {
      if (!Number.isInteger(l.montant) || l.montant <= 0) throw new BadRequestException('Les montants doivent être des entiers positifs');
      return { titre: l.titre, type: l.type, montant: BigInt(l.montant), dateLimite: new Date(l.dateLimite) };
    });
    const total = lines.reduce((s, l) => s + l.montant, 0n);
    const echeance = lines.reduce((min, l) => (l.dateLimite < min ? l.dateLimite : min), lines[0].dateLimite);
    const inv = await tx.invoice.create({
      data: {
        studentId: dto.studentId,
        academicYearId: dto.academicYearId,
        numeroFacture: `FAC-${new Date().getFullYear()}-${randomBytes(4).toString('hex').toUpperCase()}`,
        montantTotal: total,
        soldeRestant: total,
        devise: dto.devise ?? 'XAF',
        dateEcheance: echeance,
        lines: { create: lines },
      },
    });
    await this.audit.log(ctx, 'INVOICE_CREATED', 'Invoice', inv.id, null, { total, studentId: dto.studentId }, tx);
    return inv;
  }

  async bulkInvoices(
    admin: AuthUser,
    dto: { academicYearId: string; groupId?: string; programId?: string; lines: BulkInvoiceLine[] },
    ctx: AuditContext,
  ) {
    if (!dto.groupId && !dto.programId) throw new BadRequestException('Précisez un groupe ou une filière');
    const students = await this.prisma.student.findMany({
      where: {
        deletedAt: null,
        statut: { in: ['INSCRIT', 'EN_ATTENTE_DOCUMENTS'] },
        ...(dto.groupId ? { groupId: dto.groupId } : { group: { programId: dto.programId } }),
      },
      select: { id: true },
    });
    const created = await this.prisma.$transaction(async (tx) => {
      const out: string[] = [];
      for (const s of students) {
        const inv = await this.createInvoice(admin, { studentId: s.id, academicYearId: dto.academicYearId, lines: dto.lines }, ctx, tx);
        out.push(inv.id);
      }
      return out;
    });
    for (const s of students) {
      await this.notifications.notify(await this.access.stakeholderUserIds(s.id, { payersOnly: true }), {
        categorie: NotificationCategory.FINANCE,
        titre: 'Nouvelle facture disponible',
        corps: 'Une nouvelle échéance a été ajoutée. Consultez l’onglet Finances.',
        data: { type: 'INVOICE_CREATED', studentId: s.id },
      });
    }
    return { count: created.length, invoiceIds: created };
  }

  /** Remise, bourse, exonération (diminuent le total) ou pénalité (l'augmente). */
  async adjust(admin: AuthUser, invoiceId: string, dto: { type: 'REMISE' | 'BOURSE' | 'EXONERATION' | 'PENALITE'; montant: number; motif: string }, ctx: AuditContext) {
    if (!Number.isInteger(dto.montant) || dto.montant <= 0) throw new BadRequestException('Montant entier positif requis');
    return this.prisma.$transaction(async (tx) => {
      await tx.$queryRaw`SELECT id FROM "Invoice" WHERE id = ${invoiceId} FOR UPDATE`;
      const inv = await tx.invoice.findUnique({ where: { id: invoiceId } });
      if (!inv) throw new NotFoundException('Facture introuvable');
      const delta = BigInt(dto.montant) * (dto.type === 'PENALITE' ? 1n : -1n);
      const montantTotal = inv.montantTotal + delta;
      if (montantTotal < inv.montantPaye) throw new BadRequestException('La remise dépasse le reste à payer');
      const soldeRestant = montantTotal - inv.montantPaye;
      const updated = await tx.invoice.update({
        where: { id: invoiceId },
        data: {
          montantTotal,
          soldeRestant,
          statut: soldeRestant === 0n ? InvoiceStatus.PAYE : inv.statut === InvoiceStatus.PAYE ? InvoiceStatus.PARTIELLEMENT_PAYE : inv.statut,
          lines: { create: { titre: `${dto.type} — ${dto.motif}`, type: InvoiceLineType.AUTRE, montant: delta, dateLimite: inv.dateEcheance } },
        },
      });
      await this.audit.log(ctx, `INVOICE_${dto.type}`, 'Invoice', invoiceId, { montantTotal: inv.montantTotal, soldeRestant: inv.soldeRestant }, { montantTotal, soldeRestant, motif: dto.motif }, tx);
      return updated;
    });
  }

  async cancelInvoice(admin: AuthUser, invoiceId: string, motif: string, ctx: AuditContext) {
    const inv = await this.prisma.invoice.findUnique({ where: { id: invoiceId } });
    if (!inv) throw new NotFoundException('Facture introuvable');
    if (inv.montantPaye > 0n) throw new BadRequestException('Impossible d’annuler une facture ayant reçu des versements');
    const updated = await this.prisma.invoice.update({ where: { id: invoiceId }, data: { statut: InvoiceStatus.ANNULE, soldeRestant: 0n } });
    await this.audit.log(ctx, 'INVOICE_CANCELLED', 'Invoice', invoiceId, { statut: inv.statut }, { statut: 'ANNULE', motif });
    return updated;
  }

  /** État des impayés (JSON ou CSV pour Excel). */
  async unpaid(filters: { groupId?: string; programId?: string; overdueOnly?: boolean }) {
    const rows = await this.prisma.invoice.findMany({
      where: {
        soldeRestant: { gt: 0n },
        statut: { not: InvoiceStatus.ANNULE },
        ...(filters.overdueOnly ? { dateEcheance: { lt: new Date() } } : {}),
        student: {
          deletedAt: null,
          ...(filters.groupId ? { groupId: filters.groupId } : {}),
          ...(filters.programId ? { group: { programId: filters.programId } } : {}),
        },
      },
      orderBy: { dateEcheance: 'asc' },
      include: { student: { select: { matricule: true, nom: true, prenom: true, group: { select: { nom: true } } } } },
    });
    return rows.map((r) => ({
      invoiceId: r.id,
      numeroFacture: r.numeroFacture,
      matricule: r.student.matricule,
      etudiant: `${r.student.nom} ${r.student.prenom}`,
      groupe: r.student.group.nom,
      montantTotal: r.montantTotal,
      montantPaye: r.montantPaye,
      soldeRestant: r.soldeRestant,
      dateEcheance: r.dateEcheance,
      joursRetard: Math.max(0, Math.floor((Date.now() - r.dateEcheance.getTime()) / 86_400_000)),
      statut: r.statut,
    }));
  }

  toCsv(rows: Record<string, unknown>[]): string {
    if (!rows.length) return '';
    const headers = Object.keys(rows[0]);
    const esc = (v: unknown) => {
      const s = v instanceof Date ? v.toISOString().slice(0, 10) : String(v ?? '');
      // Neutralise l'injection de formules dans Excel.
      const safe = /^[=+\-@]/.test(s) ? `'${s}` : s;
      return /[";\n]/.test(safe) ? `"${safe.replace(/"/g, '""')}"` : safe;
    };
    return '﻿' + [headers.join(';'), ...rows.map((r) => headers.map((h) => esc(r[h])).join(';'))].join('\n');
  }

  async journal(filters: { from?: string; to?: string; canal?: PaymentChannel }) {
    return this.prisma.payment.findMany({
      where: {
        statut: PaymentStatus.VALIDE,
        ...(filters.canal ? { canal: filters.canal } : {}),
        ...(filters.from || filters.to ? { createdAt: { ...(filters.from ? { gte: new Date(filters.from) } : {}), ...(filters.to ? { lte: new Date(filters.to) } : {}) } } : {}),
      },
      orderBy: { createdAt: 'desc' },
      take: 500,
      include: { invoice: { select: { numeroFacture: true, student: { select: { matricule: true, nom: true, prenom: true } } } }, receipt: { select: { numeroRecu: true } } },
    });
  }

  formatAmount = formatXaf;
}

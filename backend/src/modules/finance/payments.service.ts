import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  Injectable,
  Logger,
  NotFoundException,
  ServiceUnavailableException,
} from '@nestjs/common';
import {
  InvoiceStatus,
  NotificationCategory,
  PayerType,
  PaymentChannel,
  PaymentProviderType,
  PaymentStatus,
  Prisma,
  UserRole,
} from '@prisma/client';
import { createHmac, randomBytes } from 'crypto';
import { AuthUser, ChildAccessService } from '../../common/access/child-access.service';
import { AuditContext, AuditService } from '../../common/audit/audit.service';
import { formatXaf } from '../../common/utils/http';
import { env } from '../../config/env';
import { PrismaService } from '../../prisma/prisma.service';
import { NotificationsService } from '../notifications/notifications.service';
import { CinetPayProvider } from './providers/cinetpay.provider';
import { PaymentProvider, ProviderStatus, WebhookRequest, WebhookSignatureError } from './providers/payment-provider';
import { SandboxProvider } from './providers/sandbox.provider';
import { StripeProvider } from './providers/stripe.provider';

const ONLINE_PROVIDERS = ['SANDBOX', 'CINETPAY', 'STRIPE'] as const;
export type OnlineProvider = (typeof ONLINE_PROVIDERS)[number];

export interface InitiatePaymentInput {
  invoiceId: string;
  montant: number;
  canal: 'ONLINE_MOBILE_MONEY' | 'ONLINE_CARD';
  provider?: OnlineProvider;
  telephone?: string;
}

export interface CashPaymentInput {
  invoiceId: string;
  montant: number;
  canal: 'GUICHET_ESPECES' | 'GUICHET_CHEQUE' | 'GUICHET_VIREMENT';
  payeurType: PayerType;
  payeurNom?: string;
  referenceExterne?: string;
  justificatifUrl?: string;
}

function newReference(prefix: string) {
  const d = new Date();
  const ymd = `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}${String(d.getDate()).padStart(2, '0')}`;
  return `${prefix}-${ymd}-${randomBytes(4).toString('hex').toUpperCase()}`;
}

export function receiptToken(receiptId: string) {
  return createHmac('sha256', env.receiptSigningSecret).update(receiptId).digest('base64url').slice(0, 32);
}

@Injectable()
export class PaymentsService {
  private readonly logger = new Logger('Payments');
  private readonly providers: Record<OnlineProvider, PaymentProvider>;

  constructor(
    private readonly prisma: PrismaService,
    private readonly access: ChildAccessService,
    private readonly audit: AuditService,
    private readonly notifications: NotificationsService,
    sandbox: SandboxProvider,
    cinetpay: CinetPayProvider,
    stripe: StripeProvider,
  ) {
    this.providers = { SANDBOX: sandbox, CINETPAY: cinetpay, STRIPE: stripe };
  }

  availableProviders() {
    return ONLINE_PROVIDERS.filter((p) => this.providers[p].isConfigured()).map((p) => ({
      code: p,
      canaux: p === 'STRIPE' ? ['ONLINE_CARD'] : ['ONLINE_MOBILE_MONEY', 'ONLINE_CARD'],
      parDefaut: p === env.payment.defaultProvider,
    }));
  }

  // ------------------------------------------------------------------ Paiement en ligne (P2)
  async initiate(user: AuthUser, input: InitiatePaymentInput, idempotencyKey: string, ctx: AuditContext) {
    if (!idempotencyKey || !/^[A-Za-z0-9-]{16,64}$/.test(idempotencyKey)) {
      throw new BadRequestException({ code: 'IDEMPOTENCY_KEY_REQUIRED', message: 'En-tête Idempotency-Key manquant ou invalide' });
    }

    // Double clic / renvoi réseau : on rejoue la réponse d'origine.
    const existing = await this.prisma.payment.findUnique({ where: { idempotencyKey } });
    if (existing) {
      if (existing.payeParUserId !== user.id || existing.invoiceId !== input.invoiceId) {
        throw new ConflictException({ code: 'IDEMPOTENCY_CONFLICT', message: 'Clé d’idempotence déjà utilisée pour une autre opération' });
      }
      return this.toInitiateResponse(existing);
    }

    const invoice = await this.prisma.invoice.findUnique({
      where: { id: input.invoiceId },
      include: { student: { select: { id: true, nom: true, prenom: true, matricule: true } } },
    });
    if (!invoice) throw new NotFoundException('Facture introuvable');

    await this.assertCanPay(user, invoice.studentId);

    if (invoice.statut === InvoiceStatus.ANNULE || invoice.statut === InvoiceStatus.PAYE) {
      throw new BadRequestException({ code: 'INVOICE_NOT_PAYABLE', message: 'Cette facture n’est pas payable' });
    }
    const montant = BigInt(input.montant);
    if (montant <= 0n || montant > invoice.soldeRestant) {
      throw new BadRequestException({ code: 'INVALID_AMOUNT', message: `Le montant doit être compris entre 1 et ${invoice.soldeRestant} ${invoice.devise}` });
    }

    const providerCode = input.provider ?? (env.payment.defaultProvider as OnlineProvider);
    const provider = this.providers[providerCode];
    if (!provider?.isConfigured()) {
      throw new ServiceUnavailableException({ code: 'PROVIDER_UNAVAILABLE', message: 'Ce moyen de paiement est momentanément indisponible' });
    }

    const payer = await this.prisma.user.findUniqueOrThrow({
      where: { id: user.id },
      include: { parentProfile: true, studentProfile: true },
    });
    const reference = newReference('PAY');
    const payment = await this.prisma.payment.create({
      data: {
        invoiceId: invoice.id,
        parentId: user.parentId ?? null,
        payeParUserId: user.id,
        payeurType: user.role === UserRole.ETUDIANT ? PayerType.ETUDIANT : PayerType.PARENT,
        reference,
        idempotencyKey,
        montant,
        devise: invoice.devise,
        canal: input.canal as PaymentChannel,
        provider: provider.type,
        statut: PaymentStatus.INITIALISE,
      },
    });
    await this.audit.log(ctx, 'PAYMENT_INITIATED', 'Payment', payment.id, null, {
      reference, montant, invoiceId: invoice.id, provider: provider.type,
    });

    try {
      const res = await provider.initiate({
        paymentId: payment.id,
        reference,
        amount: montant,
        currency: invoice.devise,
        description: `${invoice.numeroFacture} — ${invoice.student.prenom} ${invoice.student.nom} (${invoice.student.matricule})`,
        customer: {
          name: payer.parentProfile ? `${payer.parentProfile.prenom} ${payer.parentProfile.nom}` : `${payer.studentProfile?.prenom ?? ''} ${payer.studentProfile?.nom ?? ''}`.trim(),
          phone: input.telephone ?? payer.telephone,
          email: payer.email,
        },
        channel: input.canal === 'ONLINE_CARD' ? 'CARD' : 'MOBILE_MONEY',
        returnUrl: `${env.publicUrl}/paiement/retour/${payment.id}`,
        notifyUrl: `${env.publicUrl}/api/v1/payments/webhook/${providerCode.toLowerCase()}`,
      });
      const updated = await this.prisma.payment.update({
        where: { id: payment.id },
        data: {
          statut: PaymentStatus.EN_ATTENTE,
          referenceExterne: res.externalRef,
          metadata: { paymentUrl: res.paymentUrl, instructions: res.instructions, providerCode } as Prisma.InputJsonValue,
        },
      });
      return this.toInitiateResponse(updated);
    } catch (e) {
      this.logger.error(`Initialisation ${reference} échouée : ${(e as Error).message}`);
      const failed = await this.prisma.payment.update({
        where: { id: payment.id },
        data: { statut: PaymentStatus.ECHOUE, metadata: { error: (e as Error).message } },
      });
      await this.audit.log(ctx, 'PAYMENT_INIT_FAILED', 'Payment', payment.id, null, { error: (e as Error).message });
      return this.toInitiateResponse(failed);
    }
  }

  private toInitiateResponse(p: { id: string; reference: string; statut: PaymentStatus; montant: bigint; devise: string; metadata: Prisma.JsonValue }) {
    const meta = (p.metadata ?? {}) as Record<string, string>;
    return {
      paymentId: p.id,
      reference: p.reference,
      statut: p.statut,
      montant: p.montant,
      devise: p.devise,
      paymentUrl: meta.paymentUrl ?? null,
      instructions: meta.instructions ?? null,
    };
  }

  private async assertCanPay(user: AuthUser, studentId: string) {
    if (user.role === UserRole.PARENT) {
      await this.access.assertCanAccess(user, studentId, { requirePayer: true });
      return;
    }
    if (user.role === UserRole.ETUDIANT) {
      await this.access.assertCanAccess(user, studentId);
      const setting = await this.prisma.appSetting.findUnique({ where: { key: 'finance.studentCanPay' } });
      if (setting?.value !== true) {
        throw new ForbiddenException({ code: 'STUDENT_PAYMENT_DISABLED', message: 'Le paiement par l’étudiant n’est pas autorisé' });
      }
      return;
    }
    throw new ForbiddenException('Seuls les parents (et les étudiants autorisés) peuvent payer en ligne');
  }

  // ------------------------------------------------------------------ Webhooks
  async handleWebhook(providerCode: string, req: WebhookRequest) {
    const code = providerCode.toUpperCase() as OnlineProvider;
    const provider = this.providers[code];
    if (!provider || !provider.isConfigured()) throw new NotFoundException('Fournisseur inconnu');

    let event;
    try {
      event = await provider.parseWebhook(req);
    } catch (e) {
      if (e instanceof WebhookSignatureError) {
        this.logger.warn(`Webhook ${code} rejeté : ${e.message}`);
        await this.audit.log({ userId: null }, 'WEBHOOK_REJECTED', 'Payment', 'n/a', null, { provider: code, reason: e.message });
        throw new ForbiddenException('Signature invalide');
      }
      throw e;
    }

    const payment = await this.prisma.payment.findUnique({ where: { reference: event.reference } });
    if (!payment) {
      this.logger.warn(`Webhook ${code} pour une référence inconnue : ${event.reference}`);
      return { received: true };
    }
    await this.settle(payment.id, event.status, { amount: event.amount, currency: event.currency, externalRef: event.externalRef, source: `webhook:${code}` });
    return { received: true };
  }

  /** Polling depuis l'application : si encore en attente, on interroge la passerelle. */
  async status(user: AuthUser, paymentId: string) {
    const payment = await this.prisma.payment.findUnique({
      where: { id: paymentId },
      include: { invoice: { select: { studentId: true } }, receipt: { select: { id: true, numeroRecu: true } } },
    });
    if (!payment) throw new NotFoundException('Paiement introuvable');
    await this.access.assertCanAccess(user, payment.invoice.studentId);

    if (payment.statut === PaymentStatus.EN_ATTENTE) {
      const meta = (payment.metadata ?? {}) as Record<string, string>;
      const provider = this.providers[meta.providerCode as OnlineProvider];
      if (provider?.isConfigured() && provider.type !== PaymentProviderType.SANDBOX) {
        try {
          const s = await provider.checkStatus(payment.reference, payment.referenceExterne);
          if (s !== 'PENDING') await this.settle(payment.id, s, { source: 'polling' });
        } catch (e) {
          this.logger.warn(`Polling ${payment.reference} : ${(e as Error).message}`);
        }
      }
    }
    const fresh = await this.prisma.payment.findUniqueOrThrow({
      where: { id: paymentId },
      include: { receipt: { select: { id: true, numeroRecu: true } } },
    });
    return { paymentId: fresh.id, reference: fresh.reference, statut: fresh.statut, montant: fresh.montant, devise: fresh.devise, receipt: fresh.receipt };
  }

  // ------------------------------------------------------------------ Règlement (cœur)
  /**
   * Applique le résultat d'un paiement. Idempotent et concurrent-safe :
   * verrou de ligne sur le paiement et la facture, aucune double application.
   */
  async settle(
    paymentId: string,
    status: ProviderStatus,
    opts: { amount?: bigint; currency?: string; externalRef?: string; source: string; actorId?: string | null },
  ) {
    if (status === 'PENDING') return;

    const result = await this.prisma.$transaction(async (tx) => {
      const [locked] = await tx.$queryRaw<{ id: string; statut: PaymentStatus }[]>`
        SELECT id, statut FROM "Payment" WHERE id = ${paymentId} FOR UPDATE`;
      if (!locked) throw new NotFoundException('Paiement introuvable');
      if (locked.statut === PaymentStatus.VALIDE || locked.statut === PaymentStatus.REMBOURSE) return null; // déjà traité

      const payment = await tx.payment.findUniqueOrThrow({ where: { id: paymentId } });

      if (status === 'FAILED') {
        await tx.payment.update({ where: { id: paymentId }, data: { statut: PaymentStatus.ECHOUE, referenceExterne: opts.externalRef ?? payment.referenceExterne } });
        await this.audit.log({ userId: opts.actorId ?? null }, 'PAYMENT_FAILED', 'Payment', paymentId, { statut: payment.statut }, { statut: 'ECHOUE', source: opts.source }, tx);
        return { kind: 'failed' as const, payment };
      }

      // Contrôle anti-fraude : montant et devise doivent correspondre exactement.
      if ((opts.amount !== undefined && opts.amount !== payment.montant) || (opts.currency && opts.currency !== payment.devise)) {
        await tx.payment.update({ where: { id: paymentId }, data: { metadata: { ...(payment.metadata as object), anomaly: `montant reçu ${opts.amount} ${opts.currency}` } } });
        await this.audit.log({ userId: null }, 'PAYMENT_AMOUNT_MISMATCH', 'Payment', paymentId, { attendu: payment.montant, devise: payment.devise }, { recu: opts.amount, devise: opts.currency, source: opts.source }, tx);
        return { kind: 'anomaly' as const, payment };
      }

      await tx.$queryRaw`SELECT id FROM "Invoice" WHERE id = ${payment.invoiceId} FOR UPDATE`;
      const invoice = await tx.invoice.findUniqueOrThrow({ where: { id: payment.invoiceId } });
      const applied = payment.montant > invoice.soldeRestant ? invoice.soldeRestant : payment.montant;
      const montantPaye = invoice.montantPaye + applied;
      const soldeRestant = invoice.montantTotal - montantPaye;
      const statut =
        soldeRestant <= 0n ? InvoiceStatus.PAYE : invoice.dateEcheance < new Date() ? InvoiceStatus.EN_RETARD : InvoiceStatus.PARTIELLEMENT_PAYE;

      const validated = await tx.payment.update({
        where: { id: paymentId },
        data: { statut: PaymentStatus.VALIDE, referenceExterne: opts.externalRef ?? payment.referenceExterne },
      });
      await tx.invoice.update({ where: { id: invoice.id }, data: { montantPaye, soldeRestant: soldeRestant < 0n ? 0n : soldeRestant, statut } });

      const receipt = await tx.receipt.create({
        data: {
          paymentId,
          numeroRecu: newReference('REC'),
          pdfUrl: '',
          qrTokenVerification: randomBytes(16).toString('hex'), // remplacé ci-dessous par le jeton signé
        },
      });
      const signed = await tx.receipt.update({
        where: { id: receipt.id },
        data: { pdfUrl: `/api/v1/receipts/${receipt.id}/pdf`, qrTokenVerification: receiptToken(receipt.id) },
      });

      await this.audit.log(
        { userId: opts.actorId ?? null },
        'PAYMENT_VALIDATED',
        'Invoice',
        invoice.id,
        { montantPaye: invoice.montantPaye, soldeRestant: invoice.soldeRestant, statut: invoice.statut },
        { montantPaye, soldeRestant, statut, paymentId, receipt: signed.numeroRecu, source: opts.source },
        tx,
      );
      return { kind: 'validated' as const, payment: validated, invoice, receipt: signed };
    });

    if (!result) return;
    const invoice = await this.prisma.invoice.findUniqueOrThrow({
      where: { id: result.payment.invoiceId },
      include: { student: { select: { id: true, prenom: true, nom: true } } },
    });
    const recipients = await this.access.stakeholderUserIds(invoice.studentId);
    const enfant = `${invoice.student.prenom} ${invoice.student.nom}`;

    if (result.kind === 'validated') {
      // Parcours P2/P3 : notification immédiate à chaque versement, quel que soit l'auteur.
      await this.notifications.notify(recipients, {
        categorie: NotificationCategory.FINANCE,
        titre: 'Versement reçu',
        corps: `Versement de ${formatXaf(result.payment.montant)} reçu pour ${enfant}. Reçu n° ${result.receipt.numeroRecu}.`,
        data: { type: 'PAYMENT_VALIDATED', paymentId: result.payment.id, receiptId: result.receipt.id, studentId: invoice.studentId },
      });
    } else if (result.kind === 'failed' && result.payment.payeParUserId) {
      await this.notifications.notify([result.payment.payeParUserId], {
        categorie: NotificationCategory.FINANCE,
        titre: 'Paiement non abouti',
        corps: `Le paiement de ${formatXaf(result.payment.montant)} pour ${enfant} n’a pas abouti. Aucun montant n’a été débité.`,
        data: { type: 'PAYMENT_FAILED', paymentId: result.payment.id, studentId: invoice.studentId },
      });
    }
  }

  // ------------------------------------------------------------------ Guichet (P3)
  async recordCash(cashier: AuthUser, input: CashPaymentInput, ctx: AuditContext) {
    const invoice = await this.prisma.invoice.findUnique({ where: { id: input.invoiceId } });
    if (!invoice) throw new NotFoundException('Facture introuvable');
    if (invoice.statut === InvoiceStatus.ANNULE) throw new BadRequestException('Facture annulée');
    const montant = BigInt(input.montant);
    if (montant <= 0n || montant > invoice.soldeRestant) {
      throw new BadRequestException({ code: 'INVALID_AMOUNT', message: `Le montant doit être compris entre 1 et ${invoice.soldeRestant}` });
    }
    const payment = await this.prisma.payment.create({
      data: {
        invoiceId: invoice.id,
        enregistreParId: cashier.id,
        payeurType: input.payeurType,
        reference: newReference('GUI'),
        idempotencyKey: `cash-${randomBytes(12).toString('hex')}`,
        montant,
        devise: invoice.devise,
        canal: input.canal as PaymentChannel,
        provider: PaymentProviderType.MANUAL_GUICHET,
        referenceExterne: input.referenceExterne,
        justificatifUrl: input.justificatifUrl,
        statut: PaymentStatus.EN_ATTENTE,
        metadata: { payeurNom: input.payeurNom ?? null },
      },
    });
    await this.audit.log(ctx, 'CASH_PAYMENT_RECORDED', 'Payment', payment.id, null, {
      montant, canal: input.canal, invoiceId: invoice.id, payeurType: input.payeurType,
    });
    await this.settle(payment.id, 'SUCCESS', { source: 'guichet', actorId: cashier.id });
    return this.prisma.payment.findUniqueOrThrow({ where: { id: payment.id }, include: { receipt: true } });
  }

  /** Simulation de confirmation (sandbox, hors production) : passe par le même webhook signé. */
  async sandboxConfirm(user: AuthUser, paymentId: string, success: boolean) {
    if (env.isProd) throw new NotFoundException();
    const payment = await this.prisma.payment.findUnique({ where: { id: paymentId }, include: { invoice: true } });
    if (!payment || payment.provider !== PaymentProviderType.SANDBOX) throw new NotFoundException('Paiement sandbox introuvable');
    await this.access.assertCanAccess(user, payment.invoice.studentId);
    await this.settle(payment.id, success ? 'SUCCESS' : 'FAILED', {
      amount: payment.montant,
      currency: payment.devise,
      externalRef: payment.referenceExterne ?? undefined,
      source: 'sandbox',
    });
    return this.status(user, paymentId);
  }
}

import { PaymentProviderType } from '@prisma/client';

export interface InitiateInput {
  paymentId: string;
  reference: string; // référence interne unique, transmise à la passerelle
  amount: bigint; // entier, plus petite unité de la devise
  currency: string;
  description: string;
  customer: { name: string; phone?: string | null; email?: string | null };
  channel: 'MOBILE_MONEY' | 'CARD';
  returnUrl: string;
  notifyUrl: string;
}

export interface InitiateResult {
  externalRef?: string;
  /** URL de paiement (page hébergée de la passerelle) à ouvrir dans l'application. */
  paymentUrl?: string;
  /** Instructions à afficher (ex. « Validez la demande sur votre téléphone »). */
  instructions?: string;
}

export type ProviderStatus = 'SUCCESS' | 'FAILED' | 'PENDING';

export interface WebhookEvent {
  reference: string; // notre référence interne
  externalRef?: string;
  status: ProviderStatus;
  amount?: bigint;
  currency?: string;
  raw: unknown;
}

export interface WebhookRequest {
  headers: Record<string, string | string[] | undefined>;
  rawBody: Buffer;
  body: any;
}

/**
 * Contrat commun à toutes les passerelles. Le reste du code ne connaît
 * que cette interface : changer de fournisseur ne touche pas au métier.
 */
export interface PaymentProvider {
  readonly type: PaymentProviderType;
  isConfigured(): boolean;
  initiate(input: InitiateInput): Promise<InitiateResult>;
  /** Vérifie la signature et extrait l'évènement. Lève une erreur si la signature est invalide. */
  parseWebhook(req: WebhookRequest): Promise<WebhookEvent>;
  /** Interroge la passerelle (polling) pour connaître l'état réel d'une transaction. */
  checkStatus(reference: string, externalRef?: string | null): Promise<ProviderStatus>;
}

export class WebhookSignatureError extends Error {}

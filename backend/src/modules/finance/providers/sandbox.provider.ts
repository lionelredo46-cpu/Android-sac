import { Injectable } from '@nestjs/common';
import { PaymentProviderType } from '@prisma/client';
import { createHmac, timingSafeEqual } from 'crypto';
import { env } from '../../../config/env';
import {
  InitiateInput,
  InitiateResult,
  PaymentProvider,
  ProviderStatus,
  WebhookEvent,
  WebhookRequest,
  WebhookSignatureError,
} from './payment-provider';

export function sandboxSign(rawBody: string | Buffer): string {
  return createHmac('sha256', env.payment.sandboxWebhookSecret).update(rawBody).digest('hex');
}

/**
 * Passerelle de test (développement / démonstration / tests automatisés).
 * Même contrat qu'une vraie passerelle : la confirmation passe par un
 * webhook signé HMAC-SHA256. Interdite en production (voir config).
 */
@Injectable()
export class SandboxProvider implements PaymentProvider {
  readonly type = PaymentProviderType.SANDBOX;

  isConfigured() {
    return !env.isProd && env.payment.sandboxWebhookSecret.length >= 16;
  }

  async initiate(input: InitiateInput): Promise<InitiateResult> {
    return {
      externalRef: `SBX-${input.reference}`,
      instructions:
        input.channel === 'MOBILE_MONEY'
          ? 'Mode test : validez la demande de paiement simulée dans l’application.'
          : 'Mode test : aucune carte réelle n’est débitée.',
    };
  }

  async parseWebhook(req: WebhookRequest): Promise<WebhookEvent> {
    const given = String(req.headers['x-sandbox-signature'] ?? '');
    const expected = sandboxSign(req.rawBody);
    if (given.length !== expected.length || !timingSafeEqual(Buffer.from(given), Buffer.from(expected))) {
      throw new WebhookSignatureError('Signature sandbox invalide');
    }
    const b = req.body;
    return {
      reference: b.reference,
      externalRef: b.externalRef,
      status: b.status,
      amount: b.amount !== undefined ? BigInt(b.amount) : undefined,
      currency: b.currency,
      raw: b,
    };
  }

  async checkStatus(): Promise<ProviderStatus> {
    return 'PENDING';
  }
}

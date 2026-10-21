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

const API = 'https://api.stripe.com/v1';
const TOLERANCE_SECONDS = 300;

/**
 * Stripe Checkout (cartes Visa/Mastercard, Apple Pay, Google Pay).
 * Aucune donnée de carte ne transite par nos serveurs (PCI-DSS délégué).
 * XAF est une devise « zero-decimal » chez Stripe : le montant entier est transmis tel quel.
 */
@Injectable()
export class StripeProvider implements PaymentProvider {
  readonly type = PaymentProviderType.STRIPE;
  private readonly cfg = env.payment.stripe;

  isConfigured() {
    return !!(this.cfg.secretKey && this.cfg.webhookSecret);
  }

  private async call(path: string, params?: Record<string, string>, method = 'POST') {
    const res = await fetch(`${API}${path}`, {
      method,
      headers: {
        Authorization: `Bearer ${this.cfg.secretKey}`,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: params ? new URLSearchParams(params).toString() : undefined,
    });
    const json: any = await res.json();
    if (!res.ok) throw new Error(`Stripe : ${json.error?.message ?? res.status}`);
    return json;
  }

  async initiate(input: InitiateInput): Promise<InitiateResult> {
    const session = await this.call('/checkout/sessions', {
      mode: 'payment',
      client_reference_id: input.reference,
      'metadata[reference]': input.reference,
      'payment_intent_data[metadata][reference]': input.reference,
      'line_items[0][quantity]': '1',
      'line_items[0][price_data][currency]': input.currency.toLowerCase(),
      'line_items[0][price_data][unit_amount]': input.amount.toString(),
      'line_items[0][price_data][product_data][name]': input.description.slice(0, 120),
      success_url: `${input.returnUrl}?status=success`,
      cancel_url: `${input.returnUrl}?status=cancel`,
      ...(input.customer.email ? { customer_email: input.customer.email } : {}),
    });
    return { externalRef: session.id, paymentUrl: session.url };
  }

  async parseWebhook(req: WebhookRequest): Promise<WebhookEvent> {
    const header = String(req.headers['stripe-signature'] ?? '');
    const parts = Object.fromEntries(header.split(',').map((kv) => kv.split('=') as [string, string]));
    const timestamp = Number(parts.t);
    if (!timestamp || Math.abs(Date.now() / 1000 - timestamp) > TOLERANCE_SECONDS) {
      throw new WebhookSignatureError('Horodatage Stripe invalide');
    }
    const expected = createHmac('sha256', this.cfg.webhookSecret)
      .update(`${timestamp}.${req.rawBody.toString('utf8')}`)
      .digest('hex');
    const given = parts.v1 ?? '';
    if (given.length !== expected.length || !timingSafeEqual(Buffer.from(given), Buffer.from(expected))) {
      throw new WebhookSignatureError('Signature Stripe invalide');
    }

    const event = JSON.parse(req.rawBody.toString('utf8'));
    const obj = event.data?.object ?? {};
    const reference = obj.client_reference_id ?? obj.metadata?.reference;
    let status: ProviderStatus = 'PENDING';
    if (event.type === 'checkout.session.completed' && obj.payment_status === 'paid') status = 'SUCCESS';
    if (event.type === 'checkout.session.async_payment_succeeded') status = 'SUCCESS';
    if (event.type === 'checkout.session.expired' || event.type === 'checkout.session.async_payment_failed') status = 'FAILED';
    return {
      reference,
      externalRef: obj.id,
      status,
      amount: obj.amount_total !== undefined ? BigInt(obj.amount_total) : undefined,
      currency: obj.currency?.toUpperCase(),
      raw: { id: event.id, type: event.type },
    };
  }

  async checkStatus(_reference: string, externalRef?: string | null): Promise<ProviderStatus> {
    if (!externalRef) return 'PENDING';
    const s = await this.call(`/checkout/sessions/${externalRef}`, undefined, 'GET');
    if (s.payment_status === 'paid') return 'SUCCESS';
    if (s.status === 'expired') return 'FAILED';
    return 'PENDING';
  }
}

import { Injectable, Logger } from '@nestjs/common';
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

const API = 'https://api-checkout.cinetpay.com/v2';

/**
 * CinetPay : agrégateur Mobile Money (Airtel Money, Moov Money au Gabon) et cartes,
 * en XAF. Documentation : https://docs.cinetpay.com
 * - Initialisation : POST /payment → payment_url (page hébergée).
 * - Notification : POST sur notify_url, en-tête x-token = HMAC-SHA256 des champs.
 * - Vérification : POST /payment/check (source de vérité, toujours appelée).
 */
@Injectable()
export class CinetPayProvider implements PaymentProvider {
  readonly type = PaymentProviderType.CINETPAY;
  private readonly logger = new Logger('CinetPay');
  private readonly cfg = env.payment.cinetpay;

  isConfigured() {
    return !!(this.cfg.apiKey && this.cfg.siteId && this.cfg.secretKey);
  }

  async initiate(input: InitiateInput): Promise<InitiateResult> {
    const res = await fetch(`${API}/payment`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        apikey: this.cfg.apiKey,
        site_id: this.cfg.siteId,
        transaction_id: input.reference,
        amount: Number(input.amount),
        currency: input.currency,
        description: input.description.slice(0, 100),
        customer_name: input.customer.name,
        customer_phone_number: input.customer.phone ?? undefined,
        customer_email: input.customer.email ?? undefined,
        channels: input.channel === 'CARD' ? 'CREDIT_CARD' : 'MOBILE_MONEY',
        notify_url: input.notifyUrl,
        return_url: input.returnUrl,
        lang: 'FR',
      }),
    });
    const json: any = await res.json();
    if (json.code !== '201') {
      this.logger.error(`Initialisation refusée : ${json.code} ${json.message}`);
      throw new Error(`CinetPay : ${json.message ?? 'initialisation impossible'}`);
    }
    return { externalRef: json.data?.payment_token, paymentUrl: json.data?.payment_url };
  }

  async parseWebhook(req: WebhookRequest): Promise<WebhookEvent> {
    const b = req.body ?? {};
    const fields = [
      'cpm_site_id', 'cpm_trans_id', 'cpm_trans_date', 'cpm_amount', 'cpm_currency', 'signature',
      'payment_method', 'cel_phone_num', 'cpm_phone_prefixe', 'cpm_language', 'cpm_version',
      'cpm_payment_config', 'cpm_page_action', 'cpm_custom', 'cpm_designation', 'cpm_error_message',
    ];
    const data = fields.map((f) => b[f] ?? '').join('');
    const expected = createHmac('sha256', this.cfg.secretKey).update(data).digest('hex');
    const given = String(req.headers['x-token'] ?? '');
    if (given.length !== expected.length || !timingSafeEqual(Buffer.from(given), Buffer.from(expected))) {
      throw new WebhookSignatureError('Signature CinetPay invalide');
    }
    if (b.cpm_site_id !== this.cfg.siteId) throw new WebhookSignatureError('Site CinetPay inattendu');

    // La notification ne fait pas foi : on interroge l'API de vérification.
    const status = await this.checkStatus(b.cpm_trans_id);
    return {
      reference: b.cpm_trans_id,
      status,
      amount: b.cpm_amount ? BigInt(Math.round(Number(b.cpm_amount))) : undefined,
      currency: b.cpm_currency,
      raw: b,
    };
  }

  async checkStatus(reference: string): Promise<ProviderStatus> {
    const res = await fetch(`${API}/payment/check`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ apikey: this.cfg.apiKey, site_id: this.cfg.siteId, transaction_id: reference }),
    });
    const json: any = await res.json();
    const s = json.data?.status;
    if (json.code === '00' && s === 'ACCEPTED') return 'SUCCESS';
    if (s === 'REFUSED' || s === 'CANCELED' || json.code === '600') return 'FAILED';
    return 'PENDING';
  }
}

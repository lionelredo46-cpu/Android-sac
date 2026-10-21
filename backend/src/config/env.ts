import 'dotenv/config';

/**
 * Configuration centralisée et validée au démarrage.
 * Aucun secret n'a de valeur par défaut : l'application refuse de démarrer
 * si un secret obligatoire est absent ou trop court.
 */
function required(name: string, minLength = 1): string {
  const value = process.env[name];
  if (!value || value.length < minLength || value === 'CHANGE_ME') {
    throw new Error(
      `[Config] Variable d'environnement ${name} manquante ou invalide (min ${minLength} caractères).`,
    );
  }
  return value;
}

function optional(name: string, fallback = ''): string {
  return process.env[name] ?? fallback;
}

function bool(name: string, fallback = false): boolean {
  const v = process.env[name];
  if (v === undefined) return fallback;
  return v === 'true' || v === '1';
}

const nodeEnv = optional('NODE_ENV', 'development');
const isProd = nodeEnv === 'production';

export const env = {
  nodeEnv,
  isProd,
  port: Number(optional('PORT', '3000')),
  publicUrl: optional('APP_PUBLIC_URL', 'http://localhost:3000'),
  corsOrigins: optional('CORS_ORIGINS', '')
    .split(',')
    .map((o) => o.trim())
    .filter(Boolean),

  jwt: {
    accessSecret: required('JWT_SECRET', 32),
    refreshSecret: required('JWT_REFRESH_SECRET', 32),
    accessTtl: optional('JWT_ACCESS_TTL', '15m'),
    refreshTtlDays: Number(optional('JWT_REFRESH_TTL_DAYS', '30')),
  },

  otp: {
    ttlSeconds: Number(optional('OTP_TTL_SECONDS', '300')),
    maxAttempts: Number(optional('OTP_MAX_ATTEMPTS', '5')),
    // Jamais actif en production, quelle que soit la variable.
    devEcho: !isProd && bool('OTP_DEV_ECHO', false),
  },

  /** Requêtes / minute / IP sur les routes d'authentification sensibles. */
  authRateLimit: Number(optional('AUTH_RATE_LIMIT', '5')),

  receiptSigningSecret: required('RECEIPT_SIGNING_SECRET', 16),

  storage: {
    driver: optional('STORAGE_DRIVER', 'local'),
    localDir: optional('STORAGE_LOCAL_DIR', './storage'),
  },

  payment: {
    defaultProvider: optional('PAYMENT_DEFAULT_PROVIDER', 'SANDBOX'),
    sandboxWebhookSecret: optional('SANDBOX_WEBHOOK_SECRET', ''),
    cinetpay: {
      apiKey: optional('CINETPAY_API_KEY'),
      siteId: optional('CINETPAY_SITE_ID'),
      secretKey: optional('CINETPAY_SECRET_KEY'),
    },
    stripe: {
      secretKey: optional('STRIPE_SECRET_KEY'),
      webhookSecret: optional('STRIPE_WEBHOOK_SECRET'),
    },
  },

  firebaseServiceAccountB64: optional('FIREBASE_SERVICE_ACCOUNT_B64'),
};

if (isProd && env.payment.defaultProvider === 'SANDBOX') {
  throw new Error('[Config] Le fournisseur SANDBOX est interdit en production.');
}

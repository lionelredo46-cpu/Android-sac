#!/usr/bin/env bash
# Déploie l'API UniParent sur Railway : projet, PostgreSQL, service « api » construit
# depuis backend/Dockerfile, volume des pièces jointes, secrets et domaine public.
#
# Prérequis : npm install -g @railway/cli, puis `railway login`
# (ou la variable RAILWAY_API_TOKEN avec un jeton de compte : railway.com/account/tokens).
#
#   bash backend/scripts/deploy-railway.sh          # premier déploiement
#   bash backend/scripts/deploy-railway.sh --redeploy  # nouvelle version du code seulement
#   SEED=1 bash backend/scripts/deploy-railway.sh   # + données de démonstration (vide la base !)
#
# Mode recette : NODE_ENV=staging (paiements Sandbox, Swagger sur /api/docs). Passer en
# production = NODE_ENV=production + PAYMENT_DEFAULT_PROVIDER=CINETPAY et ses clés.
set -euo pipefail

cd "$(dirname "$0")/.."
PROJECT="${PROJECT:-uniparent}"
SERVICE="${SERVICE:-api}"

secret() { node -e "console.log(require('crypto').randomBytes(48).toString('base64url'))"; }

if [ "${1:-}" != "--redeploy" ]; then
  if ! railway status >/dev/null 2>&1; then
    echo "==> Projet Railway « $PROJECT »"
    railway init --name "$PROJECT"
  fi

  if ! railway variables --service Postgres --kv >/dev/null 2>&1; then
    echo "==> Base PostgreSQL"
    railway add --database postgres
  fi

  if ! railway variables --service "$SERVICE" --kv >/dev/null 2>&1; then
    echo "==> Service « $SERVICE »"
    railway add --service "$SERVICE"
  fi
  railway link --service "$SERVICE" >/dev/null

  echo "==> Variables (secrets générés aléatoirement)"
  railway variable set --service "$SERVICE" --skip-deploys \
    'DATABASE_URL=${{Postgres.DATABASE_URL}}' \
    "NODE_ENV=staging" \
    "PORT=3000" \
    "JWT_SECRET=$(secret)" \
    "JWT_REFRESH_SECRET=$(secret)" \
    "RECEIPT_SIGNING_SECRET=$(secret)" \
    "SANDBOX_WEBHOOK_SECRET=$(secret)" \
    "PAYMENT_DEFAULT_PROVIDER=SANDBOX" \
    "OTP_DEV_ECHO=false" \
    "STORAGE_DRIVER=local" \
    "STORAGE_LOCAL_DIR=/app/storage" \
    "AUTH_RATE_LIMIT=10" \
    "RAILWAY_RUN_UID=0"

  echo "==> Volume des pièces jointes (/app/storage)"
  railway volume --service "$SERVICE" add --mount-path /app/storage || echo "   (volume déjà présent)"
fi

echo "==> Envoi du code et construction de l'image (Dockerfile)"
railway up --service "$SERVICE" --detach

echo "==> Domaine public"
DOMAIN_JSON="$(railway domain --service "$SERVICE" --json 2>/dev/null || true)"
echo "$DOMAIN_JSON"
DOMAIN="$(echo "$DOMAIN_JSON" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const m=s.match(/[a-z0-9.-]+\.up\.railway\.app/);console.log(m?m[0]:"")})')"
if [ -n "$DOMAIN" ]; then
  railway variable set --service "$SERVICE" --skip-deploys "APP_PUBLIC_URL=https://$DOMAIN" >/dev/null
  echo "    API : https://$DOMAIN/api/v1/health"
fi

if [ "${SEED:-0}" = "1" ]; then
  echo "==> Données de démonstration (via l'URL publique de la base)"
  PUBLIC_DB="$(railway variables --service Postgres --kv | sed -n 's/^DATABASE_PUBLIC_URL=//p')"
  DATABASE_URL="$PUBLIC_DB" npx prisma migrate deploy
  DATABASE_URL="$PUBLIC_DB" npm run prisma:seed
fi

if [ -n "${DOMAIN:-}" ]; then
  echo
  echo "Terminé. Dans l'APK de recette : écran de connexion → « Serveur de l'API » → https://$DOMAIN"
  echo "(ou remplacer stagingApiBaseUrl dans lib/main_staging.dart puis recompiler)."
fi

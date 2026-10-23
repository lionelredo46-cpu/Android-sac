# API UniParent — image de production (multi-étapes, utilisateur non root)
FROM node:22-alpine AS build
WORKDIR /app
# openssl dans les deux étapes : Prisma choisit son moteur selon la version détectée.
RUN apk add --no-cache openssl
COPY package*.json ./
RUN npm ci
COPY . .
# `prisma generate` vérifie seulement que le schéma est valide (il ne se connecte pas) : une URL
# factice suffit pendant la construction. Railway (et tout hébergeur) ne transmet les variables
# réelles du service qu'au démarrage du conteneur, jamais à `docker build`.
ENV DATABASE_URL="postgresql://build:build@localhost:5432/build"
RUN npx prisma generate && npm run build && npm prune --omit=dev

FROM node:22-alpine
ENV NODE_ENV=production
WORKDIR /app
RUN addgroup -S app && adduser -S app -G app && apk add --no-cache openssl
COPY --from=build --chown=app:app /app/node_modules ./node_modules
COPY --from=build --chown=app:app /app/dist ./dist
COPY --from=build --chown=app:app /app/prisma ./prisma
COPY --from=build --chown=app:app /app/assets ./assets
COPY --from=build --chown=app:app /app/package.json ./
# Pièces jointes : à monter sur un volume persistant (STORAGE_LOCAL_DIR=/app/storage).
RUN mkdir -p /app/storage && chown app:app /app/storage
USER app
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s CMD wget -qO- http://127.0.0.1:${PORT:-3000}/api/v1/health || exit 1
# Migrations appliquées au démarrage (CLI Prisma de l'image, jamais téléchargée), puis lancement de l'API.
CMD ["sh", "-c", "./node_modules/.bin/prisma migrate deploy && node dist/main.js"]

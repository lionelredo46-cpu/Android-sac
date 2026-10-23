# UniParent AFRAM

Suivi de la vie universitaire des étudiants de l’AFRAM (Libreville) par leurs parents : finances et paiements, présences, notes et bulletins, emploi du temps, messagerie, documents, discipline, notifications. L’administration pilote tout depuis un back-office web.

| Dossier | Contenu | Stack |
|---|---|---|
| `/` (lib, android, ios) | Application mobile parents / étudiants | Flutter 3.47 · Riverpod 2 · go_router · dio · freezed · hive_ce |
| `backend/` | API REST `/api/v1` | NestJS 10 · Prisma 5 · PostgreSQL 16 · Swagger |
| `admin/` | Back-office web | Next.js 15 · Tailwind 4 · SWR |
| `Afram/` | Dossier de recherche sur l’établissement (logos, brochures, données) | — |

## Démarrage rapide (poste de développement)

Prérequis : Docker Desktop, Node 22+, Flutter 3.47.7, JDK 21, Android SDK 36.

```bash
# 1. Infrastructure : PostgreSQL (port 5433), Redis, stockage S3 (RustFS)
docker compose up -d

# 2. API
cd backend
cp .env.example .env          # puis renseigner les secrets (32+ caractères aléatoires)
npm ci
npx prisma migrate deploy
npm run prisma:seed           # données de démonstration (vide la base !)
npm run build && npm run start:prod      # http://localhost:3000 — Swagger : /api/docs

# 3. Back-office
cd ../admin
cp .env.example .env.local
npm ci && npm run dev         # http://localhost:3001

# 4. Application mobile (émulateur Android)
cd ..
flutter pub get
dart run build_runner build
flutter run --flavor dev -t lib/main_dev.dart
# Téléphone physique sur le même réseau :
#   flutter run --flavor dev -t lib/main_dev.dart --dart-define=API_BASE_URL=http://<IP-du-PC>:3000
```

### Comptes de démonstration (mot de passe `Afram2026!`)

| Rôle | Identifiant | Remarque |
|---|---|---|
| Parent | `parent@aframgabon.com` / `+241066701184` | 2 enfants, une tranche en retard |
| Parent à activer | code `AFRAM-2026-ACTIVATE` | parcours P1 (OTP affiché en dev) |
| Étudiant | `alexandre.obiang@etudiant.afram.ga` | scan QR de présence |
| Super admin | `admin@aframgabon.com` | 2FA à activer au 1er login |
| Scolarité / Comptable / Direction / Support | `scolarite@` · `comptable@` · `direction@` · `support@aframgabon.com` | |
| Enseignant | `p.ndong@aframgabon.com` | appel, saisie des notes |

En développement, le paiement passe par la passerelle **Sandbox** (webhook signé HMAC) : l’écran d’attente propose « Simuler la validation ».

## Tests

```bash
cd backend && npm test               # unitaires (calcul des moyennes…)
cd backend && npm run test:e2e       # 87 vérifications de bout en bout (API démarrée + seed)
cd admin && npm run typecheck
flutter analyze && flutter test      # unitaires + widgets
flutter widget-preview start         # aperçus des composants (lib/**/timetable_previews.dart)
# Parcours complet sur appareil (API de recette Railway, NFC simulé si l'appareil n'a pas de puce) :
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/timetable_flow_test.dart --profile --flavor staging
```

## Design « Stratosphère »

Thème sombre par défaut (variante claire « aube » dans Paramètres). Jetons de couleurs : `lib/core/theme/strato.dart` (`context.strato`) ; thème Material : `lib/core/theme/app_theme.dart`.

- Ciel animé unique derrière toutes les pages (`StratoBackground`, monté dans `MaterialApp.builder`) : pages transparentes et transition « fondu traversant » (`StratoPageTransitionsBuilder`).
- Surfaces : `GlassCard` (verre sans flou, liseré lumineux ; `gradient:` pour les cartes héroïques), `GlowIcon`, `SectionLabel`, `StratoTabBar`, dock flottant `StratoDock` (`main_shell.dart`).
- Mouvement : `Reveal` (entrée en cascade), `CountUp` (chiffres), `OrbitGauge` (jauges), `ProgressBar` animée, `OrbitEmblem` (états vides/erreur). Toutes les animations continues s'arrêtent si l'utilisateur a réduit les animations (accessibilité) — les tests de widgets s'appuient dessus.

## Emploi du temps et NFC

Module `lib/features/timetable` : timeline mobile (< 600 px), grille hebdomadaire et panneau latéral au-delà, export PDF (A4 paysage/portrait, QR de vérification), iCalendar (RFC 5545, rappel 15 min) et image (story 9:16 / carte 1:1).

Liens profonds : `/timetable?week=2026-10-19&sheet=export|nfc&nfc=room|sync|attendance|card`.

| Usage NFC | Support | Contenu attendu |
|---|---|---|
| Ma salle | Tag NDEF collé à l'entrée | URI `https://uniparent.aframgabon.com/salle/<code>` (ouvre aussi l'application fermée, Android) ou texte `AFRAM:SALLE:<code>` |
| Émargement | Borne ou badge NDEF | URI `…/presence/<code>` ou texte `AFRAM:PRESENCE:<code>` — `<code>` = code de séance du QR de présence (`POST /attendance/scan`) |
| Carte étudiant | MIFARE / DESFire / NFC | Seul l'identifiant matériel est lu ; l'association carte → étudiant est enregistrée sur le téléphone au premier scan |
| Tap-to-Sync | Téléphone à téléphone | L'émetteur émule un tag NDEF type 4 (HCE, **Android uniquement**) ; le récepteur peut être un Android ou un iPhone |

Limites : le pair-à-pair NFC « Android Beam » n'existe plus (Android 10+) et iOS ne sait pas émuler un tag ; sur iPhone, la lecture NFC exige la capacité *NFC Tag Reading* (compte Apple Developer payant) — déclarée dans `ios/Runner/Runner.entitlements`. L'API ne propose pas encore le planning complet d'une salle : la vérification affiche les cours de l'étudiant dans cette salle. Le lien de vérification du QR des PDF (`/verifier/edt?e=…&s=…&h=…`) attend sa page côté serveur.

## Architecture et règles de sécurité

- **Anti-IDOR** : toute donnée d’un étudiant passe par `ChildAccessService.assertCanAccess` (parent rattaché et validé, l’étudiant lui-même, l’enseignant de son groupe, ou le personnel autorisé).
- **RBAC granulaire** : matrice `RolePermission` en base, modifiable dans le back-office (Paramètres & droits).
- **Jetons** : accès JWT 15 min + refresh opaque rotatif stocké haché ; la réutilisation d’un refresh révoque toute la session. Côté web, les jetons restent en cookies httpOnly derrière un proxy serveur.
- **Argent** : montants `BigInt` entiers (FCFA), contraintes `CHECK` en base, clé d’idempotence obligatoire, règlement transactionnel avec verrou de ligne, confirmation uniquement par webhook signé ou par interrogation de la passerelle.
- **Audit immuable** : `AuditLog` et `GradeAuditLog` protégés par des triggers PostgreSQL (UPDATE/DELETE interdits).
- **Notes** : workflow brouillon → validé → publié ; le parent ne voit que les notes publiées ; toute correction après validation exige un motif.
- **Hors ligne** : l’application garde le dernier état connu (hive_ce) et affiche un bandeau « données du … ».

## Variables d’environnement (API)

Voir `backend/.env.example`. L’API refuse de démarrer si un secret obligatoire manque, et la passerelle Sandbox est interdite en production.

Passerelles : `PAYMENT_DEFAULT_PROVIDER=CINETPAY|STRIPE` avec leurs clés ; push : `FIREBASE_SERVICE_ACCOUNT_B64`.

## Déploiement

- **Railway (recette)** : `bash backend/scripts/deploy-railway.sh` crée le projet, PostgreSQL, le service `api` construit depuis `backend/Dockerfile` (config `backend/railway.json`), un volume `/app/storage` et un domaine `*.up.railway.app`. L'APK de recette (`lib/main_staging.dart`) pointe vers ce domaine.
- `docker-compose.prod.yml` : API, back-office, PostgreSQL, Redis, S3 derrière un reverse proxy TLS (VPS).
- CI : `.github/workflows/ci.yml` (API + e2e sur PostgreSQL, back-office, Flutter).
- Release : tag `vX.Y.Z` → `.github/workflows/release.yml` (AAB → Google Play test interne, IPA → TestFlight via Fastlane).

### Checklist de publication

- [ ] Keystore Android créé et sauvegardé ; secrets `ANDROID_KEYSTORE_*` et `PLAY_STORE_JSON_KEY` dans GitHub.
- [ ] Projet Firebase : `google-services.json` (Android) et `GoogleService-Info.plist` (iOS), clé APNs, compte de service pour l’API.
- [ ] Compte marchand CinetPay (Airtel Money / Moov Money, XAF) et/ou Stripe ; URL de webhook HTTPS publique.
- [ ] Domaine et certificats : `api.uniparent.aframgabon.com`, `admin.uniparent.aframgabon.com`, `uniparent.aframgabon.com` (liens d’activation).
- [ ] Fiches stores FR/EN, politique de confidentialité, « Data safety » Google Play, « App Privacy » Apple, compte de démonstration pour les relecteurs.
- [ ] Mac avec Xcode pour les schémas iOS par flavor et la signature.
- [ ] Données réelles validées par l’AFRAM (frais, calendrier, filières) — voir `Afram/README.md`.

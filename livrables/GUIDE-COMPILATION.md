# UniParent AFRAM — Obtenir et compiler les applications

Ce dossier contient les installables prêts à l’emploi et explique comment les régénérer.

```
livrables/
├── GUIDE-COMPILATION.md          ← ce fichier
├── android/
│   ├── UniParent-recette-1.0.0+1-arm64-v8a.apk    ← recette : API en ligne sur Railway (à installer)
│   ├── UniParent-recette-1.0.0+1-armeabi-v7a.apk  ← idem, pour les téléphones Android anciens (32 bits)
│   ├── UniParent-prod-1.0.0+1-arm64-v8a.apk       ← version production (domaine aframgabon.com)
│   ├── UniParent-prod-1.0.0+1.aab                 ← à déposer sur Google Play
│   └── SHA256SUMS.txt               ← empreintes pour vérifier les fichiers
└── ios/
    └── LISEZMOI.md                  ← l’IPA iOS se génère sur macOS (voir § 4)
```

---

## 1. Quel fichier utiliser ?

| Fichier | Pour quoi faire | Serveur utilisé |
|---|---|---|
| `UniParent-recette-*-arm64-v8a.apk` | Présenter et tester l’application sur un téléphone Android (Internet requis) | L’API de recette hébergée sur Railway (`lib/main_staging.dart`) |
| `UniParent-recette-*-armeabi-v7a.apk` | Idem, téléphones 32 bits (rares, antérieurs à 2017) | idem |
| `UniParent-prod-*.apk` | Installation directe de la version finale | `https://api.uniparent.aframgabon.com` (à déployer) |
| `UniParent-prod-*.aab` | Publication sur le Google Play Store | idem |
| IPA iOS | iPhone / TestFlight / App Store | voir § 4 |

> Les APK sont actuellement signés avec la clé de **debug** (aucun keystore de production n’existe encore). Ils s’installent sans problème, mais **Google Play exige une clé de production** : voir § 3.4.

---

## 1 bis. Mettre le back-end en ligne sur Railway (une fois)

L’APK de recette parle directement à l’API hébergée sur Railway. Pour la déployer depuis ce PC (Git Bash, dans le dossier du projet) :

```bash
npm install -g @railway/cli      # une seule fois
railway login                    # ouvre le navigateur : se connecter puis « Authorize »
bash backend/scripts/deploy-railway.sh
SEED=1 bash backend/scripts/deploy-railway.sh --redeploy   # données de démonstration (après le 1er déploiement réussi)
```

Le script crée le projet `uniparent`, la base PostgreSQL, le service `api` construit avec `backend/Dockerfile`, un volume pour les pièces jointes, génère les secrets et affiche l’adresse publique (`https://….up.railway.app`). Vérifier dans le navigateur : `https://<adresse>/api/v1/health` → `{"status":"ok"}`.

Ensuite, dans l’application de recette : écran de connexion → **Serveur de l’API** → coller l’adresse (aucune recompilation nécessaire). Pour la graver dans l’APK : remplacer `stagingApiBaseUrl` dans `lib/main_staging.dart` puis relancer `bash scripts/build-livrables.sh`.

> Pendant un incident Railway (status.railway.com), les compilations des comptes gratuits/Hobby peuvent être suspendues : le déploiement reste en file d’attente et part tout seul à la reprise.

---

## 2. Installer l’application sur un téléphone Android

L’application ne contient que l’interface : toutes les données viennent de l’API en ligne. Il n’y a plus de « démo autonome » embarquée, et chaque APK ne contient qu’une architecture de processeur : le fichier est plusieurs fois plus léger qu’avant.

### 2.1 APK de recette (API sur Railway, recommandé)

1. Copiez `UniParent-recette-*-arm64-v8a.apk` sur le téléphone (câble USB, WhatsApp, Google Drive…), ou avec le câble : `adb install -r UniParent-recette-1.0.0+1-arm64-v8a.apk`.
2. Ouvrez le fichier et autorisez « Installer des applications inconnues » si Android le demande.
3. Lancez **UniParent Recette**, passez l’introduction, puis touchez un compte dans **Comptes de démonstration**.

L’API de recette tourne sur Railway avec les données de démonstration (seed) et la passerelle de paiement **Sandbox** : l’écran d’attente propose « Simuler la validation ». Les codes SMS (activation, mot de passe oublié) ne sont pas envoyés : ils apparaissent dans les journaux du service sur Railway (*Deployments → View logs*, ligne `[SMS] →`).

Déployer ou mettre à jour l’API : `bash backend/scripts/deploy-railway.sh` (voir l’en-tête du script ; `--redeploy` pour une simple nouvelle version, `SEED=1` pour remettre les données de démonstration).

### 2.2 Version de développement (API du PC)

#### Démarrer les serveurs sur le PC

```powershell
cd E:\ANDROID
docker compose up -d                  # PostgreSQL, Redis, stockage
cd backend
npm run build
npm run start:prod                    # API sur le port 3000
```

#### Autoriser le téléphone à joindre le PC

Le téléphone et le PC doivent être sur **le même réseau Wi-Fi**. Ouvrez le port 3000 dans le pare-feu Windows (PowerShell **en administrateur**, une seule fois) :

```powershell
New-NetFirewallRule -DisplayName "UniParent API 3000" -Direction Inbound -Protocol TCP -LocalPort 3000 -Action Allow -Profile Private
```

Vérifiez depuis le navigateur du téléphone : `http://192.168.1.152:3000/api/v1/health` doit afficher `{"status":"ok",…}`.

> Si l’adresse IP du PC a changé (commande `ipconfig`, ligne « Adresse IPv4 » de la carte Wi-Fi), régénérez l’APK de démo avec la nouvelle IP (§ 3.3).

#### Installer

Installez `UniParent-dev-*.apk` comme ci-dessus et lancez **UniParent Dev** : les comptes de démonstration se connectent à l’API du PC.

### 2.3 Comptes de démonstration

| Compte | Ce qu’on peut tester |
|---|---|
| Parent — Jean-Marc OBIANG | 2 enfants, tranche en retard, paiement Mobile Money, reçu PDF |
| Étudiant — Alexandre OBIANG | ses notes, présences, scan du QR de présence |
| Étudiante — Grâce OBIANG | dossier incomplet, autre filière |
| Mère à activer — Clarisse OBIANG | parcours d’activation (code `AFRAM-2026-ACTIVATE`, le code SMS s’affiche à l’écran en démo) |

Mot de passe de tous les comptes : `Afram2026!`. Pour remettre à zéro les données du serveur : `cd backend && npm run prisma:seed` (PC) ou `SEED=1 bash backend/scripts/deploy-railway.sh --redeploy` (Railway).

---

## 3. Recompiler les applications Android (Windows)

### 3.1 Prérequis (déjà installés sur ce PC)

| Outil | Emplacement sur ce PC |
|---|---|
| Flutter 3.47.7 | `E:\DevTools\flutter` |
| Android SDK 36 + NDK 28.2 | `E:\DevTools\Android\Sdk` |
| JDK 21 (Temurin) | `C:\Program Files\Eclipse Adoptium` |
| Caches Gradle / Pub / npm | `E:\DevTools\gradle`, `E:\DevTools\pub-cache`, `E:\DevTools\npm-cache` |

Sur un autre poste : installer Flutter 3.47.7, Android Studio (ou les *command-line tools*), JDK 17+, puis `flutter doctor --android-licenses`.

### 3.2 Tout générer en une commande

Depuis **Git Bash** :

```bash
cd /e/ANDROID
bash scripts/build-livrables.sh
```

Le script génère le code, compile les APK de recette et de production (un par architecture, `--split-per-abi`) et l’App Bundle, puis les copie dans `livrables/android/` avec leurs empreintes SHA-256. Durée : 10 à 25 minutes selon la machine (le premier build est le plus long).

### 3.3 Commandes à l’unité

```bash
flutter pub get
dart run build_runner build          # modèles (freezed / json)
flutter gen-l10n                     # traductions FR / EN

# APK de recette (API Railway) : un fichier par architecture, le plus léger possible
flutter build apk --release --flavor staging -t lib/main_staging.dart --split-per-abi --obfuscate --split-debug-info=build/symbols/staging

# APK pointant vers l'API du PC (remplacer l'IP)
flutter build apk --release --flavor dev -t lib/main_dev.dart --split-per-abi --dart-define=API_BASE_URL=http://192.168.1.152:3000

# APK et App Bundle de production (code obfusqué)
flutter build apk       --release --flavor prod -t lib/main_prod.dart --split-per-abi --obfuscate --split-debug-info=build/symbols/prod
flutter build appbundle --release --flavor prod -t lib/main_prod.dart --obfuscate --split-debug-info=build/symbols/prod

# Lancer directement sur l'émulateur ou un téléphone branché (développement)
flutter run --flavor dev -t lib/main_dev.dart
```

Fichiers produits : `build/app/outputs/flutter-apk/` (APK) et `build/app/outputs/bundle/prodRelease/` (AAB).

| Flavor | Nom affiché | Identifiant | API |
|---|---|---|---|
| `dev` | UniParent Dev | `ga.afram.uniparent.dev` | PC local (HTTP autorisé) |
| `staging` | UniParent Recette | `ga.afram.uniparent.staging` | API Railway (`stagingApiBaseUrl` dans `lib/main_staging.dart`) |
| `prod` | UniParent AFRAM | `ga.afram.uniparent` | `https://api.uniparent.aframgabon.com` (HTTPS obligatoire) |

Les trois versions peuvent être installées côte à côte sur le même téléphone.

### 3.4 Signature de production (obligatoire pour Google Play)

1. Créer la clé **une seule fois** et la sauvegarder hors du PC (sa perte empêche toute mise à jour de l’application) :
   ```powershell
   mkdir E:\ANDROID\android\keystore
   keytool -genkey -v -keystore E:\ANDROID\android\keystore\uniparent-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias uniparent
   ```
2. Copier `android/key.properties.example` en `android/key.properties` et y mettre les mots de passe choisis.
3. Relancer le build : les APK/AAB `prod` sont alors signés avec cette clé. `key.properties` et `*.jks` ne sont jamais versionnés.

---

## 4. Obtenir l’installable iOS (IPA)

**Apple n’autorise la compilation iOS que sur macOS avec Xcode** : il est impossible de produire l’IPA sur ce PC Windows. Deux solutions :

### 4.1 Sans Mac : GitHub Actions (recommandé)

Le projet contient le workflow `.github/workflows/build-ios.yml`, qui compile sur un Mac fourni par GitHub.

1. Mettre le projet sur GitHub (dépôt privé).
2. Onglet **Actions** → **Build iOS (IPA)** → **Run workflow** (choisir `lib/main_prod.dart`, ou `lib/main_dev.dart` + l’URL de l’API pour une démo).
3. À la fin (~15 min), télécharger l’artefact **uniparent-ios** : il contient l’IPA. Le placer dans `livrables/ios/`.

Sans certificat Apple, l’IPA produit est **non signé** : il s’installe via Xcode, AltStore ou Sideloadly sur un iPhone personnel. Pour un IPA signé (TestFlight / App Store), ajouter dans *Settings → Secrets* du dépôt :

| Secret | Contenu |
|---|---|
| `IOS_CERTIFICATE_P12_B64` | certificat de distribution `.p12` encodé en base64 |
| `IOS_CERTIFICATE_PASSWORD` | mot de passe du `.p12` |
| `IOS_PROVISIONING_PROFILE_B64` | profil de provisionnement `.mobileprovision` en base64 |

… et renseigner votre **Team ID** Apple dans `ios/ExportOptions.plist`. Un compte **Apple Developer Program (99 USD/an)** est nécessaire.

### 4.2 Avec un Mac

```bash
# Xcode 16+ et CocoaPods installés
flutter pub get && dart run build_runner build && flutter gen-l10n
cd ios && pod install && cd ..
open ios/Runner.xcworkspace          # Signing & Capabilities : choisir votre équipe Apple
flutter build ipa --release -t lib/main_prod.dart --export-options-plist=ios/ExportOptions.plist
# → build/ios/ipa/*.ipa (à envoyer sur TestFlight avec l'app Transporter ou `fastlane ios beta`)
```

Identifiant de l’application iOS : `ga.afram.uniparent`. Les autorisations (caméra, photos, Face ID, notifications) sont déjà déclarées dans `ios/Runner/Info.plist`.

---

## 5. Publication sur les stores

| Étape | Android | iOS |
|---|---|---|
| Compte | Google Play Console (25 USD, une fois) | Apple Developer Program (99 USD/an) |
| Fichier | `UniParent-prod-*.aab` signé (§ 3.4) | IPA signé (§ 4) |
| Envoi | Play Console → Test interne, ou `fastlane android internal` | TestFlight via Transporter, ou `fastlane ios beta` |
| Automatique | pousser un tag `v1.0.0` : `.github/workflows/release.yml` construit et envoie les deux | |

Avant la mise en ligne : déployer l’API en HTTPS (`docker-compose.prod.yml`), configurer Firebase (notifications push), un compte marchand CinetPay/Stripe, et remplir les fiches « Data safety » (Google) et « App Privacy » (Apple). La checklist complète est dans le `README.md` à la racine du projet.

---

## 6. Problèmes fréquents

| Symptôme | Solution |
|---|---|
| L’app de recette affiche « Connexion impossible » | Téléphone connecté à Internet ? Service Railway démarré (`https://<domaine>/api/v1/health` doit répondre `{"status":"ok"}`) ? |
| L’app de développement affiche « Connexion impossible » | PC et téléphone sur le même Wi-Fi ? API démarrée ? Port 3000 ouvert (§ 2.2) ? IP du PC inchangée ? |
| `Kotlin… Could not close incremental caches` | Déjà corrigé (`kotlin.incremental=false` dans `android/gradle.properties`). |
| `requires core library desugaring` | Déjà corrigé dans `android/app/build.gradle.kts`. |
| Écran noir au lancement d’un APK release | R8 renommait les classes Kotlin appelées par JNI (`shared_preferences`, `path_provider`). Déjà corrigé dans `android/app/proguard-rules.pro` ; diagnostic : `adb logcat \| grep flutter`. |
| Disque C: plein pendant un build | Les caches doivent être sur E: : variables `GRADLE_USER_HOME=E:\DevTools\gradle` et `PUB_CACHE=E:\DevTools\pub-cache`. |
| `Installation bloquée` sur le téléphone | Paramètres → Sécurité → autoriser l’installation depuis la source utilisée (Fichiers, Chrome…). Désinstaller une ancienne version signée différemment. |

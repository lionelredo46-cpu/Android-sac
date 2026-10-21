# UniParent AFRAM — Obtenir et compiler les applications

Ce dossier contient les installables prêts à l’emploi et explique comment les régénérer.

```
livrables/
├── GUIDE-COMPILATION.md          ← ce fichier
├── android/
│   ├── UniParent-demo-1.0.0+1.apk   ← à installer sur un téléphone pour la démo
│   ├── UniParent-prod-1.0.0+1.apk   ← version production (serveur en ligne requis)
│   ├── UniParent-prod-1.0.0+1.aab   ← à déposer sur Google Play
│   └── SHA256SUMS.txt               ← empreintes pour vérifier les fichiers
└── ios/
    └── LISEZMOI.md                  ← l’IPA iOS se génère sur macOS (voir § 4)
```

---

## 1. Quel fichier utiliser ?

| Fichier | Pour quoi faire | Serveur utilisé |
|---|---|---|
| `UniParent-demo-*.apk` | Tester sur un vrai téléphone Android, avec les comptes de démonstration affichés sur l’écran de connexion | L’API qui tourne sur ce PC (`http://192.168.1.152:3000`) |
| `UniParent-prod-*.apk` | Installation directe de la version finale | `https://api.uniparent.aframgabon.com` (à déployer) |
| `UniParent-prod-*.aab` | Publication sur le Google Play Store | idem |
| IPA iOS | iPhone / TestFlight / App Store | voir § 4 |

> Les APK sont actuellement signés avec la clé de **debug** (aucun keystore de production n’existe encore). Ils s’installent sans problème, mais **Google Play exige une clé de production** : voir § 3.4.

---

## 2. Installer l’APK de démonstration sur un téléphone Android

### 2.1 Démarrer les serveurs sur le PC

```powershell
cd E:\ANDROID
docker compose up -d                  # PostgreSQL, Redis, stockage
cd backend
npm run build
npm run start:prod                    # API sur le port 3000
```

### 2.2 Autoriser le téléphone à joindre le PC

Le téléphone et le PC doivent être sur **le même réseau Wi-Fi**. Ouvrez le port 3000 dans le pare-feu Windows (PowerShell **en administrateur**, une seule fois) :

```powershell
New-NetFirewallRule -DisplayName "UniParent API 3000" -Direction Inbound -Protocol TCP -LocalPort 3000 -Action Allow -Profile Private
```

Vérifiez depuis le navigateur du téléphone : `http://192.168.1.152:3000/api/v1/health` doit afficher `{"status":"ok",…}`.

> Si l’adresse IP du PC a changé (commande `ipconfig`, ligne « Adresse IPv4 » de la carte Wi-Fi), régénérez l’APK de démo avec la nouvelle IP (§ 3.3).

### 2.3 Installer

1. Copiez `UniParent-demo-*.apk` sur le téléphone (câble USB, WhatsApp, Google Drive…), ou avec le câble : `adb install -r UniParent-demo-1.0.0+1.apk`.
2. Ouvrez le fichier sur le téléphone et autorisez « Installer des applications inconnues » si Android le demande.
3. Lancez **UniParent Dev**, passez l’introduction, puis touchez un compte dans **Comptes de démonstration** : la connexion est automatique.

| Compte | Ce qu’on peut tester |
|---|---|
| Parent — Jean-Marc OBIANG | 2 enfants, tranche en retard, paiement Mobile Money, reçu PDF |
| Étudiant — Alexandre OBIANG | ses notes, présences, scan du QR de présence |
| Étudiante — Grâce OBIANG | dossier incomplet, autre filière |
| Mère à activer — Clarisse OBIANG | parcours d’activation (code `AFRAM-2026-ACTIVATE`, le code SMS s’affiche à l’écran en démo) |

Mot de passe de tous les comptes : `Afram2026!`. Pour remettre les données de démonstration à zéro : `cd backend && npm run prisma:seed`.

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
bash scripts/build-livrables.sh 192.168.1.152
```

Le script génère le code, compile les 3 fichiers Android et les copie dans `livrables/android/` avec leurs empreintes SHA-256. Durée : 10 à 25 minutes selon la machine (le premier build est le plus long).

### 3.3 Commandes à l’unité

```bash
flutter pub get
dart run build_runner build          # modèles (freezed / json)
flutter gen-l10n                     # traductions FR / EN

# APK de démo pointant vers le PC (remplacer l'IP)
flutter build apk --release --flavor dev -t lib/main_dev.dart --dart-define=API_BASE_URL=http://192.168.1.152:3000

# APK et App Bundle de production (code obfusqué)
flutter build apk       --release --flavor prod -t lib/main_prod.dart --obfuscate --split-debug-info=build/symbols/prod
flutter build appbundle --release --flavor prod -t lib/main_prod.dart --obfuscate --split-debug-info=build/symbols/prod

# Lancer directement sur l'émulateur ou un téléphone branché (développement)
flutter run --flavor dev -t lib/main_dev.dart
```

Fichiers produits : `build/app/outputs/flutter-apk/` (APK) et `build/app/outputs/bundle/prodRelease/` (AAB).

| Flavor | Nom affiché | Identifiant | API |
|---|---|---|---|
| `dev` | UniParent Dev | `ga.afram.uniparent.dev` | PC local (HTTP autorisé) |
| `staging` | UniParent Recette | `ga.afram.uniparent.staging` | `https://api-staging.uniparent.aframgabon.com` |
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
| L’app de démo affiche « Connexion impossible » | PC et téléphone sur le même Wi-Fi ? API démarrée ? Port 3000 ouvert (§ 2.2) ? IP du PC inchangée ? |
| `Kotlin… Could not close incremental caches` | Déjà corrigé (`kotlin.incremental=false` dans `android/gradle.properties`). |
| `requires core library desugaring` | Déjà corrigé dans `android/app/build.gradle.kts`. |
| Disque C: plein pendant un build | Les caches doivent être sur E: : variables `GRADLE_USER_HOME=E:\DevTools\gradle` et `PUB_CACHE=E:\DevTools\pub-cache`. |
| `Installation bloquée` sur le téléphone | Paramètres → Sécurité → autoriser l’installation depuis la source utilisée (Fichiers, Chrome…). Désinstaller une ancienne version signée différemment. |

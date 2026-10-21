#!/usr/bin/env bash
# Génère les installables Android dans livrables/android.
# Usage : bash scripts/build-livrables.sh [IP_DU_PC]
#   SKIP_CODEGEN=1 bash scripts/build-livrables.sh …  pour sauter la génération de code déjà faite
#   IP_DU_PC : adresse Wi-Fi du PC qui fait tourner l'API (APK de démo). Défaut : 192.168.1.152
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
LAN_IP="${1:-192.168.1.152}"
VERSION="$(grep -E '^version:' pubspec.yaml | awk '{print $2}')"
OUT="$ROOT/livrables/android"
mkdir -p "$OUT"

flutter pub get
if [ "${SKIP_CODEGEN:-0}" != "1" ]; then
  echo "==> Génération du code (freezed, json, l10n)"
  dart run build_runner build
  flutter gen-l10n
fi

echo "==> 1/3 APK de démonstration (API http://$LAN_IP:3000, comptes de test visibles)"
flutter build apk --release --flavor dev -t lib/main_dev.dart --dart-define=API_BASE_URL="http://$LAN_IP:3000"
cp build/app/outputs/flutter-apk/app-dev-release.apk "$OUT/UniParent-demo-$VERSION.apk"

echo "==> 2/3 APK de production (API https://api.uniparent.aframgabon.com)"
flutter build apk --release --flavor prod -t lib/main_prod.dart --obfuscate --split-debug-info=build/symbols/prod
cp build/app/outputs/flutter-apk/app-prod-release.apk "$OUT/UniParent-prod-$VERSION.apk"

echo "==> 3/3 App Bundle de production (Google Play)"
flutter build appbundle --release --flavor prod -t lib/main_prod.dart --obfuscate --split-debug-info=build/symbols/prod
cp build/app/outputs/bundle/prodRelease/app-prod-release.aab "$OUT/UniParent-prod-$VERSION.aab"

(cd "$OUT" && sha256sum *.apk *.aab > SHA256SUMS.txt)
echo "==> Terminé :"
ls -lh "$OUT"

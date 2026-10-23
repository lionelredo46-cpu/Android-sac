#!/usr/bin/env bash
# Génère les installables Android dans livrables/android.
# Usage : bash scripts/build-livrables.sh
#   SKIP_CODEGEN=1 bash scripts/build-livrables.sh   pour sauter la génération de code déjà faite
#   API_BASE_URL=https://… bash scripts/build-livrables.sh   pour viser une autre API de recette
#
# L'application ne contient que l'interface : toutes les données viennent de l'API
# (Railway en recette). Un APK par architecture (--split-per-abi) : bien plus léger
# qu'un APK universel. arm64-v8a convient à presque tous les téléphones récents.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
VERSION="$(grep -E '^version:' pubspec.yaml | awk '{print $2}')"
OUT="$ROOT/livrables/android"
mkdir -p "$OUT"
DEFINES=()
if [ -n "${API_BASE_URL:-}" ]; then DEFINES+=("--dart-define=API_BASE_URL=$API_BASE_URL"); fi

flutter pub get
if [ "${SKIP_CODEGEN:-0}" != "1" ]; then
  echo "==> Génération du code (freezed, json, l10n)"
  dart run build_runner build
  flutter gen-l10n
fi

echo "==> 1/3 APK de recette (API Railway, comptes de démonstration visibles)"
flutter build apk --release --flavor staging -t lib/main_staging.dart --split-per-abi --target-platform android-arm64,android-arm --obfuscate --split-debug-info=build/symbols/staging "${DEFINES[@]}"
for abi in arm64-v8a armeabi-v7a; do
  cp "build/app/outputs/flutter-apk/app-$abi-staging-release.apk" "$OUT/UniParent-recette-$VERSION-$abi.apk"
done

echo "==> 2/3 APK de production (API https://api.uniparent.aframgabon.com)"
flutter build apk --release --flavor prod -t lib/main_prod.dart --split-per-abi --target-platform android-arm64,android-arm --obfuscate --split-debug-info=build/symbols/prod
for abi in arm64-v8a armeabi-v7a; do
  cp "build/app/outputs/flutter-apk/app-$abi-prod-release.apk" "$OUT/UniParent-prod-$VERSION-$abi.apk"
done

echo "==> 3/3 App Bundle de production (Google Play)"
flutter build appbundle --release --flavor prod -t lib/main_prod.dart --obfuscate --split-debug-info=build/symbols/prod
cp build/app/outputs/bundle/prodRelease/app-prod-release.aab "$OUT/UniParent-prod-$VERSION.aab"

(cd "$OUT" && sha256sum *.apk *.aab > SHA256SUMS.txt)
echo "==> Terminé :"
ls -lh "$OUT"

# Installable iOS

L'IPA iOS ne peut pas être compilé sous Windows : Apple impose macOS et Xcode.

Pour l'obtenir, suivez le § 4 de `../GUIDE-COMPILATION.md` :

- **sans Mac** : workflow GitHub Actions « Build iOS (IPA) », puis téléchargez l'artefact `uniparent-ios` et déposez l'IPA dans ce dossier ;
- **avec un Mac** : `flutter build ipa --release -t lib/main_prod.dart --export-options-plist=ios/ExportOptions.plist`.

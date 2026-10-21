// Embarque dans l'application les polices Google Fonts (Inter, Outfit) qu'elle télécharge
// sinon au premier lancement : indispensable pour la démo autonome, utilisable hors ligne.
// Les fichiers, empreintes SHA-256 et tailles sont ceux référencés par le package google_fonts.
// Usage : node scripts/bundle-fonts.mjs   (après flutter pub get)
import { createHash } from 'crypto';
import { mkdirSync, readFileSync, readdirSync, writeFileSync } from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const FAMILIES = { inter: 'Inter', outfit: 'Outfit' };
const WEIGHTS = { w400: 'Regular', w500: 'Medium', w600: 'SemiBold', w700: 'Bold', w800: 'ExtraBold' };
const OUT = path.join(ROOT, 'assets', 'google_fonts');

const config = JSON.parse(readFileSync(path.join(ROOT, '.dart_tool', 'package_config.json'), 'utf8'));
const pkg = config.packages.find((p) => p.name === 'google_fonts');
const partsDir = path.join(fileURLToPath(pkg.rootUri), 'lib', 'src', 'google_fonts_parts');
const sources = readdirSync(partsDir).map((f) => readFileSync(path.join(partsDir, f), 'utf8')).join('\n');

mkdirSync(OUT, { recursive: true });
for (const [method, family] of Object.entries(FAMILIES)) {
  const start = sources.indexOf(`static TextStyle ${method}(`);
  const block = sources.slice(start, sources.indexOf('return googleFontsTextStyle(', start));
  const entry = /fontWeight: FontWeight\.(w\d00),\s*fontStyle: FontStyle\.normal,\s*\): GoogleFontsFile\(\s*'([0-9a-f]{64})',\s*(\d+),/g;
  for (const [, weight, hash, length] of block.matchAll(entry)) {
    if (!WEIGHTS[weight]) continue;
    const bytes = Buffer.from(await (await fetch(`https://fonts.gstatic.com/s/a/${hash}.ttf`)).arrayBuffer());
    if (bytes.length !== Number(length) || createHash('sha256').update(bytes).digest('hex') !== hash) {
      throw new Error(`${family} ${weight} : fichier téléchargé non conforme`);
    }
    writeFileSync(path.join(OUT, `${family}-${WEIGHTS[weight]}.ttf`), bytes);
    console.log(`${family}-${WEIGHTS[weight]}.ttf (${(bytes.length / 1024).toFixed(0)} Ko)`);
  }
  const license = await fetch(`https://raw.githubusercontent.com/google/fonts/main/ofl/${method}/OFL.txt`);
  if (license.ok) writeFileSync(path.join(OUT, `${family}-OFL.txt`), await license.text());
}

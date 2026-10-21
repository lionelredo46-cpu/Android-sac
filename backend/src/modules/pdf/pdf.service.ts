import { Global, Injectable, Module } from '@nestjs/common';
import { existsSync } from 'fs';
import * as path from 'path';
import PDFDocument = require('pdfkit');
import * as QRCode from 'qrcode';

export const BRAND = {
  primary: '#0B3D91',
  gold: '#C9A227',
  text: '#1F2937',
  muted: '#6B7280',
  institution: 'Académie Franco-Américaine de Management (AFRAM)',
  address: 'Rue André MINTSA – Batterie IV, Libreville, Gabon',
  contact: 'Tél. +241 066 70 11 84 · aframilesmail@aframgabon.com',
};

const LOGO = path.resolve(process.cwd(), 'assets/logo.png');

export type Pdf = PDFKit.PDFDocument;

/** Utilitaires communs aux documents officiels (reçus, bulletins, attestations). */
@Injectable()
export class PdfService {
  render(build: (doc: Pdf) => Promise<void> | void, title: string): Promise<Buffer> {
    return new Promise(async (resolve, reject) => {
      const doc = new PDFDocument({ size: 'A4', margin: 50, info: { Title: title, Author: 'UniParent AFRAM' } });
      const chunks: Buffer[] = [];
      doc.on('data', (c: Buffer) => chunks.push(c));
      doc.on('end', () => resolve(Buffer.concat(chunks)));
      doc.on('error', reject);
      try {
        this.header(doc, title);
        await build(doc);
        this.footer(doc);
        doc.end();
      } catch (e) {
        reject(e);
      }
    });
  }

  private header(doc: Pdf, title: string) {
    if (existsSync(LOGO)) doc.image(LOGO, 50, 40, { width: 60 });
    doc.fillColor(BRAND.primary).font('Helvetica-Bold').fontSize(13).text(BRAND.institution, 120, 45, { width: 420 });
    doc.fillColor(BRAND.muted).font('Helvetica').fontSize(8.5).text(BRAND.address, 120, 63).text(BRAND.contact, 120, 75);
    doc.moveTo(50, 110).lineTo(545, 110).strokeColor(BRAND.gold).lineWidth(2).stroke();
    doc.fillColor(BRAND.text).font('Helvetica-Bold').fontSize(16).text(title.toUpperCase(), 50, 128, { align: 'center', width: 495 });
    doc.moveDown(1.5);
  }

  private footer(doc: Pdf) {
    doc
      .fillColor(BRAND.muted)
      .font('Helvetica')
      .fontSize(7.5)
      .text(
        `Document généré électroniquement par UniParent AFRAM le ${new Date().toLocaleString('fr-FR', { timeZone: 'Africa/Libreville' })}. Toute altération le rend invalide.`,
        50,
        780,
        { width: 495, align: 'center' },
      );
  }

  /** Ligne « libellé : valeur » alignée. */
  row(doc: Pdf, label: string, value: string, y?: number) {
    const top = y ?? doc.y;
    doc.font('Helvetica').fontSize(10).fillColor(BRAND.muted).text(label, 50, top, { width: 180 });
    doc.font('Helvetica-Bold').fillColor(BRAND.text).text(value, 230, top, { width: 315 });
    doc.moveDown(0.4);
  }

  async qr(doc: Pdf, payload: string, x: number, y: number, size = 110) {
    const png = await QRCode.toBuffer(payload, { errorCorrectionLevel: 'M', margin: 1, width: size * 2 });
    doc.image(png, x, y, { width: size });
  }

  /** Tableau simple (en-têtes + lignes), avec saut de page automatique. */
  table(doc: Pdf, headers: string[], rows: string[][], widths: number[]) {
    const x0 = 50;
    let y = doc.y + 4;
    const drawRow = (cells: string[], bold: boolean, fill?: string) => {
      const height = 20;
      if (y + height > 760) {
        doc.addPage();
        y = 60;
      }
      if (fill) doc.rect(x0, y, widths.reduce((a, b) => a + b, 0), height).fill(fill);
      let x = x0;
      cells.forEach((c, i) => {
        doc
          .fillColor(bold ? '#FFFFFF' : BRAND.text)
          .font(bold ? 'Helvetica-Bold' : 'Helvetica')
          .fontSize(9)
          .text(c, x + 4, y + 6, { width: widths[i] - 8, ellipsis: true, lineBreak: false });
        x += widths[i];
      });
      y += height;
    };
    drawRow(headers, true, BRAND.primary);
    rows.forEach((r, i) => drawRow(r, false, i % 2 ? '#F3F4F6' : undefined));
    doc.y = y + 8;
    doc.x = x0;
  }
}

@Global()
@Module({ providers: [PdfService], exports: [PdfService] })
export class PdfModule {}

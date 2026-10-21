import { Injectable, NotFoundException } from '@nestjs/common';
import { PaymentStatus } from '@prisma/client';
import { timingSafeEqual } from 'crypto';
import { AuthUser, ChildAccessService } from '../../common/access/child-access.service';
import { formatXaf } from '../../common/utils/http';
import { env } from '../../config/env';
import { PrismaService } from '../../prisma/prisma.service';
import { BRAND, PdfService } from '../pdf/pdf.service';
import { receiptToken } from './payments.service';

const CANAL_LABEL: Record<string, string> = {
  ONLINE_MOBILE_MONEY: 'Mobile Money (en ligne)',
  ONLINE_CARD: 'Carte bancaire (en ligne)',
  GUICHET_ESPECES: 'Espèces (guichet)',
  GUICHET_CHEQUE: 'Chèque (guichet)',
  GUICHET_VIREMENT: 'Virement bancaire',
};

const fmtDate = (d: Date) => d.toLocaleString('fr-FR', { timeZone: 'Africa/Libreville', dateStyle: 'long', timeStyle: 'short' });

@Injectable()
export class ReceiptsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly access: ChildAccessService,
    private readonly pdf: PdfService,
  ) {}

  private load(receiptId: string) {
    return this.prisma.receipt.findUnique({
      where: { id: receiptId },
      include: {
        payment: {
          include: {
            invoice: { include: { student: { include: { group: { include: { program: true } } } }, academicYear: true } },
            payeParUser: { select: { parentProfile: true, studentProfile: true } },
          },
        },
      },
    });
  }

  async pdfFor(user: AuthUser, receiptId: string): Promise<{ filename: string; buffer: Buffer }> {
    const r = await this.load(receiptId);
    if (!r) throw new NotFoundException('Reçu introuvable');
    await this.access.assertCanAccess(user, r.payment.invoice.studentId);

    const p = r.payment;
    const s = p.invoice.student;
    const payer = p.payeParUser?.parentProfile ?? p.payeParUser?.studentProfile;
    const meta = (p.metadata ?? {}) as Record<string, string | null>;
    const verifyUrl = `${env.publicUrl}/api/v1/receipts/verify/${r.qrTokenVerification}`;

    const buffer = await this.pdf.render(async (doc) => {
      doc.font('Helvetica-Bold').fontSize(12).fillColor(BRAND.primary).text(`Reçu n° ${r.numeroRecu}`, { align: 'center' });
      doc.moveDown(1);
      this.pdf.row(doc, 'Date du versement', fmtDate(p.createdAt));
      this.pdf.row(doc, 'Étudiant', `${s.prenom} ${s.nom} — ${s.matricule}`);
      this.pdf.row(doc, 'Filière / groupe', `${s.group.program.nom} — ${s.group.nom}`);
      this.pdf.row(doc, 'Année académique', p.invoice.academicYear.libelle);
      this.pdf.row(doc, 'Facture', p.invoice.numeroFacture);
      this.pdf.row(doc, 'Mode de paiement', CANAL_LABEL[p.canal] ?? p.canal);
      this.pdf.row(doc, 'Référence transaction', p.referenceExterne ?? p.reference);
      this.pdf.row(doc, 'Versé par', payer ? `${payer.prenom} ${payer.nom} (${p.payeurType.toLowerCase()})` : `${meta.payeurNom ?? 'Guichet'} (${p.payeurType.toLowerCase()})`);
      doc.moveDown(0.8);
      const boxY = doc.y;
      doc.roundedRect(50, boxY, 495, 48, 6).fill('#EEF2FF');
      doc.fillColor(BRAND.primary).font('Helvetica-Bold').fontSize(18).text(`Montant reçu : ${formatXaf(p.montant)}`, 50, boxY + 15, { width: 495, align: 'center' });
      doc.x = 50;
      doc.y = boxY + 64;
      this.pdf.row(doc, 'Reste à payer sur la facture', formatXaf(p.invoice.soldeRestant));
      this.pdf.row(doc, 'Statut', p.statut === PaymentStatus.VALIDE ? 'Paiement validé' : p.statut);
      const qrY = doc.y + 20;
      await this.pdf.qr(doc, verifyUrl, 50, qrY, 110);
      doc.font('Helvetica').fontSize(9).fillColor(BRAND.muted).text(
        'Scannez ce QR code pour vérifier l’authenticité de ce reçu auprès de l’AFRAM. Ce reçu numérique est signé électroniquement et ne nécessite pas de cachet manuscrit.',
        175, qrY + 20, { width: 370 },
      );
      doc.font('Helvetica-Bold').fontSize(10).fillColor(BRAND.primary).text('Cachet numérique — Service Comptabilité AFRAM', 175, qrY + 75, { width: 370 });
    }, 'Reçu de paiement');
    return { filename: `${r.numeroRecu}.pdf`, buffer };
  }

  /** Vérification publique (QR) : ne révèle que le minimum. */
  async verify(token: string) {
    const r = await this.prisma.receipt.findUnique({
      where: { qrTokenVerification: token },
      include: { payment: { include: { invoice: { include: { student: { select: { prenom: true, nom: true, matricule: true } } } } } } },
    });
    const expected = r ? receiptToken(r.id) : '';
    const valid = !!r && expected.length === token.length && timingSafeEqual(Buffer.from(expected), Buffer.from(token));
    if (!valid || !r) return { valide: false, message: 'Reçu inconnu ou falsifié' };
    const s = r.payment.invoice.student;
    return {
      valide: r.payment.statut === PaymentStatus.VALIDE,
      numeroRecu: r.numeroRecu,
      date: r.payment.createdAt,
      montant: r.payment.montant,
      devise: r.payment.devise,
      etudiant: `${s.prenom} ${s.nom.charAt(0)}.`,
      matricule: s.matricule,
      statut: r.payment.statut,
    };
  }

  /** Attestation de paiement (employeur, ambassade, assurance). */
  async paymentCertificate(user: AuthUser, studentId: string, academicYearId?: string) {
    await this.access.assertCanAccess(user, studentId);
    const student = await this.prisma.student.findUniqueOrThrow({ where: { id: studentId }, include: { group: { include: { program: true } } } });
    const invoices = await this.prisma.invoice.findMany({
      where: { studentId, statut: { not: 'ANNULE' }, ...(academicYearId ? { academicYearId } : {}) },
      include: { academicYear: true, payments: { where: { statut: PaymentStatus.VALIDE }, orderBy: { createdAt: 'asc' } } },
    });
    const total = invoices.reduce((s, i) => s + i.montantTotal, 0n);
    const paye = invoices.reduce((s, i) => s + i.montantPaye, 0n);

    const buffer = await this.pdf.render((doc) => {
      doc.font('Helvetica').fontSize(11).fillColor(BRAND.text).text(
        `Le Service Comptabilité de l’AFRAM atteste que l’étudiant(e) ${student.prenom} ${student.nom}, matricule ${student.matricule}, inscrit(e) en ${student.group.program.nom} (${student.group.nom}), a effectué les versements suivants :`,
        { align: 'justify' },
      );
      doc.moveDown(1);
      const rows = invoices.flatMap((i) =>
        i.payments.map((p) => [fmtDate(p.createdAt), i.academicYear.libelle, i.numeroFacture, CANAL_LABEL[p.canal] ?? p.canal, formatXaf(p.montant)]),
      );
      this.pdf.table(doc, ['Date', 'Année', 'Facture', 'Mode', 'Montant'], rows.length ? rows : [['—', '—', '—', '—', '—']], [110, 70, 110, 110, 95]);
      doc.moveDown(0.5);
      this.pdf.row(doc, 'Total facturé', formatXaf(total));
      this.pdf.row(doc, 'Total versé', formatXaf(paye));
      this.pdf.row(doc, 'Reste à payer', formatXaf(total - paye));
      doc.moveDown(1.5);
      doc.font('Helvetica-Oblique').fontSize(10).text('Attestation délivrée pour servir et valoir ce que de droit.', { align: 'right' });
    }, 'Attestation de paiement');
    return { filename: `attestation-paiement-${student.matricule}.pdf`, buffer };
  }
}

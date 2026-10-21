import { BadRequestException, ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import {
  DisciplineRecordType,
  DocumentRequestStatus,
  DocumentRequestType,
  NotificationCategory,
  Prisma,
  StudentStatus,
  UserRole,
} from '@prisma/client';
import { createHash } from 'crypto';
import { AuthUser, ChildAccessService } from '../../common/access/child-access.service';
import { AuditContext, AuditService } from '../../common/audit/audit.service';
import { StorageService } from '../../common/storage/storage.service';
import { PrismaService } from '../../prisma/prisma.service';
import { ChildrenService } from '../children/children.service';
import { NotificationsService } from '../notifications/notifications.service';
import { BRAND, PdfService } from '../pdf/pdf.service';

const REQUEST_LABEL: Record<DocumentRequestType, string> = {
  ATTESTATION_INSCRIPTION: "Attestation d'inscription",
  CERTIFICAT_SCOLARITE: 'Certificat de scolarité',
  RELEVE_NOTES_OFFICIEL: 'Relevé de notes officiel',
  DUPLICATA_CARTE: "Duplicata de carte d'étudiant",
  CHANGEMENT_FILIERE: 'Changement de filière',
  CONGE_ACADEMIQUE: 'Congé académique',
};

/** Démarches dont le document est généré automatiquement quand la scolarité les marque « prêtes ». */
const AUTO_GENERATED: DocumentRequestType[] = [DocumentRequestType.ATTESTATION_INSCRIPTION, DocumentRequestType.CERTIFICAT_SCOLARITE];

const DISCIPLINE_LABEL: Record<DisciplineRecordType, string> = {
  AVERTISSEMENT: 'Avertissement',
  BLAME: 'Blâme',
  EXCLUSION_TEMPORAIRE: 'Exclusion temporaire',
  CONVOCATION_PARENT: 'Convocation des parents',
  FELICITATION: 'Félicitations',
  ENCOURAGEMENT: 'Encouragements',
};

@Injectable()
export class DocumentsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly access: ChildAccessService,
    private readonly children: ChildrenService,
    private readonly audit: AuditService,
    private readonly notifications: NotificationsService,
    private readonly storage: StorageService,
    private readonly pdf: PdfService,
  ) {}

  // ------------------------------------------------------------------ Coffre-fort
  async vault(user: AuthUser, studentId: string) {
    await this.access.assertCanAccess(user, studentId);
    const docs = await this.prisma.documentVault.findMany({ where: { studentId }, orderBy: { createdAt: 'desc' } });
    return docs.map((d) => ({
      ...d,
      fichierUrl: undefined,
      aSigner: d.categorie === 'REGLEMENT' && !d.estSigne,
      validation: (d.signatureMetadata as Record<string, unknown> | null)?.validation ?? null,
    }));
  }

  async download(user: AuthUser, documentId: string) {
    const doc = await this.prisma.documentVault.findUnique({ where: { id: documentId } });
    if (!doc) throw new NotFoundException('Document introuvable');
    await this.access.assertCanAccess(user, doc.studentId);
    return { filename: `${doc.titre}.pdf`.replace(/[^\w\-. ]/g, '_'), key: doc.fichierUrl, buffer: await this.storage.get(doc.fichierUrl) };
  }

  /** Signature électronique simple : identité, horodatage, IP et empreinte du document signé. */
  async sign(user: AuthUser, documentId: string, ctx: AuditContext) {
    const doc = await this.prisma.documentVault.findUnique({ where: { id: documentId } });
    if (!doc) throw new NotFoundException('Document introuvable');
    await this.access.assertCanAccess(user, doc.studentId);
    if (user.role !== UserRole.PARENT && user.role !== UserRole.ETUDIANT) throw new ForbiddenException();
    if (doc.estSigne) throw new BadRequestException('Document déjà signé');
    const file = await this.storage.get(doc.fichierUrl);
    const profile = await this.prisma.user.findUniqueOrThrow({ where: { id: user.id }, include: { parentProfile: true, studentProfile: true } });
    const p = profile.parentProfile ?? profile.studentProfile;
    const signature = {
      signePar: p ? `${p.prenom} ${p.nom}` : user.email,
      userId: user.id,
      role: user.role,
      le: new Date().toISOString(),
      ip: ctx.ip,
      sha256: createHash('sha256').update(file).digest('hex'),
    };
    const updated = await this.prisma.documentVault.update({ where: { id: documentId }, data: { estSigne: true, signatureMetadata: signature } });
    await this.audit.log(ctx, 'DOCUMENT_SIGNED', 'DocumentVault', documentId, null, signature);
    return updated;
  }

  /** Téléversement d'une pièce manquante (identité, photo, diplôme), validée par la scolarité. */
  async upload(user: AuthUser, studentId: string, dto: { titre: string; categorie: string }, file: Express.Multer.File | undefined, ctx: AuditContext) {
    await this.access.assertCanAccess(user, studentId);
    this.storage.validateUpload(file);
    const stored = await this.storage.put(`dossiers/${studentId}`, file!.buffer, file!.mimetype);
    const doc = await this.prisma.documentVault.create({
      data: {
        studentId,
        titre: dto.titre,
        categorie: dto.categorie,
        fichierUrl: stored.key,
        signatureMetadata: { validation: 'EN_ATTENTE', deposePar: user.id, sha256: stored.sha256 },
      },
    });
    await this.audit.log(ctx, 'DOCUMENT_UPLOADED', 'DocumentVault', doc.id, null, { titre: dto.titre, categorie: dto.categorie, sha256: stored.sha256 });
    const scolarite = await this.prisma.user.findMany({ where: { role: UserRole.SCOLARITE, status: 'ACTIVE' }, select: { id: true } });
    await this.notifications.notify(scolarite.map((u) => u.id), {
      categorie: NotificationCategory.MESSAGERIE,
      titre: 'Pièce de dossier déposée',
      corps: `${dto.titre} — à valider`,
      data: { type: 'DOCUMENT_UPLOADED', documentId: doc.id },
    });
    return doc;
  }

  async validateUpload(user: AuthUser, documentId: string, accepte: boolean, commentaire: string | undefined, ctx: AuditContext) {
    const doc = await this.prisma.documentVault.findUnique({ where: { id: documentId } });
    if (!doc) throw new NotFoundException('Document introuvable');
    const meta = { ...((doc.signatureMetadata as object) ?? {}), validation: accepte ? 'VALIDE' : 'REJETE', commentaire, validePar: user.id, valideLe: new Date().toISOString() };
    const updated = await this.prisma.documentVault.update({ where: { id: documentId }, data: { signatureMetadata: meta as Prisma.InputJsonValue } });
    await this.audit.log(ctx, 'DOCUMENT_REVIEWED', 'DocumentVault', documentId, null, meta);
    await this.notifications.notify(await this.access.stakeholderUserIds(doc.studentId), {
      categorie: NotificationCategory.MESSAGERIE,
      titre: accepte ? 'Pièce validée' : 'Pièce refusée',
      corps: `${doc.titre}${commentaire ? ` — ${commentaire}` : ''}`,
      data: { type: 'DOCUMENT_REVIEWED', documentId, studentId: doc.studentId },
    });
    return updated;
  }

  // ------------------------------------------------------------------ Démarches
  async requests(user: AuthUser, studentId: string) {
    await this.access.assertCanAccess(user, studentId);
    const rows = await this.prisma.documentRequest.findMany({ where: { studentId }, orderBy: { createdAt: 'desc' } });
    return rows.map((r) => ({ ...r, libelle: REQUEST_LABEL[r.type], documentDisponible: !!r.documentGenereUrl }));
  }

  async request(user: AuthUser, id: string) {
    const r = await this.prisma.documentRequest.findUnique({ where: { id } });
    if (!r) throw new NotFoundException('Demande introuvable');
    await this.access.assertCanAccess(user, r.studentId);
    return { ...r, libelle: REQUEST_LABEL[r.type], documentDisponible: !!r.documentGenereUrl };
  }

  async createRequest(user: AuthUser, dto: { studentId: string; type: DocumentRequestType; motif?: string }, ctx: AuditContext) {
    await this.access.assertCanAccess(user, dto.studentId);
    const pending = await this.prisma.documentRequest.findFirst({
      where: { studentId: dto.studentId, type: dto.type, statut: { in: [DocumentRequestStatus.SOUMISE, DocumentRequestStatus.EN_TRAITEMENT] } },
    });
    if (pending) throw new BadRequestException('Une demande identique est déjà en cours');
    const r = await this.prisma.documentRequest.create({ data: dto });
    await this.audit.log(ctx, 'DOCUMENT_REQUESTED', 'DocumentRequest', r.id, null, dto);
    const scolarite = await this.prisma.user.findMany({ where: { role: UserRole.SCOLARITE, status: 'ACTIVE' }, select: { id: true } });
    await this.notifications.notify(scolarite.map((u) => u.id), {
      categorie: NotificationCategory.MESSAGERIE,
      titre: 'Nouvelle demande de document',
      corps: REQUEST_LABEL[dto.type],
      data: { type: 'DOCUMENT_REQUEST', requestId: r.id },
    });
    return r;
  }

  async requestDocument(user: AuthUser, id: string) {
    const r = await this.prisma.documentRequest.findUnique({ where: { id } });
    if (!r?.documentGenereUrl) throw new NotFoundException('Document non disponible');
    await this.access.assertCanAccess(user, r.studentId);
    return { filename: `${REQUEST_LABEL[r.type]}.pdf`, buffer: await this.storage.get(r.documentGenereUrl) };
  }

  adminRequests(statut?: DocumentRequestStatus) {
    return this.prisma.documentRequest.findMany({
      where: statut ? { statut } : { statut: { in: [DocumentRequestStatus.SOUMISE, DocumentRequestStatus.EN_TRAITEMENT] } },
      orderBy: { createdAt: 'asc' },
      include: { student: { select: { matricule: true, nom: true, prenom: true, group: { select: { nom: true } } } } },
    });
  }

  async processRequest(user: AuthUser, id: string, statut: DocumentRequestStatus, ctx: AuditContext) {
    const r = await this.prisma.documentRequest.findUnique({ where: { id } });
    if (!r) throw new NotFoundException('Demande introuvable');
    let documentGenereUrl = r.documentGenereUrl;
    if (statut === DocumentRequestStatus.PRETE && !documentGenereUrl && AUTO_GENERATED.includes(r.type)) {
      const pdf = await this.certificatePdf(r.studentId, r.type);
      documentGenereUrl = (await this.storage.put(`attestations/${r.studentId}`, pdf, 'application/pdf')).key;
    }
    const updated = await this.prisma.documentRequest.update({ where: { id }, data: { statut, traiteParId: user.id, documentGenereUrl } });
    await this.audit.log(ctx, 'DOCUMENT_REQUEST_UPDATED', 'DocumentRequest', id, { statut: r.statut }, { statut });
    await this.notifications.notify(await this.access.stakeholderUserIds(r.studentId), {
      categorie: NotificationCategory.MESSAGERIE,
      titre: statut === DocumentRequestStatus.PRETE ? 'Document prêt' : 'Suivi de votre demande',
      corps: `${REQUEST_LABEL[r.type]} : ${statut.replace('_', ' ').toLowerCase()}`,
      data: { type: 'DOCUMENT_REQUEST', requestId: id, studentId: r.studentId },
    });
    return updated;
  }

  async enrollmentCertificate(user: AuthUser, studentId: string) {
    await this.access.assertCanAccess(user, studentId);
    const s = await this.prisma.student.findUniqueOrThrow({ where: { id: studentId } });
    if (s.statut !== StudentStatus.INSCRIT && s.statut !== StudentStatus.EN_ATTENTE_DOCUMENTS) {
      throw new BadRequestException("L'étudiant n'est pas inscrit pour l'année en cours");
    }
    return { filename: `attestation-inscription-${s.matricule}.pdf`, buffer: await this.certificatePdf(studentId, DocumentRequestType.ATTESTATION_INSCRIPTION) };
  }

  private async certificatePdf(studentId: string, type: DocumentRequestType) {
    const s = await this.prisma.student.findUniqueOrThrow({ where: { id: studentId }, include: { group: { include: { program: true } } } });
    const year = await this.children.currentAcademicYear();
    return this.pdf.render((doc) => {
      doc.moveDown(1);
      doc.font('Helvetica').fontSize(11.5).fillColor(BRAND.text).text(
        `Le Directeur des études de l'Académie Franco-Américaine de Management (AFRAM) certifie que ${s.prenom} ${s.nom.toUpperCase()}, né(e) le ${s.dateNaissance.toLocaleDateString('fr-FR')}, matricule ${s.matricule}, est régulièrement ${type === DocumentRequestType.CERTIFICAT_SCOLARITE ? 'scolarisé(e)' : 'inscrit(e)'} au titre de l'année académique ${year?.libelle ?? ''} en ${s.group.program.nom} (${s.group.program.niveau.toLowerCase()}), groupe ${s.group.nom}.`,
        { align: 'justify', lineGap: 4 },
      );
      doc.moveDown(1.5);
      doc.text('En foi de quoi, la présente attestation lui est délivrée pour servir et valoir ce que de droit.', { align: 'justify' });
      doc.moveDown(2);
      doc.font('Helvetica-Bold').text(`Fait à Libreville, le ${new Date().toLocaleDateString('fr-FR', { dateStyle: 'long' })}`, { align: 'right' });
      doc.moveDown(0.5).text('La Direction des études', { align: 'right' });
    }, REQUEST_LABEL[type]);
  }

  // ------------------------------------------------------------------ Discipline (module 10)
  async discipline(user: AuthUser, studentId: string) {
    await this.access.assertCanAccess(user, studentId);
    const rows = await this.prisma.disciplineRecord.findMany({ where: { studentId }, orderBy: { dateIncident: 'desc' } });
    return rows.map((r) => ({
      ...r,
      libelle: DISCIPLINE_LABEL[r.type],
      positif: r.type === DisciplineRecordType.FELICITATION || r.type === DisciplineRecordType.ENCOURAGEMENT,
      accuseRequis: r.type === DisciplineRecordType.CONVOCATION_PARENT && !r.accuseReception,
    }));
  }

  async acknowledge(user: AuthUser, recordId: string, ctx: AuditContext) {
    const r = await this.prisma.disciplineRecord.findUnique({ where: { id: recordId } });
    if (!r) throw new NotFoundException('Élément introuvable');
    await this.access.assertCanAccess(user, r.studentId);
    if (user.role !== UserRole.PARENT) throw new ForbiddenException('Seul un parent peut accuser réception');
    if (r.accuseReception) return r;
    const updated = await this.prisma.disciplineRecord.update({ where: { id: recordId }, data: { accuseReception: true, accuseReceptionLe: new Date() } });
    await this.audit.log(ctx, 'CONVOCATION_ACKNOWLEDGED', 'DisciplineRecord', recordId, null, { par: user.id });
    return updated;
  }

  async createDiscipline(
    user: AuthUser,
    dto: { studentId: string; type: DisciplineRecordType; motif: string; sanction?: string; dateIncident: string; convocationDate?: string },
    ctx: AuditContext,
  ) {
    const s = await this.prisma.student.findUnique({ where: { id: dto.studentId } });
    if (!s) throw new NotFoundException('Étudiant introuvable');
    if (dto.type === DisciplineRecordType.CONVOCATION_PARENT && !dto.convocationDate) throw new BadRequestException('Date de convocation requise');
    const r = await this.prisma.disciplineRecord.create({
      data: { ...dto, dateIncident: new Date(dto.dateIncident), convocationDate: dto.convocationDate ? new Date(dto.convocationDate) : null, enregistreParId: user.id },
    });
    await this.audit.log(ctx, 'DISCIPLINE_RECORDED', 'DisciplineRecord', r.id, null, dto);
    const convocation = dto.type === DisciplineRecordType.CONVOCATION_PARENT;
    await this.notifications.notify(await this.access.stakeholderUserIds(dto.studentId), {
      categorie: NotificationCategory.DISCIPLINE,
      titre: convocation ? 'Convocation des parents' : DISCIPLINE_LABEL[dto.type],
      corps: `${s.prenom} ${s.nom} : ${dto.motif}${convocation ? ` — le ${new Date(dto.convocationDate!).toLocaleString('fr-FR', { timeZone: 'Africa/Libreville' })}. Merci d’accuser réception.` : ''}`,
      data: { type: 'DISCIPLINE', recordId: r.id, studentId: dto.studentId },
      forceSms: convocation,
    });
    return r;
  }
}

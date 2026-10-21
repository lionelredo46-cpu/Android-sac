import { BadRequestException, Global, Injectable, Logger, Module, NotFoundException } from '@nestjs/common';
import { createHash, randomUUID } from 'crypto';
import { promises as fs } from 'fs';
import * as path from 'path';
import { env } from '../../config/env';

/** Taille maximale d'un fichier téléversé (identique à la limite de l'application mobile). */
export const MAX_UPLOAD_BYTES = 8 * 1024 * 1024;

/** Types acceptés : extension stockée et signature binaire (magic bytes) attendue. */
const ALLOWED: Record<string, { ext: string; magic: (b: Buffer) => boolean }> = {
  'application/pdf': { ext: 'pdf', magic: (b) => b.subarray(0, 4).toString('latin1') === '%PDF' },
  'image/jpeg': { ext: 'jpg', magic: (b) => b[0] === 0xff && b[1] === 0xd8 && b[2] === 0xff },
  'image/png': { ext: 'png', magic: (b) => b.subarray(0, 8).equals(Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a])) },
  'image/webp': { ext: 'webp', magic: (b) => b.subarray(0, 4).toString('latin1') === 'RIFF' && b.subarray(8, 12).toString('latin1') === 'WEBP' },
};

export interface StoredFile {
  key: string;
  sha256: string;
  size: number;
}

/**
 * Stockage des pièces jointes (justificatifs, documents, messagerie, attestations).
 * Pilote local : fichiers sous STORAGE_LOCAL_DIR, clés relatives et non devinables.
 */
@Injectable()
export class StorageService {
  private readonly logger = new Logger('Storage');
  private readonly root = path.resolve(env.storage.localDir);

  constructor() {
    if (env.storage.driver !== 'local') {
      throw new Error(`[Config] STORAGE_DRIVER=${env.storage.driver} non pris en charge (seul "local" est disponible).`);
    }
  }

  /** Refuse un fichier absent, trop lourd, d'un type non autorisé ou dont le contenu ne correspond pas au type annoncé. */
  validateUpload(file: Express.Multer.File | undefined): asserts file is Express.Multer.File {
    if (!file?.buffer?.length) throw new BadRequestException('Fichier manquant');
    if (file.size > MAX_UPLOAD_BYTES) throw new BadRequestException('Fichier trop volumineux (8 Mo maximum)');
    const type = ALLOWED[file.mimetype];
    if (!type) throw new BadRequestException('Format non autorisé (PDF, JPG, PNG ou WebP)');
    if (!type.magic(file.buffer)) throw new BadRequestException('Le contenu du fichier ne correspond pas à son type');
  }

  async put(prefix: string, buffer: Buffer, mimetype: string): Promise<StoredFile> {
    const ext = ALLOWED[mimetype]?.ext ?? 'bin';
    const key = `${prefix}/${randomUUID()}.${ext}`;
    const full = this.resolve(key);
    await fs.mkdir(path.dirname(full), { recursive: true });
    await fs.writeFile(full, buffer);
    const sha256 = createHash('sha256').update(buffer).digest('hex');
    this.logger.log(`+ ${key} (${buffer.length} o)`);
    return { key, sha256, size: buffer.length };
  }

  async get(key: string): Promise<Buffer> {
    try {
      return await fs.readFile(this.resolve(key));
    } catch {
      throw new NotFoundException('Fichier introuvable');
    }
  }

  /** Chemin absolu d'une clé, sans possibilité de sortir du répertoire de stockage. */
  private resolve(key: string): string {
    const full = path.resolve(this.root, key);
    if (!full.startsWith(this.root + path.sep)) throw new NotFoundException('Fichier introuvable');
    return full;
  }
}

@Global()
@Module({
  providers: [StorageService],
  exports: [StorageService],
})
export class StorageModule {}

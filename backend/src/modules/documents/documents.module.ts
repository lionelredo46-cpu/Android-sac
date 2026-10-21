import { Module } from '@nestjs/common';
import { DocumentsController } from './documents.controller';
import { DocumentsService } from './documents.service';

/** Démarches, coffre-fort (module 9) et discipline (module 10). */
@Module({ controllers: [DocumentsController], providers: [DocumentsService] })
export class DocumentsModule {}

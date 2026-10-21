import {
  Body,
  Controller,
  Get,
  HttpCode,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
  Req,
  Res,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiBearerAuth, ApiConsumes, ApiOperation, ApiTags } from '@nestjs/swagger';
import { DisciplineRecordType, DocumentRequestStatus, DocumentRequestType } from '@prisma/client';
import { IsBoolean, IsDateString, IsEnum, IsIn, IsNotEmpty, IsOptional, IsString, IsUUID, MaxLength } from 'class-validator';
import { Request, Response } from 'express';
import { AuthUser } from '../../common/access/child-access.service';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { RequirePermissions } from '../../common/decorators/roles.decorator';
import { PERMISSIONS } from '../../common/guards/permissions';
import { MAX_UPLOAD_BYTES } from '../../common/storage/storage.service';
import { auditCtx } from '../../common/utils/http';
import { sendPdf } from '../finance/finance.controller';
import { DocumentsService } from './documents.service';

class UploadDto {
  @IsString() @IsNotEmpty() @MaxLength(120) titre: string;
  @IsIn(['IDENTITE', 'PHOTO', 'DIPLOME', 'CERTIFICAT_MEDICAL', 'AUTRE']) categorie: string;
}

class CreateRequestDto {
  @IsUUID() studentId: string;
  @IsEnum(DocumentRequestType) type: DocumentRequestType;
  @IsOptional() @IsString() @MaxLength(500) motif?: string;
}

class ProcessRequestDto {
  @IsEnum(DocumentRequestStatus) statut: DocumentRequestStatus;
}

class ValidateUploadDto {
  @IsBoolean() accepte: boolean;
  @IsOptional() @IsString() @MaxLength(300) commentaire?: string;
}

class DisciplineDto {
  @IsUUID() studentId: string;
  @IsEnum(DisciplineRecordType) type: DisciplineRecordType;
  @IsString() @IsNotEmpty() @MaxLength(500) motif: string;
  @IsOptional() @IsString() @MaxLength(300) sanction?: string;
  @IsDateString() dateIncident: string;
  @IsOptional() @IsDateString() convocationDate?: string;
}

@ApiTags('Documents, démarches & discipline')
@ApiBearerAuth()
@Controller('api/v1')
export class DocumentsController {
  constructor(private readonly service: DocumentsService) {}

  @Get('children/:id/documents')
  @ApiOperation({ summary: 'Coffre-fort de documents' })
  vault(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.service.vault(user, id);
  }

  @Post('children/:id/documents/upload')
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('fichier', { limits: { fileSize: MAX_UPLOAD_BYTES } }))
  upload(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: UploadDto, @UploadedFile() file: Express.Multer.File, @Req() req: Request) {
    return this.service.upload(user, id, dto, file, auditCtx(req));
  }

  @Get('documents/:id/download')
  async download(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Res() res: Response) {
    const f = await this.service.download(user, id);
    res.set({ 'Content-Type': f.key.endsWith('.pdf') ? 'application/pdf' : 'image/jpeg', 'Content-Disposition': `attachment; filename="${f.filename}"`, 'Cache-Control': 'private, no-store' });
    res.end(f.buffer);
  }

  @Post('documents/:id/sign')
  @HttpCode(200)
  @ApiOperation({ summary: 'Signature électronique (règlement intérieur, contrat)' })
  sign(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Req() req: Request) {
    return this.service.sign(user, id, auditCtx(req));
  }

  @Get('children/:id/certificates/enrollment.pdf')
  async enrollment(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Res() res: Response) {
    sendPdf(res, await this.service.enrollmentCertificate(user, id));
  }

  @Get('children/:id/requests')
  requests(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.service.requests(user, id);
  }

  @Post('requests')
  @ApiOperation({ summary: 'Demande de document ou de démarche' })
  createRequest(@CurrentUser() user: AuthUser, @Body() dto: CreateRequestDto, @Req() req: Request) {
    return this.service.createRequest(user, dto, auditCtx(req));
  }

  @Get('requests/:id')
  request(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.service.request(user, id);
  }

  @Get('requests/:id/document')
  async requestDocument(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Res() res: Response) {
    sendPdf(res, await this.service.requestDocument(user, id));
  }

  @Get('children/:id/discipline')
  discipline(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.service.discipline(user, id);
  }

  @Post('discipline/:id/acknowledge')
  @HttpCode(200)
  @ApiOperation({ summary: 'Accusé de réception d’une convocation' })
  acknowledge(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Req() req: Request) {
    return this.service.acknowledge(user, id, auditCtx(req));
  }

  // ---- Scolarité
  @RequirePermissions(PERMISSIONS.DOCUMENTS_MANAGE)
  @Get('admin/requests')
  adminRequests(@Query('statut') statut?: DocumentRequestStatus) {
    return this.service.adminRequests(statut);
  }

  @RequirePermissions(PERMISSIONS.DOCUMENTS_MANAGE)
  @Patch('admin/requests/:id')
  process(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: ProcessRequestDto, @Req() req: Request) {
    return this.service.processRequest(user, id, dto.statut, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.DOCUMENTS_MANAGE)
  @Patch('admin/documents/:id/validation')
  validate(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: ValidateUploadDto, @Req() req: Request) {
    return this.service.validateUpload(user, id, dto.accepte, dto.commentaire, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.DISCIPLINE_MANAGE)
  @Post('admin/discipline')
  createDiscipline(@CurrentUser() user: AuthUser, @Body() dto: DisciplineDto, @Req() req: Request) {
    return this.service.createDiscipline(user, dto, auditCtx(req));
  }
}

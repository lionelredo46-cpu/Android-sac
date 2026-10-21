import {
  Body,
  Controller,
  Get,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Put,
  Query,
  Req,
  Res,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiBearerAuth, ApiConsumes, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AttendanceStatus } from '@prisma/client';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsDateString,
  IsEnum,
  IsIn,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsUUID,
  Max,
  MaxLength,
  Min,
  ValidateNested,
} from 'class-validator';
import { Request, Response } from 'express';
import { AuthUser } from '../../common/access/child-access.service';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { RequirePermissions } from '../../common/decorators/roles.decorator';
import { PERMISSIONS } from '../../common/guards/permissions';
import { MAX_UPLOAD_BYTES } from '../../common/storage/storage.service';
import { auditCtx } from '../../common/utils/http';
import { AttendanceService } from './attendance.service';

class RangeQuery {
  @IsOptional() @IsDateString() from?: string;
  @IsOptional() @IsDateString() to?: string;
}

class JustifyDto {
  @IsString() @IsNotEmpty() @MaxLength(500) motif: string;
}

class RollCallItem {
  @IsUUID() studentId: string;
  @IsEnum(AttendanceStatus) statut: AttendanceStatus;
  @IsOptional() @IsInt() @Min(0) @Max(240) minutesRetard?: number;
}

class RollCallDto {
  @ValidateNested({ each: true }) @Type(() => RollCallItem) @ArrayMaxSize(300) records: RollCallItem[];
}

class ScanDto {
  @IsString() @IsNotEmpty() @MaxLength(200) code: string;
}

class ReviewDto {
  @IsIn(['VALIDE', 'REJETE']) decision: 'VALIDE' | 'REJETE';
  @IsOptional() @IsString() @MaxLength(500) commentaire?: string;
}

@ApiTags('Présences')
@ApiBearerAuth()
@Controller('api/v1')
export class AttendanceController {
  constructor(private readonly service: AttendanceService) {}

  @RequirePermissions(PERMISSIONS.ATTENDANCE_READ)
  @Get('children/:id/attendance')
  @ApiOperation({ summary: 'Liste détaillée des présences (cours, enseignant, date, durée)' })
  list(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Query() q: RangeQuery) {
    return this.service.list(user, id, q.from, q.to);
  }

  @RequirePermissions(PERMISSIONS.ATTENDANCE_READ)
  @Get('children/:id/attendance/stats')
  @ApiOperation({ summary: 'Taux d’assiduité global, par matière et par semaine' })
  stats(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Query() q: RangeQuery) {
    return this.service.stats(user, id, q.from, q.to);
  }

  @Post('absences/:id/justify')
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('fichier', { limits: { fileSize: MAX_UPLOAD_BYTES } }))
  @ApiOperation({ summary: 'Justifier une absence (motif + pièce jointe PDF/photo)' })
  justify(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: JustifyDto,
    @UploadedFile() file: Express.Multer.File,
    @Req() req: Request,
  ) {
    return this.service.justify(user, id, dto.motif, file, auditCtx(req));
  }

  @Get('absences/:id/justification/file')
  async file(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Res() res: Response) {
    const f = await this.service.justificationFile(user, id);
    res.set({ 'Content-Type': f.key.endsWith('.pdf') ? 'application/pdf' : 'image/jpeg', 'Cache-Control': 'private, no-store' });
    res.end(f.buffer);
  }

  // ---- Enseignant
  @RequirePermissions(PERMISSIONS.ATTENDANCE_RECORD)
  @Get('teacher/slots')
  @ApiOperation({ summary: 'Séances du jour de l’enseignant' })
  slots(@CurrentUser() user: AuthUser, @Query('date') date?: string) {
    return this.service.teacherSlots(user, date);
  }

  @RequirePermissions(PERMISSIONS.ATTENDANCE_RECORD)
  @Get('teacher/slots/:id/roster')
  roster(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.service.roster(user, id);
  }

  @RequirePermissions(PERMISSIONS.ATTENDANCE_RECORD)
  @Put('teacher/slots/:id/attendance')
  @ApiOperation({ summary: 'Appel numérique (présent, absent, retard, excusé)' })
  rollCall(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: RollCallDto, @Req() req: Request) {
    return this.service.rollCall(user, id, dto.records, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.ATTENDANCE_RECORD)
  @Post('teacher/slots/:id/qr')
  @ApiOperation({ summary: 'Génère le QR code de séance (valable 10 min)' })
  qr(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.service.generateQr(user, id);
  }

  @Post('attendance/scan')
  @ApiOperation({ summary: 'L’étudiant scanne le QR code affiché en cours' })
  scan(@CurrentUser() user: AuthUser, @Body() dto: ScanDto, @Req() req: Request) {
    return this.service.scan(user, dto.code, auditCtx(req));
  }

  // ---- Scolarité
  @RequirePermissions(PERMISSIONS.ATTENDANCE_JUSTIFY_REVIEW)
  @Get('admin/justifications')
  pending() {
    return this.service.pendingJustifications();
  }

  @RequirePermissions(PERMISSIONS.ATTENDANCE_JUSTIFY_REVIEW)
  @Patch('admin/justifications/:id')
  review(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: ReviewDto, @Req() req: Request) {
    return this.service.review(user, id, dto.decision, dto.commentaire, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.STATS_READ)
  @Get('admin/attendance/groups/:groupId')
  groupStats(@Param('groupId', ParseUUIDPipe) groupId: string, @Query() q: RangeQuery) {
    return this.service.groupStats(groupId, q.from, q.to);
  }
}

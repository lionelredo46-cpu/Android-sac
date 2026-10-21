import { Body, Controller, Get, HttpCode, Param, ParseUUIDPipe, Patch, Post, Put, Query, Req, Res } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AssessmentType, DisputeStatus, GradeStatus } from '@prisma/client';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsEnum,
  IsIn,
  IsNotEmpty,
  IsNumber,
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
import { auditCtx } from '../../common/utils/http';
import { sendPdf } from '../finance/finance.controller';
import { GradesService } from './grades.service';

class DisputeDto {
  @IsString() @IsNotEmpty() @MaxLength(1000) motif: string;
}

class CreateAssessmentDto {
  @IsUUID() courseId: string;
  @IsUUID() groupId: string;
  @IsUUID() semesterId: string;
  @IsEnum(AssessmentType) type: AssessmentType;
  @IsString() @IsNotEmpty() @MaxLength(120) titre: string;
  @IsNumber() @Min(1) @Max(100) bareme: number;
  @IsNumber() @Min(0.1) @Max(10) coefficient: number;
}

class GradeItem {
  @IsUUID() studentId: string;
  @IsNumber({ maxDecimalPlaces: 2 }) @Min(0) @Max(100) valeur: number;
}

class SaveGradesDto {
  @ValidateNested({ each: true }) @Type(() => GradeItem) @ArrayMaxSize(300) grades: GradeItem[];
  @IsOptional() @IsString() @MaxLength(300) motif?: string;
}

class AssessmentQuery {
  @IsOptional() @IsUUID() courseId?: string;
  @IsOptional() @IsUUID() groupId?: string;
  @IsOptional() @IsEnum(GradeStatus) statut?: GradeStatus;
}

class ReviewDisputeDto {
  @IsIn([DisputeStatus.EN_EXAMEN, DisputeStatus.ACCEPTEE, DisputeStatus.REJETEE]) statut: DisputeStatus;
  @IsString() @IsNotEmpty() @MaxLength(1000) reponse: string;
  @IsOptional() @IsNumber() @Min(0) @Max(100) nouvelleValeur?: number;
}

@ApiTags('Notes & bulletins')
@ApiBearerAuth()
@Controller('api/v1')
export class GradesController {
  constructor(private readonly service: GradesService) {}

  @RequirePermissions(PERMISSIONS.GRADES_READ)
  @Get('children/:id/grades')
  @ApiOperation({ summary: 'Notes publiées du semestre, moyennes, rang, crédits et mention' })
  grades(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Query('semesterId') semesterId?: string) {
    return this.service.semesterResults(user, id, semesterId);
  }

  @RequirePermissions(PERMISSIONS.GRADES_READ)
  @Get('children/:id/grades/history')
  @ApiOperation({ summary: 'Moyenne de chaque semestre (évolution)' })
  history(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.service.history(user, id);
  }

  @RequirePermissions(PERMISSIONS.GRADES_READ)
  @Get('children/:id/transcripts/:semesterId/pdf')
  @ApiOperation({ summary: 'Bulletin PDF du semestre' })
  async bulletin(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Param('semesterId', ParseUUIDPipe) semesterId: string, @Res() res: Response) {
    sendPdf(res, await this.service.bulletinPdf(user, id, semesterId));
  }

  @Post('grades/:id/dispute')
  @ApiOperation({ summary: 'Réclamation / demande de révision d’une note' })
  dispute(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: DisputeDto, @Req() req: Request) {
    return this.service.dispute(user, id, dto.motif, auditCtx(req));
  }

  @Get('children/:id/grade-disputes')
  myDisputes(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.service.myDisputes(user, id);
  }

  // ---- Enseignant
  @RequirePermissions(PERMISSIONS.GRADES_ENTER)
  @Get('teacher/courses')
  courses(@CurrentUser() user: AuthUser) {
    return this.service.teacherCourses(user);
  }

  @RequirePermissions(PERMISSIONS.GRADES_ENTER)
  @Get('teacher/assessments')
  assessments(@CurrentUser() user: AuthUser, @Query() q: AssessmentQuery) {
    return this.service.assessmentsFor(user, q);
  }

  @RequirePermissions(PERMISSIONS.GRADES_ENTER)
  @Post('teacher/assessments')
  create(@CurrentUser() user: AuthUser, @Body() dto: CreateAssessmentDto, @Req() req: Request) {
    return this.service.createAssessment(user, dto, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.GRADES_ENTER)
  @Get('teacher/assessments/:id')
  sheet(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.service.assessmentSheet(user, id);
  }

  @RequirePermissions(PERMISSIONS.GRADES_ENTER)
  @Put('teacher/assessments/:id/grades')
  @ApiOperation({ summary: 'Saisie / correction des notes (historisée)' })
  save(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: SaveGradesDto, @Req() req: Request) {
    return this.service.saveGrades(user, id, dto.grades, dto.motif, auditCtx(req));
  }

  // ---- Scolarité
  @RequirePermissions(PERMISSIONS.GRADES_VALIDATE)
  @Get('admin/assessments')
  adminAssessments(@CurrentUser() user: AuthUser, @Query() q: AssessmentQuery) {
    return this.service.assessmentsFor(user, q);
  }

  @RequirePermissions(PERMISSIONS.GRADES_VALIDATE)
  @Post('admin/assessments/:id/validate')
  @HttpCode(200)
  validate(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Req() req: Request) {
    return this.service.transition(user, id, 'VALIDE_SCOLARITE', auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.GRADES_VALIDATE)
  @Post('admin/assessments/:id/reject')
  @HttpCode(200)
  reject(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Req() req: Request) {
    return this.service.transition(user, id, 'BROUILLON', auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.GRADES_PUBLISH)
  @Post('admin/assessments/:id/publish')
  @HttpCode(200)
  @ApiOperation({ summary: 'Publie les notes (visibles par parents et étudiants, notification)' })
  publish(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Req() req: Request) {
    return this.service.transition(user, id, 'PUBLIE', auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.GRADES_DISPUTE_REVIEW)
  @Get('admin/grade-disputes')
  disputes(@Query('statut') statut?: DisputeStatus) {
    return this.service.disputes(statut);
  }

  @RequirePermissions(PERMISSIONS.GRADES_DISPUTE_REVIEW)
  @Patch('admin/grade-disputes/:id')
  reviewDispute(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: ReviewDisputeDto, @Req() req: Request) {
    return this.service.reviewDispute(user, id, dto, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.GRADES_VALIDATE)
  @Get('admin/grades/:id/history')
  @ApiOperation({ summary: 'Historique complet des modifications d’une note' })
  gradeHistory(@Param('id', ParseUUIDPipe) id: string) {
    return this.service.gradeHistory(id);
  }
}

import {
  BadRequestException,
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Put,
  Query,
  Req,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiBearerAuth, ApiConsumes, ApiOperation, ApiTags } from '@nestjs/swagger';
import { ParentRelationType, UserRole, UserStatus } from '@prisma/client';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsBoolean,
  IsDateString,
  IsDefined,
  IsEmail,
  IsEnum,
  IsIn,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsUUID,
  Matches,
  MaxLength,
  ValidateNested,
} from 'class-validator';
import { Request } from 'express';
import { AuthUser } from '../../common/access/child-access.service';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { RequirePermissions } from '../../common/decorators/roles.decorator';
import { PERMISSIONS } from '../../common/guards/permissions';
import { auditCtx } from '../../common/utils/http';
import { AdminService } from './admin.service';

const PHONE = /^\+?[0-9]{8,15}$/;

class UsersQuery {
  @IsOptional() @IsEnum(UserRole) role?: UserRole;
  @IsOptional() @IsString() @MaxLength(80) search?: string;
  @IsOptional() cursor?: string;
  @IsOptional() take?: number;
}

class CreateStaffDto {
  @IsEmail() email: string;
  @Matches(PHONE) telephone: string;
  @IsIn([UserRole.SUPER_ADMIN, UserRole.DIRECTION, UserRole.SCOLARITE, UserRole.COMPTABLE, UserRole.ENSEIGNANT, UserRole.SUPPORT]) role: UserRole;
  @IsOptional() @IsString() @MaxLength(80) nom?: string;
  @IsOptional() @IsString() @MaxLength(80) prenom?: string;
  @IsOptional() @IsString() @MaxLength(80) specialite?: string;
}

class StatusDto {
  @IsEnum(UserStatus) status: UserStatus;
}

class ParentInputDto {
  @IsString() @IsNotEmpty() @MaxLength(80) nom: string;
  @IsString() @IsNotEmpty() @MaxLength(80) prenom: string;
  @Matches(PHONE) telephone: string;
  @IsOptional() @IsEmail() email?: string;
  @IsEnum(ParentRelationType) relationType: ParentRelationType;
  @IsBoolean() estPayeur: boolean;
}

class CreateStudentDto {
  @IsString() @IsNotEmpty() @MaxLength(30) matricule: string;
  @IsString() @IsNotEmpty() @MaxLength(80) nom: string;
  @IsString() @IsNotEmpty() @MaxLength(80) prenom: string;
  @IsDateString() dateNaissance: string;
  @IsUUID() groupId: string;
  @IsOptional() @IsEmail() email?: string;
  @IsOptional() @Matches(PHONE) telephone?: string;
  @ValidateNested({ each: true }) @Type(() => ParentInputDto) @ArrayMinSize(1) @ArrayMaxSize(4) parents: ParentInputDto[];
}

class LinkDto {
  @IsUUID() parentUserId: string;
  @IsUUID() studentId: string;
  @IsEnum(ParentRelationType) relationType: ParentRelationType;
  @IsBoolean() estPayeur: boolean;
  @IsOptional() @IsBoolean() peutConsulter?: boolean;
}

class AuditQuery {
  @IsOptional() @IsString() entite?: string;
  @IsOptional() @IsString() entiteId?: string;
  @IsOptional() @IsUUID() userId?: string;
  @IsOptional() @IsString() action?: string;
  @IsOptional() @IsDateString() from?: string;
  @IsOptional() @IsDateString() to?: string;
  @IsOptional() cursor?: string;
  @IsOptional() take?: number;
}

class SettingDto {
  @IsDefined() value: any;
}

class PermissionsDto {
  @IsArray() @IsString({ each: true }) permissions: string[];
}

const ENTITY_KINDS = ['program', 'group', 'course', 'room', 'academicYear', 'semester'] as const;
type EntityKind = (typeof ENTITY_KINDS)[number];

@ApiTags('Back-office · Administration')
@ApiBearerAuth()
@Controller('api/v1/admin')
export class AdminController {
  constructor(private readonly service: AdminService) {}

  @RequirePermissions(PERMISSIONS.STATS_READ)
  @Get('stats/overview')
  @ApiOperation({ summary: 'Indicateurs décisionnels (inscrits, recouvrement, assiduité, notes, tickets)' })
  overview() {
    return this.service.overview();
  }

  @RequirePermissions(PERMISSIONS.USERS_MANAGE_STUDENTS)
  @Get('users')
  users(@Query() q: UsersQuery) {
    return this.service.users(q);
  }

  @RequirePermissions(PERMISSIONS.USERS_MANAGE)
  @Post('users/staff')
  createStaff(@CurrentUser() user: AuthUser, @Body() dto: CreateStaffDto, @Req() req: Request) {
    return this.service.createStaff(user, dto, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.USERS_MANAGE)
  @Patch('users/:id/status')
  @ApiOperation({ summary: 'Suspend / réactive un compte (révoque les sessions)' })
  setStatus(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: StatusDto, @Req() req: Request) {
    return this.service.setStatus(user, id, dto.status, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.USERS_MANAGE_STUDENTS)
  @Post('users/:id/resend-invitation')
  resend(@Param('id', ParseUUIDPipe) id: string, @Req() req: Request) {
    return this.service.resendInvitation(id, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.USERS_MANAGE_STUDENTS)
  @Post('students')
  @ApiOperation({ summary: 'Crée le dossier étudiant et invite les parents (activation par SMS)' })
  createStudent(@CurrentUser() user: AuthUser, @Body() dto: CreateStudentDto, @Req() req: Request) {
    return this.service.createStudent(user, dto, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.USERS_MANAGE_STUDENTS)
  @Get('students/:id')
  student(@Param('id', ParseUUIDPipe) id: string) {
    return this.service.student(id);
  }

  @RequirePermissions(PERMISSIONS.USERS_MANAGE_STUDENTS)
  @Post('students/import')
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('fichier', { limits: { fileSize: 2 * 1024 * 1024 } }))
  @ApiOperation({ summary: 'Import CSV des étudiants et parents (dryRun=true pour prévisualiser)' })
  import(@CurrentUser() user: AuthUser, @UploadedFile() file: Express.Multer.File, @Query('dryRun') dryRun: string | undefined, @Req() req: Request) {
    if (!file) throw new BadRequestException('Fichier CSV manquant');
    return this.service.importStudents(user, file.buffer.toString('utf8'), dryRun !== 'false', auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.USERS_MANAGE_STUDENTS)
  @Post('links')
  @ApiOperation({ summary: 'Crée / valide un rattachement parent ↔ étudiant' })
  link(@CurrentUser() user: AuthUser, @Body() dto: LinkDto, @Req() req: Request) {
    return this.service.link(user, dto, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.USERS_MANAGE_STUDENTS)
  @Delete('links/:parentUserId/:studentId')
  unlink(@Param('parentUserId', ParseUUIDPipe) parentUserId: string, @Param('studentId', ParseUUIDPipe) studentId: string, @Req() req: Request) {
    return this.service.unlink(parentUserId, studentId, auditCtx(req));
  }

  @Get('structure')
  @RequirePermissions(PERMISSIONS.STATS_READ)
  structure() {
    return this.service.structure();
  }

  @RequirePermissions(PERMISSIONS.SETTINGS_MANAGE)
  @Post('structure/:kind')
  @ApiOperation({ summary: 'Crée une filière, un groupe, une matière, une salle, une année ou un semestre' })
  createEntity(@Param('kind') kind: string, @Body() body: Record<string, unknown>, @Req() req: Request) {
    if (!ENTITY_KINDS.includes(kind as EntityKind)) throw new BadRequestException('Type inconnu');
    return this.service.createEntity(kind as EntityKind, body, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.AUDIT_READ)
  @Get('audit-logs')
  @ApiOperation({ summary: 'Journal d’audit (qui a fait quoi, quand, depuis où)' })
  audit(@Query() q: AuditQuery) {
    return this.service.auditLogs(q);
  }

  @RequirePermissions(PERMISSIONS.SETTINGS_MANAGE)
  @Get('settings')
  settings() {
    return this.service.settings();
  }

  @RequirePermissions(PERMISSIONS.SETTINGS_MANAGE)
  @Put('settings/:key')
  setSetting(@Param('key') key: string, @Body() dto: SettingDto, @Req() req: Request) {
    return this.service.setSetting(key, dto.value, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.SETTINGS_MANAGE)
  @Get('permissions')
  permissions() {
    return this.service.permissions();
  }

  @RequirePermissions(PERMISSIONS.SETTINGS_MANAGE)
  @Put('permissions/:role')
  setPermissions(@Param('role') role: UserRole, @Body() dto: PermissionsDto, @Req() req: Request) {
    if (!Object.values(UserRole).includes(role)) throw new BadRequestException('Rôle inconnu');
    return this.service.setPermissions(role, dto.permissions, auditCtx(req));
  }
}

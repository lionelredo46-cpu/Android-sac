import {
  Body,
  Controller,
  Get,
  Param,
  ParseIntPipe,
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
import { AnnouncementTarget, AppointmentStatus, TicketPriority, TicketService, TicketStatus } from '@prisma/client';
import { IsDateString, IsEnum, IsIn, IsInt, IsNotEmpty, IsOptional, IsString, IsUUID, Max, MaxLength, Min } from 'class-validator';
import { Request, Response } from 'express';
import { AuthUser } from '../../common/access/child-access.service';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { RequirePermissions } from '../../common/decorators/roles.decorator';
import { PERMISSIONS } from '../../common/guards/permissions';
import { MAX_UPLOAD_BYTES } from '../../common/storage/storage.service';
import { auditCtx } from '../../common/utils/http';
import { MessagingService } from './messaging.service';

class CreateTicketDto {
  @IsString() @IsNotEmpty() @MaxLength(150) sujet: string;
  @IsEnum(TicketService) service: TicketService;
  @IsOptional() @IsEnum(TicketPriority) priorite?: TicketPriority;
  @IsOptional() @IsUUID() studentId?: string;
  @IsString() @IsNotEmpty() @MaxLength(4000) message: string;
}

class ReplyDto {
  @IsString() @IsNotEmpty() @MaxLength(4000) contenu: string;
}

class StaffMessageDto {
  @IsUUID() studentId: string;
  @IsString() @IsNotEmpty() @MaxLength(150) sujet: string;
  @IsEnum(TicketService) service: TicketService;
  @IsString() @IsNotEmpty() @MaxLength(4000) message: string;
  @IsIn(['PARENTS', 'ETUDIANT']) destinataire: 'PARENTS' | 'ETUDIANT';
}

class UpdateTicketDto {
  @IsOptional() @IsEnum(TicketStatus) statut?: TicketStatus;
  @IsOptional() @IsUUID() assigneAUserId?: string;
  @IsOptional() @IsEnum(TicketPriority) priorite?: TicketPriority;
}

class RateDto {
  @IsInt() @Min(1) @Max(5) satisfaction: number;
}

class ListQuery {
  @IsOptional() @IsEnum(TicketStatus) statut?: TicketStatus;
  @IsOptional() cursor?: string;
  @IsOptional() take?: number;
}

class AnnouncementDto {
  @IsString() @IsNotEmpty() @MaxLength(150) titre: string;
  @IsString() @IsNotEmpty() @MaxLength(5000) contenu: string;
  @IsEnum(AnnouncementTarget) targetType: AnnouncementTarget;
  @IsOptional() @IsUUID() targetId?: string;
  @IsOptional() @IsDateString() dateExpiration?: string;
}

class AppointmentDto {
  @IsUUID() hoteId: string;
  @IsString() @IsNotEmpty() @MaxLength(200) objet: string;
  @IsDateString() debut: string;
  @IsDateString() fin: string;
}

class UpdateAppointmentDto {
  @IsEnum(AppointmentStatus) statut: AppointmentStatus;
  @IsOptional() @IsString() @MaxLength(120) lieu?: string;
}

@ApiTags('Messagerie, annonces & rendez-vous')
@ApiBearerAuth()
@Controller('api/v1')
export class MessagingController {
  constructor(private readonly service: MessagingService) {}

  @Get('conversations')
  list(@CurrentUser() user: AuthUser, @Query() q: ListQuery) {
    return this.service.list(user, q.statut, q.cursor, q.take);
  }

  @Post('conversations')
  @ApiConsumes('multipart/form-data', 'application/json')
  @UseInterceptors(FileInterceptor('fichier', { limits: { fileSize: MAX_UPLOAD_BYTES } }))
  @ApiOperation({ summary: 'Ouvre un ticket (finances, scolarité, discipline…) avec pièce jointe optionnelle' })
  create(@CurrentUser() user: AuthUser, @Body() dto: CreateTicketDto, @UploadedFile() file: Express.Multer.File | undefined, @Req() req: Request) {
    return this.service.create(user, dto, file, auditCtx(req));
  }

  @Get('conversations/:id/messages')
  get(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.service.get(user, id);
  }

  @Post('conversations/:id/messages')
  @ApiConsumes('multipart/form-data', 'application/json')
  @UseInterceptors(FileInterceptor('fichier', { limits: { fileSize: MAX_UPLOAD_BYTES } }))
  reply(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: ReplyDto, @UploadedFile() file: Express.Multer.File | undefined, @Req() req: Request) {
    return this.service.reply(user, id, dto.contenu, file, auditCtx(req));
  }

  @Patch('conversations/:id')
  update(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: UpdateTicketDto, @Req() req: Request) {
    return this.service.updateStatus(user, id, dto, auditCtx(req));
  }

  @Post('conversations/:id/rate')
  rate(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: RateDto) {
    return this.service.rate(user, id, dto.satisfaction);
  }

  @Get('messages/:id/attachments/:index')
  async attachment(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Param('index', ParseIntPipe) index: number, @Res() res: Response) {
    const f = await this.service.attachment(user, id, index);
    res.set({ 'Content-Type': f.key.endsWith('.pdf') ? 'application/pdf' : 'image/jpeg', 'Cache-Control': 'private, no-store' });
    res.end(f.buffer);
  }

  @RequirePermissions(PERMISSIONS.MESSAGES_SEND_TO_PARENT)
  @Post('admin/messages')
  @ApiOperation({ summary: 'L’administration écrit aux parents (ou à l’étudiant)' })
  staffMessage(@CurrentUser() user: AuthUser, @Body() dto: StaffMessageDto, @Req() req: Request) {
    return this.service.staffStart(user, dto, auditCtx(req));
  }

  @Get('announcements')
  announcements(@CurrentUser() user: AuthUser, @Query('cursor') cursor?: string, @Query('take') take?: number) {
    return this.service.announcements(user, cursor, take);
  }

  @RequirePermissions(PERMISSIONS.ANNOUNCEMENTS_PUBLISH)
  @Post('admin/announcements')
  @ApiOperation({ summary: 'Annonce ciblée (tous, filière, groupe, étudiant, parent) + notification' })
  publish(@CurrentUser() user: AuthUser, @Body() dto: AnnouncementDto, @Req() req: Request) {
    return this.service.publishAnnouncement(user, dto, auditCtx(req));
  }

  @Get('appointments/hosts')
  hosts() {
    return this.service.hosts();
  }

  @Get('appointments')
  appointments(@CurrentUser() user: AuthUser) {
    return this.service.appointments(user);
  }

  @Post('appointments')
  request(@CurrentUser() user: AuthUser, @Body() dto: AppointmentDto, @Req() req: Request) {
    return this.service.requestAppointment(user, dto, auditCtx(req));
  }

  @Patch('appointments/:id')
  updateAppointment(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: UpdateAppointmentDto, @Req() req: Request) {
    return this.service.updateAppointment(user, id, dto.statut, dto.lieu, auditCtx(req));
  }
}

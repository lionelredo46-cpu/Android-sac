import { Body, Controller, Get, Param, ParseUUIDPipe, Patch, Post, Query, Req, Res } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AnnouncementTarget, CalendarEventType } from '@prisma/client';
import { IsDateString, IsEnum, IsIn, IsNotEmpty, IsOptional, IsString, IsUUID, MaxLength } from 'class-validator';
import { Request, Response } from 'express';
import { AuthUser } from '../../common/access/child-access.service';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { RequirePermissions } from '../../common/decorators/roles.decorator';
import { PERMISSIONS } from '../../common/guards/permissions';
import { auditCtx } from '../../common/utils/http';
import { TimetableService } from './timetable.service';

class RangeQuery {
  @IsOptional() @IsDateString() from?: string;
  @IsOptional() @IsDateString() to?: string;
}

class CreateSlotDto {
  @IsUUID() semesterId: string;
  @IsUUID() courseId: string;
  @IsUUID() groupId: string;
  @IsUUID() teacherId: string;
  @IsUUID() roomId: string;
  @IsDateString() debut: string;
  @IsDateString() fin: string;
}

class UpdateSlotDto {
  @IsIn(['ANNULE', 'REPORTE', 'PLANIFIE']) statut: 'ANNULE' | 'REPORTE' | 'PLANIFIE';
  @IsOptional() @IsString() @MaxLength(300) motif?: string;
  @IsOptional() @IsDateString() debut?: string;
  @IsOptional() @IsDateString() fin?: string;
  @IsOptional() @IsUUID() roomId?: string;
}

class CreateEventDto {
  @IsString() @IsNotEmpty() @MaxLength(150) titre: string;
  @IsOptional() @IsString() @MaxLength(1000) description?: string;
  @IsEnum(CalendarEventType) type: CalendarEventType;
  @IsDateString() debut: string;
  @IsDateString() fin: string;
  @IsOptional() @IsEnum(AnnouncementTarget) targetType?: AnnouncementTarget;
  @IsOptional() @IsUUID() targetId?: string;
}

@ApiTags('Emploi du temps & calendrier')
@ApiBearerAuth()
@Controller('api/v1')
export class TimetableController {
  constructor(private readonly service: TimetableService) {}

  @Get('children/:id/timetable')
  @ApiOperation({ summary: 'Emploi du temps (semaine courante par défaut)' })
  timetable(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Query() q: RangeQuery) {
    return this.service.forStudent(user, id, q.from, q.to);
  }

  @Get('children/:id/timetable.ics')
  @ApiOperation({ summary: 'Export ICS (Google Calendar / Apple Calendar)' })
  async ics(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Res() res: Response) {
    const body = await this.service.ics(user, id);
    res.set({ 'Content-Type': 'text/calendar; charset=utf-8', 'Content-Disposition': 'attachment; filename="afram-emploi-du-temps.ics"' });
    res.send(body);
  }

  @Get('calendar/events')
  @ApiOperation({ summary: 'Calendrier académique (examens, vacances, échéances, réunions)' })
  events(@CurrentUser() user: AuthUser, @Query() q: RangeQuery) {
    return this.service.calendarEvents(user, q.from, q.to);
  }

  @RequirePermissions(PERMISSIONS.TIMETABLE_MANAGE)
  @Post('admin/timetable/slots')
  createSlot(@Body() dto: CreateSlotDto, @Req() req: Request) {
    return this.service.createSlot(dto, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.TIMETABLE_MANAGE)
  @Patch('admin/timetable/slots/:id')
  @ApiOperation({ summary: 'Annulation, report ou changement de salle (notifie les familles)' })
  updateSlot(@Param('id', ParseUUIDPipe) id: string, @Body() dto: UpdateSlotDto, @Req() req: Request) {
    return this.service.updateSlot(id, dto, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.TIMETABLE_MANAGE)
  @Post('admin/calendar/events')
  createEvent(@Body() dto: CreateEventDto, @Req() req: Request) {
    return this.service.createEvent(dto, auditCtx(req));
  }
}

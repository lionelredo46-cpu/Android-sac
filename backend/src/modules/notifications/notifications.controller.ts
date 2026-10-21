import { Body, Controller, Get, HttpCode, Param, ParseUUIDPipe, Patch, Post, Put, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { NotificationCategory } from '@prisma/client';
import { Type } from 'class-transformer';
import { ArrayMaxSize, IsArray, IsBoolean, IsEnum, IsOptional, ValidateNested } from 'class-validator';
import { AuthUser } from '../../common/access/child-access.service';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { NotificationsService } from './notifications.service';

class PreferenceItemDto {
  @IsEnum(NotificationCategory) categorie: NotificationCategory;
  @IsBoolean() push: boolean;
  @IsBoolean() sms: boolean;
  @IsBoolean() email: boolean;
}

class UpdatePreferencesDto {
  @IsArray()
  @ArrayMaxSize(20)
  @ValidateNested({ each: true })
  @Type(() => PreferenceItemDto)
  items: PreferenceItemDto[];
}

class ListQuery {
  @IsOptional() cursor?: string;
  @IsOptional() take?: number;
  @IsOptional() @IsEnum(NotificationCategory) categorie?: NotificationCategory;
}

@ApiTags('Notifications')
@ApiBearerAuth()
@Controller('api/v1')
export class NotificationsController {
  constructor(private readonly service: NotificationsService) {}

  @Get('notifications')
  list(@CurrentUser() user: AuthUser, @Query() q: ListQuery) {
    return this.service.list(user.id, q.cursor, q.take, q.categorie);
  }

  @Get('notifications/unread-count')
  unread(@CurrentUser() user: AuthUser) {
    return this.service.unreadCount(user.id);
  }

  @Patch('notifications/:id/read')
  read(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.service.markRead(user.id, id);
  }

  @Post('notifications/read-all')
  @HttpCode(200)
  readAll(@CurrentUser() user: AuthUser) {
    return this.service.markAllRead(user.id);
  }

  @Get('notification-preferences')
  prefs(@CurrentUser() user: AuthUser) {
    return this.service.preferences(user.id);
  }

  @Put('notification-preferences')
  updatePrefs(@CurrentUser() user: AuthUser, @Body() dto: UpdatePreferencesDto) {
    return this.service.updatePreferences(user.id, dto.items);
  }
}

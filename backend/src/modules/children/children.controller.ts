import { Body, Controller, Delete, Get, HttpCode, Param, ParseUUIDPipe, Patch, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { IsIn, IsNotEmpty, IsOptional, IsString, MaxLength } from 'class-validator';
import { AuthUser } from '../../common/access/child-access.service';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { PrismaService } from '../../prisma/prisma.service';
import { ChildrenService } from './children.service';
import { DashboardService } from './dashboard.service';

class UpdateMeDto {
  @IsOptional() @IsString() @MaxLength(80) profession?: string;
  @IsOptional() @IsString() @MaxLength(200) adresse?: string;
  @IsOptional() @IsString() @MaxLength(40) contactUrgence?: string;
  @IsOptional() @IsIn(['fr', 'en']) preferredLocale?: string;
}

class RegisterDeviceDto {
  @IsString() @IsNotEmpty() @MaxLength(512) token: string;
  @IsIn(['android', 'ios', 'web']) platform: string;
}

@ApiTags('Profil & enfants')
@ApiBearerAuth()
@Controller('api/v1')
export class ChildrenController {
  constructor(
    private readonly prisma: PrismaService,
    private readonly children: ChildrenService,
    private readonly dashboard: DashboardService,
  ) {}

  @Get('me')
  @ApiOperation({ summary: 'Profil de l’utilisateur connecté' })
  async me(@CurrentUser() user: AuthUser) {
    const u = await this.prisma.user.findUniqueOrThrow({
      where: { id: user.id },
      select: {
        id: true,
        email: true,
        telephone: true,
        role: true,
        status: true,
        preferredLocale: true,
        twoFactorEnabled: true,
        lastLoginAt: true,
        parentProfile: true,
        studentProfile: { select: { id: true, matricule: true, nom: true, prenom: true } },
        teacherProfile: { select: { id: true, nom: true, prenom: true, specialite: true } },
      },
    });
    return u;
  }

  @Patch('me')
  async updateMe(@CurrentUser() user: AuthUser, @Body() dto: UpdateMeDto) {
    const { preferredLocale, ...profile } = dto;
    if (preferredLocale) {
      await this.prisma.user.update({ where: { id: user.id }, data: { preferredLocale } });
    }
    if (user.parentId && Object.keys(profile).length) {
      await this.prisma.parent.update({ where: { id: user.parentId }, data: profile });
    }
    return this.me(user);
  }

  @Get('me/children')
  @ApiOperation({ summary: 'Enfants rattachés et validés (sélecteur d’enfant)' })
  myChildren(@CurrentUser() user: AuthUser) {
    return this.children.myChildren(user);
  }

  @Post('me/devices')
  @HttpCode(200)
  @ApiOperation({ summary: 'Enregistre le jeton FCM de l’appareil' })
  async registerDevice(@CurrentUser() user: AuthUser, @Body() dto: RegisterDeviceDto) {
    await this.prisma.deviceToken.upsert({
      where: { token: dto.token },
      create: { token: dto.token, platform: dto.platform, userId: user.id },
      update: { userId: user.id, platform: dto.platform },
    });
    return { success: true };
  }

  @Delete('me/devices/:token')
  async removeDevice(@CurrentUser() user: AuthUser, @Param('token') token: string) {
    await this.prisma.deviceToken.deleteMany({ where: { token, userId: user.id } });
    return { success: true };
  }

  @Get('children/:id')
  @ApiOperation({ summary: 'Fiche étudiant' })
  profile(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.children.profile(user, id);
  }

  @Get('children/:id/dashboard')
  @ApiOperation({ summary: 'Tableau de bord agrégé (finances, présence, notes, aujourd’hui, alertes)' })
  dashboardFor(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.dashboard.forStudent(user, id);
  }
}

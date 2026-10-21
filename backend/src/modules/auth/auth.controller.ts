import { Body, Controller, HttpCode, HttpStatus, Post, Req } from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Request } from 'express';
import { AuthUser } from '../../common/access/child-access.service';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { Public } from '../../common/decorators/roles.decorator';
import { auditCtx } from '../../common/utils/http';
import { env } from '../../config/env';
import { AuthService } from './auth.service';
import {
  ActivateAccountDto,
  ActivationStartDto,
  ChangePasswordDto,
  ForgotPasswordDto,
  LoginDto,
  RefreshTokenDto,
  ResetPasswordDto,
  SendOtpDto,
  TotpCodeDto,
  VerifyOtpDto,
} from './dto/auth.dto';

/** Limite stricte sur les routes sensibles (5 requêtes / minute / IP par défaut). */
const STRICT = { default: { limit: env.authRateLimit, ttl: 60_000 } };

@ApiTags('Authentification')
@Controller('api/v1/auth')
export class AuthController {
  constructor(private readonly auth: AuthService) {}

  @Public()
  @Throttle(STRICT)
  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Connexion email/téléphone + mot de passe (+ code 2FA si activée)' })
  login(@Body() dto: LoginDto, @Req() req: Request) {
    return this.auth.login(dto, auditCtx(req));
  }

  @Public()
  @Throttle(STRICT)
  @Post('otp/send')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Envoi d’un code OTP de connexion par SMS' })
  sendOtp(@Body() dto: SendOtpDto) {
    return this.auth.sendLoginOtp(dto.phone);
  }

  @Public()
  @Throttle(STRICT)
  @Post('otp/verify')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Connexion par téléphone + code OTP' })
  verifyOtp(@Body() dto: VerifyOtpDto, @Req() req: Request) {
    return this.auth.verifyLoginOtp(dto, auditCtx(req));
  }

  @Public()
  @Throttle(STRICT)
  @Post('activate/start')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: "Vérifie le code d'invitation et envoie un OTP au téléphone enregistré" })
  startActivation(@Body() dto: ActivationStartDto) {
    return this.auth.startActivation(dto.activationCode);
  }

  @Public()
  @Throttle(STRICT)
  @Post('activate')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: "Active le compte (code d'invitation + OTP + nouveau mot de passe)" })
  activate(@Body() dto: ActivateAccountDto, @Req() req: Request) {
    return this.auth.activateAccount(dto, auditCtx(req));
  }

  @Public()
  @Throttle({ default: { limit: 20, ttl: 60_000 } })
  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Rotation du refresh token' })
  refresh(@Body() dto: RefreshTokenDto, @Req() req: Request) {
    return this.auth.refresh(dto.refreshToken, auditCtx(req));
  }

  @Public()
  @Throttle(STRICT)
  @Post('forgot-password')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Envoi d’un code de réinitialisation du mot de passe' })
  forgotPassword(@Body() dto: ForgotPasswordDto) {
    return this.auth.forgotPassword(dto.identifier);
  }

  @Public()
  @Throttle(STRICT)
  @Post('reset-password')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Réinitialisation du mot de passe par code' })
  resetPassword(@Body() dto: ResetPasswordDto, @Req() req: Request) {
    return this.auth.resetPassword(dto, auditCtx(req));
  }

  @ApiBearerAuth()
  @Post('logout')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Déconnexion de la session courante' })
  logout(@CurrentUser() user: AuthUser, @Req() req: Request) {
    return this.auth.logout(user.sessionId!, user.id, auditCtx(req));
  }

  @ApiBearerAuth()
  @Post('logout-all')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Déconnexion de tous les appareils' })
  logoutAll(@CurrentUser() user: AuthUser, @Req() req: Request) {
    return this.auth.logoutAll(user.id, auditCtx(req));
  }

  @ApiBearerAuth()
  @Post('change-password')
  @HttpCode(HttpStatus.OK)
  changePassword(@CurrentUser() user: AuthUser, @Body() dto: ChangePasswordDto, @Req() req: Request) {
    return this.auth.changePassword(user.id, dto, auditCtx(req));
  }

  @ApiBearerAuth()
  @Post('2fa/setup')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Génère un secret TOTP (QR à scanner dans une application d’authentification)' })
  setup2fa(@CurrentUser() user: AuthUser) {
    return this.auth.setupTwoFactor(user.id);
  }

  @ApiBearerAuth()
  @Post('2fa/enable')
  @HttpCode(HttpStatus.OK)
  enable2fa(@CurrentUser() user: AuthUser, @Body() dto: TotpCodeDto, @Req() req: Request) {
    return this.auth.enableTwoFactor(user.id, dto.code, auditCtx(req));
  }

  @ApiBearerAuth()
  @Post('2fa/disable')
  @HttpCode(HttpStatus.OK)
  disable2fa(@CurrentUser() user: AuthUser, @Body() dto: TotpCodeDto, @Req() req: Request) {
    return this.auth.disableTwoFactor(user.id, dto.code, auditCtx(req));
  }
}

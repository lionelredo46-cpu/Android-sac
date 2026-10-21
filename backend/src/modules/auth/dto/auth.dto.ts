import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsNotEmpty, IsOptional, IsString, Length, Matches, MaxLength } from 'class-validator';

/** Politique de mot de passe : 8+ caractères, majuscule, minuscule et chiffre. */
export const PASSWORD_REGEX = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,128}$/;
export const PASSWORD_MESSAGE =
  'Le mot de passe doit contenir au moins 8 caractères dont une majuscule, une minuscule et un chiffre';
const PHONE_REGEX = /^\+?[0-9]{8,15}$/;
const OTP_REGEX = /^[0-9]{6}$/;

export class LoginDto {
  @ApiProperty({ example: 'parent@aframgabon.com', description: 'Email ou numéro de téléphone' })
  @IsString()
  @IsNotEmpty({ message: "L'identifiant est requis" })
  @MaxLength(120)
  identifier: string;

  @ApiProperty({ example: 'Afram2026!' })
  @IsString()
  @IsNotEmpty({ message: 'Le mot de passe est requis' })
  @MaxLength(128)
  password: string;

  @ApiPropertyOptional({ description: 'Code TOTP à 6 chiffres si la 2FA est activée' })
  @IsOptional()
  @Matches(OTP_REGEX, { message: 'Le code 2FA doit comporter 6 chiffres' })
  totpCode?: string;
}

export class SendOtpDto {
  @ApiProperty({ example: '+241066701184' })
  @Matches(PHONE_REGEX, { message: 'Numéro de téléphone invalide' })
  phone: string;
}

export class VerifyOtpDto extends SendOtpDto {
  @ApiProperty({ example: '482913' })
  @Matches(OTP_REGEX, { message: 'Le code OTP doit comporter 6 chiffres' })
  code: string;
}

export class ActivationStartDto {
  @ApiProperty({ example: 'AFRAM-2026-ACTIVATE', description: "Code d'invitation reçu par SMS" })
  @IsString()
  @IsNotEmpty({ message: "Le code d'activation est requis" })
  @MaxLength(64)
  activationCode: string;
}

export class ActivateAccountDto extends ActivationStartDto {
  @ApiProperty({ example: '482913', description: 'Code OTP reçu sur le téléphone enregistré' })
  @Matches(OTP_REGEX, { message: 'Le code OTP doit comporter 6 chiffres' })
  otpCode: string;

  @ApiProperty({ example: 'MonNouveauPass2026' })
  @Matches(PASSWORD_REGEX, { message: PASSWORD_MESSAGE })
  newPassword: string;
}

export class RefreshTokenDto {
  @ApiProperty()
  @IsString()
  @IsNotEmpty({ message: 'Le refresh token est requis' })
  @MaxLength(512)
  refreshToken: string;
}

export class ForgotPasswordDto {
  @ApiProperty({ example: '+241066701184', description: 'Email ou téléphone du compte' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(120)
  identifier: string;
}

export class ResetPasswordDto extends ForgotPasswordDto {
  @ApiProperty({ example: '482913' })
  @Matches(OTP_REGEX, { message: 'Le code doit comporter 6 chiffres' })
  code: string;

  @ApiProperty()
  @Matches(PASSWORD_REGEX, { message: PASSWORD_MESSAGE })
  newPassword: string;
}

export class ChangePasswordDto {
  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  @MaxLength(128)
  currentPassword: string;

  @ApiProperty()
  @Matches(PASSWORD_REGEX, { message: PASSWORD_MESSAGE })
  newPassword: string;
}

export class TotpCodeDto {
  @ApiProperty({ example: '123456' })
  @Length(6, 6)
  @Matches(OTP_REGEX, { message: 'Le code doit comporter 6 chiffres' })
  code: string;
}

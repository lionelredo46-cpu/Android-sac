import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { InvoiceLineType, InvoiceStatus, PayerType, PaymentChannel } from '@prisma/client';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsBoolean,
  IsDateString,
  IsEnum,
  IsIn,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsUUID,
  Matches,
  Max,
  MaxLength,
  Min,
  ValidateNested,
} from 'class-validator';

export class InitiatePaymentDto {
  @ApiProperty() @IsUUID() invoiceId: string;

  @ApiProperty({ description: 'Montant entier dans la devise de la facture (FCFA)', example: 150000 })
  @IsInt({ message: 'Le montant doit être un entier' })
  @Min(1)
  @Max(1_000_000_000)
  montant: number;

  @ApiProperty({ enum: ['ONLINE_MOBILE_MONEY', 'ONLINE_CARD'] })
  @IsIn(['ONLINE_MOBILE_MONEY', 'ONLINE_CARD'])
  canal: 'ONLINE_MOBILE_MONEY' | 'ONLINE_CARD';

  @ApiPropertyOptional({ enum: ['SANDBOX', 'CINETPAY', 'STRIPE'] })
  @IsOptional()
  @IsIn(['SANDBOX', 'CINETPAY', 'STRIPE'])
  provider?: 'SANDBOX' | 'CINETPAY' | 'STRIPE';

  @ApiPropertyOptional({ description: 'Numéro Mobile Money à débiter' })
  @IsOptional()
  @Matches(/^\+?[0-9]{8,15}$/, { message: 'Numéro invalide' })
  telephone?: string;
}

export class SandboxConfirmDto {
  @IsBoolean() success: boolean;
}

export class InvoiceQuery {
  @IsOptional() @IsEnum(InvoiceStatus) statut?: InvoiceStatus;
  @IsOptional() @IsUUID() academicYearId?: string;
}

export class PaymentsQuery {
  @IsOptional() @IsDateString() from?: string;
  @IsOptional() @IsDateString() to?: string;
  @IsOptional() @IsIn(['ONLINE', 'GUICHET']) canal?: 'ONLINE' | 'GUICHET';
  @IsOptional() @IsUUID() academicYearId?: string;
}

export class InstallmentRequestDto {
  @ApiProperty() @IsUUID() invoiceId: string;
  @ApiProperty({ minimum: 2, maximum: 12 }) @IsInt() @Min(2) @Max(12) nombreTranches: number;
  @ApiProperty() @IsString() @IsNotEmpty() @MaxLength(500) motif: string;
}

export class ReviewInstallmentDto {
  @IsBoolean() accepter: boolean;
  @IsOptional() @IsString() @MaxLength(500) reponse?: string;
}

export class CashPaymentDto {
  @ApiProperty() @IsUUID() invoiceId: string;
  @ApiProperty() @Type(() => Number) @IsInt() @Min(1) montant: number;
  @ApiProperty({ enum: ['GUICHET_ESPECES', 'GUICHET_CHEQUE', 'GUICHET_VIREMENT'] })
  @IsIn([PaymentChannel.GUICHET_ESPECES, PaymentChannel.GUICHET_CHEQUE, PaymentChannel.GUICHET_VIREMENT])
  canal: 'GUICHET_ESPECES' | 'GUICHET_CHEQUE' | 'GUICHET_VIREMENT';
  @ApiProperty({ enum: PayerType }) @IsEnum(PayerType) payeurType: PayerType;
  @IsOptional() @IsString() @MaxLength(120) payeurNom?: string;
  @IsOptional() @IsString() @MaxLength(120) referenceExterne?: string;
}

export class InvoiceLineDto {
  @IsString() @IsNotEmpty() @MaxLength(120) titre: string;
  @IsEnum(InvoiceLineType) type: InvoiceLineType;
  @IsInt() @Min(1) montant: number;
  @IsDateString() dateLimite: string;
}

export class CreateInvoiceDto {
  @IsUUID() studentId: string;
  @IsUUID() academicYearId: string;
  @IsOptional() @IsIn(['XAF', 'EUR', 'USD']) devise?: string;
  @ValidateNested({ each: true }) @Type(() => InvoiceLineDto) @ArrayMinSize(1) @ArrayMaxSize(30) lines: InvoiceLineDto[];
}

export class BulkInvoiceDto {
  @IsUUID() academicYearId: string;
  @IsOptional() @IsUUID() groupId?: string;
  @IsOptional() @IsUUID() programId?: string;
  @ValidateNested({ each: true }) @Type(() => InvoiceLineDto) @ArrayMinSize(1) @ArrayMaxSize(30) lines: InvoiceLineDto[];
}

export class AdjustInvoiceDto {
  @IsIn(['REMISE', 'BOURSE', 'EXONERATION', 'PENALITE']) type: 'REMISE' | 'BOURSE' | 'EXONERATION' | 'PENALITE';
  @IsInt() @Min(1) montant: number;
  @IsString() @IsNotEmpty() @MaxLength(300) motif: string;
}

export class CancelInvoiceDto {
  @IsString() @IsNotEmpty() @MaxLength(300) motif: string;
}

export class UnpaidQuery {
  @IsOptional() @IsUUID() groupId?: string;
  @IsOptional() @IsUUID() programId?: string;
  @IsOptional() @IsBoolean() overdueOnly?: boolean;
  @IsOptional() @IsIn(['json', 'csv']) format?: 'json' | 'csv';
}

export class JournalQuery {
  @IsOptional() @IsDateString() from?: string;
  @IsOptional() @IsDateString() to?: string;
  @IsOptional() @IsEnum(PaymentChannel) canal?: PaymentChannel;
}

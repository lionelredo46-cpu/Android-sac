import {
  Body,
  Controller,
  Get,
  Param,
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
import { InstallmentStatus } from '@prisma/client';
import { Request, Response } from 'express';
import { AuthUser } from '../../common/access/child-access.service';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { RequirePermissions } from '../../common/decorators/roles.decorator';
import { PERMISSIONS } from '../../common/guards/permissions';
import { MAX_UPLOAD_BYTES, StorageService } from '../../common/storage/storage.service';
import { auditCtx } from '../../common/utils/http';
import {
  AdjustInvoiceDto,
  BulkInvoiceDto,
  CancelInvoiceDto,
  CashPaymentDto,
  CreateInvoiceDto,
  JournalQuery,
  ReviewInstallmentDto,
  UnpaidQuery,
} from './dto/finance.dto';
import { FinanceService } from './finance.service';
import { PaymentsService } from './payments.service';
import { RemindersService } from './reminders.service';

@ApiTags('Back-office · Comptabilité')
@ApiBearerAuth()
@Controller('api/v1/admin/finance')
export class AdminFinanceController {
  constructor(
    private readonly finance: FinanceService,
    private readonly payments: PaymentsService,
    private readonly reminders: RemindersService,
    private readonly storage: StorageService,
  ) {}

  @RequirePermissions(PERMISSIONS.FINANCE_CASH_RECORD)
  @Post('payments/cash')
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('justificatif', { limits: { fileSize: MAX_UPLOAD_BYTES } }))
  @ApiOperation({ summary: 'Saisie d’un versement guichet (espèces, chèque, virement) avec pièce justificative' })
  async cash(
    @CurrentUser() user: AuthUser,
    @Body() dto: CashPaymentDto,
    @UploadedFile() file: Express.Multer.File | undefined,
    @Req() req: Request,
  ) {
    let justificatifUrl: string | undefined;
    if (file) {
      this.storage.validateUpload(file);
      justificatifUrl = (await this.storage.put('justificatifs-paiement', file.buffer, file.mimetype)).key;
    }
    return this.payments.recordCash(user, { ...dto, justificatifUrl }, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.FINANCE_MANAGE)
  @Post('invoices')
  createInvoice(@CurrentUser() user: AuthUser, @Body() dto: CreateInvoiceDto, @Req() req: Request) {
    return this.finance.createInvoice(user, dto, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.FINANCE_MANAGE)
  @Post('invoices/bulk')
  @ApiOperation({ summary: 'Génération en masse des factures pour un groupe ou une filière' })
  bulk(@CurrentUser() user: AuthUser, @Body() dto: BulkInvoiceDto, @Req() req: Request) {
    return this.finance.bulkInvoices(user, dto, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.FINANCE_MANAGE)
  @Post('invoices/:id/adjustments')
  @ApiOperation({ summary: 'Remise, bourse, exonération ou pénalité' })
  adjust(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: AdjustInvoiceDto, @Req() req: Request) {
    return this.finance.adjust(user, id, dto, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.FINANCE_MANAGE)
  @Post('invoices/:id/cancel')
  cancel(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: CancelInvoiceDto, @Req() req: Request) {
    return this.finance.cancelInvoice(user, id, dto.motif, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.FINANCE_READ)
  @Get('unpaid')
  @ApiOperation({ summary: 'État des impayés (JSON ou CSV/Excel)' })
  async unpaid(@Query() q: UnpaidQuery, @Res({ passthrough: true }) res: Response) {
    const rows = await this.finance.unpaid(q);
    if (q.format !== 'csv') return rows;
    res.set({ 'Content-Type': 'text/csv; charset=utf-8', 'Content-Disposition': 'attachment; filename="impayes.csv"' });
    return this.finance.toCsv(rows);
  }

  @RequirePermissions(PERMISSIONS.FINANCE_READ)
  @Get('journal')
  @ApiOperation({ summary: 'Journal des encaissements (rapprochement)' })
  journal(@Query() q: JournalQuery) {
    return this.finance.journal(q);
  }

  @RequirePermissions(PERMISSIONS.FINANCE_MANAGE)
  @Get('installment-requests')
  installments(@Query('statut') statut?: InstallmentStatus) {
    return this.finance.installmentRequests(statut);
  }

  @RequirePermissions(PERMISSIONS.FINANCE_MANAGE)
  @Patch('installment-requests/:id')
  review(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: ReviewInstallmentDto, @Req() req: Request) {
    return this.finance.reviewInstallment(user, id, dto, auditCtx(req));
  }

  @RequirePermissions(PERMISSIONS.FINANCE_MANAGE)
  @Post('reminders/run')
  @ApiOperation({ summary: 'Déclenche manuellement les relances du jour' })
  runReminders() {
    return this.reminders.run();
  }
}

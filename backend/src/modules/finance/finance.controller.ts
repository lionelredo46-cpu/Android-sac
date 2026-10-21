import {
  Body,
  Controller,
  Get,
  Headers,
  HttpCode,
  Param,
  ParseUUIDPipe,
  Post,
  Query,
  RawBodyRequest,
  Req,
  Res,
} from '@nestjs/common';
import { ApiBearerAuth, ApiHeader, ApiOperation, ApiTags } from '@nestjs/swagger';
import { SkipThrottle } from '@nestjs/throttler';
import { Request, Response } from 'express';
import { AuthUser } from '../../common/access/child-access.service';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { Public, RequirePermissions } from '../../common/decorators/roles.decorator';
import { PERMISSIONS } from '../../common/guards/permissions';
import { auditCtx } from '../../common/utils/http';
import {
  InitiatePaymentDto,
  InstallmentRequestDto,
  InvoiceQuery,
  PaymentsQuery,
  SandboxConfirmDto,
} from './dto/finance.dto';
import { FinanceService } from './finance.service';
import { PaymentsService } from './payments.service';
import { ReceiptsService } from './receipts.service';

export function sendPdf(res: Response, file: { filename: string; buffer: Buffer }, inline = false) {
  res.set({
    'Content-Type': 'application/pdf',
    'Content-Disposition': `${inline ? 'inline' : 'attachment'}; filename="${file.filename}"`,
    'Content-Length': file.buffer.length,
    'Cache-Control': 'private, no-store',
  });
  res.end(file.buffer);
}

@ApiTags('Finances')
@Controller('api/v1')
export class FinanceController {
  constructor(
    private readonly finance: FinanceService,
    private readonly payments: PaymentsService,
    private readonly receipts: ReceiptsService,
  ) {}

  @ApiBearerAuth()
  @RequirePermissions(PERMISSIONS.FINANCE_READ)
  @Get('children/:id/invoices')
  @ApiOperation({ summary: 'Échéancier : factures et statut de chaque ligne' })
  invoices(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Query() q: InvoiceQuery) {
    return this.finance.invoices(user, id, q);
  }

  @ApiBearerAuth()
  @RequirePermissions(PERMISSIONS.FINANCE_READ)
  @Get('invoices/:id')
  invoice(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.finance.invoice(user, id);
  }

  @ApiBearerAuth()
  @RequirePermissions(PERMISSIONS.FINANCE_READ)
  @Get('children/:id/payments')
  @ApiOperation({ summary: 'Historique des versements (en ligne et guichet, avec auteur et reçu)' })
  history(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Query() q: PaymentsQuery) {
    return this.finance.payments(user, id, q);
  }

  @ApiBearerAuth()
  @RequirePermissions(PERMISSIONS.FINANCE_READ)
  @Get('children/:id/finance/summary')
  @ApiOperation({ summary: 'Solde par année académique et évolution des versements' })
  summary(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.finance.summary(user, id);
  }

  @ApiBearerAuth()
  @RequirePermissions(PERMISSIONS.FINANCE_READ)
  @Get('children/:id/payment-certificate.pdf')
  async certificate(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Query('academicYearId') yearId: string | undefined, @Res() res: Response) {
    sendPdf(res, await this.receipts.paymentCertificate(user, id, yearId));
  }

  @ApiBearerAuth()
  @Get('payments/providers')
  @ApiOperation({ summary: 'Moyens de paiement disponibles' })
  providers() {
    return this.payments.availableProviders();
  }

  @ApiBearerAuth()
  @RequirePermissions(PERMISSIONS.FINANCE_PAY)
  @Post('payments/initiate')
  @ApiHeader({ name: 'Idempotency-Key', required: true, description: 'UUID unique par intention de paiement' })
  @ApiOperation({ summary: 'Initie un paiement en ligne (total ou partiel)' })
  initiate(
    @CurrentUser() user: AuthUser,
    @Body() dto: InitiatePaymentDto,
    @Headers('idempotency-key') key: string,
    @Req() req: Request,
  ) {
    return this.payments.initiate(user, dto, key, auditCtx(req));
  }

  @ApiBearerAuth()
  @Get('payments/:id/status')
  status(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.payments.status(user, id);
  }

  @ApiBearerAuth()
  @Post('payments/:id/sandbox/confirm')
  @HttpCode(200)
  @ApiOperation({ summary: '[Dev uniquement] Simule la validation côté passerelle sandbox' })
  sandboxConfirm(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: SandboxConfirmDto) {
    return this.payments.sandboxConfirm(user, id, dto.success);
  }

  @Public()
  @SkipThrottle()
  @Post('payments/webhook/:provider')
  @HttpCode(200)
  @ApiOperation({ summary: 'Webhook signé des passerelles de paiement' })
  webhook(@Param('provider') provider: string, @Req() req: RawBodyRequest<Request>) {
    return this.payments.handleWebhook(provider, {
      headers: req.headers,
      rawBody: req.rawBody ?? Buffer.from(JSON.stringify(req.body ?? {})),
      body: req.body,
    });
  }

  @ApiBearerAuth()
  @Get('receipts/:id/pdf')
  async receiptPdf(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Res() res: Response) {
    sendPdf(res, await this.receipts.pdfFor(user, id));
  }

  @Public()
  @Get('receipts/verify/:token')
  @ApiOperation({ summary: 'Vérification publique d’un reçu (QR code)' })
  verify(@Param('token') token: string) {
    return this.receipts.verify(token);
  }

  @ApiBearerAuth()
  @RequirePermissions(PERMISSIONS.FINANCE_READ)
  @Post('installment-requests')
  @ApiOperation({ summary: "Demande d'échelonnement" })
  installment(@CurrentUser() user: AuthUser, @Body() dto: InstallmentRequestDto, @Req() req: Request) {
    return this.finance.requestInstallment(user, dto, auditCtx(req));
  }
}

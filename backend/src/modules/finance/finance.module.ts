import { Module } from '@nestjs/common';
import { AdminFinanceController } from './admin-finance.controller';
import { FinanceController } from './finance.controller';
import { FinanceService } from './finance.service';
import { PaymentsService } from './payments.service';
import { CinetPayProvider } from './providers/cinetpay.provider';
import { SandboxProvider } from './providers/sandbox.provider';
import { StripeProvider } from './providers/stripe.provider';
import { ReceiptsService } from './receipts.service';
import { RemindersService } from './reminders.service';

@Module({
  controllers: [FinanceController, AdminFinanceController],
  providers: [
    FinanceService,
    PaymentsService,
    ReceiptsService,
    RemindersService,
    SandboxProvider,
    CinetPayProvider,
    StripeProvider,
  ],
  exports: [FinanceService, PaymentsService],
})
export class FinanceModule {}

import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { ScheduleModule } from '@nestjs/schedule';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { ChildAccessModule } from './common/access/child-access.service';
import { AuditModule } from './common/audit/audit.service';
import { GuardsModule } from './common/guards/guards.module';
import { JwtAuthGuard } from './common/guards/jwt-auth.guard';
import { RolesGuard } from './common/guards/roles.guard';
import { SmsModule } from './common/sms/sms.service';
import { StorageModule } from './common/storage/storage.service';
import { HealthController } from './health.controller';
import { AdminModule } from './modules/admin/admin.module';
import { AuthModule } from './modules/auth/auth.module';
import { ChildrenModule } from './modules/children/children.module';
import { DocumentsModule } from './modules/documents/documents.module';
import { FinanceModule } from './modules/finance/finance.module';
import { AcademicModule } from './modules/grades/grades.module';
import { MessagingModule } from './modules/messaging/messaging.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { PdfModule } from './modules/pdf/pdf.service';
import { TimetableModule } from './modules/timetable/timetable.module';
import { PrismaModule } from './prisma/prisma.module';

@Module({
  imports: [
    // Limitation de débit globale : 120 requêtes / minute / IP (plus stricte sur l'auth).
    ThrottlerModule.forRoot([{ ttl: 60_000, limit: 120 }]),
    ScheduleModule.forRoot(),
    PrismaModule,
    GuardsModule,
    AuditModule,
    ChildAccessModule,
    StorageModule,
    SmsModule,
    PdfModule,
    NotificationsModule,
    AuthModule,
    ChildrenModule,
    FinanceModule,
    AcademicModule,
    TimetableModule,
    MessagingModule,
    DocumentsModule,
    AdminModule,
  ],
  controllers: [HealthController],
  providers: [
    // Ordre : limitation de débit → authentification JWT → RBAC.
    { provide: APP_GUARD, useClass: ThrottlerGuard },
    { provide: APP_GUARD, useClass: JwtAuthGuard },
    { provide: APP_GUARD, useExisting: RolesGuard },
  ],
})
export class AppModule {}

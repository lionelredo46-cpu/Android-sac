import { Injectable, Logger } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { InvoiceStatus, NotificationCategory } from '@prisma/client';
import { ChildAccessService } from '../../common/access/child-access.service';
import { formatXaf } from '../../common/utils/http';
import { PrismaService } from '../../prisma/prisma.service';
import { NotificationsService } from '../notifications/notifications.service';

const REMINDER_DAYS = [7, 3, 1];
const OVERDUE_REMINDER_DAYS = [1, 7, 15, 30];

/**
 * Relances automatiques (§4.4) : J-7, J-3, J-1 avant échéance, puis J+1, J+7,
 * J+15, J+30 après retard. Tâche quotidienne à 08h00 (heure de Libreville).
 * En production multi-instance, déplacer cette tâche dans une file BullMQ (Redis)
 * pour garantir une exécution unique.
 */
@Injectable()
export class RemindersService {
  private readonly logger = new Logger('Relances');

  constructor(
    private readonly prisma: PrismaService,
    private readonly access: ChildAccessService,
    private readonly notifications: NotificationsService,
  ) {}

  @Cron('0 8 * * *', { timeZone: 'Africa/Libreville' })
  async run(now = new Date()) {
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    let sent = 0;

    const open = await this.prisma.invoice.findMany({
      where: { soldeRestant: { gt: 0n }, statut: { notIn: [InvoiceStatus.ANNULE, InvoiceStatus.PAYE] } },
      include: { student: { select: { prenom: true, nom: true } } },
    });

    for (const inv of open) {
      const due = new Date(inv.dateEcheance.getFullYear(), inv.dateEcheance.getMonth(), inv.dateEcheance.getDate());
      const diff = Math.round((due.getTime() - today.getTime()) / 86_400_000);
      const enfant = `${inv.student.prenom} ${inv.student.nom}`;

      if (diff < 0 && inv.statut !== InvoiceStatus.EN_RETARD) {
        await this.prisma.invoice.update({ where: { id: inv.id }, data: { statut: InvoiceStatus.EN_RETARD } });
      }

      let corps: string | null = null;
      if (REMINDER_DAYS.includes(diff)) {
        corps = `Échéance dans ${diff} jour${diff > 1 ? 's' : ''} : ${formatXaf(inv.soldeRestant)} restent à régler pour ${enfant}.`;
      } else if (diff < 0 && OVERDUE_REMINDER_DAYS.includes(-diff)) {
        corps = `Retard de ${-diff} jour${-diff > 1 ? 's' : ''} : ${formatXaf(inv.soldeRestant)} restent dus pour ${enfant}.`;
      }
      if (!corps) continue;

      const recipients = await this.access.stakeholderUserIds(inv.studentId, { payersOnly: true });
      await this.notifications.notify(recipients, {
        categorie: NotificationCategory.FINANCE,
        titre: diff < 0 ? 'Paiement en retard' : 'Rappel d’échéance',
        corps,
        data: { type: 'PAYMENT_REMINDER', invoiceId: inv.id, studentId: inv.studentId },
        forceSms: diff < 0,
      });
      sent++;
    }
    this.logger.log(`${sent} relance(s) envoyée(s)`);
    return { sent };
  }
}

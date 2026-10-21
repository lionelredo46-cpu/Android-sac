import { Injectable, Logger, NotFoundException, OnModuleInit } from '@nestjs/common';
import { NotificationCategory, NotificationChannel, Prisma } from '@prisma/client';
import * as admin from 'firebase-admin';
import { SmsService } from '../../common/sms/sms.service';
import { clampTake, toCursorPage } from '../../common/utils/http';
import { env } from '../../config/env';
import { PrismaService } from '../../prisma/prisma.service';

export interface NotifyInput {
  categorie: NotificationCategory;
  titre: string;
  corps: string;
  data?: Record<string, string>;
  /** Force l'envoi SMS (ex. urgence) même si la préférence est désactivée. */
  forceSms?: boolean;
}

/** Catégories qui ignorent les heures calmes. */
const URGENT: NotificationCategory[] = [NotificationCategory.URGENCE];

/**
 * Centre de notifications : historise toujours en in-app, puis diffuse
 * en push (FCM) et SMS selon les préférences de chaque utilisateur.
 */
@Injectable()
export class NotificationsService implements OnModuleInit {
  private readonly logger = new Logger('Notifications');
  private messaging: admin.messaging.Messaging | null = null;

  constructor(
    private readonly prisma: PrismaService,
    private readonly sms: SmsService,
  ) {}

  onModuleInit() {
    if (!env.firebaseServiceAccountB64) {
      this.logger.warn('FCM non configuré : notifications push désactivées (in-app uniquement)');
      return;
    }
    const credentials = JSON.parse(Buffer.from(env.firebaseServiceAccountB64, 'base64').toString('utf8'));
    const app = admin.apps.length ? admin.app() : admin.initializeApp({ credential: admin.credential.cert(credentials) });
    this.messaging = app.messaging();
  }

  async notify(userIds: string[], input: NotifyInput) {
    const ids = [...new Set(userIds.filter(Boolean))];
    if (!ids.length) return;

    await this.prisma.notification.createMany({
      data: ids.map((userId) => ({
        userId,
        titre: input.titre,
        corps: input.corps,
        categorie: input.categorie,
        canal: NotificationChannel.IN_APP,
        dataPayload: (input.data ?? {}) as Prisma.InputJsonValue,
      })),
    });

    const [prefs, users, quiet] = await Promise.all([
      this.prisma.notificationPreference.findMany({ where: { userId: { in: ids }, categorie: input.categorie } }),
      this.prisma.user.findMany({
        where: { id: { in: ids } },
        select: { id: true, telephone: true, deviceTokens: { select: { token: true } } },
      }),
      this.isQuietHours(),
    ]);
    const prefByUser = new Map(prefs.map((p) => [p.userId, p]));

    const pushTokens: string[] = [];
    for (const u of users) {
      const pref = prefByUser.get(u.id);
      const wantsPush = pref ? pref.push : true;
      const wantsSms = input.forceSms || (pref ? pref.sms : false);
      const silent = quiet && !URGENT.includes(input.categorie);

      if (wantsPush && !silent) pushTokens.push(...u.deviceTokens.map((d) => d.token));
      if (wantsSms && u.telephone && !silent) {
        await this.sms.send(u.telephone, `${input.titre} — ${input.corps}`);
      }
    }
    await this.sendPush(pushTokens, input);
  }

  private async sendPush(tokens: string[], input: NotifyInput) {
    if (!this.messaging || !tokens.length) return;
    try {
      const res = await this.messaging.sendEachForMulticast({
        tokens,
        notification: { title: input.titre, body: input.corps },
        data: { categorie: input.categorie, ...(input.data ?? {}) },
        android: { priority: 'high', notification: { channelId: input.categorie.toLowerCase() } },
        apns: { payload: { aps: { sound: 'default' } } },
      });
      // Nettoie les jetons invalides (application désinstallée…).
      const dead = res.responses
        .map((r, i) => (!r.success && r.error?.code?.includes('registration-token') ? tokens[i] : null))
        .filter((t): t is string => !!t);
      if (dead.length) await this.prisma.deviceToken.deleteMany({ where: { token: { in: dead } } });
    } catch (e) {
      this.logger.error(`Échec envoi FCM : ${(e as Error).message}`);
    }
  }

  private async isQuietHours(): Promise<boolean> {
    const setting = await this.prisma.appSetting.findUnique({ where: { key: 'notifications.quietHours' } });
    const v = setting?.value as { start?: number; end?: number; enabled?: boolean } | undefined;
    if (!v?.enabled || v.start === undefined || v.end === undefined) return false;
    // Heure de Libreville (UTC+1).
    const hour = (new Date().getUTCHours() + 1) % 24;
    return v.start > v.end ? hour >= v.start || hour < v.end : hour >= v.start && hour < v.end;
  }

  // ------------------------------------------------------------ Lecture côté utilisateur
  async list(userId: string, cursor?: string, take?: number, categorie?: NotificationCategory) {
    const n = clampTake(take);
    const rows = await this.prisma.notification.findMany({
      where: { userId, ...(categorie ? { categorie } : {}) },
      orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
      take: n + 1,
      ...(cursor ? { cursor: { id: cursor }, skip: 1 } : {}),
    });
    return toCursorPage(rows, n);
  }

  unreadCount(userId: string) {
    return this.prisma.notification.count({ where: { userId, estLu: false } }).then((count) => ({ count }));
  }

  async markRead(userId: string, id: string) {
    const res = await this.prisma.notification.updateMany({
      where: { id, userId },
      data: { estLu: true, luLe: new Date() },
    });
    if (!res.count) throw new NotFoundException('Notification introuvable');
    return { success: true };
  }

  async markAllRead(userId: string) {
    await this.prisma.notification.updateMany({
      where: { userId, estLu: false },
      data: { estLu: true, luLe: new Date() },
    });
    return { success: true };
  }

  async preferences(userId: string) {
    const rows = await this.prisma.notificationPreference.findMany({ where: { userId } });
    return Object.values(NotificationCategory).map((categorie) => {
      const r = rows.find((p) => p.categorie === categorie);
      return { categorie, push: r?.push ?? true, sms: r?.sms ?? false, email: r?.email ?? false };
    });
  }

  async updatePreferences(
    userId: string,
    items: { categorie: NotificationCategory; push: boolean; sms: boolean; email: boolean }[],
  ) {
    await this.prisma.$transaction(
      items.map((i) =>
        this.prisma.notificationPreference.upsert({
          where: { userId_categorie: { userId, categorie: i.categorie } },
          create: { userId, ...i },
          update: { push: i.push, sms: i.sms, email: i.email },
        }),
      ),
    );
    return this.preferences(userId);
  }
}

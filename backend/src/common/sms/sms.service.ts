import { Global, Injectable, Logger, Module } from '@nestjs/common';

/**
 * Envoi de SMS / WhatsApp. Le pilote par défaut journalise le message
 * (développement). Brancher ici l'agrégateur retenu (Twilio, Africa's Talking,
 * WhatsApp Business API…) sans toucher aux appelants.
 */
@Injectable()
export class SmsService {
  private readonly logger = new Logger('SMS');

  async send(to: string, message: string): Promise<void> {
    this.logger.log(`→ ${to} : ${message}`);
  }
}

@Global()
@Module({
  providers: [SmsService],
  exports: [SmsService],
})
export class SmsModule {}

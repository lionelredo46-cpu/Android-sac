import { Global, Module } from '@nestjs/common';
import { RolesGuard } from './roles.guard';

/** Instance unique du garde RBAC (partagée avec l'admin pour invalider le cache des permissions). */
@Global()
@Module({ providers: [RolesGuard], exports: [RolesGuard] })
export class GuardsModule {}

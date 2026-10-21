import { Global, Module } from '@nestjs/common';
import { ChildrenController } from './children.controller';
import { ChildrenService } from './children.service';
import { DashboardService } from './dashboard.service';

@Global()
@Module({
  controllers: [ChildrenController],
  providers: [ChildrenService, DashboardService],
  exports: [ChildrenService],
})
export class ChildrenModule {}

import { Module } from '@nestjs/common';
import { AttendanceController } from '../attendance/attendance.controller';
import { AttendanceService } from '../attendance/attendance.service';
import { GradesController } from './grades.controller';
import { GradesService } from './grades.service';

/** Suivi pédagogique : présences (module 5) et notes (module 6). */
@Module({
  controllers: [AttendanceController, GradesController],
  providers: [AttendanceService, GradesService],
})
export class AcademicModule {}

import { Module } from '@nestjs/common';
import { PrismaModule } from './prisma/prisma.module';
import { AuthModule } from './auth/auth.module';
import { EmployeesModule } from './employees/employees.module';
import { LeaveModule } from './leave/leave.module';
import { AttendanceModule } from './attendance/attendance.module';
import { PayrollModule } from './payroll/payroll.module';
import { AuditModule } from './audit/audit.module';

@Module({
  imports: [
    PrismaModule,
    AuthModule,
    EmployeesModule,
    LeaveModule,
    AttendanceModule,
    PayrollModule,
    AuditModule,
  ],
})
export class AppModule { }

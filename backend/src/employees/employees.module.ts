import { Module } from '@nestjs/common';
import { EmployeesService } from './employees.service';
import { EmployeesController } from './employees.controller';
import { RolesGuard } from '../auth/roles.guard';

@Module({
    controllers: [EmployeesController],
    providers: [EmployeesService, RolesGuard],
    exports: [EmployeesService],
})
export class EmployeesModule { }

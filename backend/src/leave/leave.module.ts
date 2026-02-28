import { Module } from '@nestjs/common';
import { LeaveService } from './leave.service';
import { LeaveController } from './leave.controller';
import { RolesGuard } from '../auth/roles.guard';

@Module({
    controllers: [LeaveController],
    providers: [LeaveService, RolesGuard],
    exports: [LeaveService],
})
export class LeaveModule { }

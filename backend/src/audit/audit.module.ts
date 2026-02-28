import { Module } from '@nestjs/common';
import { AuditService } from './audit.service';
import { AuditController } from './audit.controller';
import { RolesGuard } from '../auth/roles.guard';

@Module({
    controllers: [AuditController],
    providers: [AuditService, RolesGuard],
    exports: [AuditService],
})
export class AuditModule { }

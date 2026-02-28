import { Controller, Get, UseGuards, Query } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { AuditService } from './audit.service';
import { Roles, RolesGuard } from '../auth/roles.guard';

@UseGuards(AuthGuard('jwt'), RolesGuard)
@Roles('ADMIN')
@Controller('audit')
export class AuditController {
    constructor(private auditService: AuditService) { }

    @Get()
    findAll(@Query('limit') limit?: number) {
        return this.auditService.findAll(limit || 50);
    }
}

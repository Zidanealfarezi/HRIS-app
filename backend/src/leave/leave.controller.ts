import {
    Controller, Get, Post, Patch, Body, Param, Query,
    UseGuards, ParseIntPipe, Request,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { LeaveService } from './leave.service';
import { CreateLeaveDto, UpdateLeaveStatusDto, QueryLeaveDto } from './dto/leave.dto';
import { Roles, RolesGuard } from '../auth/roles.guard';

@UseGuards(AuthGuard('jwt'))
@Controller('leave')
export class LeaveController {
    constructor(private leaveService: LeaveService) { }

    @Get()
    findAll(@Query() query: QueryLeaveDto) {
        return this.leaveService.findAll(query);
    }

    @Get('pending-count')
    getPendingCount() {
        return this.leaveService.getPendingCount();
    }

    @Get('balance/:employeeId')
    getBalance(@Param('employeeId', ParseIntPipe) employeeId: number) {
        return this.leaveService.getBalance(employeeId);
    }

    @Get(':id')
    findOne(@Param('id', ParseIntPipe) id: number) {
        return this.leaveService.findOne(id);
    }

    @Post()
    create(@Body() dto: CreateLeaveDto) {
        return this.leaveService.create(dto);
    }

    @UseGuards(RolesGuard)
    @Roles('ADMIN')
    @Patch(':id/approve')
    approve(@Param('id', ParseIntPipe) id: number, @Request() req: any) {
        return this.leaveService.updateStatus(id, {
            status: 'APPROVED',
            approvedBy: req.user.email,
        });
    }

    @UseGuards(RolesGuard)
    @Roles('ADMIN')
    @Patch(':id/reject')
    reject(@Param('id', ParseIntPipe) id: number, @Request() req: any) {
        return this.leaveService.updateStatus(id, {
            status: 'REJECTED',
            approvedBy: req.user.email,
        });
    }
}

import {
    Controller, Get, Post, Query, UseGuards, Request, Param, ParseIntPipe,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { AttendanceService } from './attendance.service';

@UseGuards(AuthGuard('jwt'))
@Controller('attendance')
export class AttendanceController {
    constructor(private attendanceService: AttendanceService) { }

    @Get()
    findAll(
        @Query('employeeId') employeeId?: number,
        @Query('startDate') startDate?: string,
        @Query('endDate') endDate?: string,
    ) {
        return this.attendanceService.findAll(employeeId, startDate, endDate);
    }

    @Get('today-count')
    getTodayCount() {
        return this.attendanceService.getTodayCount();
    }

    @Get('weekly-trend')
    getWeeklyTrend() {
        return this.attendanceService.getWeeklyTrend();
    }

    @Post('check-in')
    checkIn(@Request() req: any) {
        return this.attendanceService.checkIn(req.user.employeeId);
    }

    @Post('check-out')
    checkOut(@Request() req: any) {
        return this.attendanceService.checkOut(req.user.employeeId);
    }
}

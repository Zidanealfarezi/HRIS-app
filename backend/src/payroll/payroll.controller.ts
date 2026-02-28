import { Controller, Get, Param, UseGuards, ParseIntPipe } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { PayrollService } from './payroll.service';

@UseGuards(AuthGuard('jwt'))
@Controller('payroll')
export class PayrollController {
    constructor(private payrollService: PayrollService) { }

    @Get()
    getAll() {
        return this.payrollService.getAll();
    }

    @Get('employee/:employeeId')
    findByEmployee(@Param('employeeId', ParseIntPipe) employeeId: number) {
        return this.payrollService.findByEmployee(employeeId);
    }

    @Get(':id')
    findOne(@Param('id', ParseIntPipe) id: number) {
        return this.payrollService.findOne(id);
    }
}

import {
    Controller, Get, Post, Patch, Delete,
    Body, Param, Query, UseGuards, ParseIntPipe,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { EmployeesService } from './employees.service';
import { CreateEmployeeDto, UpdateEmployeeDto, QueryEmployeeDto } from './dto/employee.dto';
import { Roles, RolesGuard } from '../auth/roles.guard';

@UseGuards(AuthGuard('jwt'))
@Controller('employees')
export class EmployeesController {
    constructor(private employeesService: EmployeesService) { }

    @Get()
    findAll(@Query() query: QueryEmployeeDto) {
        return this.employeesService.findAll(query);
    }

    @Get('stats')
    getStats() {
        return this.employeesService.getStats();
    }

    @Get('department-stats')
    getDepartmentStats() {
        return this.employeesService.getDepartmentStats();
    }

    @Get(':id')
    findOne(@Param('id', ParseIntPipe) id: number) {
        return this.employeesService.findOne(id);
    }

    @UseGuards(RolesGuard)
    @Roles('ADMIN')
    @Post()
    create(@Body() dto: CreateEmployeeDto) {
        return this.employeesService.create(dto);
    }

    @UseGuards(RolesGuard)
    @Roles('ADMIN')
    @Patch(':id')
    update(@Param('id', ParseIntPipe) id: number, @Body() dto: UpdateEmployeeDto) {
        return this.employeesService.update(id, dto);
    }

    @UseGuards(RolesGuard)
    @Roles('ADMIN')
    @Delete(':id')
    remove(@Param('id', ParseIntPipe) id: number) {
        return this.employeesService.remove(id);
    }
}

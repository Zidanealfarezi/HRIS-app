import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateEmployeeDto, UpdateEmployeeDto, QueryEmployeeDto } from './dto/employee.dto';
import { Prisma } from '@prisma/client';

@Injectable()
export class EmployeesService {
    constructor(private prisma: PrismaService) { }

    async findAll(query: QueryEmployeeDto) {
        const where: Prisma.EmployeeWhereInput = {};

        if (query.search) {
            where.OR = [
                { name: { contains: query.search, mode: 'insensitive' } },
                { position: { contains: query.search, mode: 'insensitive' } },
                { department: { contains: query.search, mode: 'insensitive' } },
            ];
        }
        if (query.department) {
            where.department = query.department;
        }
        if (query.status) {
            where.status = query.status;
        }
        if (query.location) {
            where.location = query.location;
        }

        return this.prisma.employee.findMany({
            where,
            orderBy: { name: 'asc' },
            include: { user: { select: { id: true, email: true, role: true } } },
        });
    }

    async findOne(id: number) {
        const employee = await this.prisma.employee.findUnique({
            where: { id },
            include: {
                user: { select: { id: true, email: true, role: true } },
                leaveRequests: { orderBy: { createdAt: 'desc' }, take: 10 },
                payrollRecords: { orderBy: { createdAt: 'desc' }, take: 5 },
            },
        });
        if (!employee) throw new NotFoundException('Karyawan tidak ditemukan');
        return employee;
    }

    async create(dto: CreateEmployeeDto) {
        return this.prisma.employee.create({
            data: {
                ...dto,
                joinDate: new Date(dto.joinDate),
            },
        });
    }

    async update(id: number, dto: UpdateEmployeeDto) {
        await this.findOne(id);
        return this.prisma.employee.update({
            where: { id },
            data: {
                ...dto,
                joinDate: dto.joinDate ? new Date(dto.joinDate) : undefined,
            },
        });
    }

    async remove(id: number) {
        await this.findOne(id);
        return this.prisma.employee.update({
            where: { id },
            data: { status: 'DIBERHENTIKAN' },
        });
    }

    async getDepartmentStats() {
        const employees = await this.prisma.employee.groupBy({
            by: ['department'],
            _count: { id: true },
            where: { status: { not: 'DIBERHENTIKAN' } },
        });
        return employees.map((e) => ({
            department: e.department,
            count: e._count.id,
        }));
    }

    async getStats() {
        const [total, active, onLeave, departments] = await Promise.all([
            this.prisma.employee.count(),
            this.prisma.employee.count({ where: { status: 'AKTIF' } }),
            this.prisma.employee.count({ where: { status: 'CUTI' } }),
            this.prisma.employee.groupBy({
                by: ['department'],
                _count: { id: true },
            }),
        ]);
        return {
            total,
            active,
            onLeave,
            departmentCount: departments.length,
        };
    }
}

import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class PayrollService {
    constructor(private prisma: PrismaService) { }

    async findByEmployee(employeeId: number) {
        return this.prisma.payrollRecord.findMany({
            where: { employeeId },
            orderBy: { periodStart: 'desc' },
            include: {
                employee: { select: { id: true, name: true, position: true, department: true, avatar: true } },
            },
        });
    }

    async findOne(id: number) {
        const record = await this.prisma.payrollRecord.findUnique({
            where: { id },
            include: {
                employee: true,
            },
        });
        if (!record) throw new NotFoundException('Slip gaji tidak ditemukan');
        return record;
    }

    async getAll() {
        return this.prisma.payrollRecord.findMany({
            orderBy: { createdAt: 'desc' },
            include: {
                employee: { select: { id: true, name: true, position: true, department: true } },
            },
        });
    }
}

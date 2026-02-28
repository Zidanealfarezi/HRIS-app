import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateLeaveDto, UpdateLeaveStatusDto, QueryLeaveDto } from './dto/leave.dto';
import { Prisma } from '@prisma/client';

@Injectable()
export class LeaveService {
    constructor(private prisma: PrismaService) { }

    async findAll(query: QueryLeaveDto) {
        const where: Prisma.LeaveRequestWhereInput = {};

        if (query.employeeId) where.employeeId = Number(query.employeeId);
        if (query.status) where.status = query.status;
        if (query.type) where.type = query.type;

        return this.prisma.leaveRequest.findMany({
            where,
            orderBy: { createdAt: 'desc' },
            include: {
                employee: { select: { id: true, name: true, position: true, department: true, avatar: true } },
            },
        });
    }

    async findOne(id: number) {
        const leave = await this.prisma.leaveRequest.findUnique({
            where: { id },
            include: {
                employee: { select: { id: true, name: true, position: true, department: true, avatar: true } },
            },
        });
        if (!leave) throw new NotFoundException('Permintaan cuti tidak ditemukan');
        return leave;
    }

    async create(dto: CreateLeaveDto) {
        // Check leave balance
        const employee = await this.prisma.employee.findUnique({
            where: { id: dto.employeeId },
        });
        if (!employee) throw new NotFoundException('Karyawan tidak ditemukan');

        if (dto.type === 'ANNUAL' && employee.leaveBalance < dto.days) {
            throw new BadRequestException(`Sisa cuti tidak cukup. Tersisa ${employee.leaveBalance} hari.`);
        }

        return this.prisma.leaveRequest.create({
            data: {
                employeeId: dto.employeeId,
                type: dto.type,
                startDate: new Date(dto.startDate),
                endDate: new Date(dto.endDate),
                days: dto.days,
                reason: dto.reason,
            },
            include: {
                employee: { select: { id: true, name: true, position: true, avatar: true } },
            },
        });
    }

    async updateStatus(id: number, dto: UpdateLeaveStatusDto) {
        const leave = await this.findOne(id);

        if (leave.status !== 'PENDING') {
            throw new BadRequestException('Hanya permintaan dengan status Menunggu yang bisa diubah');
        }

        // If approved and it's annual leave, deduct balance
        if (dto.status === 'APPROVED' && leave.type === 'ANNUAL') {
            await this.prisma.employee.update({
                where: { id: leave.employeeId },
                data: { leaveBalance: { decrement: leave.days } },
            });
        }

        return this.prisma.leaveRequest.update({
            where: { id },
            data: {
                status: dto.status,
                approvedBy: dto.approvedBy,
            },
            include: {
                employee: { select: { id: true, name: true, position: true, avatar: true } },
            },
        });
    }

    async getBalance(employeeId: number) {
        const employee = await this.prisma.employee.findUnique({
            where: { id: employeeId },
            select: { leaveBalance: true },
        });
        if (!employee) throw new NotFoundException('Karyawan tidak ditemukan');

        const usedDays = await this.prisma.leaveRequest.aggregate({
            where: { employeeId, status: 'APPROVED', type: 'ANNUAL' },
            _sum: { days: true },
        });

        return {
            total: 12,
            used: usedDays._sum.days || 0,
            remaining: employee.leaveBalance,
        };
    }

    async getPendingCount() {
        return this.prisma.leaveRequest.count({ where: { status: 'PENDING' } });
    }
}

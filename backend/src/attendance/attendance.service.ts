import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { Prisma } from '@prisma/client';

@Injectable()
export class AttendanceService {
    constructor(private prisma: PrismaService) { }

    async findAll(employeeId?: number, startDate?: string, endDate?: string) {
        const where: Prisma.AttendanceWhereInput = {};
        if (employeeId) where.employeeId = Number(employeeId);
        if (startDate || endDate) {
            where.date = {};
            if (startDate) (where.date as any).gte = new Date(startDate);
            if (endDate) (where.date as any).lte = new Date(endDate);
        }

        return this.prisma.attendance.findMany({
            where,
            orderBy: { date: 'desc' },
            include: {
                employee: { select: { id: true, name: true, position: true, department: true, avatar: true } },
            },
        });
    }

    async checkIn(employeeId: number) {
        const today = new Date();
        today.setHours(0, 0, 0, 0);

        return this.prisma.attendance.upsert({
            where: { employeeId_date: { employeeId, date: today } },
            update: { checkIn: new Date() },
            create: {
                employeeId,
                date: today,
                checkIn: new Date(),
                status: 'HADIR',
            },
        });
    }

    async checkOut(employeeId: number) {
        const today = new Date();
        today.setHours(0, 0, 0, 0);

        return this.prisma.attendance.update({
            where: { employeeId_date: { employeeId, date: today } },
            data: { checkOut: new Date() },
        });
    }

    async getTodayCount() {
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        const tomorrow = new Date(today);
        tomorrow.setDate(tomorrow.getDate() + 1);

        return this.prisma.attendance.count({
            where: {
                date: { gte: today, lt: tomorrow },
                status: 'HADIR',
            },
        });
    }

    async getWeeklyTrend() {
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        const weekAgo = new Date(today);
        weekAgo.setDate(weekAgo.getDate() - 7);

        const attendances = await this.prisma.attendance.groupBy({
            by: ['date'],
            _count: { id: true },
            where: {
                date: { gte: weekAgo, lte: today },
                status: 'HADIR',
            },
            orderBy: { date: 'asc' },
        });

        return attendances.map((a) => ({
            date: a.date,
            count: a._count.id,
        }));
    }
}

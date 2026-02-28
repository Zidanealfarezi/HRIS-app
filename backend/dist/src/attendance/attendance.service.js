"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AttendanceService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let AttendanceService = class AttendanceService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async findAll(employeeId, startDate, endDate) {
        const where = {};
        if (employeeId)
            where.employeeId = Number(employeeId);
        if (startDate || endDate) {
            where.date = {};
            if (startDate)
                where.date.gte = new Date(startDate);
            if (endDate)
                where.date.lte = new Date(endDate);
        }
        return this.prisma.attendance.findMany({
            where,
            orderBy: { date: 'desc' },
            include: {
                employee: { select: { id: true, name: true, position: true, department: true, avatar: true } },
            },
        });
    }
    async checkIn(employeeId) {
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
    async checkOut(employeeId) {
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
};
exports.AttendanceService = AttendanceService;
exports.AttendanceService = AttendanceService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], AttendanceService);
//# sourceMappingURL=attendance.service.js.map
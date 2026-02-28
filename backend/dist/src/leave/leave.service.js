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
exports.LeaveService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let LeaveService = class LeaveService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async findAll(query) {
        const where = {};
        if (query.employeeId)
            where.employeeId = Number(query.employeeId);
        if (query.status)
            where.status = query.status;
        if (query.type)
            where.type = query.type;
        return this.prisma.leaveRequest.findMany({
            where,
            orderBy: { createdAt: 'desc' },
            include: {
                employee: { select: { id: true, name: true, position: true, department: true, avatar: true } },
            },
        });
    }
    async findOne(id) {
        const leave = await this.prisma.leaveRequest.findUnique({
            where: { id },
            include: {
                employee: { select: { id: true, name: true, position: true, department: true, avatar: true } },
            },
        });
        if (!leave)
            throw new common_1.NotFoundException('Permintaan cuti tidak ditemukan');
        return leave;
    }
    async create(dto) {
        const employee = await this.prisma.employee.findUnique({
            where: { id: dto.employeeId },
        });
        if (!employee)
            throw new common_1.NotFoundException('Karyawan tidak ditemukan');
        if (dto.type === 'ANNUAL' && employee.leaveBalance < dto.days) {
            throw new common_1.BadRequestException(`Sisa cuti tidak cukup. Tersisa ${employee.leaveBalance} hari.`);
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
    async updateStatus(id, dto) {
        const leave = await this.findOne(id);
        if (leave.status !== 'PENDING') {
            throw new common_1.BadRequestException('Hanya permintaan dengan status Menunggu yang bisa diubah');
        }
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
    async getBalance(employeeId) {
        const employee = await this.prisma.employee.findUnique({
            where: { id: employeeId },
            select: { leaveBalance: true },
        });
        if (!employee)
            throw new common_1.NotFoundException('Karyawan tidak ditemukan');
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
};
exports.LeaveService = LeaveService;
exports.LeaveService = LeaveService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], LeaveService);
//# sourceMappingURL=leave.service.js.map
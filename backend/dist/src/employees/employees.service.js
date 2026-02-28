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
exports.EmployeesService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let EmployeesService = class EmployeesService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async findAll(query) {
        const where = {};
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
    async findOne(id) {
        const employee = await this.prisma.employee.findUnique({
            where: { id },
            include: {
                user: { select: { id: true, email: true, role: true } },
                leaveRequests: { orderBy: { createdAt: 'desc' }, take: 10 },
                payrollRecords: { orderBy: { createdAt: 'desc' }, take: 5 },
            },
        });
        if (!employee)
            throw new common_1.NotFoundException('Karyawan tidak ditemukan');
        return employee;
    }
    async create(dto) {
        return this.prisma.employee.create({
            data: {
                ...dto,
                joinDate: new Date(dto.joinDate),
            },
        });
    }
    async update(id, dto) {
        await this.findOne(id);
        return this.prisma.employee.update({
            where: { id },
            data: {
                ...dto,
                joinDate: dto.joinDate ? new Date(dto.joinDate) : undefined,
            },
        });
    }
    async remove(id) {
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
};
exports.EmployeesService = EmployeesService;
exports.EmployeesService = EmployeesService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], EmployeesService);
//# sourceMappingURL=employees.service.js.map
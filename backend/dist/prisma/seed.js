"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const bcrypt = __importStar(require("bcrypt"));
const prisma = new client_1.PrismaClient();
async function main() {
    console.log('🌱 Seeding database...');
    await prisma.auditLog.deleteMany();
    await prisma.payrollRecord.deleteMany();
    await prisma.attendance.deleteMany();
    await prisma.leaveRequest.deleteMany();
    await prisma.user.deleteMany();
    await prisma.employee.deleteMany();
    const employees = await Promise.all([
        prisma.employee.create({
            data: {
                name: 'Sarah Johnson',
                position: 'UX Designer',
                department: 'Product',
                status: 'AKTIF',
                location: 'Jakarta',
                joinDate: new Date('2021-03-15'),
                phone: '081234567890',
                email: 'sarah@company.com',
                leaveBalance: 10,
            },
        }),
        prisma.employee.create({
            data: {
                name: 'Michael Chen',
                position: 'Backend Dev',
                department: 'Engineering',
                status: 'CUTI',
                location: 'Jakarta',
                joinDate: new Date('2020-06-01'),
                phone: '081234567891',
                email: 'michael@company.com',
                leaveBalance: 8,
            },
        }),
        prisma.employee.create({
            data: {
                name: 'Amanda Lee',
                position: 'HR Manager',
                department: 'Human Resources',
                status: 'AKTIF',
                location: 'Jakarta',
                joinDate: new Date('2019-01-10'),
                phone: '081234567892',
                email: 'amanda@company.com',
                leaveBalance: 12,
            },
        }),
        prisma.employee.create({
            data: {
                name: 'David Wright',
                position: 'Sales Rep',
                department: 'Sales',
                status: 'DIBERHENTIKAN',
                location: 'Bandung',
                joinDate: new Date('2022-08-20'),
                phone: '081234567893',
                email: 'david@company.com',
                leaveBalance: 12,
            },
        }),
        prisma.employee.create({
            data: {
                name: 'Budi Santoso',
                position: 'Senior Developer',
                department: 'Engineering',
                status: 'AKTIF',
                location: 'Jakarta',
                joinDate: new Date('2019-04-01'),
                phone: '081234567894',
                email: 'budi@company.com',
                bankAccount: '1234567890',
                npwp: '12.345.678.9-012.000',
                leaveBalance: 12,
            },
        }),
        prisma.employee.create({
            data: {
                name: 'Zidane',
                position: 'Software Engineer',
                department: 'Engineering',
                status: 'AKTIF',
                location: 'Jakarta',
                joinDate: new Date('2023-01-15'),
                phone: '081234567895',
                email: 'zidane@company.com',
                bankAccount: '0987654321',
                npwp: '98.765.432.1-098.000',
                leaveBalance: 12,
            },
        }),
    ]);
    console.log(`✅ Created ${employees.length} employees`);
    const hashedPassword = await bcrypt.hash('password123', 10);
    await Promise.all([
        prisma.user.create({
            data: {
                email: 'admin@hris.com',
                password: hashedPassword,
                role: 'ADMIN',
                employeeId: employees[2].id,
            },
        }),
        prisma.user.create({
            data: {
                email: 'budi@hris.com',
                password: hashedPassword,
                role: 'EMPLOYEE',
                employeeId: employees[4].id,
            },
        }),
        prisma.user.create({
            data: {
                email: 'zidane@hris.com',
                password: hashedPassword,
                role: 'EMPLOYEE',
                employeeId: employees[5].id,
            },
        }),
    ]);
    console.log('✅ Created users (admin@hris.com / budi@hris.com / zidane@hris.com — password: password123)');
    await Promise.all([
        prisma.leaveRequest.create({
            data: {
                employeeId: employees[0].id,
                type: 'ANNUAL',
                startDate: new Date('2023-10-24'),
                endDate: new Date('2023-10-26'),
                days: 3,
                reason: 'Family vacation planned for months.',
                status: 'PENDING',
            },
        }),
        prisma.leaveRequest.create({
            data: {
                employeeId: employees[1].id,
                type: 'SICK',
                startDate: new Date('2023-10-28'),
                endDate: new Date('2023-10-28'),
                days: 1,
                reason: 'Tidak enak badan',
                status: 'PENDING',
            },
        }),
        prisma.leaveRequest.create({
            data: {
                employeeId: employees[0].id,
                type: 'REMOTE_WORK',
                startDate: new Date('2023-11-01'),
                endDate: new Date('2023-11-05'),
                days: 5,
                reason: 'Remote work from home',
                status: 'PENDING',
            },
        }),
        prisma.leaveRequest.create({
            data: {
                employeeId: employees[4].id,
                type: 'ANNUAL',
                startDate: new Date('2023-09-12'),
                endDate: new Date('2023-09-14'),
                days: 3,
                reason: 'Melakukan perjalanan singkat untuk mengunjungi keluarga.',
                status: 'PENDING',
            },
        }),
        prisma.leaveRequest.create({
            data: {
                employeeId: employees[4].id,
                type: 'SICK',
                startDate: new Date('2023-08-05'),
                endDate: new Date('2023-08-05'),
                days: 1,
                reason: 'Demam',
                status: 'APPROVED',
                approvedBy: 'admin@hris.com',
            },
        }),
        prisma.leaveRequest.create({
            data: {
                employeeId: employees[4].id,
                type: 'UNPAID',
                startDate: new Date('2023-08-01'),
                endDate: new Date('2023-08-02'),
                days: 2,
                reason: 'Urusan pribadi',
                status: 'REJECTED',
                approvedBy: 'admin@hris.com',
            },
        }),
        prisma.leaveRequest.create({
            data: {
                employeeId: employees[4].id,
                type: 'ANNUAL',
                startDate: new Date('2023-07-10'),
                endDate: new Date('2023-07-12'),
                days: 3,
                reason: 'Liburan',
                status: 'APPROVED',
                approvedBy: 'admin@hris.com',
            },
        }),
    ]);
    console.log('✅ Created 7 leave requests');
    const today = new Date();
    for (let i = 0; i < 7; i++) {
        const date = new Date(today);
        date.setDate(date.getDate() - i);
        date.setHours(0, 0, 0, 0);
        const checkIn = new Date(date);
        checkIn.setHours(8, Math.floor(Math.random() * 30), 0, 0);
        const checkOut = new Date(date);
        checkOut.setHours(17, Math.floor(Math.random() * 30), 0, 0);
        for (const emp of [employees[0], employees[2], employees[4], employees[5]]) {
            await prisma.attendance.create({
                data: {
                    employeeId: emp.id,
                    date,
                    checkIn,
                    checkOut,
                    status: Math.random() > 0.1 ? 'HADIR' : 'TERLAMBAT',
                },
            });
        }
    }
    console.log('✅ Created attendance records (7 days)');
    await Promise.all([
        prisma.payrollRecord.create({
            data: {
                employeeId: employees[5].id,
                period: 'Februari 2026',
                periodStart: new Date('2026-02-01'),
                periodEnd: new Date('2026-02-28'),
                baseSalary: 15000000,
                allowances: [
                    { name: 'Tunjangan Perumahan', amount: 2000000 },
                    { name: 'Tunjangan Transportasi', amount: 1000000 },
                    { name: 'Lembur (12h)', amount: 1500000 },
                ],
                deductions: [
                    { name: 'Pajak (PPh 21)', amount: 750000 },
                    { name: 'BPJS Kesehatan', amount: 150000 },
                    { name: 'Cuti Tanpa Tanggungan (1 hari)', amount: 500000 },
                ],
                netPay: 18100000,
                paidAt: new Date('2026-02-25'),
            },
        }),
        prisma.payrollRecord.create({
            data: {
                employeeId: employees[4].id,
                period: 'September 2023',
                periodStart: new Date('2023-09-01'),
                periodEnd: new Date('2023-09-30'),
                baseSalary: 18000000,
                allowances: [
                    { name: 'Tunjangan Perumahan', amount: 3000000 },
                    { name: 'Tunjangan Transportasi', amount: 1500000 },
                ],
                deductions: [
                    { name: 'Pajak (PPh 21)', amount: 900000 },
                    { name: 'BPJS Kesehatan', amount: 200000 },
                ],
                netPay: 21400000,
                paidAt: new Date('2023-09-25'),
            },
        }),
        prisma.payrollRecord.create({
            data: {
                employeeId: employees[4].id,
                period: 'Agustus 2023',
                periodStart: new Date('2023-08-01'),
                periodEnd: new Date('2023-08-31'),
                baseSalary: 18000000,
                allowances: [
                    { name: 'Tunjangan Perumahan', amount: 3000000 },
                    { name: 'Tunjangan Transportasi', amount: 1500000 },
                ],
                deductions: [
                    { name: 'Pajak (PPh 21)', amount: 900000 },
                    { name: 'BPJS Kesehatan', amount: 200000 },
                ],
                netPay: 21400000,
                paidAt: new Date('2023-08-25'),
            },
        }),
        prisma.payrollRecord.create({
            data: {
                employeeId: employees[4].id,
                period: 'Juli 2023',
                periodStart: new Date('2023-07-01'),
                periodEnd: new Date('2023-07-31'),
                baseSalary: 18000000,
                allowances: [
                    { name: 'Tunjangan Perumahan', amount: 3000000 },
                    { name: 'Tunjangan Transportasi', amount: 1500000 },
                ],
                deductions: [
                    { name: 'Pajak (PPh 21)', amount: 900000 },
                    { name: 'BPJS Kesehatan', amount: 200000 },
                ],
                netPay: 21400000,
                paidAt: new Date('2023-07-25'),
            },
        }),
    ]);
    console.log('✅ Created 4 payroll records');
    console.log('\n🎉 Seeding complete!');
    console.log('📋 Login credentials:');
    console.log('   Admin:    admin@hris.com    / password123');
    console.log('   Employee: budi@hris.com     / password123');
    console.log('   Employee: zidane@hris.com   / password123');
}
main()
    .catch((e) => {
    console.error('❌ Seed error:', e);
    process.exit(1);
})
    .finally(async () => {
    await prisma.$disconnect();
});
//# sourceMappingURL=seed.js.map
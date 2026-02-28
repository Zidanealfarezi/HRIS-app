import { PayrollService } from './payroll.service';
export declare class PayrollController {
    private payrollService;
    constructor(payrollService: PayrollService);
    getAll(): Promise<({
        employee: {
            name: string;
            position: string;
            department: string;
            id: number;
        };
    } & {
        createdAt: Date;
        id: number;
        employeeId: number;
        period: string;
        periodStart: Date;
        periodEnd: Date;
        baseSalary: import("@prisma/client/runtime/library").Decimal;
        allowances: import("@prisma/client/runtime/library").JsonValue;
        deductions: import("@prisma/client/runtime/library").JsonValue;
        netPay: import("@prisma/client/runtime/library").Decimal;
        paidAt: Date | null;
    })[]>;
    findByEmployee(employeeId: number): Promise<({
        employee: {
            name: string;
            position: string;
            department: string;
            avatar: string | null;
            id: number;
        };
    } & {
        createdAt: Date;
        id: number;
        employeeId: number;
        period: string;
        periodStart: Date;
        periodEnd: Date;
        baseSalary: import("@prisma/client/runtime/library").Decimal;
        allowances: import("@prisma/client/runtime/library").JsonValue;
        deductions: import("@prisma/client/runtime/library").JsonValue;
        netPay: import("@prisma/client/runtime/library").Decimal;
        paidAt: Date | null;
    })[]>;
    findOne(id: number): Promise<{
        employee: {
            name: string;
            position: string;
            department: string;
            status: import(".prisma/client").$Enums.EmployeeStatus;
            location: string | null;
            joinDate: Date;
            avatar: string | null;
            phone: string | null;
            email: string | null;
            bankAccount: string | null;
            npwp: string | null;
            leaveBalance: number;
            createdAt: Date;
            updatedAt: Date;
            id: number;
        };
    } & {
        createdAt: Date;
        id: number;
        employeeId: number;
        period: string;
        periodStart: Date;
        periodEnd: Date;
        baseSalary: import("@prisma/client/runtime/library").Decimal;
        allowances: import("@prisma/client/runtime/library").JsonValue;
        deductions: import("@prisma/client/runtime/library").JsonValue;
        netPay: import("@prisma/client/runtime/library").Decimal;
        paidAt: Date | null;
    }>;
}

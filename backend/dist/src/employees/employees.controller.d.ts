import { EmployeesService } from './employees.service';
import { CreateEmployeeDto, UpdateEmployeeDto, QueryEmployeeDto } from './dto/employee.dto';
export declare class EmployeesController {
    private employeesService;
    constructor(employeesService: EmployeesService);
    findAll(query: QueryEmployeeDto): Promise<({
        user: {
            email: string;
            id: number;
            role: import(".prisma/client").$Enums.Role;
        } | null;
    } & {
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
    })[]>;
    getStats(): Promise<{
        total: number;
        active: number;
        onLeave: number;
        departmentCount: number;
    }>;
    getDepartmentStats(): Promise<{
        department: string;
        count: number;
    }[]>;
    findOne(id: number): Promise<{
        user: {
            email: string;
            id: number;
            role: import(".prisma/client").$Enums.Role;
        } | null;
        leaveRequests: {
            status: import(".prisma/client").$Enums.LeaveStatus;
            createdAt: Date;
            updatedAt: Date;
            id: number;
            employeeId: number;
            type: import(".prisma/client").$Enums.LeaveType;
            startDate: Date;
            endDate: Date;
            days: number;
            reason: string | null;
            approvedBy: string | null;
        }[];
        payrollRecords: {
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
        }[];
    } & {
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
    }>;
    create(dto: CreateEmployeeDto): Promise<{
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
    }>;
    update(id: number, dto: UpdateEmployeeDto): Promise<{
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
    }>;
    remove(id: number): Promise<{
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
    }>;
}

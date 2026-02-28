import { LeaveService } from './leave.service';
import { CreateLeaveDto, QueryLeaveDto } from './dto/leave.dto';
export declare class LeaveController {
    private leaveService;
    constructor(leaveService: LeaveService);
    findAll(query: QueryLeaveDto): Promise<({
        employee: {
            name: string;
            position: string;
            department: string;
            avatar: string | null;
            id: number;
        };
    } & {
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
    })[]>;
    getPendingCount(): Promise<number>;
    getBalance(employeeId: number): Promise<{
        total: number;
        used: number;
        remaining: number;
    }>;
    findOne(id: number): Promise<{
        employee: {
            name: string;
            position: string;
            department: string;
            avatar: string | null;
            id: number;
        };
    } & {
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
    }>;
    create(dto: CreateLeaveDto): Promise<{
        employee: {
            name: string;
            position: string;
            avatar: string | null;
            id: number;
        };
    } & {
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
    }>;
    approve(id: number, req: any): Promise<{
        employee: {
            name: string;
            position: string;
            avatar: string | null;
            id: number;
        };
    } & {
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
    }>;
    reject(id: number, req: any): Promise<{
        employee: {
            name: string;
            position: string;
            avatar: string | null;
            id: number;
        };
    } & {
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
    }>;
}

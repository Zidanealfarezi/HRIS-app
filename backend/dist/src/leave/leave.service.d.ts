import { PrismaService } from '../prisma/prisma.service';
import { CreateLeaveDto, UpdateLeaveStatusDto, QueryLeaveDto } from './dto/leave.dto';
export declare class LeaveService {
    private prisma;
    constructor(prisma: PrismaService);
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
    updateStatus(id: number, dto: UpdateLeaveStatusDto): Promise<{
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
    getBalance(employeeId: number): Promise<{
        total: number;
        used: number;
        remaining: number;
    }>;
    getPendingCount(): Promise<number>;
}

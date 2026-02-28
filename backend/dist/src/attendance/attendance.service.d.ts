import { PrismaService } from '../prisma/prisma.service';
export declare class AttendanceService {
    private prisma;
    constructor(prisma: PrismaService);
    findAll(employeeId?: number, startDate?: string, endDate?: string): Promise<({
        employee: {
            name: string;
            position: string;
            department: string;
            avatar: string | null;
            id: number;
        };
    } & {
        status: import(".prisma/client").$Enums.AttendanceStatus;
        createdAt: Date;
        id: number;
        employeeId: number;
        date: Date;
        checkIn: Date | null;
        checkOut: Date | null;
    })[]>;
    checkIn(employeeId: number): Promise<{
        status: import(".prisma/client").$Enums.AttendanceStatus;
        createdAt: Date;
        id: number;
        employeeId: number;
        date: Date;
        checkIn: Date | null;
        checkOut: Date | null;
    }>;
    checkOut(employeeId: number): Promise<{
        status: import(".prisma/client").$Enums.AttendanceStatus;
        createdAt: Date;
        id: number;
        employeeId: number;
        date: Date;
        checkIn: Date | null;
        checkOut: Date | null;
    }>;
    getTodayCount(): Promise<number>;
    getWeeklyTrend(): Promise<{
        date: Date;
        count: number;
    }[]>;
}

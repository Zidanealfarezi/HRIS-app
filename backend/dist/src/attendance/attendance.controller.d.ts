import { AttendanceService } from './attendance.service';
export declare class AttendanceController {
    private attendanceService;
    constructor(attendanceService: AttendanceService);
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
    getTodayCount(): Promise<number>;
    getWeeklyTrend(): Promise<{
        date: Date;
        count: number;
    }[]>;
    checkIn(req: any): Promise<{
        status: import(".prisma/client").$Enums.AttendanceStatus;
        createdAt: Date;
        id: number;
        employeeId: number;
        date: Date;
        checkIn: Date | null;
        checkOut: Date | null;
    }>;
    checkOut(req: any): Promise<{
        status: import(".prisma/client").$Enums.AttendanceStatus;
        createdAt: Date;
        id: number;
        employeeId: number;
        date: Date;
        checkIn: Date | null;
        checkOut: Date | null;
    }>;
}

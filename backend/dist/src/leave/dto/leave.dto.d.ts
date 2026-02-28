import { LeaveType, LeaveStatus } from '@prisma/client';
export declare class CreateLeaveDto {
    employeeId: number;
    type: LeaveType;
    startDate: string;
    endDate: string;
    days: number;
    reason?: string;
}
export declare class UpdateLeaveStatusDto {
    status: LeaveStatus;
    approvedBy?: string;
}
export declare class QueryLeaveDto {
    employeeId?: number;
    status?: LeaveStatus;
    type?: LeaveType;
}

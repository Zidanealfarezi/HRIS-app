import { IsEnum, IsDateString, IsOptional, IsString, IsInt } from 'class-validator';
import { LeaveType, LeaveStatus } from '@prisma/client';

export class CreateLeaveDto {
    @IsInt()
    employeeId: number;

    @IsEnum(LeaveType)
    type: LeaveType;

    @IsDateString()
    startDate: string;

    @IsDateString()
    endDate: string;

    @IsInt()
    days: number;

    @IsString()
    @IsOptional()
    reason?: string;
}

export class UpdateLeaveStatusDto {
    @IsEnum(LeaveStatus)
    status: LeaveStatus;

    @IsString()
    @IsOptional()
    approvedBy?: string;
}

export class QueryLeaveDto {
    @IsInt()
    @IsOptional()
    employeeId?: number;

    @IsEnum(LeaveStatus)
    @IsOptional()
    status?: LeaveStatus;

    @IsEnum(LeaveType)
    @IsOptional()
    type?: LeaveType;
}

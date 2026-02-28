import { IsString, IsOptional, IsEnum, IsDateString, IsInt } from 'class-validator';
import { EmployeeStatus } from '@prisma/client';

export class CreateEmployeeDto {
    @IsString()
    name: string;

    @IsString()
    position: string;

    @IsString()
    department: string;

    @IsEnum(EmployeeStatus)
    @IsOptional()
    status?: EmployeeStatus;

    @IsString()
    @IsOptional()
    location?: string;

    @IsDateString()
    joinDate: string;

    @IsString()
    @IsOptional()
    avatar?: string;

    @IsString()
    @IsOptional()
    phone?: string;

    @IsString()
    @IsOptional()
    email?: string;

    @IsString()
    @IsOptional()
    bankAccount?: string;

    @IsString()
    @IsOptional()
    npwp?: string;

    @IsInt()
    @IsOptional()
    leaveBalance?: number;
}

export class UpdateEmployeeDto {
    @IsString()
    @IsOptional()
    name?: string;

    @IsString()
    @IsOptional()
    position?: string;

    @IsString()
    @IsOptional()
    department?: string;

    @IsEnum(EmployeeStatus)
    @IsOptional()
    status?: EmployeeStatus;

    @IsString()
    @IsOptional()
    location?: string;

    @IsDateString()
    @IsOptional()
    joinDate?: string;

    @IsString()
    @IsOptional()
    avatar?: string;

    @IsString()
    @IsOptional()
    phone?: string;

    @IsString()
    @IsOptional()
    email?: string;

    @IsString()
    @IsOptional()
    bankAccount?: string;

    @IsString()
    @IsOptional()
    npwp?: string;

    @IsInt()
    @IsOptional()
    leaveBalance?: number;
}

export class QueryEmployeeDto {
    @IsString()
    @IsOptional()
    search?: string;

    @IsString()
    @IsOptional()
    department?: string;

    @IsEnum(EmployeeStatus)
    @IsOptional()
    status?: EmployeeStatus;

    @IsString()
    @IsOptional()
    location?: string;
}

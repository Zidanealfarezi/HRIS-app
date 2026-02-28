import { EmployeeStatus } from '@prisma/client';
export declare class CreateEmployeeDto {
    name: string;
    position: string;
    department: string;
    status?: EmployeeStatus;
    location?: string;
    joinDate: string;
    avatar?: string;
    phone?: string;
    email?: string;
    bankAccount?: string;
    npwp?: string;
    leaveBalance?: number;
}
export declare class UpdateEmployeeDto {
    name?: string;
    position?: string;
    department?: string;
    status?: EmployeeStatus;
    location?: string;
    joinDate?: string;
    avatar?: string;
    phone?: string;
    email?: string;
    bankAccount?: string;
    npwp?: string;
    leaveBalance?: number;
}
export declare class QueryEmployeeDto {
    search?: string;
    department?: string;
    status?: EmployeeStatus;
    location?: string;
}

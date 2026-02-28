import { IsEmail, IsNotEmpty, IsEnum, IsOptional } from 'class-validator';
import { Role } from '@prisma/client';

export class LoginDto {
    @IsEmail()
    email: string;

    @IsNotEmpty()
    password: string;
}

export class RegisterDto {
    @IsEmail()
    email: string;

    @IsNotEmpty()
    password: string;

    @IsEnum(Role)
    @IsOptional()
    role?: Role;

    @IsOptional()
    employeeId?: number;
}

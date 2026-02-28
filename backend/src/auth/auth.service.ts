import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service';
import { LoginDto, RegisterDto } from './dto/auth.dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class AuthService {
    constructor(
        private prisma: PrismaService,
        private jwtService: JwtService,
    ) { }

    async register(dto: RegisterDto) {
        const hashedPassword = await bcrypt.hash(dto.password, 10);
        const user = await this.prisma.user.create({
            data: {
                email: dto.email,
                password: hashedPassword,
                role: dto.role || 'EMPLOYEE',
                employeeId: dto.employeeId,
            },
            include: { employee: true },
        });

        const { password, ...result } = user;
        return result;
    }

    async login(dto: LoginDto) {
        const user = await this.prisma.user.findUnique({
            where: { email: dto.email },
            include: { employee: true },
        });

        if (!user) {
            throw new UnauthorizedException('Email atau password salah');
        }

        const isPasswordValid = await bcrypt.compare(dto.password, user.password);
        if (!isPasswordValid) {
            throw new UnauthorizedException('Email atau password salah');
        }

        const payload = {
            sub: user.id,
            email: user.email,
            role: user.role,
            employeeId: user.employeeId,
        };

        return {
            access_token: this.jwtService.sign(payload),
            user: {
                id: user.id,
                email: user.email,
                role: user.role,
                employeeId: user.employeeId,
                employee: user.employee,
            },
        };
    }

    async getProfile(userId: number) {
        const user = await this.prisma.user.findUnique({
            where: { id: userId },
            include: { employee: true },
        });
        if (!user) throw new UnauthorizedException();
        const { password, ...result } = user;
        return result;
    }
}

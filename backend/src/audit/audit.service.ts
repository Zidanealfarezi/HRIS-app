import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AuditService {
    constructor(private prisma: PrismaService) { }

    async findAll(limit = 50) {
        return this.prisma.auditLog.findMany({
            take: limit,
            orderBy: { createdAt: 'desc' },
            include: {
                user: { select: { id: true, email: true, role: true } },
            },
        });
    }

    async log(userId: number, action: string, target: string, targetId?: number, details?: any) {
        return this.prisma.auditLog.create({
            data: { userId, action, target, targetId, details },
        });
    }
}

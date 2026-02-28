import { PrismaService } from '../prisma/prisma.service';
export declare class AuditService {
    private prisma;
    constructor(prisma: PrismaService);
    findAll(limit?: number): Promise<({
        user: {
            email: string;
            id: number;
            role: import(".prisma/client").$Enums.Role;
        };
    } & {
        createdAt: Date;
        id: number;
        userId: number;
        action: string;
        target: string;
        targetId: number | null;
        details: import("@prisma/client/runtime/library").JsonValue | null;
    })[]>;
    log(userId: number, action: string, target: string, targetId?: number, details?: any): Promise<{
        createdAt: Date;
        id: number;
        userId: number;
        action: string;
        target: string;
        targetId: number | null;
        details: import("@prisma/client/runtime/library").JsonValue | null;
    }>;
}

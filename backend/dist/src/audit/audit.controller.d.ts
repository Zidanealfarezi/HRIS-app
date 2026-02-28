import { AuditService } from './audit.service';
export declare class AuditController {
    private auditService;
    constructor(auditService: AuditService);
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
}

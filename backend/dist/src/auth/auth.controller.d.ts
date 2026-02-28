import { AuthService } from './auth.service';
import { LoginDto, RegisterDto } from './dto/auth.dto';
export declare class AuthController {
    private authService;
    constructor(authService: AuthService);
    register(dto: RegisterDto): Promise<{
        employee: {
            name: string;
            position: string;
            department: string;
            status: import(".prisma/client").$Enums.EmployeeStatus;
            location: string | null;
            joinDate: Date;
            avatar: string | null;
            phone: string | null;
            email: string | null;
            bankAccount: string | null;
            npwp: string | null;
            leaveBalance: number;
            createdAt: Date;
            updatedAt: Date;
            id: number;
        } | null;
        email: string;
        createdAt: Date;
        updatedAt: Date;
        id: number;
        role: import(".prisma/client").$Enums.Role;
        employeeId: number | null;
    }>;
    login(dto: LoginDto): Promise<{
        access_token: string;
        user: {
            id: number;
            email: string;
            role: import(".prisma/client").$Enums.Role;
            employeeId: number | null;
            employee: {
                name: string;
                position: string;
                department: string;
                status: import(".prisma/client").$Enums.EmployeeStatus;
                location: string | null;
                joinDate: Date;
                avatar: string | null;
                phone: string | null;
                email: string | null;
                bankAccount: string | null;
                npwp: string | null;
                leaveBalance: number;
                createdAt: Date;
                updatedAt: Date;
                id: number;
            } | null;
        };
    }>;
    getProfile(req: any): Promise<{
        employee: {
            name: string;
            position: string;
            department: string;
            status: import(".prisma/client").$Enums.EmployeeStatus;
            location: string | null;
            joinDate: Date;
            avatar: string | null;
            phone: string | null;
            email: string | null;
            bankAccount: string | null;
            npwp: string | null;
            leaveBalance: number;
            createdAt: Date;
            updatedAt: Date;
            id: number;
        } | null;
        email: string;
        createdAt: Date;
        updatedAt: Date;
        id: number;
        role: import(".prisma/client").$Enums.Role;
        employeeId: number | null;
    }>;
}

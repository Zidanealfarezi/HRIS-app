"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppModule = void 0;
const common_1 = require("@nestjs/common");
const prisma_module_1 = require("./prisma/prisma.module");
const auth_module_1 = require("./auth/auth.module");
const employees_module_1 = require("./employees/employees.module");
const leave_module_1 = require("./leave/leave.module");
const attendance_module_1 = require("./attendance/attendance.module");
const payroll_module_1 = require("./payroll/payroll.module");
const audit_module_1 = require("./audit/audit.module");
let AppModule = class AppModule {
};
exports.AppModule = AppModule;
exports.AppModule = AppModule = __decorate([
    (0, common_1.Module)({
        imports: [
            prisma_module_1.PrismaModule,
            auth_module_1.AuthModule,
            employees_module_1.EmployeesModule,
            leave_module_1.LeaveModule,
            attendance_module_1.AttendanceModule,
            payroll_module_1.PayrollModule,
            audit_module_1.AuditModule,
        ],
    })
], AppModule);
//# sourceMappingURL=app.module.js.map
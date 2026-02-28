"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.LeaveController = void 0;
const common_1 = require("@nestjs/common");
const passport_1 = require("@nestjs/passport");
const leave_service_1 = require("./leave.service");
const leave_dto_1 = require("./dto/leave.dto");
const roles_guard_1 = require("../auth/roles.guard");
let LeaveController = class LeaveController {
    leaveService;
    constructor(leaveService) {
        this.leaveService = leaveService;
    }
    findAll(query) {
        return this.leaveService.findAll(query);
    }
    getPendingCount() {
        return this.leaveService.getPendingCount();
    }
    getBalance(employeeId) {
        return this.leaveService.getBalance(employeeId);
    }
    findOne(id) {
        return this.leaveService.findOne(id);
    }
    create(dto) {
        return this.leaveService.create(dto);
    }
    approve(id, req) {
        return this.leaveService.updateStatus(id, {
            status: 'APPROVED',
            approvedBy: req.user.email,
        });
    }
    reject(id, req) {
        return this.leaveService.updateStatus(id, {
            status: 'REJECTED',
            approvedBy: req.user.email,
        });
    }
};
exports.LeaveController = LeaveController;
__decorate([
    (0, common_1.Get)(),
    __param(0, (0, common_1.Query)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [leave_dto_1.QueryLeaveDto]),
    __metadata("design:returntype", void 0)
], LeaveController.prototype, "findAll", null);
__decorate([
    (0, common_1.Get)('pending-count'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], LeaveController.prototype, "getPendingCount", null);
__decorate([
    (0, common_1.Get)('balance/:employeeId'),
    __param(0, (0, common_1.Param)('employeeId', common_1.ParseIntPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", void 0)
], LeaveController.prototype, "getBalance", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", void 0)
], LeaveController.prototype, "findOne", null);
__decorate([
    (0, common_1.Post)(),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [leave_dto_1.CreateLeaveDto]),
    __metadata("design:returntype", void 0)
], LeaveController.prototype, "create", null);
__decorate([
    (0, common_1.UseGuards)(roles_guard_1.RolesGuard),
    (0, roles_guard_1.Roles)('ADMIN'),
    (0, common_1.Patch)(':id/approve'),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __param(1, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, Object]),
    __metadata("design:returntype", void 0)
], LeaveController.prototype, "approve", null);
__decorate([
    (0, common_1.UseGuards)(roles_guard_1.RolesGuard),
    (0, roles_guard_1.Roles)('ADMIN'),
    (0, common_1.Patch)(':id/reject'),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __param(1, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, Object]),
    __metadata("design:returntype", void 0)
], LeaveController.prototype, "reject", null);
exports.LeaveController = LeaveController = __decorate([
    (0, common_1.UseGuards)((0, passport_1.AuthGuard)('jwt')),
    (0, common_1.Controller)('leave'),
    __metadata("design:paramtypes", [leave_service_1.LeaveService])
], LeaveController);
//# sourceMappingURL=leave.controller.js.map
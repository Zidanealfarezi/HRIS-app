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
Object.defineProperty(exports, "__esModule", { value: true });
exports.QueryLeaveDto = exports.UpdateLeaveStatusDto = exports.CreateLeaveDto = void 0;
const class_validator_1 = require("class-validator");
const client_1 = require("@prisma/client");
class CreateLeaveDto {
    employeeId;
    type;
    startDate;
    endDate;
    days;
    reason;
}
exports.CreateLeaveDto = CreateLeaveDto;
__decorate([
    (0, class_validator_1.IsInt)(),
    __metadata("design:type", Number)
], CreateLeaveDto.prototype, "employeeId", void 0);
__decorate([
    (0, class_validator_1.IsEnum)(client_1.LeaveType),
    __metadata("design:type", String)
], CreateLeaveDto.prototype, "type", void 0);
__decorate([
    (0, class_validator_1.IsDateString)(),
    __metadata("design:type", String)
], CreateLeaveDto.prototype, "startDate", void 0);
__decorate([
    (0, class_validator_1.IsDateString)(),
    __metadata("design:type", String)
], CreateLeaveDto.prototype, "endDate", void 0);
__decorate([
    (0, class_validator_1.IsInt)(),
    __metadata("design:type", Number)
], CreateLeaveDto.prototype, "days", void 0);
__decorate([
    (0, class_validator_1.IsString)(),
    (0, class_validator_1.IsOptional)(),
    __metadata("design:type", String)
], CreateLeaveDto.prototype, "reason", void 0);
class UpdateLeaveStatusDto {
    status;
    approvedBy;
}
exports.UpdateLeaveStatusDto = UpdateLeaveStatusDto;
__decorate([
    (0, class_validator_1.IsEnum)(client_1.LeaveStatus),
    __metadata("design:type", String)
], UpdateLeaveStatusDto.prototype, "status", void 0);
__decorate([
    (0, class_validator_1.IsString)(),
    (0, class_validator_1.IsOptional)(),
    __metadata("design:type", String)
], UpdateLeaveStatusDto.prototype, "approvedBy", void 0);
class QueryLeaveDto {
    employeeId;
    status;
    type;
}
exports.QueryLeaveDto = QueryLeaveDto;
__decorate([
    (0, class_validator_1.IsInt)(),
    (0, class_validator_1.IsOptional)(),
    __metadata("design:type", Number)
], QueryLeaveDto.prototype, "employeeId", void 0);
__decorate([
    (0, class_validator_1.IsEnum)(client_1.LeaveStatus),
    (0, class_validator_1.IsOptional)(),
    __metadata("design:type", String)
], QueryLeaveDto.prototype, "status", void 0);
__decorate([
    (0, class_validator_1.IsEnum)(client_1.LeaveType),
    (0, class_validator_1.IsOptional)(),
    __metadata("design:type", String)
], QueryLeaveDto.prototype, "type", void 0);
//# sourceMappingURL=leave.dto.js.map
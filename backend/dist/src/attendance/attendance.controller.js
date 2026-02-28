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
exports.AttendanceController = void 0;
const common_1 = require("@nestjs/common");
const passport_1 = require("@nestjs/passport");
const attendance_service_1 = require("./attendance.service");
let AttendanceController = class AttendanceController {
    attendanceService;
    constructor(attendanceService) {
        this.attendanceService = attendanceService;
    }
    findAll(employeeId, startDate, endDate) {
        return this.attendanceService.findAll(employeeId, startDate, endDate);
    }
    getTodayCount() {
        return this.attendanceService.getTodayCount();
    }
    getWeeklyTrend() {
        return this.attendanceService.getWeeklyTrend();
    }
    checkIn(req) {
        return this.attendanceService.checkIn(req.user.employeeId);
    }
    checkOut(req) {
        return this.attendanceService.checkOut(req.user.employeeId);
    }
};
exports.AttendanceController = AttendanceController;
__decorate([
    (0, common_1.Get)(),
    __param(0, (0, common_1.Query)('employeeId')),
    __param(1, (0, common_1.Query)('startDate')),
    __param(2, (0, common_1.Query)('endDate')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, String, String]),
    __metadata("design:returntype", void 0)
], AttendanceController.prototype, "findAll", null);
__decorate([
    (0, common_1.Get)('today-count'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], AttendanceController.prototype, "getTodayCount", null);
__decorate([
    (0, common_1.Get)('weekly-trend'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], AttendanceController.prototype, "getWeeklyTrend", null);
__decorate([
    (0, common_1.Post)('check-in'),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], AttendanceController.prototype, "checkIn", null);
__decorate([
    (0, common_1.Post)('check-out'),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], AttendanceController.prototype, "checkOut", null);
exports.AttendanceController = AttendanceController = __decorate([
    (0, common_1.UseGuards)((0, passport_1.AuthGuard)('jwt')),
    (0, common_1.Controller)('attendance'),
    __metadata("design:paramtypes", [attendance_service_1.AttendanceService])
], AttendanceController);
//# sourceMappingURL=attendance.controller.js.map
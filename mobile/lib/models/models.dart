class Employee {
  final int id;
  final String name;
  final String position;
  final String department;
  final String status;
  final String? location;
  final DateTime joinDate;
  final String? avatar;
  final String? phone;
  final String? email;
  final String? bankAccount;
  final String? npwp;
  final int leaveBalance;

  Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.department,
    required this.status,
    this.location,
    required this.joinDate,
    this.avatar,
    this.phone,
    this.email,
    this.bankAccount,
    this.npwp,
    this.leaveBalance = 12,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      department: json['department'],
      status: json['status'],
      location: json['location'],
      joinDate: DateTime.parse(json['joinDate']),
      avatar: json['avatar'],
      phone: json['phone'],
      email: json['email'],
      bankAccount: json['bankAccount'],
      npwp: json['npwp'],
      leaveBalance: json['leaveBalance'] ?? 12,
    );
  }
}

class LeaveRequest {
  final int id;
  final int employeeId;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final int days;
  final String? reason;
  final String status;
  final String? approvedBy;
  final DateTime createdAt;
  final Employee? employee;

  LeaveRequest({
    required this.id,
    required this.employeeId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.days,
    this.reason,
    required this.status,
    this.approvedBy,
    required this.createdAt,
    this.employee,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'],
      employeeId: json['employeeId'],
      type: json['type'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      days: json['days'],
      reason: json['reason'],
      status: json['status'],
      approvedBy: json['approvedBy'],
      createdAt: DateTime.parse(json['createdAt']),
      employee: json['employee'] != null ? Employee.fromJson(json['employee']) : null,
    );
  }

  String get typeLabel {
    switch (type) {
      case 'ANNUAL': return 'Cuti Tahunan';
      case 'SICK': return 'Cuti Sakit';
      case 'REMOTE_WORK': return 'Remote Work';
      case 'UNPAID': return 'Cuti Tanpa Tanggungan';
      default: return type;
    }
  }

  String get statusLabel {
    switch (status) {
      case 'PENDING': return 'Menunggu';
      case 'APPROVED': return 'Disetujui';
      case 'REJECTED': return 'Ditolak';
      default: return status;
    }
  }
}

class PayrollRecord {
  final int id;
  final int employeeId;
  final String period;
  final DateTime periodStart;
  final DateTime periodEnd;
  final double baseSalary;
  final List<PayrollItem> allowances;
  final List<PayrollItem> deductions;
  final double netPay;
  final DateTime? paidAt;
  final Employee? employee;

  PayrollRecord({
    required this.id,
    required this.employeeId,
    required this.period,
    required this.periodStart,
    required this.periodEnd,
    required this.baseSalary,
    required this.allowances,
    required this.deductions,
    required this.netPay,
    this.paidAt,
    this.employee,
  });

  double get totalAllowances =>
      allowances.fold(0, (sum, item) => sum + item.amount);

  double get totalDeductions =>
      deductions.fold(0, (sum, item) => sum + item.amount);

  double get totalEarnings => baseSalary + totalAllowances;

  factory PayrollRecord.fromJson(Map<String, dynamic> json) {
    return PayrollRecord(
      id: json['id'],
      employeeId: json['employeeId'],
      period: json['period'],
      periodStart: DateTime.parse(json['periodStart']),
      periodEnd: DateTime.parse(json['periodEnd']),
      baseSalary: (json['baseSalary'] is String) 
          ? double.parse(json['baseSalary']) 
          : (json['baseSalary'] as num).toDouble(),
      allowances: (json['allowances'] as List)
          .map((e) => PayrollItem.fromJson(e))
          .toList(),
      deductions: (json['deductions'] as List)
          .map((e) => PayrollItem.fromJson(e))
          .toList(),
      netPay: (json['netPay'] is String) 
          ? double.parse(json['netPay']) 
          : (json['netPay'] as num).toDouble(),
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
      employee: json['employee'] != null ? Employee.fromJson(json['employee']) : null,
    );
  }
}

class PayrollItem {
  final String name;
  final double amount;

  PayrollItem({required this.name, required this.amount});

  factory PayrollItem.fromJson(Map<String, dynamic> json) {
    return PayrollItem(
      name: json['name'],
      amount: (json['amount'] as num).toDouble(),
    );
  }
}

class AttendanceTrend {
  final DateTime date;
  final int count;

  AttendanceTrend({required this.date, required this.count});

  factory AttendanceTrend.fromJson(Map<String, dynamic> json) {
    return AttendanceTrend(
      date: DateTime.parse(json['date']),
      count: json['count'],
    );
  }
}

class DepartmentStat {
  final String department;
  final int count;

  DepartmentStat({required this.department, required this.count});

  factory DepartmentStat.fromJson(Map<String, dynamic> json) {
    return DepartmentStat(
      department: json['department'],
      count: json['count'],
    );
  }
}

class AuthUser {
  final int id;
  final String email;
  final String role;
  final int? employeeId;
  final Employee? employee;

  AuthUser({
    required this.id,
    required this.email,
    required this.role,
    this.employeeId,
    this.employee,
  });

  bool get isAdmin => role == 'ADMIN';

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      employeeId: json['employeeId'],
      employee: json['employee'] != null ? Employee.fromJson(json['employee']) : null,
    );
  }
}

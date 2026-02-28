import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class ApiService {
  // For Chrome/Web use localhost, for Android emulator use 10.0.2.2
  static const String baseUrl = 'http://localhost:3000/api';

  String? _token;

  Future<String?> get token async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    return _token;
  }

  Future<Map<String, String>> get _headers async {
    final t = await token;
    return {
      'Content-Type': 'application/json',
      if (t != null) 'Authorization': 'Bearer $t',
    };
  }

  // AUTH
  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      final data = jsonDecode(res.body);
      _token = data['access_token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      return data;
    }
    throw Exception(jsonDecode(res.body)['message'] ?? 'Login gagal');
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<AuthUser> getProfile() async {
    final res = await http.get(
      Uri.parse('$baseUrl/auth/profile'),
      headers: await _headers,
    );
    if (res.statusCode == 200) return AuthUser.fromJson(jsonDecode(res.body));
    throw Exception('Gagal memuat profil');
  }

  // EMPLOYEES
  Future<List<Employee>> getEmployees({String? search, String? department, String? status}) async {
    final params = <String, String>{};
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (department != null && department.isNotEmpty) params['department'] = department;
    if (status != null && status.isNotEmpty) params['status'] = status;
    
    final uri = Uri.parse('$baseUrl/employees').replace(queryParameters: params.isNotEmpty ? params : null);
    final res = await http.get(uri, headers: await _headers);
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((e) => Employee.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat data karyawan');
  }

  Future<Map<String, dynamic>> getEmployeeStats() async {
    final res = await http.get(Uri.parse('$baseUrl/employees/stats'), headers: await _headers);
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Gagal memuat statistik');
  }

  Future<List<DepartmentStat>> getDepartmentStats() async {
    final res = await http.get(Uri.parse('$baseUrl/employees/department-stats'), headers: await _headers);
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((e) => DepartmentStat.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat statistik departemen');
  }

  Future<Employee> createEmployee(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/employees'),
      headers: await _headers,
      body: jsonEncode(data),
    );
    if (res.statusCode == 201) return Employee.fromJson(jsonDecode(res.body));
    throw Exception('Gagal menambahkan karyawan');
  }

  Future<Employee> updateEmployee(int id, Map<String, dynamic> data) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/employees/$id'),
      headers: await _headers,
      body: jsonEncode(data),
    );
    if (res.statusCode == 200) return Employee.fromJson(jsonDecode(res.body));
    throw Exception('Gagal mengupdate karyawan');
  }

  Future<void> deleteEmployee(int id) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/employees/$id'),
      headers: await _headers,
    );
    if (res.statusCode != 200) throw Exception('Gagal menghapus karyawan');
  }

  // LEAVE
  Future<List<LeaveRequest>> getLeaveRequests({int? employeeId, String? status}) async {
    final params = <String, String>{};
    if (employeeId != null) params['employeeId'] = employeeId.toString();
    if (status != null && status.isNotEmpty) params['status'] = status;
    
    final uri = Uri.parse('$baseUrl/leave').replace(queryParameters: params.isNotEmpty ? params : null);
    final res = await http.get(uri, headers: await _headers);
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((e) => LeaveRequest.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat data cuti');
  }

  Future<int> getPendingLeaveCount() async {
    final res = await http.get(Uri.parse('$baseUrl/leave/pending-count'), headers: await _headers);
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Gagal memuat jumlah cuti pending');
  }

  Future<Map<String, dynamic>> getLeaveBalance(int employeeId) async {
    final res = await http.get(Uri.parse('$baseUrl/leave/balance/$employeeId'), headers: await _headers);
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Gagal memuat sisa cuti');
  }

  Future<LeaveRequest> createLeaveRequest(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/leave'),
      headers: await _headers,
      body: jsonEncode(data),
    );
    if (res.statusCode == 201) return LeaveRequest.fromJson(jsonDecode(res.body));
    throw Exception(jsonDecode(res.body)['message'] ?? 'Gagal mengajukan cuti');
  }

  Future<LeaveRequest> approveLeave(int id) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/leave/$id/approve'),
      headers: await _headers,
    );
    if (res.statusCode == 200) return LeaveRequest.fromJson(jsonDecode(res.body));
    throw Exception('Gagal menyetujui cuti');
  }

  Future<LeaveRequest> rejectLeave(int id) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/leave/$id/reject'),
      headers: await _headers,
    );
    if (res.statusCode == 200) return LeaveRequest.fromJson(jsonDecode(res.body));
    throw Exception('Gagal menolak cuti');
  }

  // ATTENDANCE
  Future<int> getTodayAttendance() async {
    final res = await http.get(Uri.parse('$baseUrl/attendance/today-count'), headers: await _headers);
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Gagal memuat kehadiran');
  }

  Future<List<AttendanceTrend>> getWeeklyTrend() async {
    final res = await http.get(Uri.parse('$baseUrl/attendance/weekly-trend'), headers: await _headers);
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((e) => AttendanceTrend.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat tren kehadiran');
  }

  // PAYROLL
  Future<List<PayrollRecord>> getPayrolls(int employeeId) async {
    final res = await http.get(Uri.parse('$baseUrl/payroll/employee/$employeeId'), headers: await _headers);
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((e) => PayrollRecord.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat data gaji');
  }

  Future<PayrollRecord> getPayrollDetail(int id) async {
    final res = await http.get(Uri.parse('$baseUrl/payroll/$id'), headers: await _headers);
    if (res.statusCode == 200) return PayrollRecord.fromJson(jsonDecode(res.body));
    throw Exception('Gagal memuat detail slip gaji');
  }
}

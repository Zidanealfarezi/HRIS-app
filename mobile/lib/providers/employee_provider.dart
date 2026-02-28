import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/models.dart';

class EmployeeProvider extends ChangeNotifier {
  final ApiService _api;
  List<Employee> _employees = [];
  bool _isLoading = false;
  Map<String, dynamic> _stats = {};
  List<DepartmentStat> _deptStats = [];

  EmployeeProvider(this._api);

  List<Employee> get employees => _employees;
  bool get isLoading => _isLoading;
  Map<String, dynamic> get stats => _stats;
  List<DepartmentStat> get deptStats => _deptStats;

  Future<void> loadEmployees({String? search, String? department, String? status}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _employees = await _api.getEmployees(search: search, department: department, status: status);
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadStats() async {
    try {
      _stats = await _api.getEmployeeStats();
      _deptStats = await _api.getDepartmentStats();
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> createEmployee(Map<String, dynamic> data) async {
    try {
      await _api.createEmployee(data);
      await loadEmployees();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteEmployee(int id) async {
    try {
      await _api.deleteEmployee(id);
      await loadEmployees();
      return true;
    } catch (_) {
      return false;
    }
  }
}

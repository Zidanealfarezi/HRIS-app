import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/models.dart';

class LeaveProvider extends ChangeNotifier {
  final ApiService _api;
  List<LeaveRequest> _requests = [];
  bool _isLoading = false;
  int _pendingCount = 0;
  Map<String, dynamic> _balance = {};

  LeaveProvider(this._api);

  List<LeaveRequest> get requests => _requests;
  bool get isLoading => _isLoading;
  int get pendingCount => _pendingCount;
  Map<String, dynamic> get balance => _balance;

  Future<void> loadRequests({int? employeeId, String? status}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _requests = await _api.getLeaveRequests(employeeId: employeeId, status: status);
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadPendingCount() async {
    try {
      _pendingCount = await _api.getPendingLeaveCount();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadBalance(int employeeId) async {
    try {
      _balance = await _api.getLeaveBalance(employeeId);
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> createRequest(Map<String, dynamic> data) async {
    try {
      await _api.createLeaveRequest(data);
      await loadRequests(employeeId: data['employeeId']);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> approve(int id) async {
    try {
      await _api.approveLeave(id);
      await loadRequests();
      await loadPendingCount();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> reject(int id) async {
    try {
      await _api.rejectLeave(id);
      await loadRequests();
      await loadPendingCount();
      return true;
    } catch (_) {
      return false;
    }
  }
}

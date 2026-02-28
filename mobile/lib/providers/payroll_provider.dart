import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/models.dart';

class PayrollProvider extends ChangeNotifier {
  final ApiService _api;
  List<PayrollRecord> _payrolls = [];
  PayrollRecord? _selectedPayroll;
  bool _isLoading = false;

  PayrollProvider(this._api);

  List<PayrollRecord> get payrolls => _payrolls;
  PayrollRecord? get selectedPayroll => _selectedPayroll;
  bool get isLoading => _isLoading;

  Future<void> loadPayrolls(int employeeId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _payrolls = await _api.getPayrolls(employeeId);
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadDetail(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      _selectedPayroll = await _api.getPayrollDetail(id);
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../app_theme.dart';
import '../../models/models.dart';

class PayslipDetailScreen extends StatelessWidget {
  final PayrollRecord payroll;

  const PayslipDetailScreen({super.key, required this.payroll});

  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return 'Rp ${formatter.format(amount)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Slip Gaji', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        actions: [IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Employee Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppTheme.primaryLight,
                      child: Text(
                        payroll.employee?.name.split(' ').map((w) => w[0]).take(2).join() ?? '?',
                        style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: AppTheme.primary),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(payroll.employee?.name ?? 'Unknown', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700)),
                    Text(
                      '${payroll.employee?.position ?? ''} • ID: ${payroll.employeeId}',
                      style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted),
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('PERIODE', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted, fontWeight: FontWeight.w600)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            '${payroll.periodStart.day} - ${payroll.periodEnd.day} ${_monthName(payroll.periodEnd.month)} ${payroll.periodEnd.year}',
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Earnings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: AppTheme.successLight, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.savings, color: AppTheme.success, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Text('Pendapatan', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const Divider(height: 24),
                    _PayItem(label: 'Gaji Pokok', amount: _formatCurrency(payroll.baseSalary)),
                    ...payroll.allowances.map((a) => _PayItem(label: a.name, amount: _formatCurrency(a.amount))),
                    const Divider(height: 16),
                    _PayItem(
                      label: 'Total Pendapatan',
                      amount: _formatCurrency(payroll.totalEarnings),
                      isTotal: true,
                      color: AppTheme.success,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Deductions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: AppTheme.dangerLight, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.remove_circle_outline, color: AppTheme.danger, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Text('Potongan', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const Divider(height: 24),
                    ...payroll.deductions.map((d) => _PayItem(label: d.name, amount: _formatCurrency(d.amount))),
                    const Divider(height: 16),
                    _PayItem(
                      label: 'Total Potongan',
                      amount: '- ${_formatCurrency(payroll.totalDeductions)}',
                      isTotal: true,
                      color: AppTheme.danger,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Net Pay
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gaji Bersih (Take Home Pay)', style: GoogleFonts.inter(fontSize: 13, color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text(
                    _formatCurrency(payroll.netPay),
                    style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance, color: Colors.white, size: 18),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Transfer ke Bank XYZ', style: GoogleFonts.inter(fontSize: 13, color: Colors.white)),
                            Text('•••• ${payroll.employee?.bankAccount?.substring((payroll.employee?.bankAccount?.length ?? 4) - 4) ?? '1234'}',
                                style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.check_circle, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Download Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.download, size: 20),
                label: Text('Unduh Slip Gaji (PDF)', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur download akan segera tersedia')),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return months[month - 1];
  }
}

class _PayItem extends StatelessWidget {
  final String label;
  final String amount;
  final bool isTotal;
  final Color? color;

  const _PayItem({required this.label, required this.amount, this.isTotal = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(
            fontSize: isTotal ? 14 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            color: isTotal ? (color ?? AppTheme.textDark) : AppTheme.textMuted,
          )),
          Text(amount, style: GoogleFonts.inter(
            fontSize: isTotal ? 15 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? (color ?? AppTheme.textDark) : AppTheme.textDark,
          )),
        ],
      ),
    );
  }
}

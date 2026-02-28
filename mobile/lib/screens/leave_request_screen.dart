import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/leave_provider.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  String _leaveType = 'ANNUAL';
  DateTime? _startDate;
  DateTime? _endDate;
  final _reasonController = TextEditingController();
  bool _isSubmitting = false;

  int get _days {
    if (_startDate == null || _endDate == null) return 0;
    return _endDate!.difference(_startDate!).inDays + 1;
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> _submit() async {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal cuti terlebih dahulu')),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final employeeId = auth.user?.employeeId;
    if (employeeId == null) return;

    setState(() => _isSubmitting = true);

    final success = await context.read<LeaveProvider>().createRequest({
      'employeeId': employeeId,
      'type': _leaveType,
      'startDate': _startDate!.toIso8601String(),
      'endDate': _endDate!.toIso8601String(),
      'days': _days,
      'reason': _reasonController.text,
    });

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengajuan cuti berhasil!'), backgroundColor: AppTheme.success),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Pengajuan Cuti', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leave Type
            Text('Jenis Cuti', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _leaveType,
                  items: const [
                    DropdownMenuItem(value: 'ANNUAL', child: Text('Cuti Tahunan')),
                    DropdownMenuItem(value: 'SICK', child: Text('Cuti Sakit')),
                    DropdownMenuItem(value: 'REMOTE_WORK', child: Text('Remote Work')),
                    DropdownMenuItem(value: 'UNPAID', child: Text('Cuti Tanpa Tanggungan')),
                  ],
                  onChanged: (v) => setState(() => _leaveType = v!),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Date Range
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Durasi Cuti', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted)),
                if (_days > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(8)),
                    child: Text('$_days Hari', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primary)),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDateRange,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.border),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _startDate != null && _endDate != null
                    ? Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Mulai', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
                                const SizedBox(height: 4),
                                Text(
                                  '${_startDate!.day} ${months[_startDate!.month - 1].substring(0, 3)} ${_startDate!.year}',
                                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward, color: AppTheme.primary),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Selesai', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
                                const SizedBox(height: 4),
                                Text(
                                  '${_endDate!.day} ${months[_endDate!.month - 1].substring(0, 3)} ${_endDate!.year}',
                                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          children: [
                            const Icon(Icons.calendar_today, color: AppTheme.primary, size: 32),
                            const SizedBox(height: 8),
                            Text('Pilih tanggal cuti', style: GoogleFonts.inter(color: AppTheme.textMuted)),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            // Reason
            Text('Alasan Cuti', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted)),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Jelaskan alasan pengajuan cuti Anda secara singkat...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 32),
            // Submit
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send, size: 20),
                label: Text('Kirim Pengajuan', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                onPressed: _isSubmitting ? null : _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

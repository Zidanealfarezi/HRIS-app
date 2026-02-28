import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/leave_provider.dart';
import '../../models/models.dart';
import 'leave_request_screen.dart';

class LeaveHistoryScreen extends StatefulWidget {
  const LeaveHistoryScreen({super.key});

  @override
  State<LeaveHistoryScreen> createState() => _LeaveHistoryScreenState();
}

class _LeaveHistoryScreenState extends State<LeaveHistoryScreen> {
  String _filter = 'ALL';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final auth = context.read<AuthProvider>();
    final employeeId = auth.user?.employeeId;
    if (employeeId != null) {
      await context.read<LeaveProvider>().loadRequests(employeeId: employeeId);
      await context.read<LeaveProvider>().loadBalance(employeeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Cuti', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        actions: [IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})],
      ),
      body: Consumer<LeaveProvider>(
        builder: (context, provider, _) {
          final balance = provider.balance;
          final filtered = _filter == 'ALL'
              ? provider.requests
              : provider.requests.where((r) => r.status == _filter).toList();

          // Group by month
          final grouped = <String, List<LeaveRequest>>{};
          for (final req in filtered) {
            final months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
            final key = '${months[req.startDate.month - 1].toUpperCase()} ${req.startDate.year}';
            grouped.putIfAbsent(key, () => []).add(req);
          }

          return RefreshIndicator(
            onRefresh: _loadData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance + New Request
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hak Cuti ${DateTime.now().year}', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${balance['remaining'] ?? 12}', style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w800)),
                              const SizedBox(width: 4),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text('hari tersisa', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Pengajuan Baru'),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveRequestScreen())),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Filter tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _Tab(label: 'Semua', active: _filter == 'ALL', onTap: () => setState(() => _filter = 'ALL')),
                        const SizedBox(width: 8),
                        _Tab(label: 'Menunggu', active: _filter == 'PENDING', onTap: () => setState(() => _filter = 'PENDING')),
                        const SizedBox(width: 8),
                        _Tab(label: 'Disetujui', active: _filter == 'APPROVED', onTap: () => setState(() => _filter = 'APPROVED')),
                        const SizedBox(width: 8),
                        _Tab(label: 'Ditolak', active: _filter == 'REJECTED', onTap: () => setState(() => _filter = 'REJECTED')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Grouped List
                  if (provider.isLoading)
                    const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
                  else
                    ...grouped.entries.map((entry) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.key, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
                        const SizedBox(height: 8),
                        ...entry.value.map((req) => _HistoryCard(request: req)),
                        const SizedBox(height: 16),
                      ],
                    )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppTheme.primary : Colors.transparent,
          border: Border.all(color: active ? AppTheme.primary : AppTheme.border),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(label, style: GoogleFonts.inter(fontSize: 13, color: active ? Colors.white : AppTheme.textDark, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final LeaveRequest request;

  const _HistoryCard({required this.request});

  IconData get _icon {
    switch (request.type) {
      case 'ANNUAL': return Icons.beach_access;
      case 'SICK': return Icons.local_hospital;
      case 'REMOTE_WORK': return Icons.home_work;
      case 'UNPAID': return Icons.money_off;
      default: return Icons.event;
    }
  }

  Color get _iconBgColor {
    switch (request.type) {
      case 'ANNUAL': return AppTheme.primaryLight;
      case 'SICK': return const Color(0xFFF3E8FF);
      case 'REMOTE_WORK': return AppTheme.successLight;
      case 'UNPAID': return AppTheme.dangerLight;
      default: return AppTheme.primaryLight;
    }
  }

  Color get _iconColor {
    switch (request.type) {
      case 'ANNUAL': return AppTheme.primary;
      case 'SICK': return const Color(0xFF7C3AED);
      case 'REMOTE_WORK': return AppTheme.success;
      case 'UNPAID': return AppTheme.danger;
      default: return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: _iconBgColor, borderRadius: BorderRadius.circular(12)),
                  child: Icon(_icon, color: _iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(request.typeLabel, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                      Text(
                        '${request.startDate.day.toString().padLeft(2, '0')} ${months[request.startDate.month - 1]} - ${request.endDate.day.toString().padLeft(2, '0')} ${months[request.endDate.month - 1]} · ${request.days} hari',
                        style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: request.status == 'PENDING' ? AppTheme.warningLight
                        : request.status == 'APPROVED' ? AppTheme.successLight
                        : AppTheme.dangerLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        request.status == 'PENDING' ? Icons.access_time
                            : request.status == 'APPROVED' ? Icons.check
                            : Icons.close,
                        size: 14,
                        color: request.status == 'PENDING' ? AppTheme.warning
                            : request.status == 'APPROVED' ? AppTheme.success
                            : AppTheme.danger,
                      ),
                      const SizedBox(width: 4),
                      Text(request.statusLabel, style: GoogleFonts.inter(
                        fontSize: 12, fontWeight: FontWeight.w600,
                        color: request.status == 'PENDING' ? AppTheme.warning
                            : request.status == 'APPROVED' ? AppTheme.success
                            : AppTheme.danger,
                      )),
                    ],
                  ),
                ),
              ],
            ),
            if (request.reason != null && request.reason!.isNotEmpty) ...[
              const Divider(height: 20),
              Text(
                request.reason!,
                style: GoogleFonts.inter(fontSize: 13, color: request.status == 'REJECTED' ? AppTheme.danger : AppTheme.textMuted),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

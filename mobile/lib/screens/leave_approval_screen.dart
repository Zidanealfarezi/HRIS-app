import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../providers/leave_provider.dart';
import '../../models/models.dart';

class LeaveApprovalScreen extends StatefulWidget {
  const LeaveApprovalScreen({super.key});

  @override
  State<LeaveApprovalScreen> createState() => _LeaveApprovalScreenState();
}

class _LeaveApprovalScreenState extends State<LeaveApprovalScreen> {
  String _filter = 'ALL';

  @override
  void initState() {
    super.initState();
    final provider = context.read<LeaveProvider>();
    provider.loadRequests();
    provider.loadPendingCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: Text('Manajemen Cuti', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
          const CircleAvatar(radius: 16, backgroundColor: AppTheme.primaryLight, child: Icon(Icons.person, size: 18, color: AppTheme.primary)),
          const SizedBox(width: 12),
        ],
      ),
      body: Consumer<LeaveProvider>(
        builder: (context, provider, _) {
          final filtered = _filter == 'ALL' 
              ? provider.requests 
              : provider.requests.where((r) => r.status == _filter).toList();
          final pendingCount = provider.requests.where((r) => r.status == 'PENDING').length;
          final onLeaveCount = provider.requests.where((r) => r.status == 'APPROVED').length;

          return RefreshIndicator(
            onRefresh: () => provider.loadRequests(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          label: 'MENUNGGU', value: '$pendingCount',
                          subtitle: 'Perlu tindakan',
                          icon: Icons.notifications_active, iconColor: AppTheme.warning,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          label: 'SEDANG CUTI', value: '$onLeaveCount',
                          subtitle: 'Saat ini absen',
                          icon: Icons.flight_takeoff, iconColor: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Filter Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Permintaan', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
                      TextButton.icon(
                        icon: const Icon(Icons.filter_list, size: 18),
                        label: const Text('Filter'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterTab(label: 'Semua Permintaan', active: _filter == 'ALL', onTap: () => setState(() => _filter = 'ALL')),
                        const SizedBox(width: 8),
                        _FilterTab(label: 'Menunggu ($pendingCount)', active: _filter == 'PENDING', onTap: () => setState(() => _filter = 'PENDING')),
                        const SizedBox(width: 8),
                        _FilterTab(label: 'Disetujui', active: _filter == 'APPROVED', onTap: () => setState(() => _filter = 'APPROVED')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Search
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari karyawan...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Request List
                  if (provider.isLoading)
                    const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
                  else if (filtered.isEmpty)
                    Center(child: Padding(padding: const EdgeInsets.all(32), child: Text('Tidak ada permintaan', style: GoogleFonts.inter(color: AppTheme.textMuted))))
                  else
                    ...filtered.map((req) => _LeaveRequestCard(request: req)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label, value, subtitle;
  final IconData icon;
  final Color iconColor;

  const _SummaryCard({required this.label, required this.value, required this.subtitle, required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textMuted, letterSpacing: 0.5)),
                Icon(icon, color: iconColor, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800)),
            Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterTab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

class _LeaveRequestCard extends StatelessWidget {
  final LeaveRequest request;

  const _LeaveRequestCard({required this.request});

  Color get _typeColor {
    switch (request.type) {
      case 'ANNUAL': return AppTheme.primary;
      case 'SICK': return AppTheme.warning;
      case 'REMOTE_WORK': return AppTheme.success;
      case 'UNPAID': return AppTheme.danger;
      default: return AppTheme.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppTheme.primaryLight,
                  child: Text(
                    request.employee?.name.split(' ').map((w) => w[0]).take(2).join() ?? '?',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppTheme.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(request.employee?.name ?? 'Unknown', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                      Text(request.employee?.position ?? '', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: request.status == 'PENDING' ? AppTheme.warningLight : request.status == 'APPROVED' ? AppTheme.successLight : AppTheme.dangerLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(request.statusLabel, style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.w600,
                    color: request.status == 'PENDING' ? AppTheme.warning : request.status == 'APPROVED' ? AppTheme.success : AppTheme.danger,
                  )),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jenis', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted)),
                      Row(
                        children: [
                          Container(width: 8, height: 8, decoration: BoxDecoration(color: _typeColor, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text(request.typeLabel, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Durasi', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted)),
                      Text('${request.days} Hari', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Tanggal', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted)),
            Text(
              '${_formatDate(request.startDate)} - ${_formatDate(request.endDate)}',
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            if (request.reason != null && request.reason!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('"${request.reason}"', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.warning, fontStyle: FontStyle.italic)),
            ],
            if (request.status == 'PENDING') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Tolak'),
                      onPressed: () => context.read<LeaveProvider>().reject(request.id),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.danger,
                        side: const BorderSide(color: AppTheme.danger),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Setujui'),
                      onPressed: () => context.read<LeaveProvider>().approve(request.id),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }
}

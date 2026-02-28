import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/payroll_provider.dart';
import '../../models/models.dart';
import 'payslip_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadPayrolls();
  }

  void _loadPayrolls() {
    final auth = context.read<AuthProvider>();
    final employeeId = auth.user?.employeeId;
    if (employeeId != null) {
      context.read<PayrollProvider>().loadPayrolls(employeeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final employee = auth.user?.employee;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Saya', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppTheme.primary.withValues(alpha: 0.1), Colors.transparent],
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppTheme.primaryLight,
                        child: Text(
                          employee?.name.split(' ').map((w) => w[0]).take(2).join() ?? '?',
                          style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w700, color: AppTheme.primary),
                        ),
                      ),
                      Positioned(
                        right: 0, bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                          child: const Icon(Icons.edit, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(employee?.name ?? 'User', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: AppTheme.successLight, borderRadius: BorderRadius.circular(12)),
                    child: Text(employee?.position ?? '', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.success, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${employee?.department ?? ''} • Joined ${employee?.joinDate.year ?? ''}',
                    style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted),
                  ),
                ],
              ),
            ),
            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _StatBox(label: 'CUTI', value: '${employee?.leaveBalance ?? 12}', subtitle: 'Hari Tersisa'),
                  const SizedBox(width: 8),
                  _StatBox(label: 'HADIR', value: '98%', subtitle: 'Tahun Ini'),
                  const SizedBox(width: 8),
                  _StatBox(label: 'LEMBUR', value: '24h', subtitle: 'Bulan Ini'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Payslip List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Slip Gaji Terbaru', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                  TextButton(onPressed: () {}, child: Text('Lihat Semua', style: GoogleFonts.inter(color: AppTheme.primary))),
                ],
              ),
            ),
            Consumer<PayrollProvider>(
              builder: (context, payrollProvider, _) {
                if (payrollProvider.isLoading) {
                  return const Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator());
                }
                if (payrollProvider.payrolls.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('Belum ada slip gaji', style: GoogleFonts.inter(color: AppTheme.textMuted)),
                  );
                }
                return Column(
                  children: payrollProvider.payrolls.map((payroll) => _PayslipTile(payroll: payroll)).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            // Settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pengaturan Akun', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.lock_outlined),
                          title: Text('Ubah Kata Sandi', style: GoogleFonts.inter()),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                        const Divider(height: 0),
                        ListTile(
                          leading: const Icon(Icons.dark_mode_outlined),
                          title: Text('Mode Gelap', style: GoogleFonts.inter()),
                          trailing: Switch(
                            value: auth.isDarkMode,
                            onChanged: (_) => auth.toggleDarkMode(),
                            activeTrackColor: AppTheme.primary,
                          ),
                        ),
                        const Divider(height: 0),
                        ListTile(
                          leading: const Icon(Icons.notifications_outlined),
                          title: Text('Notifikasi', style: GoogleFonts.inter()),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                        const Divider(height: 0),
                        ListTile(
                          leading: const Icon(Icons.logout, color: AppTheme.danger),
                          title: Text('Keluar', style: GoogleFonts.inter(color: AppTheme.danger)),
                          onTap: () {
                            auth.logout();
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label, value, subtitle;

  const _StatBox({required this.label, required this.value, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textMuted, letterSpacing: 0.5)),
              const SizedBox(height: 4),
              Text(value, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800)),
              Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PayslipTile extends StatelessWidget {
  final PayrollRecord payroll;

  const _PayslipTile({required this.payroll});

  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.description, color: AppTheme.primary, size: 20),
        ),
        title: Text(payroll.period, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        subtitle: Text(
          'Diterima: ${payroll.paidAt != null ? "${payroll.paidAt!.day} ${months[payroll.paidAt!.month - 1]} ${payroll.paidAt!.year}" : "-"}',
          style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility_outlined, color: AppTheme.textMuted, size: 20),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PayslipDetailScreen(payroll: payroll))),
            ),
            IconButton(
              icon: const Icon(Icons.download_outlined, color: AppTheme.textMuted, size: 20),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

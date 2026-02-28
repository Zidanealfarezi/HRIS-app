import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../app_theme.dart';

import '../../providers/employee_provider.dart';
import '../../providers/leave_provider.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _todayAttendance = 0;
  List<AttendanceTrend> _weeklyTrend = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final empProvider = context.read<EmployeeProvider>();
    final leaveProvider = context.read<LeaveProvider>();
    final api = context.read<ApiService>();

    await Future.wait([
      empProvider.loadStats(),
      empProvider.loadEmployees(),
      leaveProvider.loadPendingCount(),
    ]);

    try {
      _todayAttendance = await api.getTodayAttendance();
      _weeklyTrend = await api.getWeeklyTrend();
      if (mounted) setState(() {});
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: Text('Admin HRIS', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        actions: [
          Stack(
            children: [
              IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
              Positioned(
                right: 8, top: 8,
                child: Container(
                  width: 10, height: 10,
                  decoration: const BoxDecoration(color: AppTheme.danger, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Consumer2<EmployeeProvider, LeaveProvider>(
            builder: (context, empProvider, leaveProvider, _) {
              final stats = empProvider.stats;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Selamat Pagi,', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.primary)),
                  Text('Ringkasan Dashboard', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 20),
                  // Stats Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _StatCard(
                        icon: Icons.people, iconColor: AppTheme.primary,
                        label: 'Total Karyawan',
                        value: '${stats['total'] ?? 0}',
                      ),
                      _StatCard(
                        icon: Icons.notifications_active, iconColor: AppTheme.warning,
                        label: 'Permintaan Menunggu',
                        value: '${leaveProvider.pendingCount}',
                      ),
                      _StatCard(
                        icon: Icons.fact_check, iconColor: AppTheme.success,
                        label: 'Kehadiran Hari Ini',
                        value: '$_todayAttendance',
                      ),
                      _StatCard(
                        icon: Icons.grid_view, iconColor: AppTheme.primary,
                        label: 'Departemen',
                        value: '${stats['departmentCount'] ?? 0}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  // Analytics Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ringkasan Analitik', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
                      TextButton(onPressed: () {}, child: const Text('Lihat Semua')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Department Chart
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Distribusi Departemen', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted)),
                              const Icon(Icons.more_horiz, color: AppTheme.textMuted),
                            ],
                          ),
                          Text(
                            '${stats['total'] ?? 0} Karyawan',
                            style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 180,
                            child: empProvider.deptStats.isEmpty
                                ? const Center(child: Text('Tidak ada data'))
                                : BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment.spaceAround,
                                      maxY: (empProvider.deptStats.fold<int>(0, (max, s) => s.count > max ? s.count : max) + 2).toDouble(),
                                      barGroups: empProvider.deptStats.asMap().entries.map((entry) {
                                        return BarChartGroupData(
                                          x: entry.key,
                                          barRods: [
                                            BarChartRodData(
                                              toY: entry.value.count.toDouble(),
                                              color: AppTheme.primary.withValues(alpha: 0.7 + (entry.key * 0.05)),
                                              width: 28,
                                              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                      titlesData: FlTitlesData(
                                        show: true,
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) {
                                              final idx = value.toInt();
                                              if (idx >= empProvider.deptStats.length) return const SizedBox.shrink();
                                              final dept = empProvider.deptStats[idx].department;
                                              return Padding(
                                                padding: const EdgeInsets.only(top: 8),
                                                child: Text(
                                                  dept.length > 4 ? dept.substring(0, 3).toUpperCase() : dept.toUpperCase(),
                                                  style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      ),
                                      gridData: const FlGridData(show: false),
                                      borderData: FlBorderData(show: false),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Attendance Trend
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Tren Kehadiran', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppTheme.border),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('7 Hari Terakhir', style: GoogleFonts.inter(fontSize: 12)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_todayAttendance > 0 ? ((_todayAttendance / (stats['active'] ?? 1) * 100)).toStringAsFixed(0) : 0}%',
                            style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800),
                          ),
                          Text('+2.4%', style: GoogleFonts.inter(color: AppTheme.success, fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 150,
                            child: _weeklyTrend.isEmpty
                                ? const Center(child: Text('Tidak ada data'))
                                : LineChart(
                                    LineChartData(
                                      gridData: const FlGridData(show: false),
                                      titlesData: FlTitlesData(
                                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) {
                                              final days = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
                                              final idx = value.toInt();
                                              if (idx >= _weeklyTrend.length) return const SizedBox.shrink();
                                              return Text(days[_weeklyTrend[idx].date.weekday % 7],
                                                style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted));
                                            },
                                          ),
                                        ),
                                      ),
                                      borderData: FlBorderData(show: false),
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: _weeklyTrend.asMap().entries.map((e) => 
                                            FlSpot(e.key.toDouble(), e.value.count.toDouble())).toList(),
                                          isCurved: true,
                                          color: AppTheme.primary,
                                          barWidth: 3,
                                          dotData: FlDotData(
                                            show: true,
                                            getDotPainter: (spot, percent, barData, index) =>
                                              FlDotCirclePainter(radius: 5, color: AppTheme.primary, strokeWidth: 2, strokeColor: Colors.white),
                                          ),
                                          belowBarData: BarAreaData(show: false),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({required this.icon, required this.iconColor, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
            Text(value, style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

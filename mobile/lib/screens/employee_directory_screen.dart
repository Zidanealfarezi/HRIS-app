import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../providers/employee_provider.dart';
import '../../models/models.dart';

class EmployeeDirectoryScreen extends StatefulWidget {
  const EmployeeDirectoryScreen({super.key});

  @override
  State<EmployeeDirectoryScreen> createState() => _EmployeeDirectoryScreenState();
}

class _EmployeeDirectoryScreenState extends State<EmployeeDirectoryScreen> {
  final _searchController = TextEditingController();
  String? _selectedDept;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    context.read<EmployeeProvider>().loadEmployees();
  }

  void _search() {
    context.read<EmployeeProvider>().loadEmployees(
      search: _searchController.text,
      department: _selectedDept,
      status: _selectedStatus,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: Text('Manajemen Karyawan', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
          const CircleAvatar(radius: 16, backgroundColor: AppTheme.primaryLight, child: Icon(Icons.person, size: 18, color: AppTheme.primary)),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => _search(),
                  decoration: InputDecoration(
                    hintText: 'Cari nama, ID, atau peran...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: _selectedDept ?? 'Semua Dept',
                        onTap: () => _showDeptFilter(),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: _selectedStatus ?? 'Status',
                        onTap: () => _showStatusFilter(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Employee List
          Expanded(
            child: Consumer<EmployeeProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.employees.isEmpty) {
                  return const Center(child: Text('Tidak ada karyawan'));
                }
                return RefreshIndicator(
                  onRefresh: () => provider.loadEmployees(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.employees.length + 1,
                    itemBuilder: (context, index) {
                      if (index == provider.employees.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: TextButton(
                              onPressed: () {},
                              child: Text('Lihat Semua Karyawan →', style: GoogleFonts.inter(color: AppTheme.primary, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        );
                      }
                      return _EmployeeCard(employee: provider.employees[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: () => _showAddEmployeeDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDeptFilter() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(title: const Text('Semua Dept'), onTap: () { setState(() => _selectedDept = null); _search(); Navigator.pop(ctx); }),
          for (final dept in ['Engineering', 'Product', 'Human Resources', 'Sales', 'Marketing', 'Operations'])
            ListTile(title: Text(dept), onTap: () { setState(() => _selectedDept = dept); _search(); Navigator.pop(ctx); }),
        ],
      ),
    );
  }

  void _showStatusFilter() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(title: const Text('Semua Status'), onTap: () { setState(() => _selectedStatus = null); _search(); Navigator.pop(ctx); }),
          ListTile(title: const Text('Aktif'), onTap: () { setState(() => _selectedStatus = 'AKTIF'); _search(); Navigator.pop(ctx); }),
          ListTile(title: const Text('Cuti'), onTap: () { setState(() => _selectedStatus = 'CUTI'); _search(); Navigator.pop(ctx); }),
          ListTile(title: const Text('Diberhentikan'), onTap: () { setState(() => _selectedStatus = 'DIBERHENTIKAN'); _search(); Navigator.pop(ctx); }),
        ],
      ),
    );
  }

  void _showAddEmployeeDialog() {
    final nameC = TextEditingController();
    final posC = TextEditingController();
    final deptC = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Karyawan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Nama')),
            const SizedBox(height: 8),
            TextField(controller: posC, decoration: const InputDecoration(labelText: 'Posisi')),
            const SizedBox(height: 8),
            TextField(controller: deptC, decoration: const InputDecoration(labelText: 'Departemen')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              await context.read<EmployeeProvider>().createEmployee({
                'name': nameC.text,
                'position': posC.text,
                'department': deptC.text,
                'joinDate': DateTime.now().toIso8601String(),
              });
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(label, style: GoogleFonts.inter(fontSize: 13)),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 18),
          ],
        ),
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final Employee employee;

  const _EmployeeCard({required this.employee});

  Color get _statusColor {
    switch (employee.status) {
      case 'AKTIF': return AppTheme.success;
      case 'CUTI': return AppTheme.warning;
      case 'DIBERHENTIKAN': return AppTheme.textMuted;
      default: return AppTheme.textMuted;
    }
  }

  String get _statusLabel {
    switch (employee.status) {
      case 'AKTIF': return 'Aktif';
      case 'CUTI': return 'Cuti';
      case 'DIBERHENTIKAN': return 'Diberhentikan';
      default: return employee.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppTheme.primaryLight,
                      child: Text(
                        employee.name.split(' ').map((w) => w[0]).take(2).join(),
                        style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppTheme.primary),
                      ),
                    ),
                    Positioned(
                      right: 0, bottom: 0,
                      child: Container(
                        width: 12, height: 12,
                        decoration: BoxDecoration(
                          color: _statusColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(employee.name, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                      Text('${employee.position} • ${employee.department}',
                          style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted)),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Text('STATUS', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(_statusLabel, style: GoogleFonts.inter(fontSize: 12, color: _statusColor, fontWeight: FontWeight.w600)),
                ),
                const Spacer(),
                IconButton(icon: Icon(Icons.visibility, color: AppTheme.primary, size: 20), onPressed: () {}),
                IconButton(icon: Icon(Icons.edit, color: AppTheme.primary, size: 20), onPressed: () {}),
                IconButton(
                  icon: Icon(Icons.delete, color: AppTheme.danger, size: 20),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Hapus Karyawan?'),
                        content: Text('Yakin ingin menghapus ${employee.name}?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
                            onPressed: () {
                              context.read<EmployeeProvider>().deleteEmployee(employee.id);
                              Navigator.pop(ctx);
                            },
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'services/api_service.dart';
import 'providers/auth_provider.dart';
import 'providers/employee_provider.dart';
import 'providers/leave_provider.dart';
import 'providers/payroll_provider.dart';
import 'screens/login_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/employee_directory_screen.dart';
import 'screens/leave_approval_screen.dart';
import 'screens/leave_history_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const HRISApp());
}

class HRISApp extends StatelessWidget {
  const HRISApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return MultiProvider(
      providers: [
        Provider<ApiService>.value(value: apiService),
        ChangeNotifierProvider(create: (_) => AuthProvider(apiService)),
        ChangeNotifierProvider(create: (_) => EmployeeProvider(apiService)),
        ChangeNotifierProvider(create: (_) => LeaveProvider(apiService)),
        ChangeNotifierProvider(create: (_) => PayrollProvider(apiService)),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'HRIS',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: auth.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/login',
            routes: {
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const HomeScreen(),
            },
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // Different screens for admin vs employee
    final screens = auth.isAdmin
        ? [
            const AdminDashboardScreen(),
            const EmployeeDirectoryScreen(),
            const LeaveApprovalScreen(),
            const ProfileScreen(),
          ]
        : [
            const LeaveHistoryScreen(),
            const ProfileScreen(),
          ];

    final adminNavItems = [
      const BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
      const BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Karyawan'),
      const BottomNavigationBarItem(icon: Icon(Icons.event_available), label: 'Cuti'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
    ];

    final employeeNavItems = [
      const BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Cuti Saya'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
    ];

    // Clamp index to valid range when role changes
    final maxIndex = screens.length - 1;
    if (_currentIndex > maxIndex) _currentIndex = 0;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: auth.isAdmin ? adminNavItems : employeeNavItems,
      ),
    );
  }
}

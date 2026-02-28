import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_theme.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _fillAdmin() {
    _emailController.text = 'admin@hris.com';
    _passwordController.text = 'password123';
  }

  void _fillEmployee() {
    _emailController.text = 'budi@hris.com';
    _passwordController.text = 'password123';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Consumer<AuthProvider>(
            builder: (context, auth, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.people_alt_rounded, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'HRIS',
                    style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w800, color: AppTheme.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Human Resource Information System',
                    style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted),
                  ),
                  const SizedBox(height: 48),
                  // Email
                  Text('Email', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Password
                  Text('Password', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Masukkan password',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),
                  if (auth.error != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.dangerLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(auth.error!, style: TextStyle(color: AppTheme.danger, fontSize: 13)),
                    ),
                  ],
                  const SizedBox(height: 32),
                  // Login button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: auth.isLoading ? null : _login,
                      child: auth.isLoading
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text('Masuk', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Quick login buttons
                  Text('Login Cepat (Demo):', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _fillAdmin,
                          icon: const Icon(Icons.admin_panel_settings, size: 18),
                          label: const Text('Admin'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primary,
                            side: const BorderSide(color: AppTheme.primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _fillEmployee,
                          icon: const Icon(Icons.person, size: 18),
                          label: const Text('Employee'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primary,
                            side: const BorderSide(color: AppTheme.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

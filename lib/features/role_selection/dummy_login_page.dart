import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/luxury_background.dart';
// Import file data dummy
import '../../core/data/user_dummy_data.dart';

class DummyLoginPage extends StatefulWidget {
  const DummyLoginPage({super.key});

  @override
  State<DummyLoginPage> createState() => _DummyLoginPageState();
}

class _DummyLoginPageState extends State<DummyLoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Tambahin state buat ngetrack passwordnya lagi diliatin apa nggak
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final inputUsername = _usernameController.text.trim().toLowerCase();
    final inputPassword = _passwordController.text;

    try {
      final user = UserDummyData.users.firstWhere(
        (u) => u.username == inputUsername && u.password == inputPassword,
      );

      context.go(user.route);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Username atau password salah.'),
          backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LuxuryBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 28),
            children: [
              // --- Header ---
              Row(
                children: [
                  // Container(
                  //   width: 48,
                  //   height: 48,
                  //   decoration: BoxDecoration(
                  //     gradient: const LinearGradient(
                  //       colors: [AppColors.softGold, AppColors.goldMetallic],
                  //     ),
                  //     borderRadius: BorderRadius.circular(16),
                  //   ),
                  //   child: const Icon(
                  //     Icons.apartment_outlined,
                  //     color: Color(0xFF141006),
                  //   ),
                  // ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      "assets/images/apartHub-logo.png",
                      width: 48,
                      height: 48,
                      fit: BoxFit
                          .cover, // ganti jadi BoxFit.contain kalau logonya kepotong
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Apart Hub',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          'Integrated Apartment Management Platform',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms).moveY(begin: -10, end: 0),

              const SizedBox(height: 40),

              // --- Title ---
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ).animate().fadeIn(delay: 100.ms).moveY(begin: 10, end: 0),
              const SizedBox(height: 8),
              Text(
                'Please login with your dummy account to continue.',
                style: Theme.of(context).textTheme.bodyMedium,
              ).animate().fadeIn(delay: 200.ms).moveY(begin: 10, end: 0),

              const SizedBox(height: 32),

              // --- Form Login pake GlassCard ---
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(context, 'Username'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _usernameController,
                      hint: 'resident',
                      icon: Icons.person_outline,
                    ),

                    const SizedBox(height: 20),

                    _buildLabel(context, 'Password'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _passwordController,
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),

                    const SizedBox(height: 32),

                    // --- Login Button ---
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.softGold,
                          foregroundColor: const Color(0xFF141006),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _handleLogin,
                        child: Text(
                          'Login to Dashboard',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: const Color(0xFF141006),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms).moveY(begin: 20, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper buat label input
  Widget _buildLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.white70,
      ),
    );
  }

  // Widget helper buat TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      // Kalau isPassword true, cek state _isPasswordVisible buat nentuin obscureText-nya
      obscureText: isPassword ? !_isPasswordVisible : false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
        prefixIcon: Icon(icon, color: AppColors.softGold, size: 20),

        // Nambahin suffixIcon (mata) khusus buat field password
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  // Ganti icon berdasarkan state
                  _isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.softGold,
                  size: 20,
                ),
                onPressed: () {
                  // Update state pas icon diklik
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null, // Kalau bukan password, biarin kosong

        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.2),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.goldMetallic.withValues(alpha: 0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.goldMetallic.withValues(alpha: 0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.softGold),
        ),
      ),
    );
  }
}

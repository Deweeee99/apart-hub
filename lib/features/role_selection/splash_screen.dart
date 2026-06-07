import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/luxury_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LuxuryBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                // --- Bagian Logo yang diupdate ---
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    // Gradient dihapus biar warna bawaan logo gak ketiban
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.goldMetallic.withValues(
                          alpha: 0.30,
                        ),
                        blurRadius: 36,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      "assets/images/apartHub-logo.png",
                      fit: BoxFit.cover, // Ganti ke contain kalau dirasa kepotong
                    ),
                  ),
                )
                // Efek denyut (pulse) tetep jalan
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(
                  begin: const Offset(0.96, 0.96),
                  end: const Offset(1.04, 1.04),
                  duration: 1100.ms,
                ),
                // ---------------------------------

                const SizedBox(height: 28),
                Text(
                  'Apart Hub',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ).animate().fadeIn(duration: 500.ms).moveY(begin: 12, end: 0),
                const SizedBox(height: 10),
                Text(
                  'Integrated Apartment Management Platform',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ).animate().fadeIn(delay: 180.ms, duration: 500.ms),
                const Spacer(),
                SizedBox(
                  width: 64,
                  child: LinearProgressIndicator(
                    minHeight: 3,
                    borderRadius: BorderRadius.circular(99),
                    backgroundColor: Colors.white.withValues(alpha: 0.10),
                    color: AppColors.softGold,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
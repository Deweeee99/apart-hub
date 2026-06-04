import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const primaryBackground = Color(0xFF05070D);
  static const secondaryBackground = Color(0xFF0B1020);
  static const midnightBlue = Color(0xFF101A33);
  static const goldMetallic = Color(0xFFD4AF37);
  static const softGold = Color(0xFFF5D77B);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB8B8B8);
  static const danger = Color(0xFFD9534F);
  static const success = Color(0xFF2ECC71);
  static const warning = Color(0xFFFFC857);
  static const info = Color(0xFF6BB8FF);

  static Color get glassFill => Colors.white.withValues(alpha: 0.10);
  static Color get glassFillStrong => Colors.white.withValues(alpha: 0.14);
  static Color get glassBorder => Colors.white.withValues(alpha: 0.16);
}

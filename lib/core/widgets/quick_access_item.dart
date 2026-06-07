import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class QuickAccessItem extends StatelessWidget {
  const QuickAccessItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.05,
              ), // Transparan ala glass
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.goldMetallic.withValues(
                  alpha: 0.15,
                ), // Border emas tipis
              ),
            ),
            child: Icon(
              icon,
              color: AppColors.softGold, // Warna icon disamain sama tema
              size: 26,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

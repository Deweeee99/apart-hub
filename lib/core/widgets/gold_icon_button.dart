import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class GoldIconButton extends StatelessWidget {
  const GoldIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = 44,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: SizedBox(
        width: size,
        height: size,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: AppColors.softGold),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.goldMetallic.withValues(alpha: 0.12),
            side: BorderSide(
              color: AppColors.goldMetallic.withValues(alpha: 0.34),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}

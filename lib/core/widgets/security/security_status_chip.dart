import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class SecurityStatusChip extends StatelessWidget {
  const SecurityStatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.36)),
      ),
      child: Text(
        status.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.7,
        ),
      ),
    );
  }

  Color _statusColor(String value) {
    final normalized = value.toLowerCase();
    if (normalized.contains('valid') || normalized.contains('checked')) {
      return AppColors.success;
    }
    if (normalized.contains('denied') ||
        normalized.contains('invalid') ||
        normalized.contains('expired')) {
      return AppColors.danger;
    }
    return AppColors.warning;
  }
}

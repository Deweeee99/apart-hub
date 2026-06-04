import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _colorForStatus(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Text(
        status,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Color _colorForStatus(String value) {
    final normalized = value.toLowerCase();
    if (normalized.contains('paid') ||
        normalized.contains('approved') ||
        normalized.contains('valid') ||
        normalized.contains('checked') ||
        normalized.contains('completed') ||
        normalized.contains('resolved') ||
        normalized.contains('delivered') ||
        normalized.contains('done') ||
        normalized.contains('active')) {
      return AppColors.success;
    }
    if (normalized.contains('overdue') ||
        normalized.contains('expired') ||
        normalized.contains('reject') ||
        normalized.contains('emergency') ||
        normalized.contains('alert')) {
      return AppColors.danger;
    }
    if (normalized.contains('waiting') ||
        normalized.contains('pending') ||
        normalized.contains('new') ||
        normalized.contains('open')) {
      return AppColors.warning;
    }
    return AppColors.info;
  }
}

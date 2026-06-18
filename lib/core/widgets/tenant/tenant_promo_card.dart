import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../white_premium_card.dart';

const _navy = Color(0xFF071B34);
const _gold = Color(0xFFC08A1A);
const _muted = Color(0xFF687184);
const _softGold = Color(0xFFFFF6DF);
const _softGreen = Color(0xFFF0F9F1);
const _softBlue = Color(0xFFF0F6FF);
const _softGray = Color(0xFFF5F6F8);

class TenantPromoCard extends StatelessWidget {
  const TenantPromoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.status,
    required this.category,
    required this.dateLabel,
    required this.onEdit,
    required this.onStatusAction,
    required this.statusActionLabel,
  });

  final IconData icon;
  final String title;
  final String description;
  final String status;
  final String category;
  final String dateLabel;
  final VoidCallback onEdit;
  final VoidCallback? onStatusAction;
  final String? statusActionLabel;

  @override
  Widget build(BuildContext context) {
    final (statusColor, statusBackground) = switch (status) {
      'Active' => (AppColors.success, _softGreen),
      'Scheduled' => (const Color(0xFF2A6FDB), _softBlue),
      _ => (_muted, _softGray),
    };

    return WhitePremiumCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFFBF3), _softGold],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _gold.withValues(alpha: 0.12)),
                ),
                child: Icon(icon, color: _navy, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _navy,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.18),
                  ),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: _muted, height: 1.35),
          ),
          const SizedBox(height: 10),
          Text(
            dateLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _navy,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _softGold,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              category,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: _gold,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              TextButton(
                onPressed: onEdit,
                style: TextButton.styleFrom(
                  foregroundColor: _navy,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                ),
                child: const Text(
                  'Edit',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              if (statusActionLabel != null)
                OutlinedButton(
                  onPressed: onStatusAction,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: status == 'Active'
                        ? _muted
                        : AppColors.success,
                    side: BorderSide(
                      color: (status == 'Active' ? _muted : AppColors.success)
                          .withValues(alpha: 0.24),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    statusActionLabel!,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

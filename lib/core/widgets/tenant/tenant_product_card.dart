import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../white_premium_card.dart';

const _navy = Color(0xFF071B34);
const _gold = Color(0xFFC08A1A);
const _muted = Color(0xFF687184);
const _softGold = Color(0xFFFFF6DF);
const _softGreen = Color(0xFFF0F9F1);
const _softAmber = Color(0xFFFFF6E4);
const _softRed = Color(0xFFFFF4F2);

final _currency = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

class TenantProductCard extends StatelessWidget {
  const TenantProductCard({
    super.key,
    required this.name,
    required this.category,
    required this.price,
    required this.active,
    required this.bestSeller,
    required this.icon,
    required this.onEdit,
    required this.onToggleActive,
  });

  final String name;
  final String category;
  final int price;
  final bool active;
  final bool bestSeller;
  final IconData icon;
  final VoidCallback onEdit;
  final VoidCallback onToggleActive;

  @override
  Widget build(BuildContext context) {
    final statusColor = active ? AppColors.success : _gold;
    final statusBackground = active ? _softGreen : _softAmber;

    return WhitePremiumCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFFBF3), _softGold],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _gold.withValues(alpha: 0.12)),
            ),
            child: Icon(icon, color: _navy, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _navy,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (bestSeller)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _softRed,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.danger.withValues(alpha: 0.14),
                          ),
                        ),
                        child: Text(
                          'Best Seller',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppColors.danger,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _currency.format(price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _navy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
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
                        active ? 'Active' : 'Inactive',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
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
                    OutlinedButton(
                      onPressed: onToggleActive,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: active ? _gold : AppColors.success,
                        side: BorderSide(
                          color: (active ? _gold : AppColors.success)
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
                        active ? 'Set Inactive' : 'Set Active',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

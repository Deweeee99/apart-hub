import 'package:flutter/material.dart';

import '../white_premium_card.dart';

const _evidenceNavy = Color(0xFF071B34);
const _evidenceMuted = Color(0xFF687184);
const _evidenceGold = Color(0xFFC08A1A);

class SecurityEvidenceTile extends StatelessWidget {
  const SecurityEvidenceTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _evidenceGold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: _evidenceGold.withValues(alpha: 0.22)),
            ),
            child: const Icon(
              Icons.photo_outlined,
              color: _evidenceGold,
              size: 22,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: _evidenceNavy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _evidenceMuted,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 10),
            const Icon(Icons.chevron_right_rounded, color: _evidenceGold),
          ],
        ],
      ),
    );
  }
}

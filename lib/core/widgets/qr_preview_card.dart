import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../constants/app_colors.dart';
import 'glass_card.dart';
import 'luxury_button.dart';

class QRPreviewCard extends StatelessWidget {
  const QRPreviewCard({
    super.key,
    required this.code,
    required this.title,
    this.onShare,
  });

  final String code;
  final String title;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: QrImageView(
              data: code,
              version: QrVersions.auto,
              size: 170,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(color: Colors.black),
              dataModuleStyle: const QrDataModuleStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            code,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: AppColors.softGold),
          ),
          const SizedBox(height: 14),
          LuxuryButton(
            label: 'Share QR',
            icon: Icons.ios_share_outlined,
            onPressed: onShare ?? () {},
          ),
        ],
      ),
    );
  }
}

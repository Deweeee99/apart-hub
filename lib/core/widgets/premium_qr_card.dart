import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'luxury_button.dart';
import 'white_premium_card.dart';

const _qrNavy = Color(0xFF071B34);
const _qrGold = Color(0xFFC08A1A);
const _qrSoftGold = Color(0xFFFFF6DF);
const _qrMuted = Color(0xFF687184);
const _qrLine = Color(0xFFE7DFD1);

class PremiumQrCard extends StatelessWidget {
  const PremiumQrCard({
    super.key,
    required this.title,
    required this.code,
    required this.accessType,
    required this.visitorName,
    required this.schedule,
    required this.status,
    this.countdownText,
    this.onShare,
  });

  final String title;
  final String code;
  final String accessType;
  final String visitorName;
  final String schedule;
  final String status;
  final String? countdownText;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _qrNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$accessType - $visitorName - $schedule',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: _qrMuted, height: 1.35),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _qrLine),
              boxShadow: [
                BoxShadow(
                  color: _qrNavy.withValues(alpha: 0.06),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: QrImageView(
              data: code,
              version: QrVersions.auto,
              size: 176,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(color: Colors.black),
              dataModuleStyle: const QrDataModuleStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: _qrSoftGold,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _qrGold.withValues(alpha: 0.22)),
            ),
            child: Column(
              children: [
                Text(
                  status,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: _qrGold,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (countdownText != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    countdownText!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _qrNavy,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  code,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: _qrNavy,
                    fontFeatures: const [FontFeature.tabularFigures()],
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          if (onShare != null) ...[
            const SizedBox(height: 14),
            LuxuryButton(
              label: 'Share QR',
              icon: Icons.ios_share_outlined,
              onPressed: onShare!,
            ),
          ],
        ],
      ),
    );
  }
}

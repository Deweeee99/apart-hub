import 'package:flutter/material.dart';

import '../../models/app_models.dart';
import '../status_badge.dart';
import '../white_premium_card.dart';

const _checkpointNavy = Color(0xFF071B34);
const _checkpointMuted = Color(0xFF687184);
const _checkpointGold = Color(0xFFC08A1A);

class SecurityCheckpointCard extends StatelessWidget {
  const SecurityCheckpointCard({
    super.key,
    required this.checkpoint,
    required this.onScan,
    required this.onPhoto,
  });

  final PatrolCheckpoint checkpoint;
  final VoidCallback onScan;
  final VoidCallback onPhoto;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      checkpoint.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _checkpointNavy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${checkpoint.area} - ${checkpoint.note}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _checkpointMuted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              StatusBadge(status: checkpoint.status),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 340;
              if (stacked) {
                return Column(
                  children: [
                    _PatrolActionButton(
                      label: 'Scan Checkpoint',
                      icon: Icons.qr_code_scanner_outlined,
                      onPressed: onScan,
                    ),
                    const SizedBox(height: 10),
                    _PatrolActionButton(
                      label: 'Photo',
                      icon: Icons.photo_camera_outlined,
                      onPressed: onPhoto,
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: _PatrolActionButton(
                      label: 'Scan Checkpoint',
                      icon: Icons.qr_code_scanner_outlined,
                      onPressed: onScan,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _PatrolActionButton(
                      label: 'Photo',
                      icon: Icons.photo_camera_outlined,
                      onPressed: onPhoto,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PatrolActionButton extends StatelessWidget {
  const _PatrolActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      style: OutlinedButton.styleFrom(
        foregroundColor: _checkpointGold,
        side: BorderSide(color: _checkpointGold.withValues(alpha: 0.42)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

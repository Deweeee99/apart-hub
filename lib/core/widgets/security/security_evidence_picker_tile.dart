import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../white_premium_card.dart';

const _pickerNavy = Color(0xFF071B34);
const _pickerMuted = Color(0xFF687184);
const _pickerGold = Color(0xFFC08A1A);

class SecurityEvidencePickerTile extends StatelessWidget {
  const SecurityEvidencePickerTile({
    super.key,
    required this.hasEvidence,
    required this.isDummy,
    required this.photoBytes,
    required this.subtitle,
    required this.onTap,
    this.onRemove,
  });

  final bool hasEvidence;
  final bool isDummy;
  final Uint8List? photoBytes;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PreviewBox(
                hasEvidence: hasEvidence,
                isDummy: isDummy,
                photoBytes: photoBytes,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasEvidence
                          ? 'Photo evidence attached'
                          : 'Add photo evidence',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: _pickerNavy,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _pickerMuted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                hasEvidence ? Icons.edit_outlined : Icons.add_a_photo_outlined,
                color: _pickerGold,
                size: 20,
              ),
            ],
          ),
          if (hasEvidence) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.refresh_outlined, size: 16),
                  label: const Text('Change'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _pickerGold,
                    side: BorderSide(
                      color: _pickerGold.withValues(alpha: 0.42),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('Remove'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade600,
                    side: BorderSide(
                      color: Colors.red.shade600.withValues(alpha: 0.42),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PreviewBox extends StatelessWidget {
  const _PreviewBox({
    required this.hasEvidence,
    required this.isDummy,
    required this.photoBytes,
  });

  final bool hasEvidence;
  final bool isDummy;
  final Uint8List? photoBytes;

  @override
  Widget build(BuildContext context) {
    if (!hasEvidence) {
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: _pickerGold.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _pickerGold.withValues(alpha: 0.22)),
        ),
        child: const Icon(Icons.photo_outlined, color: _pickerGold, size: 26),
      );
    }

    if (isDummy) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _pickerGold.withValues(alpha: 0.70),
              const Color(0xFF173A67),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.image_outlined, color: Colors.white, size: 28),
      );
    }

    if (photoBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.memory(
          photoBytes!,
          width: 64,
          height: 64,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFEEF3F8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(Icons.image_outlined, color: _pickerGold, size: 26),
    );
  }
}

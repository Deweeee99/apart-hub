import 'dart:ui';

import 'package:flutter/material.dart';

const _headerNavy = Color(0xFF071B34);
const _headerBlue = Color(0xFF173A67);
const _headerGold = Color(0xFFC08A1A);
const _headerMuted = Color(0xFF687184);

class SecurityPatrolHeaderCard extends StatelessWidget {
  const SecurityPatrolHeaderCard({
    super.key,
    required this.checkedCount,
    required this.totalCount,
  });

  final int checkedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.94),
                const Color(0xFFFBFCFD).withValues(alpha: 0.90),
                _headerBlue.withValues(alpha: 0.07),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.74)),
            boxShadow: [
              BoxShadow(
                color: _headerNavy.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -24,
                top: -18,
                child: Container(
                  width: 104,
                  height: 72,
                  decoration: BoxDecoration(
                    color: _headerBlue.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
              ),
              Positioned(
                right: 18,
                bottom: 10,
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _headerGold.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: _headerNavy.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _headerGold.withValues(alpha: 0.22),
                      ),
                    ),
                    child: const Icon(
                      Icons.route_outlined,
                      color: _headerGold,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Patrol Management',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: _headerNavy,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Scan each checkpoint, upload area photo, and add notes for management review.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: _headerMuted, height: 1.35),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _SummaryPill(
                              icon: Icons.verified_outlined,
                              label: '$checkedCount of $totalCount checked',
                            ),
                            const _SummaryPill(
                              icon: Icons.schedule_outlined,
                              label: 'Routine patrol',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE7DFD1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: _headerGold),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: _headerNavy,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

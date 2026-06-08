import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/data/demo_data.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/white_premium_card.dart';
import 'access/visitor_management_page.dart';

const _accessNavy = Color(0xFF071B34);
const _accessGold = Color(0xFFC08A1A);
const _accessMuted = Color(0xFF687184);
const _accessSoft = Color(0xFFF8F5EF);
const _accessLine = Color(0xFFE7DFD1);

class DigitalAccessPage extends StatefulWidget {
  const DigitalAccessPage({super.key});

  @override
  State<DigitalAccessPage> createState() => _DigitalAccessPageState();
}

class _DigitalAccessPageState extends State<DigitalAccessPage> {
  String? _activeAccessFeature;

  void _showComingSoon(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_activeAccessFeature == 'visitor') {
      return VisitorManagementPage(
        onBack: () => setState(() => _activeAccessFeature = null),
      );
    }

    final resident = DemoData.primaryResident;
    final recentAccessItems = DemoData.visitors.take(3).toList();

    return Container(
      color: _accessSoft,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        children: [
          _AccessHeader(
            title: 'Access Management',
            subtitle: 'Secure, seamless, and trackable residence access.',
          ),
          const SizedBox(height: 18),
          WhitePremiumCard(
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: _accessGold.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.apartment_rounded,
                    color: _accessGold,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resident.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: _accessNavy,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${resident.unit.label} • ${resident.accessStatus}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: _accessMuted),
                      ),
                    ],
                  ),
                ),
                const StatusBadge(status: 'Active'),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Access Features',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _accessNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          _AccessFeatureCard(
            icon: Icons.person_add_alt_1_outlined,
            title: 'Visitor Management',
            subtitle: 'Secure visitor registration & digital access',
            description:
                'Register visitors, schedule visits, generate QR pass, and track check-in history.',
            ctaLabel: 'Manage Visitor',
            onTap: () => setState(() => _activeAccessFeature = 'visitor'),
          ),
          const SizedBox(height: 14),
          _AccessFeatureCard(
            icon: Icons.local_parking_outlined,
            title: 'Parking Access',
            subtitle: 'Vehicle entry management',
            description:
                'Manage resident guest vehicles and temporary parking passes.',
            ctaLabel: 'Coming Soon',
            onTap: () => _showComingSoon('Parking Access flow coming soon'),
          ),
          const SizedBox(height: 14),
          _AccessFeatureCard(
            icon: Icons.local_shipping_outlined,
            title: 'Delivery Access',
            subtitle: 'Courier and parcel entry',
            description:
                'Coordinate delivery verification and limited-time entry access.',
            ctaLabel: 'Coming Soon',
            onTap: () => _showComingSoon('Delivery Access flow coming soon'),
          ),
          const SizedBox(height: 14),
          _AccessFeatureCard(
            icon: Icons.groups_2_outlined,
            title: 'Guest Access',
            subtitle: 'Short-stay social visits',
            description:
                'Handle invited guest arrivals with simple, premium access control.',
            ctaLabel: 'Coming Soon',
            onTap: () => _showComingSoon('Guest Access flow coming soon'),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Recent Access History',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _accessNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () =>
                    _showComingSoon('Access history detail coming soon'),
                icon: const Icon(Icons.history_outlined, size: 18),
                label: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recentAccessItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: WhitePremiumCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 23,
                      backgroundColor: _accessGold.withValues(alpha: 0.14),
                      child: Text(
                        _initials(item.name),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: _accessNavy,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: _accessNavy,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.purpose,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: _accessMuted),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatDateTime(item.visitTime),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: _accessMuted),
                          ),
                        ],
                      ),
                    ),
                    StatusBadge(status: item.status),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccessHeader extends StatelessWidget {
  const _AccessHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: _accessNavy,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: _accessMuted, height: 1.45),
        ),
      ],
    );
  }
}

class _AccessFeatureCard extends StatelessWidget {
  const _AccessFeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.ctaLabel,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final String ctaLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _accessGold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: _accessGold, size: 27),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _accessNavy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: _accessMuted),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: _accessGold,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: _accessMuted, height: 1.45),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _accessGold.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _accessLine),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_outward_rounded,
                  size: 18,
                  color: AppColors.goldMetallic,
                ),
                const SizedBox(width: 8),
                Text(
                  ctaLabel,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: _accessNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _initials(String value) {
  final parts = value.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty) {
    return 'NA';
  }
  if (parts.length == 1) {
    return parts.first.substring(0, 1).toUpperCase();
  }
  return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
      .toUpperCase();
}

String _formatDateTime(DateTime value) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final day = value.day.toString().padLeft(2, '0');
  final month = months[value.month - 1];
  final year = value.year;
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$day $month $year, $hour:$minute';
}

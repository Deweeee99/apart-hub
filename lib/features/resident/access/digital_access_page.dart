import 'package:flutter/material.dart';

import '../../../core/data/demo_data.dart';
import '../../../core/widgets/white_premium_card.dart';
import 'access_history_page.dart';
import 'generic_access_flow_page.dart';
import 'visitor_management_page.dart';

const _accessNavy = Color(0xFF071B34);
const _accessGold = Color(0xFFC08A1A);
const _accessMuted = Color(0xFF687184);
const _accessSoft = Color(0xFFFAF8F2);
const _accessLine = Color(0xFFE7DFD1);

class DigitalAccessPage extends StatefulWidget {
  const DigitalAccessPage({super.key});

  @override
  State<DigitalAccessPage> createState() => _DigitalAccessPageState();
}

class _DigitalAccessPageState extends State<DigitalAccessPage> {
  String? _activeAccessFeature;

  @override
  Widget build(BuildContext context) {
    if (_activeAccessFeature == 'visitor') {
      return VisitorManagementPage(
        onBack: () => setState(() => _activeAccessFeature = null),
      );
    }

    if (_activeAccessFeature == 'parking') {
      return GenericAccessFlowPage(
        accessType: AccessFlowType.parking,
        onBack: () => setState(() => _activeAccessFeature = null),
      );
    }

    if (_activeAccessFeature == 'delivery') {
      return GenericAccessFlowPage(
        accessType: AccessFlowType.delivery,
        onBack: () => setState(() => _activeAccessFeature = null),
      );
    }

    if (_activeAccessFeature == 'guest') {
      return GenericAccessFlowPage(
        accessType: AccessFlowType.guest,
        onBack: () => setState(() => _activeAccessFeature = null),
      );
    }

    if (_activeAccessFeature == 'history') {
      return AccessHistoryPage(
        onBack: () => setState(() => _activeAccessFeature = null),
      );
    }

    final resident = DemoData.primaryResident;

    return ColoredBox(
      color: _accessSoft,
      child: ListView(
        key: const ValueKey('resident-access-hub'),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        children: [
          Text(
            'Access Management',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: _accessNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Secure, seamless, and trackable residence access for visitors, vehicles, and deliveries.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: _accessMuted, height: 1.45),
          ),
          const SizedBox(height: 18),
          WhitePremiumCard(
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _accessGold.withValues(alpha: 0.12),
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
                'Create parking passes for vehicles, set visit schedule, and review parking access history.',
            ctaLabel: 'Generate Parking Pass',
            onTap: () => setState(() => _activeAccessFeature = 'parking'),
          ),
          const SizedBox(height: 14),
          _AccessFeatureCard(
            icon: Icons.local_shipping_outlined,
            title: 'Delivery Access',
            subtitle: 'Courier and parcel entry',
            description:
                'Prepare delivery access, share QR pass, and verify courier entry with concierge.',
            ctaLabel: 'Create Delivery Pass',
            onTap: () => setState(() => _activeAccessFeature = 'delivery'),
          ),
          const SizedBox(height: 14),
          _AccessFeatureCard(
            icon: Icons.groups_2_outlined,
            title: 'Guest Access',
            subtitle: 'Short-stay social visits',
            description:
                'Handle temporary guest access with a reusable premium QR-based entry flow.',
            ctaLabel: 'Create Guest Pass',
            onTap: () => setState(() => _activeAccessFeature = 'guest'),
          ),
          const SizedBox(height: 14),
          _AccessFeatureCard(
            icon: Icons.history_outlined,
            title: 'Access History',
            subtitle: 'Track all visitor, parking, delivery, and guest access',
            description:
                'Review combined records, filter by access category, and download a simplified access log.',
            ctaLabel: 'View History',
            onTap: () => setState(() => _activeAccessFeature = 'history'),
          ),
        ],
      ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
            child: Text(
              ctaLabel,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: _accessNavy,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

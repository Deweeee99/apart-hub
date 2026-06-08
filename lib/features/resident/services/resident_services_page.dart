import 'package:flutter/material.dart';

import '../../../core/widgets/luxury_button.dart';
import '../../../core/widgets/white_premium_card.dart';
import 'facility_booking_page.dart';
import 'service_request_page.dart';

const _servicesBackground = Color(0xFFFAF8F2);
const _servicesNavy = Color(0xFF071B34);
const _servicesGold = Color(0xFFC08A1A);
const _servicesSoftGold = Color(0xFFFFF6DF);
const _servicesMuted = Color(0xFF687184);

class ResidentServicesPage extends StatefulWidget {
  const ResidentServicesPage({super.key});

  @override
  State<ResidentServicesPage> createState() => _ResidentServicesPageState();
}

class _ResidentServicesPageState extends State<ResidentServicesPage> {
  String? _activeFlow;

  @override
  Widget build(BuildContext context) {
    if (_activeFlow == 'service') {
      return ServiceRequestPage(onBack: _backToHub);
    }
    if (_activeFlow == 'facility') {
      return FacilityBookingPage(onBack: _backToHub);
    }

    return _ServicesSurface(
      child: ListView(
        key: const ValueKey('resident-services-hub'),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        children: [
          const _ServicesHeader(
            title: 'Services',
            subtitle: 'Manage requests, facilities, and resident operations',
            icon: Icons.home_repair_service_outlined,
          ),
          const SizedBox(height: 18),
          _ServiceFeatureCard(
            icon: Icons.build_circle_outlined,
            title: 'Service Request',
            subtitle: 'Maintenance, plumbing, electrical, housekeeping',
            description:
                'Create and track service requests with real-time progress.',
            cta: 'Create Request',
            onTap: () => setState(() => _activeFlow = 'service'),
          ),
          const SizedBox(height: 14),
          _ServiceFeatureCard(
            icon: Icons.event_available_outlined,
            title: 'Facility Booking',
            subtitle: 'Gym, pool, meeting room, and shared amenities',
            description:
                'Reserve facilities, check availability, and manage bookings.',
            cta: 'Book Facility',
            onTap: () => setState(() => _activeFlow = 'facility'),
          ),
        ],
      ),
    );
  }

  void _backToHub() {
    setState(() => _activeFlow = null);
  }
}

class _ServicesSurface extends StatelessWidget {
  const _ServicesSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: _servicesBackground,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: _servicesNavy,
          displayColor: _servicesNavy,
        ),
      ),
      child: ColoredBox(color: _servicesBackground, child: child),
    );
  }
}

class _ServicesHeader extends StatelessWidget {
  const _ServicesHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _GoldIcon(icon: icon, size: 48),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: _servicesNavy,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _servicesMuted,
                    height: 1.35,
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

class _ServiceFeatureCard extends StatelessWidget {
  const _ServiceFeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.cta,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final String cta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(20),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GoldIcon(icon: icon, size: 52),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _servicesNavy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _servicesMuted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: _servicesGold),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _servicesMuted,
              height: 1.42,
            ),
          ),
          const SizedBox(height: 18),
          LuxuryButton(
            label: cta,
            icon: Icons.arrow_forward_outlined,
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}

class _GoldIcon extends StatelessWidget {
  const _GoldIcon({required this.icon, this.size = 40});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _servicesSoftGold,
        borderRadius: BorderRadius.circular(size * 0.34),
        border: Border.all(color: _servicesGold.withValues(alpha: 0.32)),
      ),
      child: Icon(icon, color: _servicesGold, size: size * 0.54),
    );
  }
}

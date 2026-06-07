import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/luxury_background.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roles = [
      _RoleOption(
        title: 'Resident',
        subtitle:
            'Billing, visitor QR, service request, package, facility booking',
        route: '/resident',
        icon: Icons.person_outline,
      ),
      _RoleOption(
        title: 'Management Office',
        subtitle: 'Executive KPI, residents, billing, approvals, announcements',
        route: '/management',
        icon: Icons.business_center_outlined,
      ),
      _RoleOption(
        title: 'Security',
        subtitle: 'QR scanner, patrol checkpoint, incident, emergency handling',
        route: '/security',
        icon: Icons.security_outlined,
      ),
      _RoleOption(
        title: 'Tenant / Merchant',
        subtitle:
            'Services, orders, promos, customer requests, merchant profile',
        route: '/tenant',
        icon: Icons.storefront_outlined,
      ),
    ];

    return LuxuryBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 28),
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.softGold, AppColors.goldMetallic],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.apartment_outlined,
                      color: Color(0xFF141006),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Apart Hub',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          'Integrated Apartment Management Platform',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 34),
              Text(
                'Choose demo role',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Each role has its own dashboard, navigation, and local dummy workflow for presentation.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              for (var i = 0; i < roles.length; i++)
                _RoleCard(option: roles[i])
                    .animate()
                    .fadeIn(delay: (90 * i).ms, duration: 420.ms)
                    .moveY(begin: 18, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.option});

  final _RoleOption option;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      onTap: () => context.go(option.route),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.goldMetallic.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.goldMetallic.withValues(alpha: 0.28),
              ),
            ),
            child: Icon(option.icon, color: AppColors.softGold, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  option.subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.softGold,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _RoleOption {
  const _RoleOption({
    required this.title,
    required this.subtitle,
    required this.route,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String route;
  final IconData icon;
}

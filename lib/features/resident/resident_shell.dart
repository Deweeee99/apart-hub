import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/data/demo_data.dart';
import '../../core/models/app_models.dart';
import '../../core/widgets/emergency_button.dart';
import '../../core/widgets/role_scaffold.dart';
import '../../core/widgets/status_badge.dart';
import 'billing_payment_page.dart';
import 'digital_access_page.dart';
import 'services/resident_services_page.dart';

final _currency = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);
final _date = DateFormat('d MMM yyyy', 'id_ID');

const _residentBackground = Color(0xFFFAF8F2);
const _residentCard = Colors.white;
const _residentNavy = Color(0xFF071B34);
const _residentGold = Color(0xFFC08A1A);
const _residentSoftGold = Color(0xFFFFF6DF);
const _residentMuted = Color(0xFF687184);
const _residentLine = Color(0xFFE7DFD1);

class ResidentShell extends StatefulWidget {
  const ResidentShell({super.key});

  @override
  State<ResidentShell> createState() => _ResidentShellState();
}

class _ResidentShellState extends State<ResidentShell> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      ResidentDashboardPage(
        onNavigate: (newIndex) {
          setState(() {
            _index = newIndex;
          });
        },
      ),
      const DigitalAccessPage(),
      const BillingPaymentPage(),
      const ResidentServicesPage(),
      const CommunityPage(),
    ];

    return RoleScaffold(
      currentIndex: _index,
      onIndexChanged: (value) => setState(() => _index = value),
      roleLabel: 'Resident App',
      items: const [
        RoleNavItem(
          label: 'Home',
          icon: Icons.home_outlined,
          selectedIcon: Icons.home,
        ),
        RoleNavItem(
          label: 'Access',
          icon: Icons.qr_code_2_outlined,
          selectedIcon: Icons.qr_code_2,
        ),
        RoleNavItem(
          label: 'Billing',
          icon: Icons.receipt_long_outlined,
          selectedIcon: Icons.receipt_long,
        ),
        RoleNavItem(
          label: 'Services',
          icon: Icons.handyman_outlined,
          selectedIcon: Icons.handyman,
        ),
        RoleNavItem(
          label: 'Community',
          icon: Icons.forum_outlined,
          selectedIcon: Icons.forum,
        ),
      ],
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: pages[_index],
      ),
    );
  }
}

class ResidentDashboardPage extends StatelessWidget {
  const ResidentDashboardPage({super.key, required this.onNavigate});

  final Function(int) onNavigate;

  @override
  Widget build(BuildContext context) {
    final resident = DemoData.primaryResident;
    final activeBill = DemoData.billings
        .where((billing) => billing.status != 'Paid')
        .fold<int>(0, (total, billing) => total + billing.amount);
    final waitingPackages = DemoData.packages
        .where((item) => item.status == 'Waiting Pickup')
        .length;

    return _ResidentSurface(
      child: ListView(
        key: const ValueKey('resident-dashboard'),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        children: [
          _ResidentHeroCard(
            resident: resident,
            activeBill: activeBill,
          ).animate().fadeIn(duration: 420.ms).moveY(begin: 16, end: 0),
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Quick Actions',
            actionLabel: '4 shortcuts',
            icon: Icons.flash_on_outlined,
          ),
          _ResponsiveGrid(
            minTileWidth: 132,
            spacing: 12,
            childAspectRatio: 0.72,
            children: [
              _ResidentActionCard(
                icon: Icons.qr_code_2_outlined,
                title: 'Digital Access',
                subtitle: 'Visitor, parking',
                onTap: () => onNavigate(1),
              ),
              _ResidentActionCard(
                icon: Icons.payments_outlined,
                title: 'Pay Bill',
                subtitle: 'Invoices & dues',
                onTap: () => onNavigate(2),
              ),
              _ResidentActionCard(
                icon: Icons.event_available_outlined,
                title: 'Facility',
                subtitle: 'Book amenity',
                onTap: () => onNavigate(3),
              ),
              _ResidentActionCard(
                icon: Icons.forum_outlined,
                title: 'Community',
                subtitle: 'Forum & events',
                onTap: () => onNavigate(4),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionTitle(
            title: 'Latest Services',
            actionLabel: 'View all',
            icon: Icons.apps_outlined,
          ),
          _ResponsiveGrid(
            minTileWidth: 148,
            spacing: 12,
            childAspectRatio: 0.74,
            children: [
              _MiniFeatureTile(
                icon: Icons.receipt_long_outlined,
                title: 'Billing & Payment',
                subtitle: 'Review active invoice',
                onTap: () => onNavigate(2),
              ),
              _MiniFeatureTile(
                icon: Icons.handyman_outlined,
                title: 'Service Request',
                subtitle: 'Track maintenance',
                onTap: () => onNavigate(3),
              ),
              _MiniFeatureTile(
                icon: Icons.pool_outlined,
                title: 'Facility Booking',
                subtitle: 'Reserve premium spaces',
                onTap: () => onNavigate(3),
              ),
              _MiniFeatureTile(
                icon: Icons.inventory_2_outlined,
                title: 'Package & Delivery',
                subtitle: '$waitingPackages waiting pickup',
                onTap: () => onNavigate(3),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionTitle(
            title: 'Today Summary',
            actionLabel: resident.unit.label,
            icon: Icons.today_outlined,
          ),
          _ResponsiveGrid(
            minTileWidth: 132,
            spacing: 12,
            childAspectRatio: 0.78,
            children: [
              _MetricMiniCard(
                icon: Icons.domain_outlined,
                label: 'Resident',
                value: resident.residencyStatus,
                caption: resident.unit.status,
              ),
              _MetricMiniCard(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Running bill',
                value: _currency.format(activeBill),
                caption: 'IPL, electricity, parking',
              ),
              _MetricMiniCard(
                icon: Icons.inventory_2_outlined,
                label: 'Packages',
                value: '$waitingPackages parcels',
                caption: 'Waiting pickup',
              ),
              _MetricMiniCard(
                icon: Icons.verified_user_outlined,
                label: 'Access',
                value: resident.accessStatus,
                caption: 'Billing ${resident.billingStatus}',
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionTitle(
            title: 'Community Hub',
            actionLabel: 'Latest',
            icon: Icons.campaign_outlined,
          ),
          _WhitePremiumCard(
            child: _AnnouncementPreview(
              title: DemoData.announcements.first.title,
              message: DemoData.announcements.first.message,
              category: DemoData.announcements.first.category,
              onTap: () => onNavigate(4),
            ),
          ),
          const SizedBox(height: 16),
          _EmergencyPanel(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Emergency alert simulated for Unit A-1808.'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['Forum', 'Marketplace', 'Lost & Found', 'Events'];

    return DefaultTabController(
      length: categories.length,
      child: _ResidentSurface(
        child: Column(
          key: const ValueKey('resident-community'),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _ResidentHeader(
                    title: 'Community Hub',
                    subtitle: 'Stay connected, informed, and engaged',
                    icon: Icons.forum_outlined,
                  ),
                  const SizedBox(height: 14),
                  const _CommunityFeatureRow(),
                  const SizedBox(height: 14),
                  _WhitePremiumCard(
                    padding: const EdgeInsets.all(6),
                    child: TabBar(
                      isScrollable: true,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: _residentSoftGold,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: _residentGold.withValues(alpha: 0.32),
                        ),
                      ),
                      labelColor: _residentNavy,
                      unselectedLabelColor: _residentMuted,
                      labelStyle: Theme.of(context).textTheme.labelLarge
                          ?.copyWith(fontWeight: FontWeight.w900),
                      tabAlignment: TabAlignment.start,
                      tabs: [
                        for (final category in categories)
                          Tab(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(category),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  for (final category in categories)
                    ListView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                      children: [
                        for (final post in DemoData.communityPosts.where(
                          (item) => item.category == category,
                        ))
                          _CommunityPostCard(post: post),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResidentSurface extends StatelessWidget {
  const _ResidentSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    return Theme(
      data: base.copyWith(
        textTheme: base.textTheme.apply(
          bodyColor: _residentNavy,
          displayColor: _residentNavy,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: _residentMuted),
          floatingLabelStyle: const TextStyle(
            color: _residentGold,
            fontWeight: FontWeight.w800,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _residentLine),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _residentGold, width: 1.2),
          ),
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          textStyle: TextStyle(color: _residentNavy),
        ),
      ),
      child: ColoredBox(color: _residentBackground, child: child),
    );
  }
}

class _WhitePremiumCard extends StatelessWidget {
  const _WhitePremiumCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.margin = EdgeInsets.zero,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: _residentCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _residentLine),
        boxShadow: [
          BoxShadow(
            color: _residentNavy.withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
    if (onTap == null) {
      return content;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: content,
      ),
    );
  }
}

class _ResidentHeader extends StatelessWidget {
  const _ResidentHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return _WhitePremiumCard(
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
                    color: _residentNavy,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _residentMuted,
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

class _ResidentHeroCard extends StatelessWidget {
  const _ResidentHeroCard({required this.resident, required this.activeBill});

  final Resident resident;
  final int activeBill;

  @override
  Widget build(BuildContext context) {
    return _WhitePremiumCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: _residentNavy,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _residentGold.withValues(alpha: 0.46),
                    ),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: _residentGold,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning, ${resident.name.split(' ').first}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${resident.unit.label} / ${resident.residencyStatus} Resident',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.76),
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      tooltip: 'Notifications',
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_none_outlined,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      top: 9,
                      right: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.danger,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 360;
                final cards = [
                  _HeroMiniCard(
                    label: 'Due Payments',
                    value: _currency.format(activeBill),
                    caption: 'Due ${_date.format(DateTime(2026, 6, 12))}',
                    icon: Icons.receipt_long_outlined,
                    dark: true,
                  ),
                  const _HeroMiniCard(
                    label: 'My Points',
                    value: '12.450',
                    caption: 'Active access status',
                    icon: Icons.card_giftcard_outlined,
                  ),
                ];
                if (isNarrow) {
                  return Column(
                    children: [
                      cards.first,
                      const SizedBox(height: 12),
                      cards.last,
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(child: cards.first),
                    const SizedBox(width: 12),
                    Expanded(child: cards.last),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMiniCard extends StatelessWidget {
  const _HeroMiniCard({
    required this.label,
    required this.value,
    required this.caption,
    required this.icon,
    this.dark = false,
  });

  final String label;
  final String value;
  final String caption;
  final IconData icon;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? _residentNavy : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: dark ? Colors.transparent : _residentLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: dark
                        ? Colors.white.withValues(alpha: 0.78)
                        : _residentMuted,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Icon(icon, color: _residentGold, size: 22),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: dark ? _residentGold : _residentNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            caption,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: dark
                  ? Colors.white.withValues(alpha: 0.72)
                  : _residentMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.icon,
    this.actionLabel,
  });

  final String title;
  final IconData icon;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: _residentGold, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: _residentNavy,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          if (actionLabel != null)
            Text(
              actionLabel!,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: _residentGold,
                fontWeight: FontWeight.w800,
              ),
            ),
        ],
      ),
    );
  }
}

class _ResponsiveGrid extends StatelessWidget {
  const _ResponsiveGrid({
    required this.children,
    this.minTileWidth = 140,
    this.spacing = 12,
    this.childAspectRatio,
  });

  final List<Widget> children;
  final double minTileWidth;
  final double spacing;
  final double? childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final rawCount =
            ((constraints.maxWidth + spacing) / (minTileWidth + spacing))
                .floor();
        final count = rawCount.clamp(2, 4);
        return GridView.count(
          crossAxisCount: count,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: childAspectRatio ?? (count > 2 ? 1.05 : 1.18),
          children: children,
        );
      },
    );
  }
}

class _ResidentActionCard extends StatelessWidget {
  const _ResidentActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _WhitePremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _GoldIcon(icon: icon, size: 48),
          const SizedBox(height: 14),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: _residentNavy,
              fontWeight: FontWeight.w900,
              height: 1.16,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _residentMuted,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniFeatureTile extends StatelessWidget {
  const _MiniFeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _WhitePremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _GoldIcon(icon: icon, size: 48),
          const SizedBox(height: 14),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: _residentNavy,
              fontWeight: FontWeight.w900,
              height: 1.16,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            subtitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: _residentMuted, height: 1.3),
          ),
        ],
      ),
    );
  }
}

class _MetricMiniCard extends StatelessWidget {
  const _MetricMiniCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.caption,
  });

  final IconData icon;
  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return _WhitePremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _GoldIcon(icon: icon, size: 46),
          const SizedBox(height: 14),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: _residentNavy,
              fontWeight: FontWeight.w900,
              height: 1.16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _residentMuted,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _residentMuted,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementPreview extends StatelessWidget {
  const _AnnouncementPreview({
    required this.title,
    required this.message,
    required this.category,
    required this.onTap,
  });

  final String title;
  final String message;
  final String category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Row(
        children: [
          const _GoldIcon(icon: Icons.campaign_outlined, size: 46),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusBadge(status: category),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: _residentNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _residentMuted,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: _residentGold),
        ],
      ),
    );
  }
}

class _EmergencyPanel extends StatelessWidget {
  const _EmergencyPanel({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _WhitePremiumCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.danger.withValues(alpha: 0.20),
                  ),
                ),
                child: const Icon(Icons.sos_outlined, color: AppColors.danger),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency Assistance',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: _residentNavy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'SOS, security, and medical assistance remain one tap away.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: _residentMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          EmergencyButton(onPressed: onPressed),
        ],
      ),
    );
  }
}

class _CommunityFeatureRow extends StatelessWidget {
  const _CommunityFeatureRow();

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.campaign_outlined, 'Announcements'),
      (Icons.event_outlined, 'Events'),
      (Icons.chat_bubble_outline, 'Forum'),
      (Icons.folder_copy_outlined, 'Archive'),
    ];
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 126,
            child: _WhitePremiumCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GoldIcon(icon: items[index].$1, size: 34),
                  const Spacer(),
                  Text(
                    items[index].$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: _residentNavy,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CommunityPostCard extends StatelessWidget {
  const _CommunityPostCard({required this.post});

  final CommunityPost post;

  @override
  Widget build(BuildContext context) {
    final icon = switch (post.category) {
      'Marketplace' => Icons.sell_outlined,
      'Lost & Found' => Icons.manage_search_outlined,
      'Events' => Icons.celebration_outlined,
      _ => Icons.chat_bubble_outline,
    };
    return _WhitePremiumCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _GoldIcon(icon: icon, size: 42),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: _residentNavy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      post.category,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: _residentMuted),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz, color: _residentMuted),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            post.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: _residentNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            post.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _residentMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 17,
                color: _residentMuted.withValues(alpha: 0.85),
              ),
              const SizedBox(width: 5),
              Text(
                '12',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: _residentMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.favorite_border,
                size: 17,
                color: _residentMuted.withValues(alpha: 0.85),
              ),
              const SizedBox(width: 5),
              Text(
                '24',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: _residentMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
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
        color: _residentSoftGold,
        borderRadius: BorderRadius.circular(size * 0.34),
        border: Border.all(color: _residentGold.withValues(alpha: 0.32)),
      ),
      child: Icon(icon, color: _residentGold, size: size * 0.54),
    );
  }
}

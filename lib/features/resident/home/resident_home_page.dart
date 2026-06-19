import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/data/demo_data.dart';
import '../../../core/models/app_models.dart';
import '../../../core/widgets/emergency_button.dart';
import '../../../core/widgets/white_premium_card.dart';
import '../marketplace/tenant_marketplace_page.dart';

final _currency = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);
final _date = DateFormat('d MMM yyyy', 'id_ID');

const _homeSurface = Color(0xFFF8F5EF);
const _homeNavy = Color(0xFF071B34);
const _homeBlue = Color(0xFF173A67);
const _homeGold = Color(0xFFC08A1A);
const _homeSoftGold = Color(0xFFFFF6DF);
const _homeMuted = Color(0xFF687184);
const _homeLine = Color(0xFFE7DFD1);

class ResidentDashboardPage extends StatelessWidget {
  const ResidentDashboardPage({super.key, required this.onNavigate});

  final void Function(int) onNavigate;

  @override
  Widget build(BuildContext context) {
    final resident = DemoData.primaryResident;
    final activeBillings = DemoData.billings
        .where((billing) => billing.status != 'Paid')
        .toList();
    final totalOutstanding = activeBillings.fold<int>(
      0,
      (total, billing) => total + billing.amount,
    );
    final nearestDue = activeBillings.isEmpty
        ? null
        : activeBillings.reduce(
            (current, next) =>
                current.dueDate.isBefore(next.dueDate) ? current : next,
          );
    final waitingPackages = DemoData.packages
        .where((item) => item.status == 'Waiting Pickup')
        .length;
    final upcomingBooking = DemoData.bookings.firstWhere(
      (booking) => booking.residentName == resident.name,
      orElse: () => DemoData.bookings.first,
    );
    final latestPackage = DemoData.packages.first;
    final activeTicket = DemoData.tickets.first;
    final latestAnnouncement = DemoData.announcements.first;
    final promo = const _PromoCardData(
      merchant: 'Brew Cabin',
      item: 'Cappuccino',
      priceLabel: 'Rp 32.000',
      badge: 'Promo Today',
    );
    final emergencyContact = const _EmergencyContactData(
      securityLabel: 'Security Center',
      securityPhone: '021 - 1234 - 5678',
      medicalLabel: 'Ambulance',
      medicalPhone: '021 - 1234 - 5679',
    );

    void showEmergency() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Emergency alert simulated for Unit A-1808.'),
        ),
      );
    }

    void showPackagesSoon() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Package tracking will be available soon'),
        ),
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(
          context,
        ).textTheme.apply(bodyColor: _homeNavy, displayColor: _homeNavy),
      ),
      child: ColoredBox(
        color: _homeSurface,
        child: ListView(
          key: const ValueKey('resident-dashboard'),
          padding: const EdgeInsets.only(bottom: 130),
          children: [
            _HeroBillStack(
              resident: resident,
              totalOutstanding: totalOutstanding,
              nearestDue: nearestDue,
              onEmergency: showEmergency,
              onPayNow: () => onNavigate(2),
            ).animate().fadeIn(duration: 420.ms).moveY(begin: 16, end: 0),
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const _SectionTitle(
                    title: 'Quick Access',
                    actionLabel: '8 shortcuts',
                  ),
                  const SizedBox(height: 12),
                  _AdaptiveGrid(
                    minTileWidth: 92,
                    childAspectRatio: 0.94,
                    children: [
                      _QuickAccessCard(
                        icon: Icons.person_search_outlined,
                        title: 'QR Visitor',
                        onTap: () => onNavigate(1),
                      ),
                      _QuickAccessCard(
                        icon: Icons.directions_car_outlined,
                        title: 'QR Parking',
                        onTap: () => onNavigate(1),
                      ),
                      _QuickAccessCard(
                        icon: Icons.storefront_outlined,
                        title: 'Marketplace',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const TenantMarketplacePage(),
                            ),
                          );
                        },
                      ),
                      _QuickAccessCard(
                        icon: Icons.qr_code_scanner_outlined,
                        title: 'Digital Access',
                        onTap: () => onNavigate(1),
                      ),
                      _QuickAccessCard(
                        icon: Icons.event_available_outlined,
                        title: 'Facility Booking',
                        onTap: () => onNavigate(3),
                      ),
                      _QuickAccessCard(
                        icon: Icons.handyman_outlined,
                        title: 'Services',
                        onTap: () => onNavigate(3),
                      ),
                      _QuickAccessCard(
                        icon: Icons.local_shipping_outlined,
                        title: 'Packages',
                        onTap: showPackagesSoon,
                      ),
                      _QuickAccessCard(
                        icon: Icons.forum_outlined,
                        title: 'Community',
                        onTap: () => onNavigate(4),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SummaryStrip(
                residentStatus: resident.residencyStatus,
                accessStatus: resident.accessStatus,
                waitingPackages: waitingPackages,
                activeBillLabel: _currency.format(totalOutstanding),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const _SectionTitle(
                    title: "What's New",
                    actionLabel: 'View All',
                  ),
                  const SizedBox(height: 12),
                  _AdaptiveGrid(
                    minTileWidth: 156,
                    childAspectRatio: 0.86,
                    children: [
                      _ActivityCard(
                        icon: Icons.event_available_outlined,
                        eyebrow: 'Upcoming Booking',
                        title: upcomingBooking.facility,
                        detail:
                            '${_date.format(upcomingBooking.date)}\n${upcomingBooking.slot}',
                        actionLabel: 'View',
                        actionColor: const Color(0xFF3A94C9),
                        onTap: () => onNavigate(3),
                      ),
                      _ActivityCard(
                        icon: Icons.inventory_2_outlined,
                        eyebrow: 'New Package Arrived',
                        title: latestPackage.sender,
                        detail:
                            '${latestPackage.courier}\n${_date.format(latestPackage.arrivalTime)} ${_clock(latestPackage.arrivalTime)}',
                        actionLabel: 'View Details',
                        actionColor: _homeGold,
                        onTap: showPackagesSoon,
                      ),
                      _ActivityCard(
                        icon: Icons.handyman_outlined,
                        eyebrow: 'Service Request',
                        title: activeTicket.title,
                        detail:
                            'Status\n${_ticketStatusLabel(activeTicket.status)}',
                        actionLabel: 'Track',
                        actionColor: AppColors.success,
                        onTap: () => onNavigate(3),
                      ),
                      _ActivityCard(
                        icon: Icons.campaign_outlined,
                        eyebrow: 'Community Update',
                        title: latestAnnouncement.title,
                        detail:
                            '${_date.format(latestAnnouncement.publishedAt)}\n${latestAnnouncement.message}',
                        actionLabel: 'Read More',
                        actionColor: const Color(0xFF3A94C9),
                        onTap: () => onNavigate(4),
                      ),
                      _ActivityCard(
                        icon: Icons.local_cafe_outlined,
                        eyebrow: 'Tenant Promo',
                        title: promo.merchant,
                        detail: '${promo.item}\n${promo.priceLabel}',
                        badgeText: promo.badge,
                        actionLabel: 'Order Now',
                        actionColor: _homeGold,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Tenant promo ordering is simulated.',
                              ),
                            ),
                          );
                        },
                      ),
                      _ActivityCard(
                        icon: Icons.support_agent_outlined,
                        eyebrow: 'Emergency Contact',
                        title: emergencyContact.securityLabel,
                        detail:
                            '${emergencyContact.securityPhone}\n${emergencyContact.medicalLabel}\n${emergencyContact.medicalPhone}',
                        actionLabel: 'Call Now',
                        actionColor: AppColors.danger,
                        onTap: showEmergency,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _EmergencyPanel(onPressed: showEmergency),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroBillStack extends StatelessWidget {
  const _HeroBillStack({
    required this.resident,
    required this.totalOutstanding,
    required this.nearestDue,
    required this.onEmergency,
    required this.onPayNow,
  });

  final Resident resident;
  final int totalOutstanding;
  final Billing? nearestDue;
  final VoidCallback onEmergency;
  final VoidCallback onPayNow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 388,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _HeroHeader(resident: resident, onEmergency: onEmergency),
          const Positioned(
            left: 0,
            right: 0,
            top: 188,
            height: 96,
            child: IgnorePointer(child: _HeroFadeTransition()),
          ),
          Positioned(
            left: 20,
            right: 20,
            top: 224,
            child: Transform.translate(
              offset: const Offset(0, -2),
              child: _OutstandingBillCard(
                totalOutstanding: totalOutstanding,
                nearestDue: nearestDue,
                onPayNow: onPayNow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.resident, required this.onEmergency});

  final Resident resident;
  final VoidCallback onEmergency;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 274,
      padding: const EdgeInsets.fromLTRB(28, 30, 28, 86),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_homeNavy, _homeBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: _homeNavy.withValues(alpha: 0.20),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -24,
            right: -18,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.16),
                    Colors.white.withValues(alpha: 0.02),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -18,
            left: 104,
            child: Container(
              width: 184,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(120),
                gradient: LinearGradient(
                  colors: [
                    _homeGold.withValues(alpha: 0.08),
                    Colors.white.withValues(alpha: 0.01),
                  ],
                ),
              ),
            ),
          ),
          Column(
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
                          'Good Morning,',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.92),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${resident.name.split(' ').first} 👋',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                height: 1.0,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _NotificationButton(),
                  const SizedBox(width: 10),
                  _HeroEmergencyButton(onTap: onEmergency),
                  const SizedBox(width: 10),
                  _HeroLogoutButton(onTap: () => context.go('/login')),
                ],
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _HeroBadge(text: 'Unit ${resident.unit.number}'),
                  _HeroBadge(text: resident.unit.tower),
                  _HeroBadge(text: '${resident.accessStatus} Access'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroFadeTransition extends StatelessWidget {
  const _HeroFadeTransition();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            _homeSurface.withValues(alpha: 0.84),
            _homeSurface,
          ],
        ),
      ),
    );
  }
}

class _OutstandingBillCard extends StatelessWidget {
  const _OutstandingBillCard({
    required this.totalOutstanding,
    required this.nearestDue,
    required this.onPayNow,
  });

  final int totalOutstanding;
  final Billing? nearestDue;
  final VoidCallback onPayNow;

  @override
  Widget build(BuildContext context) {
    final dueLabel = nearestDue == null
        ? 'No active invoice'
        : 'Due Date ${_date.format(nearestDue!.dueDate)}';
    final badgeLabel = totalOutstanding > 0 ? 'Due Soon' : 'Paid';

    return WhitePremiumCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: _homeSoftGold,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _homeGold.withValues(alpha: 0.25)),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: _homeGold,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Outstanding Bill',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: _homeNavy,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _BillStatusPill(label: badgeLabel),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _currency.format(totalOutstanding),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: _homeNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  dueLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: _homeMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 42,
            child: ElevatedButton(
              onPressed: onPayNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: _homeGold,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Pay Now',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BillStatusPill extends StatelessWidget {
  const _BillStatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFC9E1FF)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: const Color(0xFF60A5FA),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.actionLabel});

  final String title;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: _homeNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (actionLabel != null)
          Text(
            actionLabel!,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: _homeGold,
              fontWeight: FontWeight.w800,
            ),
          ),
      ],
    );
  }
}

class _AdaptiveGrid extends StatelessWidget {
  const _AdaptiveGrid({
    required this.children,
    required this.minTileWidth,
    required this.childAspectRatio,
  });

  final List<Widget> children;
  final double minTileWidth;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final rawCount =
            ((constraints.maxWidth + spacing) / (minTileWidth + spacing))
                .floor();
        final count = rawCount.clamp(2, 4);
        return GridView.count(
          crossAxisCount: count,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: childAspectRatio,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: children,
        );
      },
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(child: _GoldIcon(icon: icon, size: 40)),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 28,
            child: Center(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: _homeNavy,
                  fontWeight: FontWeight.w800,
                  height: 1.16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({
    required this.residentStatus,
    required this.accessStatus,
    required this.waitingPackages,
    required this.activeBillLabel,
  });

  final String residentStatus;
  final String accessStatus;
  final int waitingPackages;
  final String activeBillLabel;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _SummaryItem(label: 'Resident', value: residentStatus),
          _SummaryItem(label: 'Access', value: accessStatus),
          _SummaryItem(label: 'Packages', value: '$waitingPackages Waiting'),
          _SummaryItem(label: 'Active Bill', value: activeBillLabel),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 120),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _homeLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _homeMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _homeNavy,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.detail,
    required this.actionLabel,
    required this.actionColor,
    required this.onTap,
    this.badgeText,
  });

  final IconData icon;
  final String eyebrow;
  final String title;
  final String detail;
  final String actionLabel;
  final Color actionColor;
  final VoidCallback onTap;
  final String? badgeText;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _homeGold, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  eyebrow,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: _homeNavy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _homeSoftGold,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: _homeGold.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Text(
                    badgeText!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _homeGold,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _homeNavy,
              fontWeight: FontWeight.w900,
              height: 1.16,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              detail,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: _homeMuted, height: 1.4),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: actionColor,
                side: BorderSide(color: actionColor.withValues(alpha: 0.48)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                actionLabel,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
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
    return WhitePremiumCard(
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
                        color: _homeNavy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Need urgent help? Contact security instantly.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: _homeMuted),
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

class _NotificationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
          ),
          child: const Icon(
            Icons.notifications_none_outlined,
            color: Colors.white,
          ),
        ),
        Positioned(
          top: -2,
          right: -2,
          child: Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.danger,
              shape: BoxShape.circle,
            ),
            child: const Text(
              '3',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroEmergencyButton extends StatelessWidget {
  const _HeroEmergencyButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shield_outlined,
              color: AppColors.danger,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'SOS',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.danger,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroLogoutButton extends StatelessWidget {
  const _HeroLogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Logout',
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.10),
        foregroundColor: _homeGold,
        minimumSize: const Size(44, 44),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.16)),
      ),
      icon: const Icon(Icons.exit_to_app_outlined),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.white.withValues(alpha: 0.92),
          fontWeight: FontWeight.w700,
        ),
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
        color: _homeSoftGold,
        borderRadius: BorderRadius.circular(size * 0.32),
        border: Border.all(color: _homeGold.withValues(alpha: 0.30)),
      ),
      child: Icon(icon, color: _homeGold, size: size * 0.52),
    );
  }
}

class _PromoCardData {
  const _PromoCardData({
    required this.merchant,
    required this.item,
    required this.priceLabel,
    required this.badge,
  });

  final String merchant;
  final String item;
  final String priceLabel;
  final String badge;
}

class _EmergencyContactData {
  const _EmergencyContactData({
    required this.securityLabel,
    required this.securityPhone,
    required this.medicalLabel,
    required this.medicalPhone,
  });

  final String securityLabel;
  final String securityPhone;
  final String medicalLabel;
  final String medicalPhone;
}

String _clock(DateTime value) {
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String _ticketStatusLabel(String status) {
  return switch (status) {
    'Progress' => 'In Progress',
    'Assigned' => 'Assigned',
    'Done' => 'Completed',
    _ => status,
  };
}

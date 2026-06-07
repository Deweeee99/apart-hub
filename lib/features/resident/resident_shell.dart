import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../core/data/demo_data.dart';
import '../../core/models/app_models.dart';
import '../../core/widgets/emergency_button.dart';
import '../../core/widgets/luxury_button.dart';
import '../../core/widgets/role_scaffold.dart';
import '../../core/widgets/status_badge.dart';
import 'billing_payment_page.dart';
import 'digital_access_page.dart';

final _currency = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);
final _date = DateFormat('d MMM yyyy', 'id_ID');
final _time = DateFormat('HH:mm', 'id_ID');

const _residentBackground = Color(0xFFFAF8F2);
const _residentCard = Colors.white;
const _residentNavy = Color(0xFF071B34);
const _residentGold = Color(0xFFC08A1A);
const _residentSoftGold = Color(0xFFFFF6DF);
const _residentMuted = Color(0xFF687184);
const _residentLine = Color(0xFFE7DFD1);
const _residentSoftGray = Color(0xFFF2F0EA);

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
      const ResidentServicePage(),
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
          label: 'Service',
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

class ResidentServicePage extends StatefulWidget {
  const ResidentServicePage({super.key});

  @override
  State<ResidentServicePage> createState() => _ResidentServicePageState();
}

class _ResidentServicePageState extends State<ResidentServicePage> {
  late var _tickets = DemoData.tickets.map((item) => item).toList();
  late var _bookings = DemoData.bookings
      .where((item) => item.residentName == 'Jonathan Wijaya')
      .toList();
  var _mode = 'Tickets';
  var _category = 'AC Rusak';
  var _priority = 'Medium';
  var _facility = 'Kolam Renang';
  var _slot = '07:00 - 08:00';
  final _titleController = TextEditingController(
    text: 'AC ruang tamu perlu pengecekan',
  );
  final _descriptionController = TextEditingController(
    text: 'Udara kurang dingin sejak semalam.',
  );

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ResidentSurface(
      child: ListView(
        key: const ValueKey('resident-service'),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        children: [
          const _ResidentHeader(
            title: 'Service, Package & Facility',
            subtitle: 'Fast, transparent, and efficient resident operations',
            icon: Icons.home_repair_service_outlined,
          ),
          const SizedBox(height: 14),
          const _FlowStepStrip(
            steps: [
              'Create',
              'Describe',
              'Submitted',
              'Assigned',
              'Progress',
              'Completed',
              'Rate',
            ],
          ),
          const SizedBox(height: 16),
          _SegmentedModeControl(
            modes: const ['Tickets', 'Packages', 'Facility'],
            selected: _mode,
            onSelected: (value) => setState(() => _mode = value),
          ),
          const SizedBox(height: 16),
          if (_mode == 'Tickets') ..._ticketContent(context),
          if (_mode == 'Packages') ..._packageContent(),
          if (_mode == 'Facility') ..._facilityContent(context),
        ],
      ),
    );
  }

  List<Widget> _ticketContent(BuildContext context) {
    return [
      _WhitePremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _CardTitle(
              title: 'Submit Ticket',
              subtitle:
                  'Describe the issue and let management assign the right staff.',
              icon: Icons.edit_note_outlined,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items:
                  [
                        'AC Rusak',
                        'Plumbing',
                        'Listrik',
                        'Housekeeping',
                        'Internet',
                      ]
                      .map(
                        (item) =>
                            DropdownMenuItem(value: item, child: Text(item)),
                      )
                      .toList(),
              onChanged: (value) =>
                  setState(() => _category = value ?? _category),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              minLines: 3,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _priority,
              decoration: const InputDecoration(labelText: 'Priority'),
              items: ['Low', 'Medium', 'High', 'Emergency']
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: (value) =>
                  setState(() => _priority = value ?? _priority),
            ),
            const SizedBox(height: 12),
            const _UploadPhotoStub(),
            const SizedBox(height: 14),
            LuxuryButton(
              label: 'Submit Ticket',
              icon: Icons.add_task_outlined,
              onPressed: () {
                final id = 'SR-${2400 + _tickets.length + 1}';
                setState(() {
                  _tickets = [
                    ServiceTicket(
                      id: id,
                      category: _category,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      priority: _priority,
                      status: 'Open',
                      assignee: 'Waiting assignment',
                    ),
                    ..._tickets,
                  ];
                });
              },
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      const _SectionTitle(
        title: 'Ticket Pipeline',
        actionLabel: 'Live status',
        icon: Icons.route_outlined,
      ),
      const _ServiceStatusTimeline(),
      const SizedBox(height: 12),
      for (final ticket in _tickets) _TicketPipelineCard(ticket: ticket),
    ];
  }

  List<Widget> _packageContent() {
    return [
      _PremiumQrCard(
        code: 'PKG-A1808-PICKUP',
        title: 'Pickup QR / Code',
        subtitle: 'Show this code at concierge to collect waiting packages.',
      ),
      const SizedBox(height: 20),
      _SectionTitle(
        title: 'Package List',
        actionLabel: '${DemoData.packages.length} items',
        icon: Icons.inventory_2_outlined,
      ),
      for (final item in DemoData.packages) _PackageCard(item: item),
    ];
  }

  List<Widget> _facilityContent(BuildContext context) {
    return [
      _WhitePremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _CardTitle(
              title: 'Booking Facility',
              subtitle:
                  'Choose facility, review availability, and submit a digital reservation.',
              icon: Icons.event_available_outlined,
            ),
            const SizedBox(height: 16),
            _ChoiceWrap(
              items: const [
                'Kolam Renang',
                'Gym',
                'Function Hall',
                'Tennis Court',
                'Meeting Room',
              ],
              selected: _facility,
              onSelected: (value) => setState(() => _facility = value),
            ),
            const SizedBox(height: 16),
            const _InfoTile(
              icon: Icons.calendar_month_outlined,
              title: 'Selected date',
              subtitle: '7 Jun 2026',
              status: 'Available',
            ),
            const SizedBox(height: 12),
            _ChoiceWrap(
              items: const [
                '07:00 - 08:00',
                '10:00 - 11:00',
                '16:00 - 17:00',
                '19:00 - 22:00',
              ],
              selected: _slot,
              onSelected: (value) => setState(() => _slot = value),
            ),
            const SizedBox(height: 16),
            LuxuryButton(
              label: 'Submit Booking',
              icon: Icons.event_available_outlined,
              onPressed: () {
                setState(() {
                  _bookings = [
                    FacilityBooking(
                      id: 'BK-${1000 + _bookings.length + 1}',
                      facility: _facility,
                      date: DateTime(2026, 6, 7),
                      slot: _slot,
                      status: 'Waiting Approval',
                      residentName: 'Jonathan Wijaya',
                    ),
                    ..._bookings,
                  ];
                });
              },
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      _SectionTitle(
        title: 'Booking History',
        actionLabel: '${_bookings.length} reservations',
        icon: Icons.history_toggle_off_outlined,
      ),
      for (final booking in _bookings) _FacilityBookingCard(booking: booking),
    ];
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

class _FlowStepStrip extends StatelessWidget {
  const _FlowStepStrip({required this.steps});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: steps.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return _FlowStepCard(number: index + 1, label: steps[index]);
        },
      ),
    );
  }
}

class _FlowStepCard extends StatelessWidget {
  const _FlowStepCard({required this.number, required this.label});

  final int number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _residentGold.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: _residentGold,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const Spacer(),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: _residentNavy,
              fontWeight: FontWeight.w900,
              height: 1.12,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GoldIcon(icon: icon, size: 42),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _residentNavy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _residentMuted,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChoiceWrap extends StatelessWidget {
  const _ChoiceWrap({
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  final List<String> items;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in items)
          _PillChoice(
            label: item,
            selected: selected == item,
            onTap: () => onSelected(item),
          ),
      ],
    );
  }
}

class _PillChoice extends StatelessWidget {
  const _PillChoice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _residentSoftGold : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(
          color: selected
              ? _residentGold.withValues(alpha: 0.55)
              : _residentLine,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: selected ? _residentNavy : _residentMuted,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumQrCard extends StatelessWidget {
  const _PremiumQrCard({
    required this.code,
    required this.title,
    required this.subtitle,
  });

  final String code;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return _WhitePremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _residentNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _residentMuted,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _residentLine),
              boxShadow: [
                BoxShadow(
                  color: _residentNavy.withValues(alpha: 0.06),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: QrImageView(
              data: code,
              version: QrVersions.auto,
              size: 180,
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
              color: _residentSoftGold,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _residentGold.withValues(alpha: 0.22)),
            ),
            child: Text(
              code,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: _residentNavy,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedModeControl extends StatelessWidget {
  const _SegmentedModeControl({
    required this.modes,
    required this.selected,
    required this.onSelected,
  });

  final List<String> modes;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return _WhitePremiumCard(
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          for (final mode in modes)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => onSelected(mode),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selected == mode ? _residentNavy : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      mode,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: selected == mode ? Colors.white : _residentMuted,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _UploadPhotoStub extends StatelessWidget {
  const _UploadPhotoStub();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _residentSoftGray,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _residentLine),
      ),
      child: Row(
        children: [
          const Icon(Icons.photo_camera_outlined, color: _residentGold),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload photo dummy',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: _residentNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Photo placeholder attached for presentation.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: _residentMuted),
                ),
              ],
            ),
          ),
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _residentLine),
            ),
            child: const Icon(Icons.add, color: _residentGold),
          ),
        ],
      ),
    );
  }
}

class _ServiceStatusTimeline extends StatelessWidget {
  const _ServiceStatusTimeline();

  @override
  Widget build(BuildContext context) {
    final steps = [
      ('Open', Icons.add_circle_outline),
      ('Assigned', Icons.engineering_outlined),
      ('Progress', Icons.sync_outlined),
      ('Done', Icons.check_circle_outline),
    ];
    return _WhitePremiumCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            Expanded(
              child: Column(
                children: [
                  _GoldIcon(icon: steps[i].$2, size: 38),
                  const SizedBox(height: 8),
                  Text(
                    steps[i].$1,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _residentNavy,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            if (i != steps.length - 1)
              Container(
                width: 18,
                height: 1,
                color: _residentGold.withValues(alpha: 0.45),
              ),
          ],
        ],
      ),
    );
  }
}

class _TicketPipelineCard extends StatelessWidget {
  const _TicketPipelineCard({required this.ticket});

  final ServiceTicket ticket;

  @override
  Widget build(BuildContext context) {
    return _InfoTile(
      icon: Icons.build_circle_outlined,
      title: '${ticket.id} - ${ticket.title}',
      subtitle: '${ticket.category} - ${ticket.priority} - ${ticket.assignee}',
      status: ticket.status,
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.item});

  final PackageDelivery item;

  @override
  Widget build(BuildContext context) {
    return _InfoTile(
      icon: Icons.inventory_2_outlined,
      title: '${item.sender} via ${item.courier}',
      subtitle:
          'Arrived ${_date.format(item.arrivalTime)} at ${_time.format(item.arrivalTime)} - Pickup ${item.pickupCode}',
      status: item.status,
    );
  }
}

class _FacilityBookingCard extends StatelessWidget {
  const _FacilityBookingCard({required this.booking});

  final FacilityBooking booking;

  @override
  Widget build(BuildContext context) {
    return _InfoTile(
      icon: Icons.sports_tennis_outlined,
      title: booking.facility,
      subtitle: '${_date.format(booking.date)} - ${booking.slot}',
      status: booking.status,
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

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.status,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? status;

  @override
  Widget build(BuildContext context) {
    return _WhitePremiumCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          _GoldIcon(icon: icon, size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: _residentNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
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
          if (status != null) ...[
            const SizedBox(width: 10),
            StatusBadge(status: status!),
          ],
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

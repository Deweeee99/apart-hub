import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/data/demo_data.dart';
import '../../core/models/app_models.dart';
import '../../core/widgets/emergency_button.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/luxury_button.dart';
import '../../core/widgets/metric_card.dart';
import '../../core/widgets/premium_list_tile.dart';
import '../../core/widgets/qr_preview_card.dart';
import '../../core/widgets/role_scaffold.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/status_badge.dart';

final _currency = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);
final _date = DateFormat('d MMM yyyy', 'id_ID');
final _time = DateFormat('HH:mm', 'id_ID');

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
      const ResidentDashboardPage(),
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
  const ResidentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final resident = DemoData.primaryResident;
    final activeBill = DemoData.billings
        .where((billing) => billing.status != 'Paid')
        .fold<int>(0, (total, billing) => total + billing.amount);
    final waitingPackages = DemoData.packages
        .where((item) => item.status == 'Waiting Pickup')
        .length;

    return ListView(
      key: const ValueKey('resident-dashboard'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        GlassCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Evening, Jonathan',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your residence, billing, access, and concierge flow in one private dashboard.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.nights_stay_outlined,
                    color: AppColors.softGold,
                    size: 34,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _TinyInfo(label: 'Unit', value: resident.unit.label),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _TinyInfo(
                      label: 'Status',
                      value: resident.residencyStatus,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(duration: 420.ms).moveY(begin: 16, end: 0),
        const SectionHeader(title: 'Today Summary'),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.0,
          children: [
            MetricCard(
              icon: Icons.domain_outlined,
              label: 'Resident',
              value: resident.residencyStatus,
              caption: resident.unit.label,
            ),
            MetricCard(
              icon: Icons.payments_outlined,
              label: 'Running bill',
              value: _currency.format(activeBill),
              caption: 'IPL, listrik, parkir',
            ),
            MetricCard(
              icon: Icons.inventory_2_outlined,
              label: 'Packages',
              value: '$waitingPackages Packages',
              caption: 'Waiting pickup',
            ),
            MetricCard(
              icon: Icons.verified_user_outlined,
              label: 'IPL status',
              value: resident.billingStatus,
              caption: 'Access ${resident.accessStatus}',
            ),
          ],
        ),
        const SectionHeader(title: 'Latest Announcement'),
        PremiumListTile(
          icon: Icons.campaign_outlined,
          title: DemoData.announcements.first.title,
          subtitle: DemoData.announcements.first.message,
          trailing: const StatusBadge(status: 'Maintenance'),
        ),
        const SectionHeader(title: 'Emergency'),
        EmergencyButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Emergency alert simulated for Unit A-1808.'),
            ),
          ),
        ),
      ],
    );
  }
}

class DigitalAccessPage extends StatefulWidget {
  const DigitalAccessPage({super.key});

  @override
  State<DigitalAccessPage> createState() => _DigitalAccessPageState();
}

class _DigitalAccessPageState extends State<DigitalAccessPage> {
  final _nameController = TextEditingController(text: 'Michael Tan');
  final _phoneController = TextEditingController(text: '+62 812 2211 0077');
  final _scheduleController = TextEditingController(text: '5 Jun 2026, 19:00');
  final _vehicleController = TextEditingController(text: 'B 1808 GOLD');
  final _qrTypes = const [
    'QR Visitor',
    'QR Parking',
    'QR Delivery',
    'QR Guest',
  ];
  final _purposes = const [
    'Family Visit',
    'Business',
    'Delivery',
    'Private Guest',
  ];
  var _selectedQr = 'QR Visitor';
  var _selectedPurpose = 'Family Visit';
  var _generatedCode = 'VIS-A1808-2026-001';
  var _visitorFilter = 'Upcoming';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _scheduleController.dispose();
    _vehicleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredVisitors = DemoData.visitors
        .where((item) => item.status == _visitorFilter)
        .toList();

    return ListView(
      key: const ValueKey('resident-access'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        const SectionHeader(title: 'Digital Access'),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Generate QR Pass',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final type in _qrTypes)
                    ChoiceChip(
                      label: Text(type),
                      selected: _selectedQr == type,
                      onSelected: (_) => setState(() => _selectedQr = type),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Guest / courier name',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone number'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _vehicleController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle / delivery detail',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _scheduleController,
                decoration: const InputDecoration(labelText: 'Date and time'),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final purpose in _purposes)
                    ChoiceChip(
                      label: Text(purpose),
                      selected: _selectedPurpose == purpose,
                      onSelected: (_) =>
                          setState(() => _selectedPurpose = purpose),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              LuxuryButton(
                label: 'Generate QR Code',
                icon: Icons.qr_code_2_outlined,
                onPressed: () {
                  final prefix = switch (_selectedQr) {
                    'QR Parking' => 'PAR',
                    'QR Delivery' => 'DEL',
                    'QR Guest' => 'GST',
                    _ => 'VIS',
                  };
                  setState(() => _generatedCode = '$prefix-A1808-2026-001');
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        QRPreviewCard(
          code: _generatedCode,
          title: '$_selectedQr Pass',
          onShare: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Share QR simulated for ${_nameController.text}.'),
            ),
          ),
        ),
        const SectionHeader(title: 'Visitor Management'),
        Wrap(
          spacing: 8,
          children: [
            for (final status in ['Upcoming', 'Used', 'Expired'])
              ChoiceChip(
                label: Text(status),
                selected: _visitorFilter == status,
                onSelected: (_) => setState(() => _visitorFilter = status),
              ),
          ],
        ),
        const SizedBox(height: 12),
        for (final visitor in filteredVisitors)
          PremiumListTile(
            icon: Icons.person_pin_circle_outlined,
            title: visitor.name,
            subtitle:
                '${visitor.purpose} - ${_date.format(visitor.visitTime)} at ${_time.format(visitor.visitTime)}',
            trailing: StatusBadge(status: visitor.status),
          ),
      ],
    );
  }
}

class BillingPaymentPage extends StatefulWidget {
  const BillingPaymentPage({super.key});

  @override
  State<BillingPaymentPage> createState() => _BillingPaymentPageState();
}

class _BillingPaymentPageState extends State<BillingPaymentPage> {
  late final _billings = DemoData.billings.map((item) => item).toList();

  @override
  Widget build(BuildContext context) {
    final totalActive = _billings
        .where((billing) => billing.status != 'Paid')
        .fold<int>(0, (total, billing) => total + billing.amount);

    return ListView(
      key: const ValueKey('resident-billing'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        const SectionHeader(title: 'Billing & Payment'),
        GlassCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Outstanding',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _currency.format(totalActive),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'IPL, Air, Listrik, Parkir, and Denda are ready for API integration.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.softGold,
                size: 38,
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'Active Invoices'),
        for (var i = 0; i < _billings.length; i++)
          GlassCard(
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${_billings[i].category} - ${_billings[i].id}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    StatusBadge(status: _billings[i].status),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _currency.format(_billings[i].amount),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'Due ${_date.format(_billings[i].dueDate)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Invoice PDF generated for ${_billings[i].id}.',
                                ),
                              ),
                            ),
                        icon: const Icon(Icons.picture_as_pdf_outlined),
                        label: const Text('Invoice PDF'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (_billings[i].status != 'Paid')
                      Expanded(
                        child: LuxuryButton(
                          label: 'Pay Now',
                          icon: Icons.payments_outlined,
                          onPressed: () => _openPaymentSheet(context, i),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        const SectionHeader(title: 'Payment History'),
        PremiumListTile(
          icon: Icons.check_circle_outline,
          title: 'Air - INV-WTR-0626',
          subtitle: 'Paid via Virtual Account on 2 Jun 2026',
          trailing: const StatusBadge(status: 'Paid'),
        ),
      ],
    );
  }

  void _openPaymentSheet(BuildContext context, int index) {
    var method = 'Midtrans';
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: GlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Method',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final item in [
                          'Midtrans',
                          'Xendit',
                          'Virtual Account',
                          'QRIS',
                        ])
                          ChoiceChip(
                            label: Text(item),
                            selected: method == item,
                            onSelected: (_) =>
                                setSheetState(() => method = item),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    PremiumListTile(
                      icon: Icons.info_outline,
                      title: '$method Instruction',
                      subtitle:
                          'Mock payment gateway. Follow displayed virtual instruction, then simulate success.',
                    ),
                    LuxuryButton(
                      label: 'Simulate Payment Success',
                      icon: Icons.verified_outlined,
                      onPressed: () {
                        setState(
                          () => _billings[index] = _billings[index].copyWith(
                            status: 'Paid',
                          ),
                        );
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${_billings[index].id} marked as Paid via $method.',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
    return ListView(
      key: const ValueKey('resident-service'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        const SectionHeader(title: 'Service, Package & Facility'),
        Wrap(
          spacing: 8,
          children: [
            for (final mode in ['Tickets', 'Packages', 'Facility'])
              ChoiceChip(
                label: Text(mode),
                selected: _mode == mode,
                onSelected: (_) => setState(() => _mode = mode),
              ),
          ],
        ),
        const SizedBox(height: 14),
        if (_mode == 'Tickets') ..._ticketContent(context),
        if (_mode == 'Packages') ..._packageContent(),
        if (_mode == 'Facility') ..._facilityContent(context),
      ],
    );
  }

  List<Widget> _ticketContent(BuildContext context) {
    return [
      GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Submit Ticket',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
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
            PremiumListTile(
              icon: Icons.photo_camera_outlined,
              title: 'Upload photo dummy',
              subtitle: 'Photo placeholder attached for presentation.',
            ),
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
      const SectionHeader(title: 'Ticket Pipeline'),
      Text(
        'Open > Assigned > Progress > Done',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      const SizedBox(height: 10),
      for (final ticket in _tickets)
        PremiumListTile(
          icon: Icons.build_circle_outlined,
          title: '${ticket.id} - ${ticket.title}',
          subtitle:
              '${ticket.category} - ${ticket.priority} - ${ticket.assignee}',
          trailing: StatusBadge(status: ticket.status),
        ),
    ];
  }

  List<Widget> _packageContent() {
    return [
      QRPreviewCard(code: 'PKG-A1808-PICKUP', title: 'Pickup QR / Code'),
      const SectionHeader(title: 'Package List'),
      for (final item in DemoData.packages)
        PremiumListTile(
          icon: Icons.inventory_2_outlined,
          title: '${item.sender} via ${item.courier}',
          subtitle:
              'Arrived ${_date.format(item.arrivalTime)} at ${_time.format(item.arrivalTime)} - Proof photo placeholder',
          trailing: StatusBadge(status: item.status),
        ),
    ];
  }

  List<Widget> _facilityContent(BuildContext context) {
    return [
      GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Facility',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final item in [
                  'Kolam Renang',
                  'Gym',
                  'Function Hall',
                  'Tennis Court',
                  'Meeting Room',
                ])
                  ChoiceChip(
                    label: Text(item),
                    selected: _facility == item,
                    onSelected: (_) => setState(() => _facility = item),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            PremiumListTile(
              icon: Icons.calendar_month_outlined,
              title: 'Selected date',
              subtitle: '7 Jun 2026',
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final slot in [
                  '07:00 - 08:00',
                  '10:00 - 11:00',
                  '16:00 - 17:00',
                  '19:00 - 22:00',
                ])
                  ChoiceChip(
                    label: Text(slot),
                    selected: _slot == slot,
                    onSelected: (_) => setState(() => _slot = slot),
                  ),
              ],
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
      const SectionHeader(title: 'Booking History'),
      for (final booking in _bookings)
        PremiumListTile(
          icon: Icons.sports_tennis_outlined,
          title: booking.facility,
          subtitle: '${_date.format(booking.date)} - ${booking.slot}',
          trailing: StatusBadge(status: booking.status),
        ),
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
      child: Column(
        key: const ValueKey('resident-community'),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Community'),
                GlassCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: TabBar(
                    isScrollable: true,
                    indicatorColor: AppColors.softGold,
                    labelColor: AppColors.softGold,
                    unselectedLabelColor: AppColors.textSecondary,
                    tabs: [
                      for (final category in categories) Tab(text: category),
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
                        PremiumListTile(
                          icon: switch (category) {
                            'Marketplace' => Icons.sell_outlined,
                            'Lost & Found' => Icons.manage_search_outlined,
                            'Events' => Icons.celebration_outlined,
                            _ => Icons.chat_bubble_outline,
                          },
                          title: post.title,
                          subtitle: '${post.author} - ${post.description}',
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyInfo extends StatelessWidget {
  const _TinyInfo({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

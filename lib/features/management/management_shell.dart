import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/data/demo_data.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/luxury_button.dart';
import '../../core/widgets/metric_card.dart';
import '../../core/widgets/premium_list_tile.dart';
import '../../core/widgets/role_scaffold.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/status_badge.dart';

final _currency = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);
final _date = DateFormat('d MMM yyyy', 'id_ID');

class ManagementShell extends StatefulWidget {
  const ManagementShell({super.key});

  @override
  State<ManagementShell> createState() => _ManagementShellState();
}

class _ManagementShellState extends State<ManagementShell> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const ManagementDashboardPage(),
      const ResidentManagementPage(),
      const BillingManagementPage(),
      const ServiceRequestManagementPage(),
      const ManagementMorePage(),
    ];

    return RoleScaffold(
      currentIndex: _index,
      onIndexChanged: (value) => setState(() => _index = value),
      roleLabel: 'Management Office',
      items: const [
        RoleNavItem(
          label: 'Dashboard',
          icon: Icons.dashboard_outlined,
          selectedIcon: Icons.dashboard,
        ),
        RoleNavItem(
          label: 'Residents',
          icon: Icons.people_outline,
          selectedIcon: Icons.people,
        ),
        RoleNavItem(
          label: 'Billing',
          icon: Icons.request_quote_outlined,
          selectedIcon: Icons.request_quote,
        ),
        RoleNavItem(
          label: 'Requests',
          icon: Icons.assignment_outlined,
          selectedIcon: Icons.assignment,
        ),
        RoleNavItem(
          label: 'More',
          icon: Icons.apps_outlined,
          selectedIcon: Icons.apps,
        ),
      ],
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: pages[_index],
      ),
    );
  }
}

class ManagementDashboardPage extends StatelessWidget {
  const ManagementDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final outstanding = DemoData.billings
        .where((item) => item.status != 'Paid')
        .fold<int>(0, (total, item) => total + item.amount);

    return ListView(
      key: const ValueKey('management-dashboard'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        GlassCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Executive Overview',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Building operations, finance, visitors, and resident services in one premium console.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.stacked_line_chart_outlined,
                color: AppColors.softGold,
                size: 40,
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'KPI Snapshot'),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.98,
          children: [
            const MetricCard(
              icon: Icons.apartment_outlined,
              label: 'Total Units',
              value: '420',
              caption: '3 towers',
            ),
            const MetricCard(
              icon: Icons.meeting_room_outlined,
              label: 'Occupied Units',
              value: '386',
              caption: '91.9% occupancy',
            ),
            MetricCard(
              icon: Icons.account_balance_outlined,
              label: 'Outstanding Billing',
              value: _currency.format(outstanding),
              caption: '15 invoices',
            ),
            const MetricCard(
              icon: Icons.handyman_outlined,
              label: 'Open Requests',
              value: '18',
              caption: '6 urgent',
            ),
            const MetricCard(
              icon: Icons.badge_outlined,
              label: 'Visitors Today',
              value: '72',
              caption: '44 checked-in',
            ),
            const MetricCard(
              icon: Icons.calendar_month_outlined,
              label: 'Facility Bookings',
              value: '26',
              caption: '8 waiting',
            ),
            const MetricCard(
              icon: Icons.report_outlined,
              label: 'Incidents',
              value: '4',
              caption: 'This month',
            ),
            const MetricCard(
              icon: Icons.local_shipping_outlined,
              label: 'Packages',
              value: '118',
              caption: '42 waiting pickup',
            ),
          ],
        ),
        const SectionHeader(title: 'Billing Performance'),
        GlassCard(
          child: _MiniBarChart(
            values: const [74, 88, 67, 92, 81],
            labels: const ['Jan', 'Feb', 'Mar', 'Apr', 'May'],
          ),
        ),
      ],
    );
  }
}

class ResidentManagementPage extends StatelessWidget {
  const ResidentManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('management-residents'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        const SectionHeader(
          title: 'Resident Management',
          actionLabel: 'Add Resident',
        ),
        for (final resident in DemoData.residents)
          GlassCard(
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        resident.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    StatusBadge(status: resident.billingStatus),
                  ],
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.domain_outlined,
                  label: 'Unit',
                  value: '${resident.unit.label} - ${resident.unit.status}',
                ),
                _InfoRow(
                  icon: Icons.person_outline,
                  label: 'Resident status',
                  value: resident.residencyStatus,
                ),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Contact',
                  value: resident.phone,
                ),
                _InfoRow(
                  icon: Icons.lock_open_outlined,
                  label: 'Access',
                  value: resident.accessStatus,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class BillingManagementPage extends StatefulWidget {
  const BillingManagementPage({super.key});

  @override
  State<BillingManagementPage> createState() => _BillingManagementPageState();
}

class _BillingManagementPageState extends State<BillingManagementPage> {
  late final _billings = DemoData.billings.map((item) => item).toList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('management-billing'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        const SectionHeader(title: 'Billing Management'),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Generate Monthly Billing',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Create IPL, Air, Listrik, Parkir, and Denda invoices from local dummy data.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 14),
              LuxuryButton(
                label: 'Generate Billing',
                icon: Icons.auto_awesome_outlined,
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Billing generation simulated for June 2026.',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'Invoice Monitoring'),
        for (var i = 0; i < _billings.length; i++)
          PremiumListTile(
            icon: Icons.receipt_long_outlined,
            title: '${_billings[i].id} - ${_billings[i].category}',
            subtitle:
                '${_currency.format(_billings[i].amount)} due ${_date.format(_billings[i].dueDate)}',
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusBadge(status: _billings[i].status),
                if (_billings[i].status != 'Paid')
                  TextButton(
                    onPressed: () => setState(
                      () =>
                          _billings[i] = _billings[i].copyWith(status: 'Paid'),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: AppColors.softGold),
                    ),
                  ),
              ],
            ),
          ),
        const SectionHeader(title: 'Outstanding Report'),
        PremiumListTile(
          icon: Icons.summarize_outlined,
          title: 'June 2026 outstanding report',
          subtitle: 'Mock export ready for finance review.',
          trailing: const Icon(
            Icons.download_outlined,
            color: AppColors.softGold,
          ),
        ),
      ],
    );
  }
}

class ServiceRequestManagementPage extends StatefulWidget {
  const ServiceRequestManagementPage({super.key});

  @override
  State<ServiceRequestManagementPage> createState() =>
      _ServiceRequestManagementPageState();
}

class _ServiceRequestManagementPageState
    extends State<ServiceRequestManagementPage> {
  late final _tickets = DemoData.tickets.map((item) => item).toList();
  final _statuses = const ['Open', 'Assigned', 'Progress', 'Done'];

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('management-requests'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        const SectionHeader(title: 'Service Request Management'),
        Text(
          'Open > Assigned > Progress > Done',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < _tickets.length; i++)
          GlassCard(
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${_tickets[i].id} - ${_tickets[i].title}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    StatusBadge(status: _tickets[i].status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${_tickets[i].category} - ${_tickets[i].priority}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'Assigned to: ${_tickets[i].assignee}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => setState(
                        () => _tickets[i] = _tickets[i].copyWith(
                          status: 'Assigned',
                          assignee: 'Dimas - Engineering',
                        ),
                      ),
                      icon: const Icon(Icons.engineering_outlined),
                      label: const Text('Assign'),
                    ),
                    for (final status in _statuses)
                      ChoiceChip(
                        label: Text(status),
                        selected: _tickets[i].status == status,
                        onSelected: (_) => setState(
                          () => _tickets[i] = _tickets[i].copyWith(
                            status: status,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                PremiumListTile(
                  icon: Icons.note_add_outlined,
                  title: 'Internal note',
                  subtitle:
                      'Technician notified. Resident prefers evening appointment.',
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class ManagementMorePage extends StatefulWidget {
  const ManagementMorePage({super.key});

  @override
  State<ManagementMorePage> createState() => _ManagementMorePageState();
}

class _ManagementMorePageState extends State<ManagementMorePage> {
  late final _bookings = DemoData.bookings.map((item) => item).toList();
  var _mode = 'Facility';
  final _announcementTitle = TextEditingController(
    text: 'Pool maintenance on Sunday',
  );
  final _announcementMessage = TextEditingController(
    text: 'Pool area will be closed from 08:00 to 14:00.',
  );
  var _announcementCategory = 'Maintenance';

  @override
  void dispose() {
    _announcementTitle.dispose();
    _announcementMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('management-more'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        const SectionHeader(title: 'Management More'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final item in [
              'Facility',
              'Announcement',
              'Packages',
              'Tenants',
            ])
              ChoiceChip(
                label: Text(item),
                selected: _mode == item,
                onSelected: (_) => setState(() => _mode = item),
              ),
          ],
        ),
        const SizedBox(height: 14),
        if (_mode == 'Facility') ..._facilityApproval(),
        if (_mode == 'Announcement') ..._announcementContent(context),
        if (_mode == 'Packages') ..._packageMonitoring(),
        if (_mode == 'Tenants') ..._tenantManagement(),
      ],
    );
  }

  List<Widget> _facilityApproval() {
    return [
      const SectionHeader(title: 'Facility Approval'),
      for (var i = 0; i < _bookings.length; i++)
        PremiumListTile(
          icon: Icons.event_available_outlined,
          title: '${_bookings[i].facility} - ${_bookings[i].residentName}',
          subtitle: '${_date.format(_bookings[i].date)} - ${_bookings[i].slot}',
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StatusBadge(status: _bookings[i].status),
              if (_bookings[i].status == 'Waiting Approval')
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => setState(
                        () => _bookings[i] = _bookings[i].copyWith(
                          status: 'Approved',
                        ),
                      ),
                      child: const Text(
                        'Approve',
                        style: TextStyle(color: AppColors.success),
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(
                        () => _bookings[i] = _bookings[i].copyWith(
                          status: 'Rejected',
                        ),
                      ),
                      child: const Text(
                        'Reject',
                        style: TextStyle(color: AppColors.danger),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      PremiumListTile(
        icon: Icons.calendar_view_month_outlined,
        title: 'Facility calendar',
        subtitle: 'Monthly calendar placeholder with peak amenity usage.',
      ),
    ];
  }

  List<Widget> _announcementContent(BuildContext context) {
    return [
      GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Announcement',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _announcementTitle,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _announcementCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              items: ['General', 'Maintenance', 'Emergency', 'Event']
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: (value) => setState(
                () => _announcementCategory = value ?? _announcementCategory,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _announcementMessage,
              minLines: 3,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Message'),
            ),
            const SizedBox(height: 14),
            LuxuryButton(
              label: 'Publish Announcement',
              icon: Icons.campaign_outlined,
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${_announcementTitle.text} published to residents.',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      const SectionHeader(title: 'Published'),
      for (final item in DemoData.announcements)
        PremiumListTile(
          icon: Icons.campaign_outlined,
          title: item.title,
          subtitle: '${item.category} - ${item.message}',
          trailing: StatusBadge(status: item.category),
        ),
    ];
  }

  List<Widget> _packageMonitoring() {
    return [
      const SectionHeader(title: 'Package Monitoring'),
      for (final item in DemoData.packages)
        PremiumListTile(
          icon: Icons.inventory_2_outlined,
          title: '${item.id} - ${item.sender}',
          subtitle: '${item.courier} - pickup code ${item.pickupCode}',
          trailing: StatusBadge(status: item.status),
        ),
    ];
  }

  List<Widget> _tenantManagement() {
    return [
      const SectionHeader(title: 'Tenant / Merchant Management'),
      for (final tenant in DemoData.tenants)
        PremiumListTile(
          icon: Icons.storefront_outlined,
          title: tenant.name,
          subtitle:
              '${tenant.category} - ${tenant.hours} - rating ${tenant.rating}',
          trailing: StatusBadge(status: tenant.status),
        ),
      PremiumListTile(
        icon: Icons.insights_outlined,
        title: 'Tenant order / booking summary',
        subtitle: '22 active orders, 5 promos live, monthly revenue tracked.',
      ),
    ];
  }
}

class _MiniBarChart extends StatelessWidget {
  const _MiniBarChart({required this.values, required this.labels});

  final List<int> values;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < values.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: values[i] / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.softGold,
                                  AppColors.goldMetallic,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      labels[i],
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Icon(icon, color: AppColors.softGold, size: 18),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.softGold),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

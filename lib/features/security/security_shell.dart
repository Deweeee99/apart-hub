import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/data/demo_data.dart';
import '../../core/models/app_models.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/luxury_button.dart';
import '../../core/widgets/metric_card.dart';
import '../../core/widgets/premium_list_tile.dart';
import '../../core/widgets/role_scaffold.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/status_badge.dart';

final _date = DateFormat('d MMM yyyy', 'id_ID');
final _time = DateFormat('HH:mm', 'id_ID');

class SecurityShell extends StatefulWidget {
  const SecurityShell({super.key});

  @override
  State<SecurityShell> createState() => _SecurityShellState();
}

class _SecurityShellState extends State<SecurityShell> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const SecurityDashboardPage(),
      const VisitorScannerPage(),
      const PatrolManagementPage(),
      const IncidentReportPage(),
      const EmergencyHandlingPage(),
    ];

    return RoleScaffold(
      currentIndex: _index,
      onIndexChanged: (value) => setState(() => _index = value),
      roleLabel: 'Security',
      items: const [
        RoleNavItem(
          label: 'Dashboard',
          icon: Icons.security_outlined,
          selectedIcon: Icons.security,
        ),
        RoleNavItem(
          label: 'Scanner',
          icon: Icons.qr_code_scanner_outlined,
          selectedIcon: Icons.qr_code_scanner,
        ),
        RoleNavItem(
          label: 'Patrol',
          icon: Icons.route_outlined,
          selectedIcon: Icons.route,
        ),
        RoleNavItem(
          label: 'Incident',
          icon: Icons.report_outlined,
          selectedIcon: Icons.report,
        ),
        RoleNavItem(
          label: 'Emergency',
          icon: Icons.sos_outlined,
          selectedIcon: Icons.sos,
        ),
      ],
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: pages[_index],
      ),
    );
  }
}

class SecurityDashboardPage extends StatelessWidget {
  const SecurityDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('security-dashboard'),
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
                      'Security Command',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Visitor validation, patrol status, incidents, and resident emergency alerts.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.shield_outlined,
                color: AppColors.softGold,
                size: 42,
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'Shift Overview'),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.0,
          children: const [
            MetricCard(
              icon: Icons.badge_outlined,
              label: 'Visitor Today',
              value: '72',
              caption: '44 checked-in',
            ),
            MetricCard(
              icon: Icons.qr_code_2_outlined,
              label: 'Active QR',
              value: '31',
              caption: 'Resident generated',
            ),
            MetricCard(
              icon: Icons.timer_off_outlined,
              label: 'Expired QR',
              value: '9',
              caption: 'Auto denied',
            ),
            MetricCard(
              icon: Icons.report_problem_outlined,
              label: 'Incident Open',
              value: '2',
              caption: 'Under review',
            ),
            MetricCard(
              icon: Icons.route_outlined,
              label: 'Patrol Status',
              value: '60%',
              caption: '3 of 5 checked',
            ),
            MetricCard(
              icon: Icons.sos_outlined,
              label: 'Emergency Alert',
              value: '1',
              caption: 'Tower A active',
            ),
          ],
        ),
        const SectionHeader(title: 'Active Emergency'),
        PremiumListTile(
          icon: Icons.emergency_outlined,
          title: 'Unit A-1808 triggered emergency',
          subtitle: 'Tower A - 20:45 - Action required',
          trailing: const StatusBadge(status: 'Emergency'),
        ),
      ],
    );
  }
}

class VisitorScannerPage extends StatefulWidget {
  const VisitorScannerPage({super.key});

  @override
  State<VisitorScannerPage> createState() => _VisitorScannerPageState();
}

class _VisitorScannerPageState extends State<VisitorScannerPage> {
  VisitorPass? _scannedPass;
  var _scanStatus = 'Ready';

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('security-scanner'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        const SectionHeader(title: 'Visitor Scanner'),
        GlassCard(
          child: Column(
            children: [
              Container(
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.goldMetallic.withValues(alpha: 0.45),
                  ),
                  color: Colors.black.withValues(alpha: 0.26),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(34),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.softGold,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                    const Center(
                      child: Icon(
                        Icons.qr_code_scanner_outlined,
                        color: AppColors.softGold,
                        size: 72,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LuxuryButton(
                label: 'Simulate Scan',
                icon: Icons.document_scanner_outlined,
                onPressed: () => setState(() {
                  _scannedPass = DemoData.visitors.first;
                  _scanStatus = 'Valid';
                }),
              ),
            ],
          ),
        ),
        if (_scannedPass != null) ...[
          const SectionHeader(title: 'Verification Result'),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _scannedPass!.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    StatusBadge(status: _scanStatus),
                  ],
                ),
                const SizedBox(height: 12),
                _ResultRow(label: 'Destination', value: _scannedPass!.unit),
                _ResultRow(
                  label: 'Visit time',
                  value:
                      '${_date.format(_scannedPass!.visitTime)} ${_time.format(_scannedPass!.visitTime)}',
                ),
                _ResultRow(label: 'Purpose', value: _scannedPass!.purpose),
                _ResultRow(label: 'QR Code', value: _scannedPass!.code),
                if (_scanStatus == 'Valid') ...[
                  const SizedBox(height: 14),
                  LuxuryButton(
                    label: 'Check-in Visitor',
                    icon: Icons.login_outlined,
                    onPressed: () => setState(() => _scanStatus = 'Used'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class PatrolManagementPage extends StatefulWidget {
  const PatrolManagementPage({super.key});

  @override
  State<PatrolManagementPage> createState() => _PatrolManagementPageState();
}

class _PatrolManagementPageState extends State<PatrolManagementPage> {
  late final _checkpoints = DemoData.checkpoints.map((item) => item).toList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('security-patrol'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        const SectionHeader(title: 'Patrol Management'),
        GlassCard(
          child: Row(
            children: [
              const Icon(
                Icons.route_outlined,
                color: AppColors.softGold,
                size: 34,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Scan each checkpoint, upload a dummy area photo, and add notes for management review.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'Checkpoint List'),
        for (var i = 0; i < _checkpoints.length; i++)
          GlassCard(
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _checkpoints[i].name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    StatusBadge(status: _checkpoints[i].status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${_checkpoints[i].area} - ${_checkpoints[i].note}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => setState(
                          () => _checkpoints[i] = _checkpoints[i].copyWith(
                            status: 'Checked',
                            note: 'Condition normal',
                          ),
                        ),
                        icon: const Icon(Icons.qr_code_scanner_outlined),
                        label: const Text('Scan Checkpoint'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Dummy photo uploaded for ${_checkpoints[i].name}.',
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.photo_camera_outlined),
                        label: const Text('Photo'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class IncidentReportPage extends StatefulWidget {
  const IncidentReportPage({super.key});

  @override
  State<IncidentReportPage> createState() => _IncidentReportPageState();
}

class _IncidentReportPageState extends State<IncidentReportPage> {
  late var _incidents = DemoData.incidents.map((item) => item).toList();
  var _category = 'Kehilangan';
  var _severity = 'Medium';
  final _location = TextEditingController(text: 'Lobby');
  final _description = TextEditingController(
    text: 'Resident melaporkan barang tertinggal.',
  );

  @override
  void dispose() {
    _location.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('security-incident'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        const SectionHeader(title: 'Incident Report'),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Incident category',
                ),
                items:
                    [
                          'Kehilangan',
                          'Keributan',
                          'Kerusakan fasilitas',
                          'Kebakaran',
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
                controller: _location,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _description,
                minLines: 3,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _severity,
                decoration: const InputDecoration(labelText: 'Severity'),
                items: ['Low', 'Medium', 'High', 'Emergency']
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _severity = value ?? _severity),
              ),
              const SizedBox(height: 12),
              PremiumListTile(
                icon: Icons.photo_outlined,
                title: 'Photo evidence dummy',
                subtitle: 'Evidence placeholder attached.',
              ),
              LuxuryButton(
                label: 'Submit Report',
                icon: Icons.report_outlined,
                onPressed: () => setState(() {
                  _incidents = [
                    SecurityIncident(
                      id: 'INC-${2400 + _incidents.length + 1}',
                      category: _category,
                      location: _location.text,
                      description: _description.text,
                      severity: _severity,
                      status: 'Reported',
                    ),
                    ..._incidents,
                  ];
                }),
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'Reports'),
        for (final incident in _incidents)
          PremiumListTile(
            icon: Icons.report_problem_outlined,
            title: '${incident.id} - ${incident.category}',
            subtitle:
                '${incident.location} - ${incident.severity} - ${incident.description}',
            trailing: StatusBadge(status: incident.status),
          ),
      ],
    );
  }
}

class EmergencyHandlingPage extends StatefulWidget {
  const EmergencyHandlingPage({super.key});

  @override
  State<EmergencyHandlingPage> createState() => _EmergencyHandlingPageState();
}

class _EmergencyHandlingPageState extends State<EmergencyHandlingPage> {
  var _status = 'Emergency Alert';

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('security-emergency'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        const SectionHeader(title: 'Emergency Handling'),
        GlassCard(
          fillColor: AppColors.danger.withValues(alpha: 0.16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.sos_outlined, color: Colors.white, size: 42),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Unit A-1808 triggered emergency',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  StatusBadge(status: _status),
                ],
              ),
              const SizedBox(height: 14),
              _ResultRow(label: 'Location', value: 'Tower A'),
              _ResultRow(label: 'Time', value: '20:45'),
              _ResultRow(label: 'Resident', value: 'Jonathan Wijaya'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () =>
                        setState(() => _status = 'Calling Resident'),
                    icon: const Icon(Icons.phone_outlined),
                    label: const Text('Call Resident'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () =>
                        setState(() => _status = 'Security Dispatched'),
                    icon: const Icon(Icons.directions_run_outlined),
                    label: const Text('Dispatch Security'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LuxuryButton(
                label: 'Mark Resolved',
                icon: Icons.check_circle_outline,
                onPressed: () => setState(() => _status = 'Resolved'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.softGold),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

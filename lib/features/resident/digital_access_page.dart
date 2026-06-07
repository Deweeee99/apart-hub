import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/data/demo_data.dart';
import '../../core/widgets/luxury_button.dart';
import '../../core/widgets/premium_qr_card.dart';
import '../../core/widgets/premium_step_indicator.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/white_premium_card.dart';

final _date = DateFormat('d MMM yyyy', 'id_ID');
final _time = DateFormat('HH:mm', 'id_ID');

const _accessBackground = Color(0xFFFAF8F2);
const _accessNavy = Color(0xFF071B34);
const _accessGold = Color(0xFFC08A1A);
const _accessSoftGold = Color(0xFFFFF6DF);
const _accessMuted = Color(0xFF687184);
const _accessLine = Color(0xFFE7DFD1);
const _accessSoftGray = Color(0xFFF2F0EA);

class AccessHistoryItem {
  const AccessHistoryItem({
    required this.accessType,
    required this.name,
    required this.detail,
    required this.dateTime,
    required this.status,
  });

  final String accessType;
  final String name;
  final String detail;
  final DateTime dateTime;
  final String status;
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
  final _accessTypes = const [
    'Visitor Access',
    'Parking Access',
    'Delivery Access',
    'Guest Access',
  ];
  final _purposes = const [
    'Family Visit',
    'Business',
    'Delivery',
    'Private Guest',
  ];
  late final List<AccessHistoryItem> _accessHistories = [
    for (final visitor in DemoData.visitors)
      AccessHistoryItem(
        accessType: visitor.purpose == 'Delivery'
            ? 'Delivery Access'
            : 'Visitor Access',
        name: visitor.name,
        detail: visitor.phone,
        dateTime: visitor.visitTime,
        status: visitor.status == 'Upcoming' ? 'Approved' : visitor.status,
      ),
    AccessHistoryItem(
      accessType: 'Parking Access',
      name: 'Andrew Wijaya',
      detail: 'B 1234 ABC',
      dateTime: DateTime(2026, 6, 6, 16, 15),
      status: 'Approved',
    ),
    AccessHistoryItem(
      accessType: 'Delivery Access',
      name: 'DHL Express',
      detail: 'Concierge pickup',
      dateTime: DateTime(2026, 6, 5, 11, 20),
      status: 'Used',
    ),
    AccessHistoryItem(
      accessType: 'Guest Access',
      name: 'Sarah Lim',
      detail: '+62 811 4455 9000',
      dateTime: DateTime(2026, 6, 2, 9, 45),
      status: 'Expired',
    ),
  ];

  Timer? _qrTimer;
  var _accessStep = 0;
  var _selectedAccessType = 'Visitor Access';
  var _historyFilter = 'All Access';
  var _selectedPurpose = 'Family Visit';
  var _generatedCode = 'VIS-A1808-2026-001';
  var _qrSecondsRemaining = 179;
  var _isVerifying = false;
  var _verifyToken = 0;

  @override
  void dispose() {
    _qrTimer?.cancel();
    _nameController.dispose();
    _phoneController.dispose();
    _scheduleController.dispose();
    _vehicleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DigitalAccessSurface(
      child: ListView(
        key: const ValueKey('resident-access'),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        children: [
          _buildFlowHeader(),
          const SizedBox(height: 14),
          PremiumStepIndicator(
            currentStep: _accessStep,
            steps: const [
              'Select',
              'Generate',
              'Share',
              'Verify',
              'Granted',
              'History',
            ],
            onStepSelected: _goToStep,
          ),
          const SizedBox(height: 16),
          _buildStepContent(),
        ],
      ),
    );
  }

  void _goToStep(int step) {
    final nextStep = step.clamp(0, 5);
    setState(() {
      _accessStep = nextStep;
      if (nextStep == 3) {
        _isVerifying = true;
      }
    });
    if (nextStep == 3) {
      _startVerification();
    }
  }

  void _resetAccessFlow() {
    setState(() {
      _accessStep = 0;
      _selectedAccessType = 'Visitor Access';
      _selectedPurpose = 'Family Visit';
      _generatedCode = 'VIS-A1808-2026-001';
      _qrSecondsRemaining = 179;
      _isVerifying = false;
    });
  }

  void _generateQrCode() {
    final sequence = (_accessHistories.length + 1).toString().padLeft(3, '0');
    setState(() {
      _generatedCode =
          '${_accessPrefix(_selectedAccessType)}-A1808-2026-$sequence';
      _qrSecondsRemaining = 179;
      _accessStep = 2;
    });
    _startQrTimer();
  }

  void _startQrTimer() {
    _qrTimer?.cancel();
    _qrTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_qrSecondsRemaining <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _qrSecondsRemaining--);
    });
  }

  void _startVerification() {
    final token = ++_verifyToken;
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted || token != _verifyToken) {
        return;
      }
      setState(() => _isVerifying = false);
    });
  }

  Widget _buildFlowHeader() {
    return const _AccessHeader(
      title: 'Digital Access',
      subtitle: 'Secure, seamless, and contactless entry',
      icon: Icons.qr_code_2_outlined,
    );
  }

  Widget _buildStepContent() {
    return switch (_accessStep) {
      0 => _buildSelectAccessType(),
      1 => _buildGenerateQrForm(),
      2 => _buildShareAccess(),
      3 => _buildScanVerify(),
      4 => _buildAccessGranted(),
      _ => _buildAccessHistory(),
    };
  }

  Widget _buildSelectAccessType() {
    final resident = DemoData.primaryResident;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WhitePremiumCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const _GoldIcon(icon: Icons.person_pin_circle_outlined, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resident.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: _accessNavy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      resident.unit.label,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: _accessMuted),
                    ),
                  ],
                ),
              ),
              StatusBadge(status: resident.accessStatus),
            ],
          ),
        ),
        const SizedBox(height: 14),
        for (final accessType in _accessTypes) ...[
          _buildAccessTypeCard(accessType),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildGenerateQrForm() {
    return WhitePremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(
            title: 'Generate QR Code',
            subtitle:
                'Create a secure temporary pass for $_selectedAccessType.',
            icon: _accessIcon(_selectedAccessType),
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
          _ChoiceWrap(
            items: _purposes,
            selected: _selectedPurpose,
            onSelected: (value) => setState(() => _selectedPurpose = value),
          ),
          const SizedBox(height: 16),
          LuxuryButton(
            label: 'Generate QR Code',
            icon: Icons.qr_code_2_outlined,
            onPressed: _generateQrCode,
          ),
        ],
      ),
    );
  }

  Widget _buildShareAccess() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PremiumQrCard(
          title: 'Your QR Code',
          code: _generatedCode,
          accessType: _selectedAccessType,
          visitorName: _nameController.text,
          schedule: _scheduleController.text,
          status: 'QR VALID',
          countdownText: _countdownText,
          onShare: () => _showAccessSnack(
            'Share QR simulated for ${_nameController.text}.',
          ),
        ),
        const SizedBox(height: 14),
        WhitePremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CardTitle(
                title: 'Share Access',
                subtitle: 'Send the QR code to the visitor, guest, or driver.',
                icon: Icons.ios_share_outlined,
              ),
              const SizedBox(height: 16),
              _OutlineActionButton(
                label: 'Share via WhatsApp',
                icon: Icons.chat_outlined,
                onPressed: () => _showAccessSnack(
                  'WhatsApp share simulated for ${_nameController.text}.',
                ),
              ),
              const SizedBox(height: 10),
              _OutlineActionButton(
                label: 'Share via Email',
                icon: Icons.email_outlined,
                onPressed: () => _showAccessSnack(
                  'Email share simulated for ${_nameController.text}.',
                ),
              ),
              const SizedBox(height: 10),
              _OutlineActionButton(
                label: 'Copy Link',
                icon: Icons.link_outlined,
                onPressed: () =>
                    _showAccessSnack('Access link copied for $_generatedCode.'),
              ),
              const SizedBox(height: 16),
              LuxuryButton(
                label: 'Continue to Verify',
                icon: Icons.verified_user_outlined,
                onPressed: () => _goToStep(3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScanVerify() {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              color: _accessSoftGold,
              shape: BoxShape.circle,
              border: Border.all(color: _accessGold.withValues(alpha: 0.40)),
            ),
            child: const Icon(
              Icons.qr_code_scanner_outlined,
              color: _accessGold,
              size: 46,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Scanning QR Code',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _accessNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Security scans and verifies access instantly.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: _accessMuted, height: 1.35),
          ),
          const SizedBox(height: 20),
          if (_isVerifying) ...[
            const SizedBox(
              width: 42,
              height: 42,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: _accessGold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Validating encrypted QR token...',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: _accessMuted),
            ),
          ] else ...[
            _buildAccessSummary(status: 'Valid Access'),
            const SizedBox(height: 18),
            LuxuryButton(
              label: 'Grant Access',
              icon: Icons.fact_check_outlined,
              onPressed: () => _goToStep(4),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAccessGranted() {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F7EE),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF2DAE62)),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF218D4F),
              size: 56,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Access Granted!',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFF218D4F),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Gate opened successfully.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: _accessMuted),
          ),
          const SizedBox(height: 20),
          _buildGrantedSummary(),
          const SizedBox(height: 18),
          LuxuryButton(
            label: 'Done',
            icon: Icons.done_all_outlined,
            onPressed: () {
              setState(() {
                _accessHistories.insert(0, _currentAccessHistoryItem());
                _accessStep = 5;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccessHistory() {
    final filtered =
        _accessHistories
            .where(
              (item) =>
                  _historyFilter == 'All Access' ||
                  item.accessType.startsWith(_historyFilter),
            )
            .toList()
          ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    final today = filtered
        .where((item) => _isSameDay(item.dateTime, _historyToday))
        .toList();
    final yesterday = filtered
        .where((item) => _isSameDay(item.dateTime, _historyYesterday))
        .toList();
    final older = filtered
        .where(
          (item) =>
              !_isSameDay(item.dateTime, _historyToday) &&
              !_isSameDay(item.dateTime, _historyYesterday),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WhitePremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CardTitle(
                title: 'Access History',
                subtitle: 'All access records are stored and traceable.',
                icon: Icons.history_outlined,
              ),
              const SizedBox(height: 16),
              _ChoiceWrap(
                items: const [
                  'All Access',
                  'Visitor',
                  'Parking',
                  'Delivery',
                  'Guest',
                ],
                selected: _historyFilter,
                onSelected: (value) => setState(() => _historyFilter = value),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _buildHistorySection('Today', today),
        _buildHistorySection('Yesterday', yesterday),
        _buildHistorySection('Older', older),
        const SizedBox(height: 4),
        _OutlineActionButton(
          label: 'Download History',
          icon: Icons.download_outlined,
          onPressed: () =>
              _showAccessSnack('Access history download simulated.'),
        ),
        const SizedBox(height: 10),
        LuxuryButton(
          label: 'Create New Access',
          icon: Icons.add_circle_outline,
          onPressed: _resetAccessFlow,
        ),
      ],
    );
  }

  Widget _buildAccessTypeCard(String accessType) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(16),
      onTap: () {
        setState(() {
          _selectedAccessType = accessType;
          _selectedPurpose = switch (accessType) {
            'Delivery Access' => 'Delivery',
            'Guest Access' => 'Private Guest',
            'Parking Access' => 'Business',
            _ => 'Family Visit',
          };
          _accessStep = 1;
        });
      },
      child: Row(
        children: [
          _GoldIcon(icon: _accessIcon(accessType), size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  accessType,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: _accessNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _accessSubtitle(accessType),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _accessMuted,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: _accessGold),
        ],
      ),
    );
  }

  Widget _buildAccessSummary({required String status}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _accessSoftGray,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _accessLine),
      ),
      child: Column(
        children: [
          _buildDetailRow('Status', status),
          const SizedBox(height: 8),
          _buildDetailRow('Visitor', _nameController.text),
          const SizedBox(height: 8),
          _buildDetailRow('Purpose', _selectedPurpose),
          const SizedBox(height: 8),
          _buildDetailRow('Unit', DemoData.primaryResident.unit.label),
          const SizedBox(height: 8),
          _buildDetailRow('Access Type', _selectedAccessType),
        ],
      ),
    );
  }

  Widget _buildGrantedSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _accessSoftGray,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _accessLine),
      ),
      child: Column(
        children: [
          _buildDetailRow('Access Type', _selectedAccessType),
          const SizedBox(height: 8),
          _buildDetailRow('Visitor', _nameController.text),
          const SizedBox(height: 8),
          _buildDetailRow('Schedule', _scheduleController.text),
          const SizedBox(height: 8),
          _buildDetailRow('Code', _generatedCode),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _accessMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _accessNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection(String title, List<AccessHistoryItem> items) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 8, 2, 10),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: _accessNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        for (final item in items) _buildHistoryCard(item),
      ],
    );
  }

  Widget _buildHistoryCard(AccessHistoryItem item) {
    return WhitePremiumCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GoldIcon(icon: _accessIcon(item.accessType), size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.accessType,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: _accessNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.name} - ${item.detail}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _accessMuted,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${_date.format(item.dateTime)} at ${_time.format(item.dateTime)}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: _accessMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          StatusBadge(status: item.status),
        ],
      ),
    );
  }

  AccessHistoryItem _currentAccessHistoryItem() {
    return AccessHistoryItem(
      accessType: _selectedAccessType,
      name: _nameController.text,
      detail: _vehicleController.text.isEmpty
          ? _phoneController.text
          : _vehicleController.text,
      dateTime: _historyToday.add(const Duration(hours: 10, minutes: 30)),
      status: 'Approved',
    );
  }

  void _showAccessSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  IconData _accessIcon(String accessType) {
    return switch (accessType) {
      'Parking Access' => Icons.local_parking_outlined,
      'Delivery Access' => Icons.inventory_2_outlined,
      'Guest Access' => Icons.group_outlined,
      _ => Icons.person_add_alt_1_outlined,
    };
  }

  String _accessPrefix(String accessType) {
    return switch (accessType) {
      'Parking Access' => 'PAR',
      'Delivery Access' => 'DEL',
      'Guest Access' => 'GST',
      _ => 'VIS',
    };
  }

  String _accessSubtitle(String accessType) {
    return switch (accessType) {
      'Parking Access' => 'Access to parking area',
      'Delivery Access' => 'For parcel or delivery pickup',
      'Guest Access' => 'Access for invited guest',
      _ => 'Allow visitors to enter the residence',
    };
  }

  bool _isSameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  String get _countdownText {
    final minutes = (_qrSecondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_qrSecondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  DateTime get _historyToday => DateTime(2026, 6, 7);

  DateTime get _historyYesterday =>
      _historyToday.subtract(const Duration(days: 1));
}

class _DigitalAccessSurface extends StatelessWidget {
  const _DigitalAccessSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: _accessBackground,
        textTheme: Theme.of(
          context,
        ).textTheme.apply(bodyColor: _accessNavy, displayColor: _accessNavy),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: _accessMuted),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _accessLine),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _accessGold, width: 1.2),
          ),
        ),
      ),
      child: ColoredBox(color: _accessBackground, child: child),
    );
  }
}

class _AccessHeader extends StatelessWidget {
  const _AccessHeader({
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
                    color: _accessNavy,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _accessMuted,
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
                  color: _accessNavy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _accessMuted,
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
      color: selected ? _accessSoftGold : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(
          color: selected ? _accessGold.withValues(alpha: 0.55) : _accessLine,
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
              color: selected ? _accessNavy : _accessMuted,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  const _OutlineActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          alignment: Alignment.centerLeft,
          foregroundColor: _accessNavy,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          side: const BorderSide(color: _accessLine),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
        color: _accessSoftGold,
        borderRadius: BorderRadius.circular(size * 0.34),
        border: Border.all(color: _accessGold.withValues(alpha: 0.32)),
      ),
      child: Icon(icon, color: _accessGold, size: size * 0.54),
    );
  }
}

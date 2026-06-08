import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/data/demo_data.dart';
import '../../../core/widgets/luxury_button.dart';
import '../../../core/widgets/premium_qr_card.dart';
import '../../../core/widgets/premium_step_indicator.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/white_premium_card.dart';

const _visitorNavy = Color(0xFF071B34);
const _visitorGold = Color(0xFFC08A1A);
const _visitorMuted = Color(0xFF687184);
const _visitorSoft = Color(0xFFF8F5EF);
const _visitorLine = Color(0xFFE7DFD1);

class VisitorAccessRecord {
  const VisitorAccessRecord({
    required this.visitorName,
    required this.purpose,
    required this.dateTime,
    required this.passCode,
    required this.status,
    required this.vehicleNumber,
  });

  final String visitorName;
  final String purpose;
  final DateTime dateTime;
  final String passCode;
  final String status;
  final String vehicleNumber;
}

class VisitorManagementPage extends StatefulWidget {
  const VisitorManagementPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<VisitorManagementPage> createState() => _VisitorManagementPageState();
}

class _VisitorManagementPageState extends State<VisitorManagementPage> {
  static const _steps = [
    'Register',
    'Schedule',
    'Pass',
    'Share',
    'Verify',
    'Check-In',
    'History',
  ];
  static const _timeOptions = ['10:00', '14:00', '16:00', '19:00'];
  static const _durationOptions = ['30 mins', '1 hour', '2 hours', 'Other'];
  static const _purposeOptions = [
    'Visit Family',
    'Business Meeting',
    'Delivery',
    'Private Guest',
  ];
  static const _historyFilters = [
    'All',
    'Upcoming',
    'Past',
    'Checked In',
    'Checked Out',
  ];

  int _visitorStep = 0;
  String _visitorName = 'John Doe';
  String _phone = '+62 812-3456-7890';
  String _purpose = 'Visit Family';
  final String _visitDate = '08 June 2026';
  String _visitTime = '14:00';
  String _duration = '1 hour';
  int _visitorCount = 1;
  String _vehicleNumber = 'B 1234 ABC';
  String _visitorPassCode = 'VST-2026-00125';
  String _historyFilter = 'All';
  bool _isVerifying = false;
  bool _hasSavedCheckIn = false;

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _vehicleController;
  late final List<VisitorAccessRecord> _visitorHistory;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _visitorName);
    _phoneController = TextEditingController(text: _phone);
    _vehicleController = TextEditingController(text: _vehicleNumber);
    _visitorHistory = [
      VisitorAccessRecord(
        visitorName: 'John Doe',
        purpose: 'Visit Family',
        dateTime: DateTime(2026, 6, 8, 14, 3),
        passCode: 'VST-2026-00125',
        status: 'Checked In',
        vehicleNumber: 'B 1234 ABC',
      ),
      VisitorAccessRecord(
        visitorName: 'Michael Tan',
        purpose: 'Business Meeting',
        dateTime: DateTime(2026, 6, 5, 10, 15),
        passCode: 'VST-2026-00102',
        status: 'Checked In',
        vehicleNumber: 'B 2026 MT',
      ),
      VisitorAccessRecord(
        visitorName: 'Sarah Lim',
        purpose: 'Visit Family',
        dateTime: DateTime(2026, 6, 1, 16, 45),
        passCode: 'VST-2026-00094',
        status: 'Checked Out',
        vehicleNumber: '-',
      ),
      VisitorAccessRecord(
        visitorName: 'David Wong',
        purpose: 'Delivery',
        dateTime: DateTime(2026, 5, 30, 11, 20),
        passCode: 'VST-2026-00081',
        status: 'Checked Out',
        vehicleNumber: 'B 9912 DW',
      ),
      ...DemoData.visitors.map(
        (item) => VisitorAccessRecord(
          visitorName: item.name,
          purpose: item.purpose,
          dateTime: item.visitTime,
          passCode: item.code,
          status: item.status == 'Upcoming'
              ? 'Upcoming'
              : item.status == 'Used'
              ? 'Checked Out'
              : 'Past',
          vehicleNumber: '-',
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _vehicleController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    setState(() => _visitorStep = step.clamp(0, _steps.length - 1));
    if (step == 4) {
      _startVerification();
    }
  }

  void _nextStep() => _goToStep(_visitorStep + 1);

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _saveRegistration() {
    setState(() {
      _visitorName = _nameController.text.trim().isEmpty
          ? 'John Doe'
          : _nameController.text.trim();
      _phone = _phoneController.text.trim().isEmpty
          ? '+62 812-3456-7890'
          : _phoneController.text.trim();
      _vehicleNumber = _vehicleController.text.trim().isEmpty
          ? '-'
          : _vehicleController.text.trim();
    });
    _nextStep();
  }

  void _generatePassCode() {
    final nextNumber = (_visitorHistory.length + 126).toString().padLeft(
      5,
      '0',
    );
    setState(() {
      _visitorPassCode = 'VST-2026-$nextNumber';
    });
  }

  void _startVerification() {
    setState(() => _isVerifying = true);
    unawaited(
      Future<void>.delayed(const Duration(seconds: 1), () {
        if (!mounted || _visitorStep != 4) {
          return;
        }
        setState(() => _isVerifying = false);
      }),
    );
  }

  void _completeCheckIn() {
    if (!_hasSavedCheckIn) {
      final visitDateTime = DateTime(
        2026,
        6,
        8,
        int.parse(_visitTime.split(':').first),
        int.parse(_visitTime.split(':').last),
      );
      setState(() {
        _visitorHistory.insert(
          0,
          VisitorAccessRecord(
            visitorName: _visitorName,
            purpose: _purpose,
            dateTime: visitDateTime.add(const Duration(minutes: 3)),
            passCode: _visitorPassCode,
            status: 'Checked In',
            vehicleNumber: _vehicleNumber,
          ),
        );
        _hasSavedCheckIn = true;
      });
    }
    _nextStep();
  }

  List<VisitorAccessRecord> get _filteredHistory {
    final now = DateTime(2026, 6, 8, 12);
    return _visitorHistory.where((record) {
      switch (_historyFilter) {
        case 'Upcoming':
          return record.dateTime.isAfter(now);
        case 'Past':
          return record.dateTime.isBefore(now);
        case 'Checked In':
          return record.status == 'Checked In';
        case 'Checked Out':
          return record.status == 'Checked Out';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _visitorSoft,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        children: [
          _buildTopBar(context),
          const SizedBox(height: 18),
          PremiumStepIndicator(
            currentStep: _visitorStep,
            steps: _steps,
            onStepSelected: _goToStep,
          ),
          const SizedBox(height: 18),
          _buildStepBody(context),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: _visitorStep == 0
              ? widget.onBack
              : () => _goToStep(_visitorStep - 1),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          alignment: Alignment.centerLeft,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _visitorNavy,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Visitor Management',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: _visitorNavy,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Secure visitor registration & digital access',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: _visitorMuted, height: 1.45),
        ),
      ],
    );
  }

  Widget _buildStepBody(BuildContext context) {
    switch (_visitorStep) {
      case 0:
        return _buildRegisterStep(context);
      case 1:
        return _buildScheduleStep(context);
      case 2:
        return _buildPassStep(context);
      case 3:
        return _buildShareStep(context);
      case 4:
        return _buildVerifyStep(context);
      case 5:
        return _buildCheckInStep(context);
      case 6:
        return _buildHistoryStep(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRegisterStep(BuildContext context) {
    return WhitePremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeading(
            title: 'Register Visitor',
            subtitle: 'Create a secure visitor profile before arrival.',
          ),
          const SizedBox(height: 18),
          _LabeledField(
            label: 'Visitor Name',
            child: _PremiumTextField(
              controller: _nameController,
              hintText: 'Visitor full name',
              icon: Icons.person_outline_rounded,
            ),
          ),
          const SizedBox(height: 14),
          _LabeledField(
            label: 'Mobile Number',
            child: _PremiumTextField(
              controller: _phoneController,
              hintText: '+62 812-3456-7890',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
          ),
          const SizedBox(height: 14),
          _LabeledField(
            label: 'Purpose of Visit',
            child: _ChoiceWrap<String>(
              options: _purposeOptions,
              selected: _purpose,
              onSelected: (value) => setState(() => _purpose = value),
            ),
          ),
          const SizedBox(height: 14),
          _LabeledField(
            label: 'Number of Visitors',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFCF7),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _visitorLine),
              ),
              child: Row(
                children: [
                  const Icon(Icons.groups_2_outlined, color: _visitorGold),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '$_visitorCount visitor${_visitorCount > 1 ? 's' : ''}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _visitorNavy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _visitorCount > 1
                        ? () => setState(() => _visitorCount -= 1)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline_rounded),
                  ),
                  IconButton(
                    onPressed: _visitorCount < 6
                        ? () => setState(() => _visitorCount += 1)
                        : null,
                    icon: const Icon(Icons.add_circle_outline_rounded),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _LabeledField(
            label: 'Vehicle Number (Optional)',
            child: _PremiumTextField(
              controller: _vehicleController,
              hintText: 'B 1234 ABC',
              icon: Icons.directions_car_outlined,
            ),
          ),
          const SizedBox(height: 22),
          LuxuryButton(label: 'Next', onPressed: _saveRegistration),
        ],
      ),
    );
  }

  Widget _buildScheduleStep(BuildContext context) {
    return Column(
      children: [
        WhitePremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeading(
                title: 'Schedule Visit',
                subtitle: 'Choose visit date, time, and expected duration.',
              ),
              const SizedBox(height: 18),
              _CalendarCard(selectedDay: 8),
              const SizedBox(height: 18),
              _LabeledField(
                label: 'Visit Time',
                child: _ChoiceWrap<String>(
                  options: _timeOptions,
                  selected: _visitTime,
                  onSelected: (value) => setState(() => _visitTime = value),
                ),
              ),
              const SizedBox(height: 14),
              _LabeledField(
                label: 'Expected Duration',
                child: _ChoiceWrap<String>(
                  options: _durationOptions,
                  selected: _duration,
                  onSelected: (value) => setState(() => _duration = value),
                ),
              ),
              const SizedBox(height: 20),
              LuxuryButton(
                label: 'Confirm',
                onPressed: () {
                  _generatePassCode();
                  _nextStep();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPassStep(BuildContext context) {
    return Column(
      children: [
        PremiumQrCard(
          title: 'PASS GENERATED',
          code: _visitorPassCode,
          accessType: 'Visitor Pass',
          visitorName: _visitorName,
          schedule: '$_visitDate, $_visitTime',
          status: 'Ready to Share',
          countdownText: 'Valid until 16:00',
        ),
        const SizedBox(height: 14),
        WhitePremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(label: 'Visitor ID', value: _visitorPassCode),
              _InfoRow(label: 'Purpose of Visit', value: _purpose),
              _InfoRow(
                label: 'Unit',
                value: DemoData.primaryResident.unit.label,
              ),
              _InfoRow(label: 'Vehicle Number', value: _vehicleNumber),
              _InfoRow(label: 'Duration', value: _duration),
              const Divider(height: 26),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.verified_user_outlined,
                    size: 18,
                    color: _visitorGold,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This pass is valid only for the above time and unit.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _visitorMuted,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              LuxuryButton(
                label: 'Share Visitor Pass',
                icon: Icons.ios_share_outlined,
                onPressed: _nextStep,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShareStep(BuildContext context) {
    return WhitePremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeading(
            title: 'Share Visitor Pass',
            subtitle: 'Share visitor pass with your guest.',
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFCF7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _visitorLine),
            ),
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: _visitorLine),
                  ),
                  child: const Icon(
                    Icons.qr_code_2_rounded,
                    size: 34,
                    color: _visitorNavy,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _visitorPassCode,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: _visitorNavy,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Generated for $_visitorName',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: _visitorMuted),
                      ),
                      const SizedBox(height: 8),
                      const StatusBadge(status: 'Generated'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ...[
            ('WhatsApp', Icons.chat_bubble_outline_rounded),
            ('SMS', Icons.sms_outlined),
            ('Email', Icons.mail_outline_rounded),
            ('Copy Link', Icons.link_rounded),
            ('More Options', Icons.more_horiz_rounded),
          ].map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ShareOptionTile(
                label: item.$1,
                icon: item.$2,
                onTap: () => _showSnackBar(
                  item.$1 == 'Copy Link'
                      ? 'Visitor pass link copied'
                      : 'Visitor pass shared via ${item.$1}',
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          LuxuryButton(
            label: 'Continue to Verification',
            onPressed: () {
              _goToStep(4);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyStep(BuildContext context) {
    return WhitePremiumCard(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: _isVerifying
            ? SizedBox(
                key: const ValueKey('loading'),
                height: 320,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: _visitorGold),
                      const SizedBox(height: 18),
                      Text(
                        'Scanning visitor pass...',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: _visitorNavy,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                key: const ValueKey('verified'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: Color(0xFFEAF7EF),
                      child: Icon(
                        Icons.shield_rounded,
                        size: 42,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text(
                      'QR Verified',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Visitor is verified successfully.',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: _visitorMuted),
                    ),
                  ),
                  const SizedBox(height: 22),
                  _InfoRow(label: 'Visitor Name', value: _visitorName),
                  _InfoRow(label: 'Visitor ID', value: _visitorPassCode),
                  _InfoRow(
                    label: 'Unit',
                    value: DemoData.primaryResident.unit.label,
                  ),
                  _InfoRow(label: 'Valid Until', value: '08 Jun 2026, 16:00'),
                  _InfoRow(label: 'Purpose', value: _purpose),
                  const SizedBox(height: 16),
                  LuxuryButton(label: 'Access Approved', onPressed: _nextStep),
                ],
              ),
      ),
    );
  }

  Widget _buildCheckInStep(BuildContext context) {
    return WhitePremiumCard(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 42,
            backgroundColor: Color(0xFFEAF7EF),
            child: Icon(
              Icons.domain_verification_rounded,
              size: 42,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Check-In Successful',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Visitor has entered the residence.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: _visitorMuted),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFCF7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _visitorLine),
            ),
            child: Column(
              children: [
                _InfoRow(label: 'Visitor Name', value: _visitorName),
                _InfoRow(label: 'Check-In Time', value: '08 Jun 2026, 14:03'),
                _InfoRow(
                  label: 'Unit',
                  value: DemoData.primaryResident.unit.label,
                ),
                _InfoRow(label: 'Vehicle Number', value: _vehicleNumber),
              ],
            ),
          ),
          const SizedBox(height: 20),
          LuxuryButton(label: 'Done', onPressed: _completeCheckIn),
        ],
      ),
    );
  }

  Widget _buildHistoryStep(BuildContext context) {
    final items = _filteredHistory;
    return Column(
      children: [
        WhitePremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeading(
                title: 'Visitor History',
                subtitle: 'Track all visitor activity and check-in records.',
              ),
              const SizedBox(height: 16),
              _ChoiceWrap<String>(
                options: _historyFilters,
                selected: _historyFilter,
                onSelected: (value) => setState(() => _historyFilter = value),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ...items.map(
          (record) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: WhitePremiumCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: _visitorGold.withValues(alpha: 0.14),
                    child: Text(
                      _initials(record.visitorName),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: _visitorNavy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.visitorName,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: _visitorNavy,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          record.purpose,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: _visitorMuted),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDateTime(record.dateTime),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: _visitorMuted),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Vehicle: ${record.vehicleNumber}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: _visitorMuted),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(status: record.status),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _showSnackBar('Visitor history downloaded'),
          icon: const Icon(Icons.download_rounded),
          label: const Text('Download History'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 54),
            foregroundColor: _visitorNavy,
            side: const BorderSide(color: _visitorLine),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: widget.onBack,
          child: const Text('Back to Access Hub'),
        ),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: _visitorNavy,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: _visitorMuted, height: 1.45),
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: _visitorNavy,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _PremiumTextField extends StatelessWidget {
  const _PremiumTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: _visitorGold),
        filled: true,
        fillColor: const Color(0xFFFFFCF7),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: _visitorLine),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: _visitorLine),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: _visitorGold),
        ),
      ),
    );
  }
}

class _ChoiceWrap<T> extends StatelessWidget {
  const _ChoiceWrap({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<T> options;
  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((option) {
        final isSelected = option == selected;
        return InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => onSelected(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? _visitorGold.withValues(alpha: 0.16)
                  : Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isSelected ? _visitorGold : _visitorLine,
              ),
            ),
            child: Text(
              '$option',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isSelected ? _visitorNavy : _visitorMuted,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({required this.selectedDay});

  final int selectedDay;

  @override
  Widget build(BuildContext context) {
    const weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const days = [
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29,
      30,
      0,
      0,
      0,
      0,
      0,
      0,
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _visitorLine),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.chevron_left_rounded, color: _visitorNavy),
              Expanded(
                child: Text(
                  'June 2026',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _visitorNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: _visitorNavy),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: weekDays
                .map(
                  (day) => Expanded(
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: _visitorMuted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final day = days[index];
              final isSelected = day == selectedDay;
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: day == 0
                      ? Colors.transparent
                      : isSelected
                      ? _visitorNavy
                      : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: day == 0
                      ? null
                      : Border.all(
                          color: isSelected ? _visitorNavy : _visitorLine,
                        ),
                ),
                child: Text(
                  day == 0 ? '' : '$day',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isSelected ? Colors.white : _visitorNavy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: _visitorMuted),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _visitorNavy,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareOptionTile extends StatelessWidget {
  const _ShareOptionTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _visitorGold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: _visitorGold, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: _visitorNavy,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: _visitorGold,
          ),
        ],
      ),
    );
  }
}

String _initials(String value) {
  final parts = value.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts.first.isEmpty) {
    return 'NA';
  }
  if (parts.length == 1 || parts.last.isEmpty) {
    return parts.first.substring(0, 1).toUpperCase();
  }
  return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
      .toUpperCase();
}

String _formatDateTime(DateTime value) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final day = value.day.toString().padLeft(2, '0');
  final month = months[value.month - 1];
  final year = value.year;
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$day $month $year, $hour:$minute';
}

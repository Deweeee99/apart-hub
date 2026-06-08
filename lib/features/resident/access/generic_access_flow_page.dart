import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/data/demo_data.dart';
import '../../../core/widgets/luxury_button.dart';
import '../../../core/widgets/premium_qr_card.dart';
import '../../../core/widgets/premium_step_indicator.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/white_premium_card.dart';

const _flowBackground = Color(0xFFFAF8F2);
const _flowNavy = Color(0xFF071B34);
const _flowGold = Color(0xFFC08A1A);
const _flowMuted = Color(0xFF687184);
const _flowLine = Color(0xFFE7DFD1);
const _flowSoftGold = Color(0xFFFFF6DF);

enum AccessFlowType { parking, delivery, guest }

class AccessFlowConfig {
  const AccessFlowConfig({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.detailStepTitle,
    required this.generateStepTitle,
    required this.shareStepTitle,
    required this.verifyStepTitle,
    required this.grantedTitle,
    required this.historyTitle,
    required this.passPrefix,
    required this.fieldLabels,
    required this.seedValues,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String detailStepTitle;
  final String generateStepTitle;
  final String shareStepTitle;
  final String verifyStepTitle;
  final String grantedTitle;
  final String historyTitle;
  final String passPrefix;
  final List<String> fieldLabels;
  final Map<String, String> seedValues;
}

class GenericAccessHistoryRecord {
  const GenericAccessHistoryRecord({
    required this.name,
    required this.detail,
    required this.schedule,
    required this.passCode,
    required this.status,
  });

  final String name;
  final String detail;
  final String schedule;
  final String passCode;
  final String status;
}

class GenericAccessFlowPage extends StatefulWidget {
  const GenericAccessFlowPage({
    super.key,
    required this.accessType,
    required this.onBack,
  });

  final AccessFlowType accessType;
  final VoidCallback onBack;

  @override
  State<GenericAccessFlowPage> createState() => _GenericAccessFlowPageState();
}

class _GenericAccessFlowPageState extends State<GenericAccessFlowPage> {
  static const _steps = [
    'Detail',
    'Generate',
    'Share',
    'Verify',
    'Granted',
    'History',
  ];
  static const _historyFilters = ['All', 'Approved', 'Used', 'Expired'];

  late final AccessFlowConfig _config;
  late final Map<String, TextEditingController> _controllers;
  late List<GenericAccessHistoryRecord> _history;

  var _flowStep = 0;
  var _historyFilter = 'All';
  var _generatedCode = '';
  var _isVerifying = false;
  var _hasSavedRecord = false;

  @override
  void initState() {
    super.initState();
    _config = _configFor(widget.accessType);
    _controllers = {
      for (final field in _config.fieldLabels)
        field: TextEditingController(text: _config.seedValues[field] ?? ''),
    };
    _history = _seedHistoryFor(widget.accessType);
    _generatedCode = _initialCode;
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _flowBackground,
      child: ListView(
        key: ValueKey('generic-access-${widget.accessType.name}'),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        children: [
          _FlowHeader(
            title: _config.title,
            subtitle: _config.subtitle,
            icon: _config.icon,
            onBack: _flowStep == 0
                ? widget.onBack
                : () => _goToStep(_flowStep - 1),
          ),
          const SizedBox(height: 16),
          PremiumStepIndicator(
            currentStep: _flowStep,
            steps: _steps,
            onStepSelected: _goToStep,
          ),
          const SizedBox(height: 18),
          _buildStepContent(),
        ],
      ),
    );
  }

  void _goToStep(int step) {
    final clamped = step.clamp(0, _steps.length - 1);
    setState(() => _flowStep = clamped);
    if (clamped == 3) {
      _startVerify();
    }
  }

  void _startVerify() {
    setState(() => _isVerifying = true);
    unawaited(
      Future<void>.delayed(const Duration(seconds: 1), () {
        if (!mounted || _flowStep != 3) {
          return;
        }
        setState(() => _isVerifying = false);
      }),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _generateQr() {
    setState(() {
      _generatedCode = _initialCode;
      _flowStep = 1;
    });
  }

  void _completeFlow() {
    if (!_hasSavedRecord) {
      setState(() {
        _history = [
          GenericAccessHistoryRecord(
            name: _primaryTitle,
            detail: _secondaryDetail,
            schedule: _scheduleValue,
            passCode: _generatedCode,
            status: 'Approved',
          ),
          ..._history,
        ];
        _hasSavedRecord = true;
        _flowStep = 5;
      });
      return;
    }
    _goToStep(5);
  }

  Widget _buildStepContent() {
    return switch (_flowStep) {
      0 => _buildDetailStep(),
      1 => _buildGenerateStep(),
      2 => _buildShareStep(),
      3 => _buildVerifyStep(),
      4 => _buildGrantedStep(),
      _ => _buildHistoryStep(),
    };
  }

  Widget _buildDetailStep() {
    return WhitePremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeading(
            title: _config.detailStepTitle,
            subtitle: 'Fill in the access details before generating a QR pass.',
            icon: _config.icon,
          ),
          const SizedBox(height: 18),
          for (final field in _config.fieldLabels) ...[
            Text(
              field,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: _flowNavy,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controllers[field],
              decoration: InputDecoration(
                hintText: field,
                filled: true,
                fillColor: const Color(0xFFFFFCF7),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: _flowLine),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: _flowGold),
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
          const SizedBox(height: 8),
          LuxuryButton(
            label: 'Generate QR Code',
            icon: Icons.qr_code_2_rounded,
            onPressed: _generateQr,
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateStep() {
    return Column(
      children: [
        PremiumQrCard(
          title: _config.generateStepTitle,
          code: _generatedCode,
          accessType: _config.title,
          visitorName: _primaryTitle,
          schedule: _scheduleValue,
          status: 'QR VALID',
          countdownText: '02:59',
        ),
        const SizedBox(height: 14),
        WhitePremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(label: 'Pass Code', value: _generatedCode),
              _InfoRow(label: 'Primary Detail', value: _primaryTitle),
              _InfoRow(label: 'Schedule', value: _scheduleValue),
              _InfoRow(label: 'Access Note', value: _secondaryDetail),
              const Divider(height: 28),
              Text(
                'This pass is valid only for the above schedule and intended residence access.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _flowMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              LuxuryButton(
                label: 'Share Pass',
                icon: Icons.ios_share_outlined,
                onPressed: () => _goToStep(2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShareStep() {
    final shareLabel = _config.shareStepTitle.toLowerCase();
    return WhitePremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeading(
            title: _config.shareStepTitle,
            subtitle: 'Send the generated pass through your preferred channel.',
            icon: Icons.share_outlined,
          ),
          const SizedBox(height: 18),
          ...[
            ('WhatsApp', Icons.chat_bubble_outline_rounded),
            ('SMS', Icons.sms_outlined),
            ('Email', Icons.mail_outline_rounded),
            ('Copy Link', Icons.link_rounded),
          ].map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ShareTile(
                label: item.$1,
                icon: item.$2,
                onTap: () => _showSnackBar(
                  item.$1 == 'Copy Link'
                      ? '${_config.title} link copied'
                      : '$shareLabel shared via ${item.$1}',
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          LuxuryButton(
            label: 'Continue to Verify',
            icon: Icons.verified_user_outlined,
            onPressed: () => _goToStep(3),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyStep() {
    return WhitePremiumCard(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: _isVerifying
            ? SizedBox(
                key: const ValueKey('verifying'),
                height: 320,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: _flowGold),
                      const SizedBox(height: 16),
                      Text(
                        'Scanning and verifying access...',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: _flowNavy,
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
                        color: Color(0xFF2DAE62),
                        size: 42,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      _config.verifyStepTitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: const Color(0xFF218D4F),
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Access details are verified successfully.',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: _flowMuted),
                    ),
                  ),
                  const SizedBox(height: 22),
                  _InfoRow(label: 'Access Type', value: _config.title),
                  _InfoRow(label: 'Pass Code', value: _generatedCode),
                  _InfoRow(label: 'Primary Detail', value: _primaryTitle),
                  _InfoRow(label: 'Schedule', value: _scheduleValue),
                  _InfoRow(
                    label: 'Unit',
                    value: DemoData.primaryResident.unit.label,
                  ),
                  const SizedBox(height: 14),
                  LuxuryButton(
                    label: 'Verify Access',
                    icon: Icons.check_circle_outline,
                    onPressed: () => _goToStep(4),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildGrantedStep() {
    return WhitePremiumCard(
      child: Column(
        children: [
          const _SuccessIcon(),
          const SizedBox(height: 18),
          Text(
            _config.grantedTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF218D4F),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Access has been approved and is ready for use.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: _flowMuted),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFCF7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _flowLine),
            ),
            child: Column(
              children: [
                _InfoRow(label: 'Pass Code', value: _generatedCode),
                _InfoRow(label: 'Primary Detail', value: _primaryTitle),
                _InfoRow(label: 'Schedule', value: _scheduleValue),
                _InfoRow(label: 'Status', value: 'Approved'),
              ],
            ),
          ),
          const SizedBox(height: 18),
          LuxuryButton(label: 'Done', onPressed: _completeFlow),
        ],
      ),
    );
  }

  Widget _buildHistoryStep() {
    final items = _history.where((record) {
      if (_historyFilter == 'All') {
        return true;
      }
      return record.status == _historyFilter;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WhitePremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CardHeading(
                title: _config.historyTitle,
                subtitle:
                    'Review current and past ${_config.title.toLowerCase()} records.',
                icon: Icons.history_outlined,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final filter in _historyFilters)
                    _ChoiceChipButton(
                      label: filter,
                      selected: _historyFilter == filter,
                      onTap: () => setState(() => _historyFilter = filter),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        for (final record in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: WhitePremiumCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _flowGold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(_config.icon, color: _flowGold),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.name,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: _flowNavy,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          record.detail,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: _flowMuted),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          record.passCode,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: _flowNavy,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          record.schedule,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: _flowMuted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusBadge(status: record.status),
                ],
              ),
            ),
          ),
        const SizedBox(height: 4),
        OutlinedButton.icon(
          onPressed: () => _showSnackBar('${_config.title} history downloaded'),
          icon: const Icon(Icons.download_rounded),
          label: const Text('Download History'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 54),
            foregroundColor: _flowNavy,
            side: const BorderSide(color: _flowLine),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        const SizedBox(height: 10),
        LuxuryButton(
          label: 'Back to Access Hub',
          icon: Icons.arrow_back_outlined,
          onPressed: widget.onBack,
        ),
      ],
    );
  }

  AccessFlowConfig _configFor(AccessFlowType type) {
    return switch (type) {
      AccessFlowType.parking => const AccessFlowConfig(
        title: 'Parking Access',
        subtitle: 'Vehicle entry management',
        icon: Icons.local_parking_outlined,
        detailStepTitle: 'Parking Detail',
        generateStepTitle: 'Generate Parking QR',
        shareStepTitle: 'Share Parking Pass',
        verifyStepTitle: 'Parking Verified',
        grantedTitle: 'Parking Access Granted',
        historyTitle: 'Parking History',
        passPrefix: 'PAR',
        fieldLabels: [
          'Driver Name',
          'Phone Number',
          'Vehicle Plate',
          'Vehicle Type',
          'Visit Schedule',
          'Parking Area',
        ],
        seedValues: {
          'Driver Name': 'Michael Tan',
          'Phone Number': '+62 812 2211 0077',
          'Vehicle Plate': 'B 1808 GOLD',
          'Vehicle Type': 'Car',
          'Visit Schedule': '8 Jun 2026, 14:00',
          'Parking Area': 'Basement B2',
        },
      ),
      AccessFlowType.delivery => const AccessFlowConfig(
        title: 'Delivery Access',
        subtitle: 'Courier and parcel entry',
        icon: Icons.local_shipping_outlined,
        detailStepTitle: 'Delivery Detail',
        generateStepTitle: 'Generate Delivery QR',
        shareStepTitle: 'Share Delivery Pass',
        verifyStepTitle: 'Delivery Verified',
        grantedTitle: 'Delivery Access Granted',
        historyTitle: 'Delivery History',
        passPrefix: 'DEL',
        fieldLabels: [
          'Courier Name',
          'Courier Company',
          'Tracking Number',
          'Package Type',
          'Delivery Schedule',
          'Drop-off Area',
        ],
        seedValues: {
          'Courier Name': 'Andi Saputra',
          'Courier Company': 'JNE Express',
          'Tracking Number': 'JNE-9821-ABCD',
          'Package Type': 'Parcel',
          'Delivery Schedule': '8 Jun 2026, 16:00',
          'Drop-off Area': 'Concierge Desk',
        },
      ),
      AccessFlowType.guest => const AccessFlowConfig(
        title: 'Guest Access',
        subtitle: 'Temporary guest access management',
        icon: Icons.groups_2_outlined,
        detailStepTitle: 'Guest Detail',
        generateStepTitle: 'Generate Guest QR',
        shareStepTitle: 'Share Guest Pass',
        verifyStepTitle: 'Guest Verified',
        grantedTitle: 'Guest Access Granted',
        historyTitle: 'Guest History',
        passPrefix: 'GST',
        fieldLabels: [
          'Guest Name',
          'Phone Number',
          'Purpose',
          'Visit Schedule',
          'Number of Guests',
          'Access Area',
        ],
        seedValues: {
          'Guest Name': 'Sarah Lim',
          'Phone Number': '+62 812 9900 1122',
          'Purpose': 'Private Guest',
          'Visit Schedule': '8 Jun 2026, 19:00',
          'Number of Guests': '2',
          'Access Area': 'Lobby & Unit A-1808',
        },
      ),
    };
  }

  List<GenericAccessHistoryRecord> _seedHistoryFor(AccessFlowType type) {
    return switch (type) {
      AccessFlowType.parking => const [
        GenericAccessHistoryRecord(
          name: 'Michael Tan',
          detail: 'B 1808 GOLD • Basement B2',
          schedule: '08 Jun 2026, 14:00',
          passCode: 'PAR-A1808-2026-001',
          status: 'Approved',
        ),
        GenericAccessHistoryRecord(
          name: 'Jonathan Driver',
          detail: 'B 9999 JP • Basement B1',
          schedule: '06 Jun 2026, 09:30',
          passCode: 'PAR-A1808-2026-010',
          status: 'Used',
        ),
        GenericAccessHistoryRecord(
          name: 'Raymond Lim',
          detail: 'B 1212 RL • Basement B2',
          schedule: '03 Jun 2026, 19:30',
          passCode: 'PAR-A1808-2026-014',
          status: 'Expired',
        ),
      ],
      AccessFlowType.delivery => const [
        GenericAccessHistoryRecord(
          name: 'Andi Saputra',
          detail: 'JNE Express • Concierge Desk',
          schedule: '08 Jun 2026, 16:00',
          passCode: 'DEL-A1808-2026-001',
          status: 'Approved',
        ),
        GenericAccessHistoryRecord(
          name: 'DHL Courier',
          detail: 'DHL • Tower A Lobby',
          schedule: '06 Jun 2026, 11:20',
          passCode: 'DEL-A1808-2026-009',
          status: 'Used',
        ),
        GenericAccessHistoryRecord(
          name: 'SiCepat Runner',
          detail: 'SiCepat • Concierge Desk',
          schedule: '02 Jun 2026, 18:10',
          passCode: 'DEL-A1808-2026-017',
          status: 'Expired',
        ),
      ],
      AccessFlowType.guest => const [
        GenericAccessHistoryRecord(
          name: 'Sarah Lim',
          detail: 'Private Guest • Lobby & Unit A-1808',
          schedule: '08 Jun 2026, 19:00',
          passCode: 'GST-A1808-2026-001',
          status: 'Approved',
        ),
        GenericAccessHistoryRecord(
          name: 'Daniel Hart',
          detail: '2 guests • Lobby & Unit A-1808',
          schedule: '05 Jun 2026, 20:00',
          passCode: 'GST-A1808-2026-011',
          status: 'Used',
        ),
        GenericAccessHistoryRecord(
          name: 'Marissa Chen',
          detail: '1 guest • Lobby only',
          schedule: '01 Jun 2026, 17:30',
          passCode: 'GST-A1808-2026-020',
          status: 'Expired',
        ),
      ],
    };
  }

  String get _initialCode => '${_config.passPrefix}-A1808-2026-001';

  String get _primaryTitle {
    final key = _config.fieldLabels.first;
    return _controllers[key]?.text.trim().isNotEmpty == true
        ? _controllers[key]!.text.trim()
        : _config.seedValues[key] ?? '-';
  }

  String get _secondaryDetail {
    return switch (widget.accessType) {
      AccessFlowType.parking =>
        '${_controllers['Vehicle Plate']?.text.trim() ?? '-'} • ${_controllers['Parking Area']?.text.trim() ?? '-'}',
      AccessFlowType.delivery =>
        '${_controllers['Courier Company']?.text.trim() ?? '-'} • ${_controllers['Drop-off Area']?.text.trim() ?? '-'}',
      AccessFlowType.guest =>
        '${_controllers['Purpose']?.text.trim() ?? '-'} • ${_controllers['Access Area']?.text.trim() ?? '-'}',
    };
  }

  String get _scheduleValue {
    final key = switch (widget.accessType) {
      AccessFlowType.parking => 'Visit Schedule',
      AccessFlowType.delivery => 'Delivery Schedule',
      AccessFlowType.guest => 'Visit Schedule',
    };
    return _controllers[key]?.text.trim().isNotEmpty == true
        ? _controllers[key]!.text.trim()
        : _config.seedValues[key] ?? '-';
  }
}

class _FlowHeader extends StatelessWidget {
  const _FlowHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: _flowNavy,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _flowSoftGold,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _flowGold.withValues(alpha: 0.28)),
            ),
            child: Icon(icon, color: _flowGold),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: _flowNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _flowMuted,
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

class _CardHeading extends StatelessWidget {
  const _CardHeading({
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
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _flowSoftGold,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _flowGold.withValues(alpha: 0.28)),
          ),
          child: Icon(icon, color: _flowGold, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _flowNavy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _flowMuted,
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

class _ShareTile extends StatelessWidget {
  const _ShareTile({
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
              color: _flowGold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: _flowGold, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: _flowNavy,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: _flowGold,
          ),
        ],
      ),
    );
  }
}

class _ChoiceChipButton extends StatelessWidget {
  const _ChoiceChipButton({
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
      color: selected ? _flowSoftGold : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(color: selected ? _flowGold : _flowLine),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: selected ? _flowNavy : _flowMuted,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
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
              ).textTheme.bodyMedium?.copyWith(color: _flowMuted),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _flowNavy,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessIcon extends StatelessWidget {
  const _SuccessIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

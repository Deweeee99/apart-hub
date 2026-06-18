import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/data/demo_data.dart';
import '../../../core/models/app_models.dart';
import '../../../core/widgets/security/security_scanner_frame.dart';
import '../../../core/widgets/security/security_status_chip.dart';
import '../../../core/widgets/security/security_visitor_detail_card.dart';
import '../../../core/widgets/white_premium_card.dart';

final _date = DateFormat('d MMM yyyy', 'id_ID');
final _time = DateFormat('HH:mm', 'id_ID');

const _securitySurface = Color(0xFFF8F5EF);
const _securityNavy = Color(0xFF071B34);
const _securityBlue = Color(0xFF173A67);
const _securityGold = Color(0xFFC08A1A);
const _securityMuted = Color(0xFF687184);
const _securityLine = Color(0xFFE7DFD1);

enum _ScannerView { scanner, detail, result, log }

class VisitorScannerPage extends StatefulWidget {
  const VisitorScannerPage({super.key});

  @override
  State<VisitorScannerPage> createState() => _VisitorScannerPageState();
}

class _VisitorScannerPageState extends State<VisitorScannerPage> {
  late final MobileScannerController _scannerController;
  late List<SecurityVisitorPass> _passes;
  late List<SecurityAccessLog> _accessLogs;

  var _view = _ScannerView.scanner;
  var _isProcessingScan = false;
  var _logFilter = 'All';
  var _invalidCode = '';
  var _resultStatus = 'Checked In';
  SecurityVisitorPass? _selectedPass;
  DateTime? _actionTime;

  bool get _cameraSupported {
    if (kIsWeb) return true;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android ||
      TargetPlatform.iOS ||
      TargetPlatform.macOS => true,
      _ => false,
    };
  }

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      formats: const [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
    _passes = DemoData.securityVisitorPasses.map((item) => item).toList();
    _accessLogs = DemoData.securityAccessLogs.map((item) => item).toList();
  }

  @override
  void dispose() {
    unawaited(_scannerController.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.sizeOf(context).width < 390
        ? 18.0
        : 20.0;

    final topPadding = MediaQuery.viewPaddingOf(context).top + 20;

    return ColoredBox(
      color: _securitySurface,
      child: ListView(
        key: const ValueKey('security-scanner'),
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          topPadding,
          horizontalPadding,
          132,
        ),
        children: [
          const _HeroCard(),
          const SizedBox(height: 18),
          _StatsRow(
            expected: _passes.where((item) => item.status == 'Valid').length,
            checkedIn: _passes
                .where((item) => item.status == 'Checked In')
                .length,
            denied: _passes.where((item) => item.status == 'Denied').length,
          ),
          const SizedBox(height: 18),
          if (_view == _ScannerView.scanner) _scannerCard(),
          if (_view == _ScannerView.detail) _verificationDetailCard(),
          if (_view == _ScannerView.result) _resultCard(),
          const SizedBox(height: 18),
          _accessLogCard(),
        ],
      ),
    );
  }

  Widget _scannerCard() {
    return WhitePremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SecurityScannerFrame(
            showFooter: false,
            child: _cameraSupported ? _cameraPreview() : _cameraFallback(),
          ),
          const SizedBox(height: 12),
          Text(
            'Place QR code inside the frame',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _securityNavy,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Use resident-generated QR codes only.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _securityMuted,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _GoldActionButton(
                label: 'Simulate Scan',
                icon: Icons.document_scanner_outlined,
                onPressed: _simulateValidScan,
              ),
              _OutlineActionButton(
                label: 'Simulate Expired',
                icon: Icons.history_toggle_off_outlined,
                onPressed: () => _simulateScan('Expired'),
              ),
              _OutlineActionButton(
                label: 'Simulate Invalid',
                icon: Icons.block_outlined,
                danger: true,
                onPressed: () => _resolveScan('UNKNOWN-DEMO-QR'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoNote(
            icon: Icons.verified_user_outlined,
            text: _cameraSupported
                ? 'Security only verifies passes generated by residents.'
                : 'Camera scanning is available on mobile. Use simulate scan for desktop demo.',
          ),
        ],
      ),
    );
  }

  Widget _cameraPreview() {
    return MobileScanner(
      controller: _scannerController,
      onDetect: _handleBarcode,
      errorBuilder: (context, error) => _cameraFallback(
        message: 'Camera preview is unavailable. Use simulate scan for demo.',
      ),
    );
  }

  Widget _cameraFallback({String? message}) {
    return Container(
      color: Colors.black.withValues(alpha: 0.42),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.qr_code_scanner_outlined,
                color: AppColors.softGold,
                size: 70,
              ),
              const SizedBox(height: 14),
              Text(
                message ??
                    'Camera scanning is available on supported mobile/web builds.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.82),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _verificationDetailCard() {
    final pass = _selectedPass;
    final status = pass?.status ?? 'Invalid';
    final isValid = status == 'Valid';
    final canDeny = status == 'Valid' || status == 'Expired';

    return SecurityVisitorDetailCard(
      pass: pass,
      status: status,
      invalidCode: _invalidCode,
      canCheckIn: isValid,
      canDeny: canDeny,
      onCheckIn: isValid ? _checkInVisitor : null,
      onDeny: canDeny ? _denyVisitor : null,
      onScanAgain: _resetScanner,
      onReportIssue: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Issue report noted for review.')),
        );
      },
    );
  }

  Widget _resultCard() {
    final pass = _selectedPass;
    final denied = _resultStatus == 'Denied';

    return WhitePremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (denied ? AppColors.danger : AppColors.success)
                    .withValues(alpha: 0.18),
                border: Border.all(
                  color: (denied ? AppColors.danger : AppColors.success)
                      .withValues(alpha: 0.38),
                ),
              ),
              child: Icon(
                denied
                    ? Icons.cancel_outlined
                    : Icons.check_circle_outline_rounded,
                color: denied ? AppColors.danger : AppColors.success,
                size: 42,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(
              denied ? 'Access Denied' : 'Check-In Successful',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: _securityNavy,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              denied
                  ? 'Visitor access has been denied.'
                  : 'Visitor has entered the residence.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: _securityMuted),
            ),
          ),
          const SizedBox(height: 18),
          if (pass != null) ...[
            _DetailRow(label: 'Visitor Name', value: pass.visitorName),
            _DetailRow(
              label: denied ? 'Denied Time' : 'Check-In Time',
              value: _actionTime == null
                  ? '-'
                  : '${_date.format(_actionTime!)} ${_time.format(_actionTime!)}',
            ),
            _DetailRow(label: 'Unit', value: pass.unit),
            _DetailRow(label: 'Resident', value: pass.residentName),
            _DetailRow(label: 'QR Code', value: pass.code),
          ],
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _GoldActionButton(
                  label: 'Back to Scanner',
                  icon: Icons.qr_code_scanner_outlined,
                  onPressed: _resetScanner,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _OutlineActionButton(
                  label: 'View Access Log',
                  icon: Icons.list_alt_outlined,
                  onPressed: () => setState(() => _view = _ScannerView.log),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _accessLogCard() {
    final logs = _filteredLogs;

    return WhitePremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Visitor Access Log',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: _securityNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (_view != _ScannerView.log)
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: _securityGold),
                  onPressed: () => setState(() => _view = _ScannerView.log),
                  child: const Text('View All'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final filter in const [
                  'All',
                  'Valid',
                  'Checked In',
                  'Denied',
                  'Expired',
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: _logFilter == filter,
                      onSelected: (_) => setState(() => _logFilter = filter),
                      selectedColor: _securityGold.withValues(alpha: 0.16),
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: _logFilter == filter
                            ? _securityGold.withValues(alpha: 0.46)
                            : _securityLine,
                      ),
                      labelStyle: TextStyle(
                        color: _logFilter == filter
                            ? _securityGold
                            : _securityMuted,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (logs.isEmpty)
            _InfoNote(
              icon: Icons.inbox_outlined,
              text: 'No visitor records for this filter yet.',
            )
          else
            for (final log in logs.take(_view == _ScannerView.log ? 20 : 3))
              _LogTile(log: log),
          if (_view == _ScannerView.log) ...[
            const SizedBox(height: 8),
            _OutlineActionButton(
              label: 'Back to Scanner',
              icon: Icons.qr_code_scanner_outlined,
              onPressed: _resetScanner,
            ),
          ],
        ],
      ),
    );
  }

  List<SecurityAccessLog> get _filteredLogs {
    if (_logFilter == 'All') return _accessLogs;
    return _accessLogs.where((item) => item.status == _logFilter).toList();
  }

  void _handleBarcode(BarcodeCapture capture) {
    if (_isProcessingScan) return;
    final rawValue = capture.barcodes
        .map((item) => item.rawValue)
        .whereType<String>()
        .firstOrNull;
    if (rawValue == null || rawValue.trim().isEmpty) return;

    _isProcessingScan = true;
    unawaited(_scannerController.stop());
    _resolveScan(rawValue);
  }

  void _simulateValidScan() => _simulateScan('Valid');

  void _simulateScan(String status) {
    final pass = _passes.firstWhere(
      (item) => item.status == status,
      orElse: () => _passes.first,
    );
    _resolveScan(pass.code);
  }

  void _resolveScan(String rawValue) {
    final code = rawValue.trim();
    final match = _passes
        .where((item) => item.code.toUpperCase() == code.toUpperCase())
        .firstOrNull;
    if (_cameraSupported) {
      unawaited(_scannerController.stop());
    }

    setState(() {
      _selectedPass = match;
      _invalidCode = match == null ? code : '';
      _view = _ScannerView.detail;
      _isProcessingScan = false;
    });
  }

  void _checkInVisitor() {
    final pass = _selectedPass;
    if (pass == null || pass.status != 'Valid') return;

    final updated = pass.copyWith(status: 'Checked In');
    _commitVisitorAction(updated, 'Checked In');
  }

  void _denyVisitor() {
    final pass = _selectedPass;
    if (pass == null || (pass.status != 'Valid' && pass.status != 'Expired')) {
      return;
    }

    final updated = pass.copyWith(status: 'Denied');
    _commitVisitorAction(updated, 'Denied');
  }

  void _commitVisitorAction(SecurityVisitorPass updated, String status) {
    final now = DateTime.now();
    setState(() {
      _passes = [
        for (final pass in _passes)
          if (pass.code == updated.code) updated else pass,
      ];
      _selectedPass = updated;
      _resultStatus = status;
      _actionTime = now;
      _view = _ScannerView.result;
      _accessLogs = [
        SecurityAccessLog(
          visitorName: updated.visitorName,
          unit: updated.unit,
          timestamp: now,
          status: status,
          code: updated.code,
        ),
        ..._accessLogs,
      ];
    });
  }

  void _resetScanner() {
    setState(() {
      _view = _ScannerView.scanner;
      _selectedPass = null;
      _invalidCode = '';
      _actionTime = null;
      _isProcessingScan = false;
    });
    if (_cameraSupported) {
      unawaited(_scannerController.start());
    }
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.92),
                const Color(0xFFFBFCFD).withValues(alpha: 0.88),
                _securityBlue.withValues(alpha: 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
            boxShadow: [
              BoxShadow(
                color: _securityNavy.withValues(alpha: 0.08),
                blurRadius: 26,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -24,
                top: -16,
                child: Transform.rotate(
                  angle: -0.35,
                  child: Container(
                    width: 96,
                    height: 68,
                    decoration: BoxDecoration(
                      color: _securityBlue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _securityNavy.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _securityGold.withValues(alpha: 0.20),
                      ),
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner_outlined,
                      color: _securityGold,
                      size: 29,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Visitor Verification',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: _securityNavy,
                                fontWeight: FontWeight.w900,
                                height: 1.05,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Scan and verify resident-generated visitor passes.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: _securityMuted, height: 1.35),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: _securityGold.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified_user_outlined,
                      color: _securityGold,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.expected,
    required this.checkedIn,
    required this.denied,
  });

  final int expected;
  final int checkedIn;
  final int denied;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Expected Visitors',
            value: expected.toString(),
            icon: Icons.groups_2_outlined,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'Checked In',
            value: checkedIn.toString(),
            icon: Icons.login_outlined,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'Denied',
            value: denied.toString(),
            icon: Icons.block_outlined,
            color: AppColors.danger,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.color = AppColors.softGold,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: _securityNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _securityMuted,
              height: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 116,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _securityGold,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _securityNavy,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.log});

  final SecurityAccessLog log;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFBF8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _securityLine),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _securityGold.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.badge_outlined,
              color: _securityGold,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.visitorName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: _securityNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${log.unit} - ${_time.format(log.timestamp)} - ${log.code}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: _securityMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SecurityStatusChip(status: log.status),
        ],
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  const _InfoNote({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFBF8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _securityLine),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _securityGold, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _securityMuted,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoldActionButton extends StatelessWidget {
  const _GoldActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 19),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.softGold,
          disabledBackgroundColor: _securityLine,
          disabledForegroundColor: _securityMuted.withValues(alpha: 0.58),
          foregroundColor: const Color(0xFF17120A),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
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
    this.danger = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.danger : _securityGold;
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, overflow: TextOverflow.ellipsis),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        disabledForegroundColor: _securityMuted.withValues(alpha: 0.52),
        side: BorderSide(color: color.withValues(alpha: 0.48)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

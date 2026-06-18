import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../models/app_models.dart';
import '../white_premium_card.dart';
import 'security_status_chip.dart';

final _date = DateFormat('d MMM yyyy', 'id_ID');
final _time = DateFormat('HH:mm', 'id_ID');

const _detailNavy = Color(0xFF071B34);
const _detailGold = Color(0xFFC08A1A);

class SecurityVisitorDetailCard extends StatelessWidget {
  const SecurityVisitorDetailCard({
    super.key,
    required this.pass,
    required this.status,
    required this.invalidCode,
    required this.canCheckIn,
    required this.canDeny,
    required this.onCheckIn,
    required this.onDeny,
    required this.onScanAgain,
    required this.onReportIssue,
  });

  final SecurityVisitorPass? pass;
  final String status;
  final String invalidCode;
  final bool canCheckIn;
  final bool canDeny;
  final VoidCallback? onCheckIn;
  final VoidCallback? onDeny;
  final VoidCallback onScanAgain;
  final VoidCallback onReportIssue;

  @override
  Widget build(BuildContext context) {
    final visitorPass = pass;

    return WhitePremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: _detailGold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _detailGold.withValues(alpha: 0.24),
                  ),
                ),
                child: const Icon(
                  Icons.person_search_outlined,
                  color: _detailGold,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visitorPass?.visitorName ?? 'Unknown Visitor Pass',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: _detailNavy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SecurityStatusChip(status: status),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (visitorPass == null)
            _InvalidPassNotice(code: invalidCode)
          else ...[
            _SecurityDetailRow(
              label: 'Visitor Type',
              value: visitorPass.visitorType,
            ),
            _SecurityDetailRow(
              label: 'Visiting / Unit',
              value: visitorPass.unit,
            ),
            _SecurityDetailRow(
              label: 'Resident',
              value: visitorPass.residentName,
            ),
            _SecurityDetailRow(
              label: 'Phone Number',
              value: visitorPass.phoneNumber,
            ),
            _SecurityDetailRow(
              label: 'Vehicle Number',
              value: visitorPass.vehicleNumber,
            ),
            _SecurityDetailRow(
              label: 'Visit Time',
              value: _visitWindow(visitorPass),
            ),
            _SecurityDetailRow(label: 'QR Code', value: visitorPass.code),
          ],
          const SizedBox(height: 18),
          _GoldActionButton(
            label: 'Check In',
            icon: Icons.login_outlined,
            onPressed: canCheckIn ? onCheckIn : null,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _OutlineActionButton(
                  label: 'Deny Access',
                  icon: Icons.block_outlined,
                  danger: true,
                  onPressed: canDeny ? onDeny : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _OutlineActionButton(
                  label: 'Scan Again',
                  icon: Icons.refresh_outlined,
                  onPressed: onScanAgain,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: _detailGold),
            onPressed: onReportIssue,
            icon: const Icon(Icons.report_problem_outlined),
            label: const Text('Report Issue'),
          ),
        ],
      ),
    );
  }

  String _visitWindow(SecurityVisitorPass pass) {
    return '${_date.format(pass.startTime)}, ${_time.format(pass.startTime)} - ${_time.format(pass.endTime)}';
  }
}

class _InvalidPassNotice extends StatelessWidget {
  const _InvalidPassNotice({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QR code is not registered in resident visitor passes.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _detailNavy,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          _SecurityDetailRow(
            label: 'QR Code',
            value: code.isEmpty ? '-' : code,
          ),
        ],
      ),
    );
  }
}

class _SecurityDetailRow extends StatelessWidget {
  const _SecurityDetailRow({required this.label, required this.value});

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
                color: _detailGold,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _detailNavy,
                fontWeight: FontWeight.w600,
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
          disabledBackgroundColor: const Color(0xFFE7DFD1),
          disabledForegroundColor: const Color(
            0xFF687184,
          ).withValues(alpha: 0.58),
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
    final color = danger ? AppColors.danger : _detailGold;
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, overflow: TextOverflow.ellipsis),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        disabledForegroundColor: const Color(
          0xFF687184,
        ).withValues(alpha: 0.52),
        side: BorderSide(color: color.withValues(alpha: 0.48)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

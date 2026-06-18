import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/white_premium_card.dart';

const _surface = Color(0xFFF8F5EF);
const _navy = Color(0xFF071B34);
const _blue = Color(0xFF173A67);
const _gold = Color(0xFFC08A1A);
const _muted = Color(0xFF687184);
const _line = Color(0xFFE7DFD1);
const _softRed = Color(0xFFFFF4F2);

class EmergencyHandlingPage extends StatefulWidget {
  const EmergencyHandlingPage({super.key});

  @override
  State<EmergencyHandlingPage> createState() => _EmergencyHandlingPageState();
}

class _EmergencyHandlingPageState extends State<EmergencyHandlingPage> {
  var _status = 'Emergency Alert';

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _surface,
      child: ListView(
        key: const ValueKey('security-emergency'),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 132),
        children: [
          _EmergencyHeroCard(status: _status),
          const SizedBox(height: 18),
          _ActiveEmergencyCard(
            status: _status,
            onCallResident: () {
              setState(() => _status = 'Calling Resident');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calling resident...')),
              );
            },
            onDispatchSecurity: () {
              setState(() => _status = 'Security Dispatched');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Security dispatched to Tower A.'),
                ),
              );
            },
            onMarkResolved: () {
              setState(() => _status = 'Resolved');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Emergency marked as resolved.')),
              );
            },
          ),
          const SizedBox(height: 18),
          _ResponseProgressCard(status: _status),
        ],
      ),
    );
  }
}

class _EmergencyHeroCard extends StatelessWidget {
  const _EmergencyHeroCard({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.94),
                const Color(0xFFFBFCFD).withValues(alpha: 0.90),
                _blue.withValues(alpha: 0.06),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.74)),
            boxShadow: [
              BoxShadow(
                color: _navy.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -16,
                top: -16,
                child: Container(
                  width: 92,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 0,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _gold.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.16),
                      ),
                    ),
                    child: const Icon(
                      Icons.sos_outlined,
                      color: AppColors.danger,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Emergency Handling',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: _navy,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Respond to resident emergency alerts and record security actions.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: _muted, height: 1.35),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const StatusBadge(status: 'High Priority'),
                            const SizedBox(width: 10),
                            Flexible(child: StatusBadge(status: status)),
                          ],
                        ),
                      ],
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

class _ActiveEmergencyCard extends StatelessWidget {
  const _ActiveEmergencyCard({
    required this.status,
    required this.onCallResident,
    required this.onDispatchSecurity,
    required this.onMarkResolved,
  });

  final String status;
  final VoidCallback onCallResident;
  final VoidCallback onDispatchSecurity;
  final VoidCallback onMarkResolved;

  @override
  Widget build(BuildContext context) {
    final isResolved = status == 'Resolved';

    return WhitePremiumCard(
      child: Container(
        decoration: BoxDecoration(
          color: _softRed.withValues(alpha: 0.68),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.danger.withValues(alpha: 0.18)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.emergency_outlined,
                    color: AppColors.danger,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unit A-1808 triggered emergency',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: _navy,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      StatusBadge(status: status),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _DetailRow(label: 'Location', value: 'Tower A'),
            const _DetailRow(label: 'Time', value: '20:45'),
            const _DetailRow(label: 'Resident', value: 'Jonathan Wijaya'),
            const _DetailRow(
              label: 'Emergency Type',
              value: 'Medical Assistance',
            ),
            const _DetailRow(label: 'Priority', value: 'High'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _ActionButton(
                  label: 'Call Resident',
                  icon: Icons.phone_outlined,
                  color: AppColors.danger,
                  onPressed: onCallResident,
                ),
                _ActionButton(
                  label: 'Dispatch Security',
                  icon: Icons.directions_run_outlined,
                  color: _gold,
                  onPressed: onDispatchSecurity,
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isResolved ? null : onMarkResolved,
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: Text(isResolved ? 'Resolved' : 'Mark Resolved'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  disabledBackgroundColor: _line,
                  disabledForegroundColor: _muted.withValues(alpha: 0.60),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResponseProgressCard extends StatelessWidget {
  const _ResponseProgressCard({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final steps = [
      ('Alert Received', true, AppColors.danger),
      (
        'Resident Contacted',
        status == 'Calling Resident' ||
            status == 'Security Dispatched' ||
            status == 'Resolved',
        _gold,
      ),
      (
        'Security Dispatched',
        status == 'Security Dispatched' || status == 'Resolved',
        const Color(0xFF4F88C6),
      ),
      ('Resolved', status == 'Resolved', AppColors.success),
    ];

    return WhitePremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Response Progress',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _navy,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == steps.length - 1 ? 0 : 12),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: steps[i].$2
                          ? steps[i].$3.withValues(alpha: 0.14)
                          : const Color(0xFFF4F4F4),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      steps[i].$2 ? Icons.check : Icons.circle_outlined,
                      size: 16,
                      color: steps[i].$2 ? steps[i].$3 : _muted,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      steps[i].$1,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _navy,
                        fontWeight: steps[i].$2
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, overflow: TextOverflow.ellipsis),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.36)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 108,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _gold,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _navy,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

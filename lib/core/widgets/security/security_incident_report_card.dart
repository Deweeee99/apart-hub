import 'package:flutter/material.dart';

import '../../models/app_models.dart';
import '../status_badge.dart';
import '../white_premium_card.dart';

const _incidentNavy = Color(0xFF071B34);
const _incidentMuted = Color(0xFF687184);
const _incidentGold = Color(0xFFC08A1A);

class SecurityIncidentReportCard extends StatelessWidget {
  const SecurityIncidentReportCard({
    super.key,
    required this.incident,
    this.hasEvidence = false,
  });

  final SecurityIncident incident;
  final bool hasEvidence;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _severityColor(incident).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: _severityColor(incident).withValues(alpha: 0.22),
              ),
            ),
            child: Icon(
              _severityIcon(incident),
              color: _severityColor(incident),
              size: 22,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${incident.id} - ${incident.category}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: _incidentNavy,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    StatusBadge(status: incident.status),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${incident.location} - ${incident.severity} - ${incident.description}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _incidentMuted,
                    height: 1.35,
                  ),
                ),
                if (hasEvidence) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _incidentGold.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: _incidentGold.withValues(alpha: 0.28),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.photo_outlined,
                          size: 14,
                          color: _incidentGold,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Evidence attached',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: _incidentGold,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _severityIcon(SecurityIncident incident) {
    final severity = incident.severity.toLowerCase();
    if (severity.contains('emergency') || severity.contains('high')) {
      return Icons.priority_high_rounded;
    }
    if (severity.contains('medium')) {
      return Icons.report_problem_outlined;
    }
    return Icons.info_outline_rounded;
  }

  Color _severityColor(SecurityIncident incident) {
    final severity = incident.severity.toLowerCase();
    if (severity.contains('emergency') || severity.contains('high')) {
      return Colors.red.shade600;
    }
    if (severity.contains('medium')) {
      return _incidentGold;
    }
    return const Color(0xFF4F88C6);
  }
}

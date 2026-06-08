import 'package:flutter/material.dart';

import '../../../core/data/demo_data.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/white_premium_card.dart';

const _historyBackground = Color(0xFFFAF8F2);
const _historyNavy = Color(0xFF071B34);
const _historyGold = Color(0xFFC08A1A);
const _historyMuted = Color(0xFF687184);
const _historyLine = Color(0xFFE7DFD1);
const _historySoftGold = Color(0xFFFFF6DF);

class AccessHistoryRecord {
  const AccessHistoryRecord({
    required this.category,
    required this.title,
    required this.detail,
    required this.schedule,
    required this.passCode,
    required this.status,
    required this.icon,
  });

  final String category;
  final String title;
  final String detail;
  final String schedule;
  final String passCode;
  final String status;
  final IconData icon;
}

class AccessHistoryPage extends StatefulWidget {
  const AccessHistoryPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<AccessHistoryPage> createState() => _AccessHistoryPageState();
}

class _AccessHistoryPageState extends State<AccessHistoryPage> {
  static const _filters = ['All', 'Visitor', 'Parking', 'Delivery', 'Guest'];
  late final List<AccessHistoryRecord> _records;
  var _activeFilter = 'All';

  @override
  void initState() {
    super.initState();
    _records = [
      ...DemoData.visitors.map(
        (item) => AccessHistoryRecord(
          category: 'Visitor',
          title: item.name,
          detail: item.purpose,
          schedule: _formatDateTime(item.visitTime),
          passCode: item.code,
          status: item.status == 'Used'
              ? 'Used'
              : item.status == 'Expired'
              ? 'Expired'
              : 'Approved',
          icon: Icons.person_add_alt_1_outlined,
        ),
      ),
      const AccessHistoryRecord(
        category: 'Parking',
        title: 'Michael Tan',
        detail: 'B 1808 GOLD • Basement B2',
        schedule: '08 Jun 2026, 14:00',
        passCode: 'PAR-A1808-2026-001',
        status: 'Approved',
        icon: Icons.local_parking_outlined,
      ),
      const AccessHistoryRecord(
        category: 'Delivery',
        title: 'Andi Saputra',
        detail: 'JNE Express • Concierge Desk',
        schedule: '08 Jun 2026, 16:00',
        passCode: 'DEL-A1808-2026-001',
        status: 'Approved',
        icon: Icons.local_shipping_outlined,
      ),
      const AccessHistoryRecord(
        category: 'Guest',
        title: 'Sarah Lim',
        detail: 'Private Guest • Lobby & Unit A-1808',
        schedule: '08 Jun 2026, 19:00',
        passCode: 'GST-A1808-2026-001',
        status: 'Approved',
        icon: Icons.groups_2_outlined,
      ),
      const AccessHistoryRecord(
        category: 'Parking',
        title: 'Raymond Lim',
        detail: 'B 1212 RL • Basement B2',
        schedule: '03 Jun 2026, 19:30',
        passCode: 'PAR-A1808-2026-014',
        status: 'Expired',
        icon: Icons.local_parking_outlined,
      ),
      const AccessHistoryRecord(
        category: 'Delivery',
        title: 'DHL Courier',
        detail: 'DHL • Tower A Lobby',
        schedule: '06 Jun 2026, 11:20',
        passCode: 'DEL-A1808-2026-009',
        status: 'Used',
        icon: Icons.local_shipping_outlined,
      ),
      const AccessHistoryRecord(
        category: 'Guest',
        title: 'Daniel Hart',
        detail: '2 guests • Lobby & Unit A-1808',
        schedule: '05 Jun 2026, 20:00',
        passCode: 'GST-A1808-2026-011',
        status: 'Used',
        icon: Icons.groups_2_outlined,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = _activeFilter == 'All'
        ? _records
        : _records.where((item) => item.category == _activeFilter).toList();

    return ColoredBox(
      color: _historyBackground,
      child: ListView(
        key: const ValueKey('resident-access-history'),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        children: [
          WhitePremiumCard(
            child: Row(
              children: [
                IconButton(
                  onPressed: widget.onBack,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: _historyNavy,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _historySoftGold,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _historyGold.withValues(alpha: 0.28),
                    ),
                  ),
                  child: const Icon(
                    Icons.history_outlined,
                    color: _historyGold,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Access History',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: _historyNavy,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Track all visitor, parking, delivery, and guest access records.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _historyMuted,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          WhitePremiumCard(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final filter in _filters)
                  _FilterChipButton(
                    label: filter,
                    selected: _activeFilter == filter,
                    onTap: () => setState(() => _activeFilter = filter),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          for (final item in items)
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
                        color: _historyGold.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(item.icon, color: _historyGold),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: _historyNavy,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${item.category} • ${item.detail}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: _historyMuted),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.passCode,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: _historyNavy,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.schedule,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: _historyMuted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(status: item.status),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 4),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Access history downloaded')),
              );
            },
            icon: const Icon(Icons.download_rounded),
            label: const Text('Download History'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 54),
              foregroundColor: _historyNavy,
              side: const BorderSide(color: _historyLine),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: widget.onBack,
            child: const Text('Back to Access Hub'),
          ),
        ],
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
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
      color: selected ? _historySoftGold : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(color: selected ? _historyGold : _historyLine),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: selected ? _historyNavy : _historyMuted,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
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

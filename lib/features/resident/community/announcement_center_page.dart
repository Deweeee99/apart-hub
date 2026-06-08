import 'package:flutter/material.dart';

import '../../../core/data/demo_data.dart';
import '../../../core/models/app_models.dart';
import '../../../core/services/local_notification_service.dart';
import '../../../core/widgets/luxury_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/white_premium_card.dart';

const _bg = Color(0xFFFAF8F2);
const _navy = Color(0xFF071B34);
const _gold = Color(0xFFC08A1A);
const _softGold = Color(0xFFFFF6DF);
const _muted = Color(0xFF687184);
const _line = Color(0xFFE7DFD1);

class AnnouncementCenterPage extends StatefulWidget {
  const AnnouncementCenterPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<AnnouncementCenterPage> createState() => _AnnouncementCenterPageState();
}

class _AnnouncementCenterPageState extends State<AnnouncementCenterPage> {
  var _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final items = DemoData.communityAnnouncements.where((item) {
      if (_filter == 'All') return true;
      if (_filter == 'Important') return item.priority == 'Important';
      return item.category == _filter;
    }).toList();

    return _Surface(
      child: ListView(
        key: const ValueKey('announcement-center'),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        children: [
          _SubHeader(
            icon: Icons.campaign_outlined,
            title: 'Announcement Center',
            subtitle: 'Get the latest updates from management office',
            onBack: widget.onBack,
          ),
          const SizedBox(height: 14),
          _FilterChips(
            values: const ['All', 'Important', 'General', 'Maintenance'],
            selected: _filter,
            onSelected: (value) => setState(() => _filter = value),
          ),
          const SizedBox(height: 14),
          for (final item in items)
            _AnnouncementCard(
              item: item,
              onTap: () => _showAnnouncementDetail(item),
            ),
          const SizedBox(height: 4),
          LuxuryButton(
            label: 'Send Test Notification',
            icon: Icons.notifications_active_outlined,
            onPressed: _sendNotificationPreview,
          ),
        ],
      ),
    );
  }

  Future<void> _sendNotificationPreview() async {
    final shown = await LocalNotificationService.showAnnouncementPreview();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          shown
              ? 'Notification preview sent.'
              : 'Notification preview simulated.',
        ),
      ),
    );
  }

  void _showAnnouncementDetail(CommunityAnnouncementItem item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DetailSheet(
        title: item.title,
        rows: [
          ('Category', item.category),
          ('Date', item.date),
          ('Priority', item.priority),
          ('Office', 'Management Office'),
          ('Affected area', item.affectedArea),
        ],
        message: item.fullMessage,
        actionNote: item.actionNote,
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({required this.item, required this.onTap});

  final CommunityAnnouncementItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GoldIcon(icon: _iconFor(item.iconType), size: 46),
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
                        item.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: _navy,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(status: item.priority),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  item.message,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: _muted, height: 1.35),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      item.date,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    StatusBadge(status: item.category),
                    const SizedBox(width: 6),
                    const Icon(Icons.chevron_right, color: _gold, size: 18),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

IconData _iconFor(String type) {
  return switch (type) {
    'water' => Icons.water_drop_outlined,
    'pool' => Icons.pool_outlined,
    'fire' => Icons.local_fire_department_outlined,
    'cleaning' => Icons.cleaning_services_outlined,
    'event' => Icons.event_outlined,
    _ => Icons.construction_outlined,
  };
}

class _DetailSheet extends StatelessWidget {
  const _DetailSheet({
    required this.title,
    required this.rows,
    required this.message,
    required this.actionNote,
  });

  final String title;
  final List<(String, String)> rows;
  final String message;
  final String actionNote;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: WhitePremiumCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: _navy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(message, style: const TextStyle(color: _muted, height: 1.4)),
              const SizedBox(height: 14),
              for (final row in rows) _InfoRow(label: row.$1, value: row.$2),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _softGold,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _gold.withValues(alpha: 0.22)),
                ),
                child: Text(
                  actionNote,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _navy,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubHeader extends StatelessWidget {
  const _SubHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: _navy),
          ),
          _GoldIcon(icon: icon, size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _navy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: _muted, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.values,
    required this.selected,
    required this.onSelected,
  });

  final List<String> values;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final value = values[index];
          final active = selected == value;
          return ActionChip(
            label: Text(value),
            onPressed: () => onSelected(value),
            backgroundColor: active ? _softGold : Colors.white,
            side: BorderSide(color: active ? _gold : _line),
            labelStyle: TextStyle(
              color: active ? _navy : _muted,
              fontWeight: active ? FontWeight.w900 : FontWeight.w700,
            ),
          );
        },
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: _muted)),
          ),
          Text(
            value,
            style: const TextStyle(color: _navy, fontWeight: FontWeight.w900),
          ),
        ],
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
        color: _softGold,
        borderRadius: BorderRadius.circular(size * 0.34),
        border: Border.all(color: _gold.withValues(alpha: 0.32)),
      ),
      child: Icon(icon, color: _gold, size: size * 0.54),
    );
  }
}

class _Surface extends StatelessWidget {
  const _Surface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(
          context,
        ).textTheme.apply(bodyColor: _navy, displayColor: _navy),
      ),
      child: ColoredBox(color: _bg, child: child),
    );
  }
}

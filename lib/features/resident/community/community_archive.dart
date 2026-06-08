import 'package:flutter/material.dart';

import '../../../core/data/demo_data.dart';
import '../../../core/models/app_models.dart';
import '../../../core/widgets/luxury_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/white_premium_card.dart';

const _bg = Color(0xFFFAF8F2);
const _navy = Color(0xFF071B34);
const _gold = Color(0xFFC08A1A);
const _softGold = Color(0xFFFFF6DF);
const _muted = Color(0xFF687184);
const _line = Color(0xFFE7DFD1);

class CommunityArchivePage extends StatefulWidget {
  const CommunityArchivePage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<CommunityArchivePage> createState() => _CommunityArchivePageState();
}

class _CommunityArchivePageState extends State<CommunityArchivePage> {
  var _filter = 'Announcements';

  @override
  Widget build(BuildContext context) {
    final archives = DemoData.communityArchive
        .where((item) => item.category == _filter)
        .toList();

    return _Surface(
      child: ListView(
        key: const ValueKey('community-archive'),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        children: [
          _SubHeader(
            icon: Icons.folder_copy_outlined,
            title: 'Community Archive',
            subtitle:
                'Access past announcements, events, and forum discussions',
            onBack: widget.onBack,
          ),
          const SizedBox(height: 14),
          _FilterChips(
            values: const ['Announcements', 'Events', 'Forum'],
            selected: _filter,
            onSelected: (value) => setState(() => _filter = value),
          ),
          const SizedBox(height: 14),
          for (final item in archives)
            _ArchiveCard(item: item, onTap: () => _showDetail(item)),
          if (archives.isEmpty)
            const WhitePremiumCard(
              child: Text(
                'Archive records for this category will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted),
              ),
            ),
          const SizedBox(height: 4),
          LuxuryButton(
            label: 'View All Archive',
            icon: Icons.download_outlined,
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Community archive prepared.')),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetail(CommunityArchiveItem item) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: WhitePremiumCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.summary,
                  style: const TextStyle(color: _muted, height: 1.4),
                ),
                const SizedBox(height: 14),
                _InfoRow(label: 'Category', value: item.category),
                _InfoRow(label: 'Date', value: item.date),
                const SizedBox(height: 12),
                LuxuryButton(
                  label: 'Close',
                  icon: Icons.check_outlined,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArchiveCard extends StatelessWidget {
  const _ArchiveCard({required this.item, required this.onTap});

  final CommunityArchiveItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Row(
        children: [
          _GoldIcon(icon: _iconFor(item.iconType), size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: _navy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.date} - ${item.summary}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, height: 1.3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          StatusBadge(status: item.category),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: _gold),
        ],
      ),
    );
  }
}

IconData _iconFor(String type) {
  return switch (type) {
    'fire' => Icons.local_fire_department_outlined,
    'gym' => Icons.fitness_center_outlined,
    'ramadan' => Icons.nightlight_round_outlined,
    'health' => Icons.volunteer_activism_outlined,
    'cleaning' => Icons.cleaning_services_outlined,
    _ => Icons.folder_copy_outlined,
  };
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
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: _muted, height: 1.35),
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

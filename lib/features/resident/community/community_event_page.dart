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

class CommunityEventPage extends StatefulWidget {
  const CommunityEventPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<CommunityEventPage> createState() => _CommunityEventPageState();
}

class _CommunityEventPageState extends State<CommunityEventPage> {
  var _filter = 'Upcoming';

  @override
  Widget build(BuildContext context) {
    final events = DemoData.communityEvents
        .where((event) => event.status == _filter)
        .toList();

    return _Surface(
      child: ListView(
        key: const ValueKey('community-events'),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        children: [
          _SubHeader(
            icon: Icons.event_available_outlined,
            title: 'Community Events',
            subtitle: 'See upcoming community events and activities',
            onBack: widget.onBack,
          ),
          const SizedBox(height: 14),
          _FilterChips(
            values: const ['Upcoming', 'Ongoing', 'Past'],
            selected: _filter,
            onSelected: (value) => setState(() => _filter = value),
          ),
          const SizedBox(height: 14),
          for (final event in events)
            _EventCard(event: event, onDetails: () => _showEventDetail(event)),
          if (events.isEmpty)
            const _EmptyState(
              icon: Icons.event_busy_outlined,
              title: 'No events found',
              subtitle: 'Try another event status to explore more activities.',
            ),
        ],
      ),
    );
  }

  void _showEventDetail(CommunityEventItem event) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
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
                  event.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: _navy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event.description,
                  style: const TextStyle(color: _muted, height: 1.4),
                ),
                const SizedBox(height: 14),
                _InfoRow(
                  label: 'Date & time',
                  value: '${event.date}, ${event.time}',
                ),
                _InfoRow(label: 'Location', value: event.location),
                _InfoRow(label: 'Host', value: event.host),
                _InfoRow(label: 'Capacity', value: event.capacity),
                _InfoRow(label: 'Status', value: event.status),
                const SizedBox(height: 12),
                LuxuryButton(
                  label: 'Register Interest',
                  icon: Icons.how_to_reg_outlined,
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Interest registered for ${event.title}.',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event, required this.onDetails});

  final CommunityEventItem event;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: _softGold,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _gold.withValues(alpha: 0.25)),
            ),
            child: Icon(_iconFor(event.iconType), color: _gold, size: 34),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: _navy,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    StatusBadge(status: event.status),
                  ],
                ),
                const SizedBox(height: 8),
                _SmallMeta(
                  icon: Icons.calendar_today_outlined,
                  text: event.date,
                ),
                _SmallMeta(icon: Icons.schedule_outlined, text: event.time),
                _SmallMeta(
                  icon: Icons.location_on_outlined,
                  text: event.location,
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: onDetails,
                  child: const Text('View Details'),
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
    'wellness' => Icons.self_improvement_outlined,
    'gathering' => Icons.groups_outlined,
    'kids' => Icons.child_care_outlined,
    'health' => Icons.volunteer_activism_outlined,
    'ramadan' => Icons.nightlight_round_outlined,
    _ => Icons.event_outlined,
  };
}

class _SmallMeta extends StatelessWidget {
  const _SmallMeta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 15, color: _muted),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: _muted, height: 1.2),
            ),
          ),
        ],
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
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: _navy, fontWeight: FontWeight.w900),
            ),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      child: Column(
        children: [
          _GoldIcon(icon: icon, size: 48),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(color: _navy, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _muted, height: 1.35),
          ),
        ],
      ),
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

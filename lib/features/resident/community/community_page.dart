import 'package:flutter/material.dart';

import '../../../core/widgets/white_premium_card.dart';
import 'announcement_center_page.dart';
import 'community_archive.dart';
import 'community_event_page.dart';
import 'community_resident_forum.dart';

const _communityBackground = Color(0xFFFAF8F2);
const _communityNavy = Color(0xFF071B34);
const _communityGold = Color(0xFFC08A1A);
const _communitySoftGold = Color(0xFFFFF6DF);
const _communityMuted = Color(0xFF687184);

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  String? _activeCommunityPage;

  @override
  Widget build(BuildContext context) {
    return switch (_activeCommunityPage) {
      'announcement' => AnnouncementCenterPage(onBack: _backToHub),
      'events' => CommunityEventPage(onBack: _backToHub),
      'forum' => CommunityResidentForumPage(onBack: _backToHub),
      'archive' => CommunityArchivePage(onBack: _backToHub),
      _ => _CommunitySurface(
        child: ListView(
          key: const ValueKey('community-hub'),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _CommunityMenuCard(
              icon: Icons.campaign_outlined,
              title: 'Announcement Center',
              subtitle: 'Official updates from management',
              description:
                  'Read notices, maintenance updates, and important information.',
              cta: 'Open Announcements',
              onTap: () => _openPage('announcement'),
            ),
            _CommunityMenuCard(
              icon: Icons.event_available_outlined,
              title: 'Community Events',
              subtitle: 'Upcoming resident activities',
              description:
                  'Explore events, schedules, and shared community activities.',
              cta: 'View Events',
              onTap: () => _openPage('events'),
            ),
            _CommunityMenuCard(
              icon: Icons.chat_bubble_outline,
              title: 'Resident Forum',
              subtitle: 'Connect with your neighbors',
              description: 'Ask questions, share updates, and help each other.',
              cta: 'Open Forum',
              onTap: () => _openPage('forum'),
            ),
            _CommunityMenuCard(
              icon: Icons.folder_copy_outlined,
              title: 'Community Archive',
              subtitle: 'Past updates and discussions',
              description:
                  'Access old announcements, events, and forum discussions.',
              cta: 'View Archive',
              onTap: () => _openPage('archive'),
            ),
          ],
        ),
      ),
    };
  }

  Widget _buildHeader() {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const _GoldIcon(icon: Icons.forum_outlined, size: 50),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Community Hub',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: _communityNavy,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Stay connected, informed, and engaged with your community',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _communityMuted,
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

  void _openPage(String page) {
    setState(() => _activeCommunityPage = page);
  }

  void _backToHub() {
    setState(() => _activeCommunityPage = null);
  }
}

class _CommunitySurface extends StatelessWidget {
  const _CommunitySurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    return Theme(
      data: base.copyWith(
        textTheme: base.textTheme.apply(
          bodyColor: _communityNavy,
          displayColor: _communityNavy,
        ),
      ),
      child: ColoredBox(color: _communityBackground, child: child),
    );
  }
}

class _CommunityMenuCard extends StatelessWidget {
  const _CommunityMenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.cta,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final String cta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _GoldIcon(icon: icon, size: 48),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _communityNavy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _communityGold,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: _communityGold),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _communityMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _communitySoftGold,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: _communityGold.withValues(alpha: 0.24)),
            ),
            child: Text(
              cta,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: _communityNavy,
                fontWeight: FontWeight.w900,
              ),
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
        color: _communitySoftGold,
        borderRadius: BorderRadius.circular(size * 0.34),
        border: Border.all(color: _communityGold.withValues(alpha: 0.32)),
      ),
      child: Icon(icon, color: _communityGold, size: size * 0.54),
    );
  }
}

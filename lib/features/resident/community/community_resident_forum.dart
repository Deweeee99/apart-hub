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

class CommunityResidentForumPage extends StatefulWidget {
  const CommunityResidentForumPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<CommunityResidentForumPage> createState() =>
      _CommunityResidentForumPageState();
}

class _CommunityResidentForumPageState
    extends State<CommunityResidentForumPage> {
  var _filter = 'All';
  late var _posts = DemoData.communityPosts.toList();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  var _newPostCategory = 'General';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final posts = _posts.where((post) {
      if (_filter == 'All') return true;
      if (_filter == 'General') return post.category == 'Forum';
      return post.category == _filter;
    }).toList();

    return _Surface(
      child: ListView(
        key: const ValueKey('resident-forum'),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        children: [
          _SubHeader(
            icon: Icons.chat_bubble_outline,
            title: 'Resident Forum',
            subtitle: 'Connect, ask questions, share, and help each other',
            onBack: widget.onBack,
          ),
          const SizedBox(height: 14),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'Search in forum...',
              prefixIcon: const Icon(Icons.search, color: _muted),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: _line),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: _line),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _FilterChips(
            values: const ['All', 'General', 'Lost & Found', 'Marketplace'],
            selected: _filter,
            onSelected: (value) => setState(() => _filter = value),
          ),
          const SizedBox(height: 14),
          for (final post in posts)
            _ForumPostCard(
              post: post,
              onLike: () => _snack('Liked ${post.title}.'),
              onReply: () => _showReplySheet(post),
              onDetail: () => _showPostDetail(post),
            ),
          const SizedBox(height: 4),
          LuxuryButton(
            label: 'New Post',
            icon: Icons.add_comment_outlined,
            onPressed: _showNewPostSheet,
          ),
        ],
      ),
    );
  }

  void _showPostDetail(CommunityPost post) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _SimpleSheet(
        title: post.title,
        message: '${post.author} - ${post.description}',
        actionLabel: 'Close',
      ),
    );
  }

  void _showReplySheet(CommunityPost post) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _SimpleSheet(
        title: 'Reply to ${post.author}',
        message: 'Reply composer simulated for "${post.title}".',
        actionLabel: 'Send Reply',
        onAction: () => _snack('Reply sent to ${post.author}.'),
      ),
    );
  }

  void _showNewPostSheet() {
    _titleController.text = 'New community update';
    _descriptionController.text = 'Share a helpful note with neighbors.';
    _newPostCategory = 'General';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: WhitePremiumCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'New Post',
                        style: TextStyle(
                          color: _navy,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: _newPostCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
                        items: const ['General', 'Lost & Found', 'Marketplace']
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => setSheetState(
                          () => _newPostCategory = value ?? _newPostCategory,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _descriptionController,
                        minLines: 3,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                      ),
                      const SizedBox(height: 14),
                      LuxuryButton(
                        label: 'Submit',
                        icon: Icons.send_outlined,
                        onPressed: () {
                          final category = _newPostCategory == 'General'
                              ? 'Forum'
                              : _newPostCategory;
                          setState(() {
                            _posts = [
                              CommunityPost(
                                title: _titleController.text,
                                category: category,
                                author: 'Jonathan Wijaya',
                                description: _descriptionController.text,
                              ),
                              ..._posts,
                            ];
                          });
                          Navigator.of(context).pop();
                          _snack('New post published.');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ForumPostCard extends StatelessWidget {
  const _ForumPostCard({
    required this.post,
    required this.onLike,
    required this.onReply,
    required this.onDetail,
  });

  final CommunityPost post;
  final VoidCallback onLike;
  final VoidCallback onReply;
  final VoidCallback onDetail;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _GoldIcon(icon: _iconFor(post.category), size: 42),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: _navy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text('2h ago', style: TextStyle(color: _muted)),
                  ],
                ),
              ),
              StatusBadge(
                status: post.category == 'Forum' ? 'General' : post.category,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            post.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: _navy,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            post.description,
            style: const TextStyle(color: _muted, height: 1.38),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _SmallAction(
                icon: Icons.favorite_border,
                label: '24',
                onTap: onLike,
              ),
              _SmallAction(
                icon: Icons.chat_bubble_outline,
                label: '12',
                onTap: onReply,
              ),
              _SmallAction(
                icon: Icons.visibility_outlined,
                label: 'Detail',
                onTap: onDetail,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

IconData _iconFor(String category) {
  return switch (category) {
    'Marketplace' => Icons.sell_outlined,
    'Lost & Found' => Icons.manage_search_outlined,
    'Events' => Icons.celebration_outlined,
    _ => Icons.chat_bubble_outline,
  };
}

class _SmallAction extends StatelessWidget {
  const _SmallAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: _softGold,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: _gold.withValues(alpha: 0.22)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: _gold),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(color: _navy, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleSheet extends StatelessWidget {
  const _SimpleSheet({
    required this.title,
    required this.message,
    required this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback? onAction;

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
                style: const TextStyle(
                  color: _navy,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(message, style: const TextStyle(color: _muted, height: 1.4)),
              const SizedBox(height: 16),
              LuxuryButton(
                label: actionLabel,
                icon: Icons.check_outlined,
                onPressed: () {
                  Navigator.of(context).pop();
                  onAction?.call();
                },
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

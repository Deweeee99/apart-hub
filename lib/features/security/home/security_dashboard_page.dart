import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/white_premium_card.dart';

const _surface = Color(0xFFF8F5EF);
const _navy = Color(0xFF071B34);
const _blue = Color(0xFF173A67);
const _gold = Color(0xFFC08A1A);
const _softGold = Color(0xFFFFF6DF);
const _muted = Color(0xFF687184);
const _line = Color(0xFFE7DFD1);
const _softRed = Color(0xFFFFF4F2);

class SecurityDashboardPage extends StatelessWidget {
  const SecurityDashboardPage({super.key, required this.onNavigate});

  final Function(int) onNavigate;

  @override
  Widget build(BuildContext context) {
    const metrics = [
      _SecurityMetricData(
        icon: Icons.groups_2_outlined,
        iconColor: Color(0xFF8EA7C9),
        iconBackground: Color(0xFFF4F7FC),
        value: '24',
        label: 'Visitors Today',
        caption: 'Checked-in',
        footer: '+12% today',
        footerColor: AppColors.success,
      ),
      _SecurityMetricData(
        icon: Icons.person_search_outlined,
        iconColor: Color(0xFFD6941E),
        iconBackground: Color(0xFFFFF7E8),
        value: '5',
        label: 'Pending Verification',
        caption: 'Approval queue',
        footer: 'Action needed',
        footerColor: Color(0xFFD6941E),
      ),
      _SecurityMetricData(
        icon: Icons.shield_outlined,
        iconColor: AppColors.success,
        iconBackground: Color(0xFFF0F9F1),
        value: '68%',
        label: 'Patrol Progress',
        caption: '3/5 checkpoints',
        footer: 'On schedule',
        footerColor: AppColors.success,
        progress: 0.68,
      ),
      _SecurityMetricData(
        icon: Icons.description_outlined,
        iconColor: AppColors.danger,
        iconBackground: Color(0xFFFFF1F1),
        value: '2',
        label: 'Open Incidents',
        caption: 'Needs review',
        footer: 'Follow-up',
        footerColor: AppColors.danger,
      ),
      _SecurityMetricData(
        icon: Icons.notifications_active_outlined,
        iconColor: AppColors.danger,
        iconBackground: Color(0xFFFFF1F1),
        value: '1',
        label: 'Active Emergency',
        caption: 'High priority',
        footer: 'Respond',
        footerColor: AppColors.danger,
      ),
    ];

    const quickActions = [
      _QuickActionData(
        icon: Icons.qr_code_scanner_outlined,
        label: 'Access Scanner',
        index: 1,
      ),
      _QuickActionData(icon: Icons.shield_outlined, label: 'Patrol', index: 2),
      _QuickActionData(
        icon: Icons.edit_document,
        label: 'Incident Report',
        index: 3,
      ),
      _QuickActionData(
        icon: Icons.calendar_month_outlined,
        label: 'Attendance',
      ),
      _QuickActionData(
        icon: Icons.notifications_active_outlined,
        label: 'Emergency',
        index: 4,
        emergency: true,
      ),
    ];

    const tasks = [
      _TaskData(
        icon: Icons.person_search_outlined,
        iconColor: Color(0xFF8EA7C9),
        iconBackground: Color(0xFFF4F7FC),
        title: 'Verify Visitor - Mr. Andi Saputra',
        subtitle: 'Expected at Main Lobby',
        dueLabel: 'Due in 15 min',
        targetIndex: 1,
      ),
      _TaskData(
        icon: Icons.shield_outlined,
        iconColor: AppColors.success,
        iconBackground: Color(0xFFF0F9F1),
        title: 'Patrol Checkpoint - Basement B1',
        subtitle: 'Routine patrol',
        dueLabel: 'Due in 45 min',
        targetIndex: 2,
      ),
      _TaskData(
        icon: Icons.description_outlined,
        iconColor: Color(0xFFD6941E),
        iconBackground: Color(0xFFFFF7E8),
        title: 'Incident Follow-up - Unit 18-08',
        subtitle: 'Lost item report',
        dueLabel: 'Due in 2 hrs',
        targetIndex: 3,
      ),
    ];

    void showAttendancePreview() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance flow will be added later.')),
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(
          context,
        ).textTheme.apply(bodyColor: _navy, displayColor: _navy),
      ),
      child: ColoredBox(
        color: _surface,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 390;
            final horizontalPadding = isCompact ? 20.0 : 24.0;
            final metricCardWidth = isCompact ? 154.0 : 160.0;
            final metricListHeight = isCompact ? 218.0 : 210.0;

            return ListView(
              key: const ValueKey('security-dashboard'),
              padding: const EdgeInsets.only(bottom: 144),
              children: [
                _SecurityHeroStack(
                  isCompact: isCompact,
                  horizontalPadding: horizontalPadding,
                  onEmergency: () => onNavigate(4),
                  onLogout: () => context.go('/login'),
                  onAttendancePreview: showAttendancePreview,
                ).animate().fadeIn(duration: 420.ms).moveY(begin: 16, end: 0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      const SizedBox(height: 18),
                      const _SectionTitle(title: 'Quick Actions'),
                      const SizedBox(height: 10),
                      _QuickActionGrid(
                        isCompact: isCompact,
                        actions: quickActions,
                        onTap: (action) {
                          if (action.index == null) {
                            showAttendancePreview();
                            return;
                          }
                          onNavigate(action.index!);
                        },
                      ),
                      const SizedBox(height: 18),
                      const _SectionTitle(
                        title: 'Operational Overview',
                        actionLabel: 'View All',
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: metricListHeight,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          padding: EdgeInsets.zero,
                          itemCount: metrics.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 12),
                          itemBuilder: (context, index) => SizedBox(
                            width: metricCardWidth,
                            child: _MetricCard(data: metrics[index]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      const _SectionTitle(
                        title: "Today's Tasks",
                        actionLabel: 'View All',
                      ),
                      const SizedBox(height: 10),
                      WhitePremiumCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Column(
                          children: [
                            for (var i = 0; i < tasks.length; i++) ...[
                              _TaskTile(
                                task: tasks[i],
                                onTap: () => onNavigate(tasks[i].targetIndex),
                              ),
                              if (i != tasks.length - 1)
                                Divider(
                                  height: 1,
                                  color: _line.withValues(alpha: 0.82),
                                ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: _PriorityAlertCard(
                    isCompact: isCompact,
                    onRespond: () => onNavigate(4),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SecurityHeroStack extends StatelessWidget {
  const _SecurityHeroStack({
    required this.isCompact,
    required this.horizontalPadding,
    required this.onEmergency,
    required this.onLogout,
    required this.onAttendancePreview,
  });

  final bool isCompact;
  final double horizontalPadding;
  final VoidCallback onEmergency;
  final VoidCallback onLogout;
  final VoidCallback onAttendancePreview;

  @override
  Widget build(BuildContext context) {
    final heroBaseHeight = isCompact ? 318.0 : 304.0;
    final transitionHeight = isCompact ? 76.0 : 70.0;
    final shiftCardHeight = isCompact ? 108.0 : 104.0;
    final cardOverlap = isCompact ? 56.0 : 58.0;
    final stackHeight = heroBaseHeight + shiftCardHeight - cardOverlap + 12.0;

    return SizedBox(
      height: stackHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: heroBaseHeight,
            child: _SecurityHeroHeader(
              isCompact: isCompact,
              onEmergency: onEmergency,
              onLogout: onLogout,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: heroBaseHeight - transitionHeight,
            height: transitionHeight + 20,
            child: const IgnorePointer(child: _SecurityHeroFadeTransition()),
          ),
          Positioned(
            left: horizontalPadding,
            right: horizontalPadding,
            top: heroBaseHeight - cardOverlap,
            child: _ShiftStatusCard(
              isCompact: isCompact,
              onTap: onAttendancePreview,
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityHeroHeader extends StatelessWidget {
  const _SecurityHeroHeader({
    required this.isCompact,
    required this.onEmergency,
    required this.onLogout,
  });

  final bool isCompact;
  final VoidCallback onEmergency;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = isCompact ? 22.0 : 24.0;
    final topPadding = isCompact ? 18.0 : 22.0;
    final heroHeight = isCompact ? 318.0 : 304.0;
    final officerFont = isCompact ? 32.0 : 34.0;

    return Container(
      width: double.infinity,
      height: heroHeight,
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        topPadding,
        horizontalPadding,
        isCompact ? 68.0 : 66.0,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, _blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -14,
            right: -18,
            child: Container(
              width: 138,
              height: 138,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.12),
                    Colors.white.withValues(alpha: 0.01),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 66,
            child: Container(
              width: 164,
              height: 82,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(120),
                gradient: LinearGradient(
                  colors: [
                    _gold.withValues(alpha: 0.08),
                    Colors.white.withValues(alpha: 0.01),
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Apart Hub',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Security Command',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: _gold,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2,
                              ),
                        ),
                      ],
                    ),
                  ),
                  _HeroIconButton(
                    compact: isCompact,
                    icon: Icons.notifications_none_outlined,
                    badge: '3',
                    onTap: () {},
                  ),
                  SizedBox(width: isCompact ? 8 : 10),
                  _HeroSosButton(compact: isCompact, onTap: onEmergency),
                  SizedBox(width: isCompact ? 8 : 10),
                  _HeroIconButton(
                    compact: isCompact,
                    icon: Icons.exit_to_app_outlined,
                    onTap: onLogout,
                  ),
                ],
              ),
              SizedBox(height: isCompact ? 14 : 16),
              Text(
                'Good Evening,',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontWeight: FontWeight.w400,
                  fontSize: isCompact ? 21 : 22,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Officer Budi',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: const Color(0xFFFFD98A),
                        fontWeight: FontWeight.w900,
                        height: 0.96,
                        fontSize: officerFont,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: _gold.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified_user_outlined,
                      color: Color(0xFFFFD98A),
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: const [
                  _HeroBadge(
                    icon: Icons.wb_sunny_outlined,
                    text: 'Morning Shift',
                  ),
                  _HeroBadge(icon: Icons.location_on_outlined, text: 'Tower A'),
                  _HeroBadge(
                    icon: Icons.verified_outlined,
                    text: 'On Duty',
                    green: true,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SecurityHeroFadeTransition extends StatelessWidget {
  const _SecurityHeroFadeTransition();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            _navy.withValues(alpha: 0.08),
            _surface.withValues(alpha: 0.42),
            _surface,
          ],
          stops: const [0.0, 0.34, 0.72, 1.0],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.data});

  final _SecurityMetricData data;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: data.iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, color: data.iconColor, size: 18),
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              data.value,
              maxLines: 1,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: _navy,
                fontWeight: FontWeight.w900,
                fontSize: 28,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _navy,
              fontWeight: FontWeight.w700,
              height: 1.2,
              fontSize: 14.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            data.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _muted,
              height: 1.25,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          if (data.progress != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: data.progress,
                minHeight: 4,
                backgroundColor: _line,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.success,
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
          Text(
            data.footer,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: data.footerColor,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionGrid extends StatelessWidget {
  const _QuickActionGrid({
    required this.isCompact,
    required this.actions,
    required this.onTap,
  });

  final bool isCompact;
  final List<_QuickActionData> actions;
  final ValueChanged<_QuickActionData> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: isCompact ? 132 : 128,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];
            return WhitePremiumCard(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              onTap: () => onTap(action),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: action.emergency
                          ? AppColors.danger.withValues(alpha: 0.08)
                          : _softGold,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: action.emergency
                            ? AppColors.danger.withValues(alpha: 0.18)
                            : _gold.withValues(alpha: 0.24),
                      ),
                    ),
                    child: Icon(
                      action.icon,
                      color: action.emergency ? AppColors.danger : _navy,
                      size: 19,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _navy,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _PriorityAlertCard extends StatelessWidget {
  const _PriorityAlertCard({required this.isCompact, required this.onRespond});

  final bool isCompact;
  final VoidCallback onRespond;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _softRed,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.danger.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -12,
            child: Icon(
              Icons.notifications_active_outlined,
              size: 100,
              color: AppColors.danger.withValues(alpha: 0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.priority_high_outlined,
                    color: AppColors.danger,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Priority Alert',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  const StatusBadge(status: 'High Priority'),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Active Emergency',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: _navy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Unit A-1808 - Medical Assistance',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _navy,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tower A, 18th Floor',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: _muted),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: isCompact ? double.infinity : 168,
                child: ElevatedButton(
                  onPressed: onRespond,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.danger,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'View & Respond',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShiftStatusCard extends StatelessWidget {
  const _ShiftStatusCard({required this.isCompact, required this.onTap});

  final bool isCompact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.10),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: WhitePremiumCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.badge_outlined,
                color: AppColors.success,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Shift Status',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _navy,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Clock In 06:58 AM',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: _muted),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '07:00 AM - 03:00 PM  |  On Duty',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                foregroundColor: _gold,
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 10 : 14,
                  vertical: 10,
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
              ),
              child: const Text(
                'Attendance',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task, required this.onTap});

  final _TaskData task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: task.iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(task.icon, color: task.iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _navy,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    task.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: _muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  task.dueLabel,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF1D63E6),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: _line),
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    color: _gold,
                    size: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.actionLabel});

  final String title;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: _navy,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (actionLabel != null)
          Text(
            actionLabel!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _gold,
              fontWeight: FontWeight.w800,
            ),
          ),
      ],
    );
  }
}

class _HeroIconButton extends StatelessWidget {
  const _HeroIconButton({
    required this.compact,
    required this.icon,
    required this.onTap,
    this.badge,
  });

  final bool compact;
  final IconData icon;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            width: compact ? 50 : 54,
            height: compact ? 50 : 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            ),
            child: Icon(icon, color: Colors.white, size: compact ? 22 : 24),
          ),
        ),
        if (badge != null)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _gold,
                shape: BoxShape.circle,
                border: Border.all(color: _navy, width: 2),
              ),
              child: Text(
                badge!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _HeroSosButton extends StatelessWidget {
  const _HeroSosButton({required this.compact, required this.onTap});

  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: compact ? 68 : 72,
        height: compact ? 50 : 54,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.danger.withValues(alpha: 0.92),
              const Color(0xFF9F1F1B),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.danger.withValues(alpha: 0.28),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          'SOS',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: compact ? 17 : 18,
          ),
        ),
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({
    required this.icon,
    required this.text,
    this.green = false,
  });

  final IconData icon;
  final String text;
  final bool green;

  @override
  Widget build(BuildContext context) {
    final iconColor = green ? AppColors.success : const Color(0xFFFFD98A);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 13),
          const SizedBox(width: 6),
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.94),
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityMetricData {
  const _SecurityMetricData({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.value,
    required this.label,
    required this.caption,
    required this.footer,
    required this.footerColor,
    this.progress,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String value;
  final String label;
  final String caption;
  final String footer;
  final Color footerColor;
  final double? progress;
}

class _QuickActionData {
  const _QuickActionData({
    required this.icon,
    required this.label,
    this.index,
    this.emergency = false,
  });

  final IconData icon;
  final String label;
  final int? index;
  final bool emergency;
}

class _TaskData {
  const _TaskData({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.dueLabel,
    required this.targetIndex,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final String dueLabel;
  final int targetIndex;
}

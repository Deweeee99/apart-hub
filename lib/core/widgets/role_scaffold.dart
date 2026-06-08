import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import 'luxury_background.dart';

class RoleNavItem {
  const RoleNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class RoleScaffold extends StatelessWidget {
  const RoleScaffold({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.items,
    required this.child,
    required this.roleLabel,
    this.compactHeader = false,
    this.showHeader = true,
  });

  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final List<RoleNavItem> items;
  final Widget child;
  final String roleLabel;
  final bool compactHeader;
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    final titleStyle = compactHeader
        ? Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)
        : null;
    final subtitleStyle = compactHeader
        ? Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.softGold,
            fontWeight: FontWeight.w700,
          )
        : Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.softGold);

    return LuxuryBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: showHeader
            ? AppBar(
                toolbarHeight: compactHeader ? 64 : null,
                titleSpacing: 20,
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Apart Hub', style: titleStyle),
                    Text(roleLabel, style: subtitleStyle),
                  ],
                ),
                actions: [
                  IconButton(
                    tooltip: 'logout',
                    onPressed: () => context.go('/login'),
                    icon: const Icon(
                      Icons.exit_to_app_outlined,
                      color: AppColors.softGold,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              )
            : null,
        body: SafeArea(top: false, child: child),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onIndexChanged,
              items: [
                for (var i = 0; i < items.length; i++)
                  BottomNavigationBarItem(
                    icon: Icon(
                      currentIndex == i ? items[i].selectedIcon : items[i].icon,
                    ),
                    label: items[i].label,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

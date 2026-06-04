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
  });

  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final List<RoleNavItem> items;
  final Widget child;
  final String roleLabel;

  @override
  Widget build(BuildContext context) {
    return LuxuryBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          titleSpacing: 20,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Apartemen Meikarta'),
              Text(
                roleLabel,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.softGold),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Switch role',
              onPressed: () => context.go('/roles'),
              icon: const Icon(
                Icons.swap_horiz_outlined,
                color: AppColors.softGold,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
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

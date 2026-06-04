import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/management/management_shell.dart';
import 'features/resident/resident_shell.dart';
import 'features/role_selection/role_selection_screen.dart';
import 'features/role_selection/splash_screen.dart';
import 'features/security/security_shell.dart';
import 'features/tenant/tenant_shell.dart';

class AureliaApp extends StatelessWidget {
  const AureliaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
        GoRoute(
          path: '/roles',
          builder: (context, state) => const RoleSelectionScreen(),
        ),
        GoRoute(
          path: '/resident',
          builder: (context, state) => const ResidentShell(),
        ),
        GoRoute(
          path: '/management',
          builder: (context, state) => const ManagementShell(),
        ),
        GoRoute(
          path: '/security',
          builder: (context, state) => const SecurityShell(),
        ),
        GoRoute(
          path: '/tenant',
          builder: (context, state) => const TenantShell(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Apartemen Meikarta',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkLuxuryTheme,
      routerConfig: router,
    );
  }
}

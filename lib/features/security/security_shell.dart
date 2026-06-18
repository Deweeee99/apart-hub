import 'package:flutter/material.dart';

import '../../core/widgets/role_scaffold.dart';
import 'emergency/emergency_handling_page.dart';
import 'home/security_dashboard_page.dart';
import 'incident/incident_report_page.dart';
import 'patrol/patrol_management_page.dart';
import 'scanner/visitor_scanner_page.dart';

class SecurityShell extends StatefulWidget {
  const SecurityShell({super.key});

  @override
  State<SecurityShell> createState() => _SecurityShellState();
}

class _SecurityShellState extends State<SecurityShell> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      SecurityDashboardPage(
        onNavigate: (newIndex) {
          setState(() => _index = newIndex);
        },
      ),
      const VisitorScannerPage(),
      const PatrolManagementPage(),
      const IncidentReportPage(),
      const EmergencyHandlingPage(),
    ];

    return RoleScaffold(
      currentIndex: _index,
      onIndexChanged: (value) => setState(() => _index = value),
      roleLabel: 'Security',
      showHeader: false,
      items: const [
        RoleNavItem(
          label: 'Dashboard',
          icon: Icons.security_outlined,
          selectedIcon: Icons.security,
        ),
        RoleNavItem(
          label: 'Scanner',
          icon: Icons.qr_code_scanner_outlined,
          selectedIcon: Icons.qr_code_scanner,
        ),
        RoleNavItem(
          label: 'Patrol',
          icon: Icons.route_outlined,
          selectedIcon: Icons.route,
        ),
        RoleNavItem(
          label: 'Incident',
          icon: Icons.report_outlined,
          selectedIcon: Icons.report,
        ),
        RoleNavItem(
          label: 'Emergency',
          icon: Icons.sos_outlined,
          selectedIcon: Icons.sos,
        ),
      ],
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: pages[_index],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/widgets/role_scaffold.dart';
import 'access/digital_access_page.dart';
import 'billing_payment_page.dart';
import 'community/community_page.dart';
import 'home/resident_home_page.dart';
import 'services/resident_services_page.dart';

class ResidentShell extends StatefulWidget {
  const ResidentShell({super.key});

  @override
  State<ResidentShell> createState() => _ResidentShellState();
}

class _ResidentShellState extends State<ResidentShell> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      ResidentDashboardPage(
        onNavigate: (newIndex) {
          setState(() {
            _index = newIndex;
          });
        },
      ),
      const DigitalAccessPage(),
      const BillingPaymentPage(),
      const ResidentServicesPage(),
      const CommunityPage(),
    ];

    return RoleScaffold(
      currentIndex: _index,
      onIndexChanged: (value) => setState(() => _index = value),
      roleLabel: 'Resident App',
      items: const [
        RoleNavItem(
          label: 'Home',
          icon: Icons.home_outlined,
          selectedIcon: Icons.home,
        ),
        RoleNavItem(
          label: 'Access',
          icon: Icons.qr_code_2_outlined,
          selectedIcon: Icons.qr_code_2,
        ),
        RoleNavItem(
          label: 'Billing',
          icon: Icons.receipt_long_outlined,
          selectedIcon: Icons.receipt_long,
        ),
        RoleNavItem(
          label: 'Services',
          icon: Icons.handyman_outlined,
          selectedIcon: Icons.handyman,
        ),
        RoleNavItem(
          label: 'Community',
          icon: Icons.forum_outlined,
          selectedIcon: Icons.forum,
        ),
      ],
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: pages[_index],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/widgets/role_scaffold.dart';
import 'home/tenant_home_page.dart';
import 'orders/tenant_orders_page.dart';
import 'profile/tenant_profile_page.dart';
import 'promo/tenant_promo_page.dart';
import 'products/tenant_products_page.dart';

class TenantShell extends StatefulWidget {
  const TenantShell({super.key});

  @override
  State<TenantShell> createState() => _TenantShellState();
}

class _TenantShellState extends State<TenantShell> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      TenantDashboardPage(
        onNavigate: (newIndex) {
          setState(() => _index = newIndex);
        },
      ),
      const TenantProductsPage(),
      const TenantOrdersPage(),
      const TenantPromoPage(),
      const TenantProfilePage(),
    ];

    return RoleScaffold(
      currentIndex: _index,
      onIndexChanged: (value) => setState(() => _index = value),
      roleLabel: 'Tenant / Merchant',
      showHeader: false,
      items: const [
        RoleNavItem(
          label: 'Dashboard',
          icon: Icons.dashboard_outlined,
          selectedIcon: Icons.dashboard,
        ),
        RoleNavItem(
          label: 'Products',
          icon: Icons.inventory_2_outlined,
          selectedIcon: Icons.inventory_2,
        ),
        RoleNavItem(
          label: 'Orders',
          icon: Icons.shopping_bag_outlined,
          selectedIcon: Icons.shopping_bag,
        ),
        RoleNavItem(
          label: 'Promo',
          icon: Icons.local_offer_outlined,
          selectedIcon: Icons.local_offer,
        ),
        RoleNavItem(
          label: 'Profile',
          icon: Icons.storefront_outlined,
          selectedIcon: Icons.storefront,
        ),
      ],
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: pages[_index],
      ),
    );
  }
}

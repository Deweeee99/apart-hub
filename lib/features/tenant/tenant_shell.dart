import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/data/demo_data.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/luxury_button.dart';
import '../../core/widgets/metric_card.dart';
import '../../core/widgets/premium_list_tile.dart';
import '../../core/widgets/role_scaffold.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/status_badge.dart';

final _currency = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);
final _time = DateFormat('HH:mm', 'id_ID');

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
      const TenantDashboardPage(),
      const ProductServicePage(),
      const ResidentOrdersPage(),
      const PromoManagementPage(),
      const MerchantProfilePage(),
    ];

    return RoleScaffold(
      currentIndex: _index,
      onIndexChanged: (value) => setState(() => _index = value),
      roleLabel: 'Tenant / Merchant',
      items: const [
        RoleNavItem(
          label: 'Dashboard',
          icon: Icons.dashboard_outlined,
          selectedIcon: Icons.dashboard,
        ),
        RoleNavItem(
          label: 'Services',
          icon: Icons.room_service_outlined,
          selectedIcon: Icons.room_service,
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

class TenantDashboardPage extends StatelessWidget {
  const TenantDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final revenue = DemoData.merchantOrders.fold<int>(
      0,
      (total, order) => total + order.amount,
    );

    return ListView(
      key: const ValueKey('tenant-dashboard'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        GlassCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DemoData.tenant.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Resident-facing merchant workspace for services, orders, promos, and requests.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.storefront_outlined,
                color: AppColors.softGold,
                size: 42,
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'Merchant Metrics'),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.0,
          children: [
            const MetricCard(
              icon: Icons.shopping_bag_outlined,
              label: 'Orders Today',
              value: '18',
              caption: '6 new',
            ),
            const MetricCard(
              icon: Icons.local_offer_outlined,
              label: 'Promo Active',
              value: '3',
              caption: 'Laundry deals',
            ),
            MetricCard(
              icon: Icons.star_outline,
              label: 'Rating',
              value: DemoData.tenant.rating.toStringAsFixed(1),
              caption: 'Resident reviews',
            ),
            MetricCard(
              icon: Icons.payments_outlined,
              label: 'Revenue Month',
              value: _currency.format(revenue * 42),
              caption: 'Dummy forecast',
            ),
            const MetricCard(
              icon: Icons.support_agent_outlined,
              label: 'Customer Requests',
              value: '7',
              caption: 'Need response',
            ),
            const MetricCard(
              icon: Icons.inventory_outlined,
              label: 'Available Services',
              value: '12',
              caption: 'Catalog live',
            ),
          ],
        ),
        const SectionHeader(title: 'Customer Requests'),
        PremiumListTile(
          icon: Icons.message_outlined,
          title: 'Jonathan Wijaya',
          subtitle: 'Request pickup at Tower A / 18-08 after 19:00.',
          trailing: const StatusBadge(status: 'New'),
        ),
      ],
    );
  }
}

class ProductServicePage extends StatefulWidget {
  const ProductServicePage({super.key});

  @override
  State<ProductServicePage> createState() => _ProductServicePageState();
}

class _ProductServicePageState extends State<ProductServicePage> {
  var _services = const [
    _MerchantService(
      name: 'Premium laundry 8kg',
      price: 168000,
      available: true,
    ),
    _MerchantService(name: 'Express ironing', price: 82000, available: true),
    _MerchantService(name: 'Dry clean suit', price: 215000, available: true),
    _MerchantService(
      name: 'Bed cover cleaning',
      price: 145000,
      available: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('tenant-services'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        const SectionHeader(title: 'Product / Service List'),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Catalog Control',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Add and edit dummy services for the resident marketplace demo.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 14),
              LuxuryButton(
                label: 'Add Dummy Service',
                icon: Icons.add_circle_outline,
                onPressed: () => setState(() {
                  _services = [
                    const _MerchantService(
                      name: 'Sneaker care package',
                      price: 125000,
                      available: true,
                    ),
                    ..._services,
                  ];
                }),
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'Services'),
        for (var i = 0; i < _services.length; i++)
          PremiumListTile(
            icon: Icons.room_service_outlined,
            title: _services[i].name,
            subtitle: _currency.format(_services[i].price),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusBadge(
                  status: _services[i].available ? 'Available' : 'Unavailable',
                ),
                TextButton(
                  onPressed: () => setState(
                    () => _services[i] = _services[i].copyWith(
                      available: !_services[i].available,
                    ),
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: AppColors.softGold),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class ResidentOrdersPage extends StatefulWidget {
  const ResidentOrdersPage({super.key});

  @override
  State<ResidentOrdersPage> createState() => _ResidentOrdersPageState();
}

class _ResidentOrdersPageState extends State<ResidentOrdersPage> {
  late final _orders = DemoData.merchantOrders.map((item) => item).toList();
  final _statuses = const [
    'New',
    'Accepted',
    'Preparing',
    'Delivered',
    'Completed',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('tenant-orders'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        const SectionHeader(title: 'Resident Orders'),
        for (var i = 0; i < _orders.length; i++)
          GlassCard(
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${_orders[i].id} - ${_orders[i].customer}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    StatusBadge(status: _orders[i].status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _orders[i].item,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '${_currency.format(_orders[i].amount)} - requested ${_time.format(_orders[i].requestTime)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final status in _statuses)
                      ChoiceChip(
                        label: Text(status),
                        selected: _orders[i].status == status,
                        onSelected: (_) => setState(
                          () =>
                              _orders[i] = _orders[i].copyWith(status: status),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class PromoManagementPage extends StatefulWidget {
  const PromoManagementPage({super.key});

  @override
  State<PromoManagementPage> createState() => _PromoManagementPageState();
}

class _PromoManagementPageState extends State<PromoManagementPage> {
  final _title = TextEditingController(text: 'Weekend Laundry Gold');
  final _discount = TextEditingController(text: '20%');
  final _validDate = TextEditingController(text: 'Valid until 30 Jun 2026');
  var _promos = const [
    _Promo(
      title: 'Weekend Laundry Gold',
      discount: '20%',
      validDate: '30 Jun 2026',
    ),
    _Promo(
      title: 'Express Ironing Hour',
      discount: '15%',
      validDate: '15 Jun 2026',
    ),
  ];

  @override
  void dispose() {
    _title.dispose();
    _discount.dispose();
    _validDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('tenant-promo'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        const SectionHeader(title: 'Promo Management'),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.goldMetallic, AppColors.softGold],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_offer_outlined,
                      color: Color(0xFF17120A),
                      size: 34,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Promo banner preview',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: const Color(0xFF17120A)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Promo title'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _discount,
                decoration: const InputDecoration(labelText: 'Discount'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _validDate,
                decoration: const InputDecoration(labelText: 'Valid date'),
              ),
              const SizedBox(height: 14),
              LuxuryButton(
                label: 'Create Promo',
                icon: Icons.campaign_outlined,
                onPressed: () => setState(() {
                  _promos = [
                    _Promo(
                      title: _title.text,
                      discount: _discount.text,
                      validDate: _validDate.text,
                    ),
                    ..._promos,
                  ];
                }),
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'Active Promos'),
        for (final promo in _promos)
          PremiumListTile(
            icon: Icons.local_offer_outlined,
            title: promo.title,
            subtitle: '${promo.discount} discount - ${promo.validDate}',
            trailing: const StatusBadge(status: 'Active'),
          ),
      ],
    );
  }
}

class MerchantProfilePage extends StatelessWidget {
  const MerchantProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tenant = DemoData.tenant;

    return ListView(
      key: const ValueKey('tenant-profile'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        const SectionHeader(title: 'Merchant Profile'),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.softGold, AppColors.goldMetallic],
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(
                      Icons.local_laundry_service_outlined,
                      color: Color(0xFF17120A),
                      size: 34,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tenant.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          tenant.category,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(status: tenant.status),
                ],
              ),
              const SizedBox(height: 18),
              _ProfileRow(
                icon: Icons.category_outlined,
                label: 'Category',
                value:
                    'Laundry, Cleaning, Food & Beverage, Mini Market, Maintenance Partner',
              ),
              _ProfileRow(
                icon: Icons.schedule_outlined,
                label: 'Operating hours',
                value: tenant.hours,
              ),
              _ProfileRow(
                icon: Icons.phone_outlined,
                label: 'Contact',
                value: tenant.contact,
              ),
              _ProfileRow(
                icon: Icons.star_outline,
                label: 'Rating',
                value: tenant.rating.toStringAsFixed(1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MerchantService {
  const _MerchantService({
    required this.name,
    required this.price,
    required this.available,
  });

  final String name;
  final int price;
  final bool available;

  _MerchantService copyWith({bool? available}) {
    return _MerchantService(
      name: name,
      price: price,
      available: available ?? this.available,
    );
  }
}

class _Promo {
  const _Promo({
    required this.title,
    required this.discount,
    required this.validDate,
  });

  final String title;
  final String discount;
  final String validDate;
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.softGold, size: 20),
          const SizedBox(width: 10),
          SizedBox(
            width: 118,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.softGold),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

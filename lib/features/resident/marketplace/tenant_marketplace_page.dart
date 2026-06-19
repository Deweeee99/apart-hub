import 'package:flutter/material.dart';

import '../../../core/data/data_dummy.dart';
import '../../../core/widgets/white_premium_card.dart';
import 'tenant_marketplace_models.dart';
import 'tenant_review_history_page.dart';
import 'tenant_store_detail_page.dart';

class TenantMarketplacePage extends StatefulWidget {
  const TenantMarketplacePage({super.key});

  @override
  State<TenantMarketplacePage> createState() => _TenantMarketplacePageState();
}

class _TenantMarketplacePageState extends State<TenantMarketplacePage> {
  final _searchController = TextEditingController();
  String _category = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MarketplaceTenant> get _tenants => DataDummy.marketplaceTenants
      .map(
        (item) => MarketplaceTenant(
          id: item.id,
          name: item.name,
          category: item.category,
          location: item.location,
          rating: item.rating,
          deliveryEta: item.deliveryEta,
          iconKey: item.iconKey,
          open: item.open,
        ),
      )
      .toList();

  List<MarketplaceOrderHistory> get _history => DataDummy
      .marketplaceOrderHistory
      .map(
        (item) => MarketplaceOrderHistory(
          orderId: item.orderId,
          tenantName: item.tenantName,
          itemSummary: item.itemSummary,
          total: item.total,
          status: item.status,
          date: item.date,
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final stores = _tenants.where((tenant) {
      final categoryMatch = switch (_category) {
        'Food & Beverage' => tenant.category == 'Coffee Shop',
        'Laundry' => tenant.category == 'Laundry',
        'Minimarket' => tenant.category == 'Minimarket',
        'Beauty & Salon' => tenant.category == 'Beauty & Salon',
        'Home & Living' => false,
        'Services' => false,
        _ => true,
      };
      final queryMatch =
          query.isEmpty ||
          tenant.name.toLowerCase().contains(query) ||
          tenant.category.toLowerCase().contains(query);
      return categoryMatch && queryMatch;
    }).toList();

    return Scaffold(
      backgroundColor: marketplaceSurface,
      body: SafeArea(
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.apply(
              bodyColor: marketplaceNavy,
              displayColor: marketplaceNavy,
            ),
          ),
          child: ColoredBox(
            color: marketplaceSurface,
            child: ListView(
              key: const ValueKey('tenant-marketplace'),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 132),
              children: [
                _MarketplaceTopBar(onBack: () => Navigator.of(context).pop()),
                const SizedBox(height: 14),
                const _MarketplaceHeaderCard(),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: marketplaceNavy),
                  cursorColor: marketplaceGold,
                  decoration: InputDecoration(
                    hintText: 'Search store or product',
                    hintStyle: const TextStyle(color: marketplaceMuted),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: marketplaceMuted,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: marketplaceLine),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: marketplaceGold),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const _SectionTitle(
                  title: 'Categories',
                  actionLabel: 'View All',
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 96,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final item in const [
                        ('All', Icons.apps_outlined),
                        ('Food & Beverage', Icons.local_cafe_outlined),
                        ('Laundry', Icons.local_laundry_service_outlined),
                        ('Minimarket', Icons.storefront_outlined),
                        ('Beauty & Salon', Icons.content_cut_outlined),
                        ('Services', Icons.handyman_outlined),
                      ]) ...[
                        _CategoryTile(
                          label: item.$1,
                          icon: item.$2,
                          selected: _category == item.$1,
                          onTap: () => setState(() => _category = item.$1),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const _SectionTitle(
                  title: 'Featured Stores',
                  actionLabel: 'View All',
                ),
                const SizedBox(height: 12),
                for (final tenant in stores) ...[
                  _StoreCard(
                    tenant: tenant,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TenantStoreDetailPage(tenant: tenant),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 18),
                _SectionTitle(
                  title: 'Order History',
                  actionLabel: 'View All',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const TenantReviewHistoryPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                for (final item in _history.take(2)) ...[
                  WhitePremiumCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: marketplaceSoftGold,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: marketplaceGold.withValues(alpha: 0.22),
                            ),
                          ),
                          child: Icon(
                            marketplacePromoIconForKey(
                              item.tenantName == 'Quick Wash'
                                  ? 'laundry'
                                  : 'coffee',
                            ),
                            color: marketplaceGold,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.tenantName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      color: marketplaceNavy,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.itemSummary,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: marketplaceMuted),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.date,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: marketplaceMuted,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              marketplaceCurrency.format(item.total),
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: marketplaceNavy,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F9F1),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                item.status,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MarketplaceTopBar extends StatelessWidget {
  const _MarketplaceTopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: marketplaceNavy,
            shadowColor: Colors.black.withValues(alpha: 0.08),
            side: const BorderSide(color: marketplaceLine),
          ),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Tenant Marketplace',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: marketplaceNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _MarketplaceHeaderCard extends StatelessWidget {
  const _MarketplaceHeaderCard();

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(18),
      child: Stack(
        children: [
          Positioned(
            top: -18,
            right: -10,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    marketplaceGold.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Marketplace',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: marketplaceNavy,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FC),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: marketplaceBlue.withValues(alpha: 0.12),
                      ),
                    ),
                    child: const Icon(
                      Icons.notifications_none_outlined,
                      color: marketplaceNavy,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Order products & services from trusted tenants.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: marketplaceMuted),
              ),
              const SizedBox(height: 12),
              Text(
                'Aether Residences / Apart Hub Residence',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: marketplaceGold,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 86,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFFCF7) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? marketplaceGold : marketplaceLine,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: marketplaceSoftGold,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: marketplaceGold, size: 18),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: marketplaceNavy,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.tenant, required this.onTap});

  final MarketplaceTenant tenant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: marketplaceSoftGold,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: marketplaceGold.withValues(alpha: 0.20),
              ),
            ),
            child: Icon(
              marketplaceIconForKey(tenant.iconKey),
              color: marketplaceGold,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tenant.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: marketplaceNavy,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: tenant.open
                            ? const Color(0xFFF0F9F1)
                            : const Color(0xFFF5F6F8),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        tenant.open ? 'Open' : 'Closed',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: tenant.open
                              ? Colors.green.shade700
                              : marketplaceMuted,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  tenant.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: marketplaceMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _StoreMeta(
                      icon: Icons.location_on_outlined,
                      label: tenant.location,
                    ),
                    _StoreMeta(
                      icon: Icons.star_rounded,
                      label: tenant.rating.toStringAsFixed(1),
                      iconColor: marketplaceGold,
                    ),
                    _StoreMeta(
                      icon: Icons.delivery_dining_outlined,
                      label: tenant.deliveryEta,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreMeta extends StatelessWidget {
  const _StoreMeta({required this.icon, required this.label, this.iconColor});

  final IconData icon;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor ?? marketplaceMuted, size: 14),
        const SizedBox(width: 4),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: marketplaceMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.actionLabel, this.onTap});

  final String title;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: marketplaceNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              foregroundColor: marketplaceGold,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.zero,
            ),
            child: Text(
              actionLabel!,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
      ],
    );
  }
}

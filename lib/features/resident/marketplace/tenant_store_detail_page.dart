import 'package:flutter/material.dart';

import '../../../core/data/data_dummy.dart';
import '../../../core/widgets/white_premium_card.dart';
import 'tenant_cart_page.dart';
import 'tenant_marketplace_models.dart';

class TenantStoreDetailPage extends StatefulWidget {
  const TenantStoreDetailPage({super.key, required this.tenant});

  final MarketplaceTenant tenant;

  @override
  State<TenantStoreDetailPage> createState() => _TenantStoreDetailPageState();
}

class _TenantStoreDetailPageState extends State<TenantStoreDetailPage> {
  String _filter = 'All';
  final Map<String, int> _cartQuantities = {};

  List<MarketplaceProduct> get _products => DataDummy.marketplaceProducts
      .where((item) => item.tenantId == widget.tenant.id)
      .map(
        (item) => MarketplaceProduct(
          id: item.id,
          tenantId: item.tenantId,
          name: item.name,
          description: item.description,
          category: item.category,
          price: item.price,
          imageKey: item.imageKey,
          available: item.available,
          bestSeller: item.bestSeller,
        ),
      )
      .toList();

  List<MarketplaceCartItem> get _cartItems => _products
      .where((product) => (_cartQuantities[product.id] ?? 0) > 0)
      .map(
        (product) => MarketplaceCartItem(
          product: product,
          quantity: _cartQuantities[product.id] ?? 1,
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final items = _products.where((product) {
      return switch (_filter) {
        'Coffee' => product.category == 'Coffee',
        'Pastry' => product.category == 'Pastry',
        'Best Seller' => product.bestSeller,
        _ => true,
      };
    }).toList();
    final cartItems = _cartItems;
    final cartCount = cartItems.fold<int>(
      0,
      (total, item) => total + item.quantity,
    );
    final cartTotal = cartItems.fold<int>(
      0,
      (total, item) => total + item.total,
    );

    return Scaffold(
      backgroundColor: marketplaceSurface,
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                child: WhitePremiumCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '$cartCount item${cartCount > 1 ? 's' : ''} • ${marketplaceCurrency.format(cartTotal)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: marketplaceNavy,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => TenantCartPage(
                                tenant: widget.tenant,
                                items: cartItems,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: marketplaceGold,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'View Cart',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      body: SafeArea(
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.apply(
              bodyColor: marketplaceNavy,
              displayColor: marketplaceNavy,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 132),
            children: [
              _SubpageHeader(
                title: widget.tenant.name,
                onBack: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 14),
              WhitePremiumCard(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: marketplaceSoftGold,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: marketplaceGold.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Icon(
                        marketplaceIconForKey(widget.tenant.iconKey),
                        color: marketplaceGold,
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.tenant.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: marketplaceNavy,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.tenant.category,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: marketplaceMuted),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 8,
                            children: [
                              _MetaPill(
                                icon: Icons.location_on_outlined,
                                label: widget.tenant.location,
                              ),
                              _MetaPill(
                                icon: Icons.star_rounded,
                                label: widget.tenant.rating.toStringAsFixed(1),
                                iconColor: marketplaceGold,
                              ),
                              _MetaPill(
                                icon: Icons.delivery_dining_outlined,
                                label: widget.tenant.deliveryEta,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final item in const [
                      'All',
                      'Coffee',
                      'Pastry',
                      'Best Seller',
                    ]) ...[
                      _FilterChip(
                        label: item,
                        selected: _filter == item,
                        onTap: () => setState(() => _filter = item),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              for (final product in items) ...[
                WhitePremiumCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 66,
                        height: 66,
                        decoration: BoxDecoration(
                          color: marketplaceSoftGold,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: marketplaceGold.withValues(alpha: 0.18),
                          ),
                        ),
                        child: Icon(
                          marketplaceIconForKey(product.imageKey),
                          color: marketplaceGold,
                          size: 30,
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
                                    product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: marketplaceNavy,
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                ),
                                if (product.bestSeller)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: marketplaceSoftGold,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      'Best Seller',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: marketplaceGold,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              product.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: marketplaceMuted,
                                    height: 1.35,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    marketplaceCurrency.format(product.price),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: marketplaceNavy,
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: product.available
                                      ? () {
                                          setState(() {
                                            _cartQuantities[product.id] =
                                                (_cartQuantities[product.id] ??
                                                    0) +
                                                1;
                                          });
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: marketplaceGold,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text(
                                    'Add',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
    );
  }
}

class _SubpageHeader extends StatelessWidget {
  const _SubpageHeader({required this.title, required this.onBack});

  final String title;
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
          ),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
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

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.icon, required this.label, this.iconColor});

  final IconData icon;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF7),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: marketplaceLine),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor ?? marketplaceMuted, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: marketplaceNavy,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? marketplaceNavy : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? marketplaceNavy : marketplaceLine,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: selected ? const Color(0xFFFFD98A) : marketplaceNavy,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

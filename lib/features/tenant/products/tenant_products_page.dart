import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/data/data_dummy.dart';
import '../../../core/widgets/tenant/tenant_product_card.dart';
import '../../../core/widgets/white_premium_card.dart';

const _surface = Color(0xFFF8F5EF);
const _navy = Color(0xFF071B34);
const _blue = Color(0xFF173A67);
const _gold = Color(0xFFC08A1A);
const _muted = Color(0xFF687184);
const _line = Color(0xFFE7DFD1);
const _softGreen = Color(0xFFF0F9F1);
const _softAmber = Color(0xFFFFF6E4);
const _softBlue = Color(0xFFF0F6FF);

class TenantProductsPage extends StatefulWidget {
  const TenantProductsPage({super.key});

  @override
  State<TenantProductsPage> createState() => _TenantProductsPageState();
}

class _TenantProductsPageState extends State<TenantProductsPage> {
  late List<_TenantProduct> _products = DataDummy.tenantProducts
      .map(
        (item) => _TenantProduct(
          name: item.name,
          category: item.category,
          price: item.price,
          active: item.active,
          bestSeller: item.bestSeller,
          iconKey: item.iconKey,
        ),
      )
      .toList();
  String _filter = 'All';

  List<_TenantProduct> get _filteredProducts {
    return _products.where((product) {
      switch (_filter) {
        case 'Coffee':
          return product.category == 'Coffee';
        case 'Pastry':
          return product.category == 'Pastry';
        case 'Beverage':
          return product.category == 'Beverage';
        case 'Inactive':
          return !product.active;
        case 'All':
        default:
          return true;
      }
    }).toList();
  }

  void _toggleProduct(int index) {
    setState(() {
      _products[index] = _products[index].copyWith(
        active: !_products[index].active,
      );
    });
  }

  Future<void> _showProductSheet({_TenantProduct? product, int? index}) async {
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController = TextEditingController(
      text: product?.price.toString() ?? '',
    );
    var category = product?.category ?? 'Coffee';
    var active = product?.active ?? true;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: WhitePremiumCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product == null ? 'Add Product' : 'Edit Product',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: _navy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: _navy),
                      cursorColor: _gold,
                      decoration: _fieldDecoration('Product Name'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: category,
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: _navy),
                      decoration: _fieldDecoration('Category'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Coffee',
                          child: Text('Coffee'),
                        ),
                        DropdownMenuItem(
                          value: 'Pastry',
                          child: Text('Pastry'),
                        ),
                        DropdownMenuItem(
                          value: 'Beverage',
                          child: Text('Beverage'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setSheetState(() => category = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: _navy),
                      cursorColor: _gold,
                      decoration: _fieldDecoration('Price'),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _softBlue,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _line),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Status Active',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: _navy,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                          Switch(
                            value: active,
                            activeThumbColor: AppColors.success,
                            onChanged: (value) {
                              setSheetState(() => active = value);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final parsedPrice =
                              int.tryParse(priceController.text.trim()) ?? 0;
                          final name = nameController.text.trim();
                          if (name.isEmpty || parsedPrice <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please complete the product form.',
                                ),
                              ),
                            );
                            return;
                          }

                          final iconKey = _iconKeyForCategory(category);
                          setState(() {
                            final newProduct = _TenantProduct(
                              name: name,
                              category: category,
                              price: parsedPrice,
                              active: active,
                              bestSeller: product?.bestSeller ?? false,
                              iconKey: iconKey,
                            );

                            if (index == null) {
                              _products = [newProduct, ..._products];
                            } else {
                              _products[index] = newProduct;
                            }
                          });

                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text(
                                index == null
                                    ? 'Product added to catalog.'
                                    : 'Product updated successfully.',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _navy,
                          foregroundColor: const Color(0xFFFFD98A),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          product == null ? 'Save Product' : 'Save Changes',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _filteredProducts;
    final activeCount = _products.where((product) => product.active).length;
    final inactiveCount = _products.where((product) => !product.active).length;
    final bestSeller = _products.firstWhere(
      (product) => product.bestSeller,
      orElse: () => _products.first,
    );

    return ColoredBox(
      color: _surface,
      child: ListView(
        key: const ValueKey('tenant-products'),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 132),
        children: [
          const _ProductsIntroCard(),
          const SizedBox(height: 16),
          SizedBox(
            height: 128,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _CatalogSummaryCard(
                  icon: Icons.inventory_2_outlined,
                  iconColor: AppColors.success,
                  iconBackground: _softGreen,
                  label: 'Active Products',
                  value: '$activeCount',
                ),
                const SizedBox(width: 12),
                _CatalogSummaryCard(
                  icon: Icons.pause_circle_outline,
                  iconColor: _gold,
                  iconBackground: _softAmber,
                  label: 'Inactive',
                  value: '$inactiveCount',
                ),
                const SizedBox(width: 12),
                _CatalogSummaryCard(
                  icon: Icons.workspace_premium_outlined,
                  iconColor: _blue,
                  iconBackground: _softBlue,
                  label: 'Best Seller',
                  value: bestSeller.name,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          WhitePremiumCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            onTap: () => _showProductSheet(),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _softBlue,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.add_rounded, color: _blue, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Add Product',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: _navy,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Create a new menu item',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: _gold),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final filter in const [
                  'All',
                  'Coffee',
                  'Pastry',
                  'Beverage',
                  'Inactive',
                ]) ...[
                  _CatalogFilterChip(
                    label: filter,
                    selected: _filter == filter,
                    onTap: () => setState(() => _filter = filter),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (filteredProducts.isEmpty)
            WhitePremiumCard(
              padding: const EdgeInsets.all(18),
              child: Text(
                'No products match the selected filter.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: _muted),
              ),
            )
          else
            for (final product in filteredProducts) ...[
              TenantProductCard(
                name: product.name,
                category: product.category,
                price: product.price,
                active: product.active,
                bestSeller: product.bestSeller,
                icon: _iconForKey(product.iconKey),
                onEdit: () => _showProductSheet(
                  product: product,
                  index: _products.indexOf(product),
                ),
                onToggleActive: () =>
                    _toggleProduct(_products.indexOf(product)),
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class _ProductsIntroCard extends StatelessWidget {
  const _ProductsIntroCard();

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
              width: 126,
              height: 126,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [_gold.withValues(alpha: 0.18), Colors.transparent],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F2647), Color(0xFF173A67)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Product Catalog',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: _navy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Manage menu availability, pricing, and product visibility.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: _muted),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _softGreen,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.16),
                  ),
                ),
                child: Text(
                  'Brew Cabin Coffee',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w800,
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

class _CatalogSummaryCard extends StatelessWidget {
  const _CatalogSummaryCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 138,
      child: WhitePremiumCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: _navy,
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogFilterChip extends StatelessWidget {
  const _CatalogFilterChip({
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
          color: selected ? _navy : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? _navy : _line),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: _navy.withValues(alpha: 0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: selected ? const Color(0xFFFFD98A) : _navy,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

InputDecoration _fieldDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: _muted),
    floatingLabelStyle: const TextStyle(color: _gold),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: _line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: _gold),
    ),
  );
}

IconData _iconForKey(String iconKey) {
  return switch (iconKey) {
    'pastry' => Icons.bakery_dining_outlined,
    'beverage' => Icons.local_drink_outlined,
    _ => Icons.local_cafe_outlined,
  };
}

String _iconKeyForCategory(String category) {
  return switch (category) {
    'Pastry' => 'pastry',
    'Beverage' => 'beverage',
    _ => 'coffee',
  };
}

class _TenantProduct {
  const _TenantProduct({
    required this.name,
    required this.category,
    required this.price,
    required this.active,
    required this.bestSeller,
    required this.iconKey,
  });

  final String name;
  final String category;
  final int price;
  final bool active;
  final bool bestSeller;
  final String iconKey;

  _TenantProduct copyWith({
    String? name,
    String? category,
    int? price,
    bool? active,
    bool? bestSeller,
    String? iconKey,
  }) {
    return _TenantProduct(
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      active: active ?? this.active,
      bestSeller: bestSeller ?? this.bestSeller,
      iconKey: iconKey ?? this.iconKey,
    );
  }
}

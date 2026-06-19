import 'package:flutter/material.dart';

import '../../../core/widgets/white_premium_card.dart';
import 'tenant_marketplace_models.dart';
import 'tenant_payment_page.dart';

class TenantCartPage extends StatefulWidget {
  const TenantCartPage({super.key, required this.tenant, required this.items});

  final MarketplaceTenant tenant;
  final List<MarketplaceCartItem> items;

  @override
  State<TenantCartPage> createState() => _TenantCartPageState();
}

class _TenantCartPageState extends State<TenantCartPage> {
  late final List<MarketplaceCartItem> _items = widget.items;
  final _notesController = TextEditingController();
  String _deliveryOption = 'Deliver to Unit';

  int get _subtotal => _items.fold<int>(0, (sum, item) => sum + item.total);
  int get _deliveryFee => _deliveryOption == 'Deliver to Unit' ? 5000 : 0;
  int get _total => _subtotal + _deliveryFee;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 132),
            children: [
              _SubpageHeader(
                title: 'My Cart',
                onBack: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 16),
              for (var i = 0; i < _items.length; i++) ...[
                WhitePremiumCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: marketplaceSoftGold,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          marketplaceIconForKey(_items[i].product.imageKey),
                          color: marketplaceGold,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _items[i].product.name,
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
                              _items[i].sizeLabel,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: marketplaceMuted),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              marketplaceCurrency.format(
                                _items[i].product.price,
                              ),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: marketplaceNavy,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _QtyButton(
                                  icon: Icons.remove,
                                  onTap: () {
                                    setState(() {
                                      final nextQty = _items[i].quantity - 1;
                                      if (nextQty <= 0) {
                                        _items.removeAt(i);
                                      } else {
                                        _items[i] = _items[i].copyWith(
                                          quantity: nextQty,
                                        );
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '${_items[i].quantity}',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        color: marketplaceNavy,
                                        fontWeight: FontWeight.w900,
                                      ),
                                ),
                                const SizedBox(width: 10),
                                _QtyButton(
                                  icon: Icons.add,
                                  onTap: () {
                                    setState(() {
                                      _items[i] = _items[i].copyWith(
                                        quantity: _items[i].quantity + 1,
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _items.removeAt(i)),
                        icon: const Icon(Icons.delete_outline),
                        color: marketplaceMuted,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              WhitePremiumCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Option',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: marketplaceNavy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SelectableOptionTile(
                      selected: _deliveryOption == 'Deliver to Unit',
                      icon: Icons.delivery_dining_outlined,
                      title: 'Deliver to Unit',
                      subtitle: 'Delivery to Unit A-1808',
                      onTap: () {
                        setState(() => _deliveryOption = 'Deliver to Unit');
                      },
                    ),
                    const SizedBox(height: 10),
                    _SelectableOptionTile(
                      selected: _deliveryOption == 'Pickup at Tenant',
                      icon: Icons.storefront_outlined,
                      title: 'Pickup at Tenant',
                      subtitle: 'Pick up directly at tenant store',
                      onTap: () {
                        setState(() => _deliveryOption = 'Pickup at Tenant');
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _notesController,
                      style: const TextStyle(color: marketplaceNavy),
                      cursorColor: marketplaceGold,
                      decoration: InputDecoration(
                        labelText: 'Add a note for the tenant',
                        labelStyle: const TextStyle(color: marketplaceMuted),
                        floatingLabelStyle: const TextStyle(
                          color: marketplaceGold,
                        ),
                        filled: true,
                        fillColor: Colors.white,
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
                  ],
                ),
              ),
              const SizedBox(height: 16),
              WhitePremiumCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _AmountRow(label: 'Subtotal', value: _subtotal),
                    const SizedBox(height: 8),
                    _AmountRow(label: 'Delivery Fee', value: _deliveryFee),
                    const SizedBox(height: 10),
                    Divider(color: marketplaceLine),
                    const SizedBox(height: 10),
                    _AmountRow(label: 'Total', value: _total, emphasize: true),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _items.isEmpty
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TenantPaymentPage(
                              order: MarketplaceOrderFlowData(
                                orderId: '#MC-070624-001',
                                tenant: widget.tenant,
                                items: _items,
                                orderTime: DateTime(2026, 6, 7, 8, 41),
                                deliveryTo: 'Unit A-1808',
                                deliveryOption: _deliveryOption,
                                notes: _notesController.text.trim(),
                              ),
                            ),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: marketplaceGold,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Place Order',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
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

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: marketplaceLine),
        ),
        child: Icon(icon, color: marketplaceNavy, size: 16),
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final int value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: emphasize ? marketplaceNavy : marketplaceMuted,
              fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
        Text(
          marketplaceCurrency.format(value),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: marketplaceNavy,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _SelectableOptionTile extends StatelessWidget {
  const _SelectableOptionTile({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? marketplaceSoftGold.withValues(alpha: 0.65)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? marketplaceGold : marketplaceLine,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFCF7),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: marketplaceGold.withValues(alpha: 0.16),
                ),
              ),
              child: Icon(icon, color: marketplaceGold, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: marketplaceNavy,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: marketplaceMuted,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            _SelectedIndicator(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _SelectedIndicator extends StatelessWidget {
  const _SelectedIndicator({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? marketplaceGold : Colors.transparent,
        border: Border.all(color: selected ? marketplaceGold : marketplaceLine),
      ),
      child: selected
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );
  }
}

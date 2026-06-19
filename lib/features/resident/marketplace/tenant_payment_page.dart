import 'package:flutter/material.dart';

import '../../../core/widgets/white_premium_card.dart';
import 'tenant_marketplace_models.dart';
import 'tenant_order_detail_page.dart';

class TenantPaymentPage extends StatefulWidget {
  const TenantPaymentPage({super.key, required this.order});

  final MarketplaceOrderFlowData order;

  @override
  State<TenantPaymentPage> createState() => _TenantPaymentPageState();
}

class _TenantPaymentPageState extends State<TenantPaymentPage> {
  String _selectedMethod = 'E-Wallet';

  @override
  Widget build(BuildContext context) {
    final order = widget.order.copyWith(paymentMethod: _selectedMethod);

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
                title: 'Payment',
                onBack: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 16),
              WhitePremiumCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: marketplaceNavy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      order.itemSummary,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: marketplaceMuted),
                    ),
                    const SizedBox(height: 12),
                    _AmountRow(label: 'Items', value: order.subtotal),
                    const SizedBox(height: 8),
                    _AmountRow(label: 'Delivery Fee', value: order.deliveryFee),
                    const SizedBox(height: 10),
                    Divider(color: marketplaceLine),
                    const SizedBox(height: 10),
                    _AmountRow(
                      label: 'Total Payment',
                      value: order.total,
                      emphasize: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              WhitePremiumCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Method',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: marketplaceNavy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _PaymentMethodTile(
                      selected: _selectedMethod == 'E-Wallet',
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'E-Wallet',
                      subtitle: 'GoPay, OVO, DANA, ShopeePay',
                      onTap: () {
                        setState(() => _selectedMethod = 'E-Wallet');
                      },
                    ),
                    const SizedBox(height: 10),
                    _PaymentMethodTile(
                      selected: _selectedMethod == 'Virtual Account',
                      icon: Icons.account_balance_outlined,
                      title: 'Virtual Account',
                      subtitle: 'Pay from any bank',
                      onTap: () {
                        setState(() => _selectedMethod = 'Virtual Account');
                      },
                    ),
                    const SizedBox(height: 10),
                    _PaymentMethodTile(
                      selected: _selectedMethod == 'Credit / Debit Card',
                      icon: Icons.credit_card_outlined,
                      title: 'Credit / Debit Card',
                      subtitle: 'Visa, Mastercard, JCB',
                      onTap: () {
                        setState(() => _selectedMethod = 'Credit / Debit Card');
                      },
                    ),
                    const SizedBox(height: 10),
                    _PaymentMethodTile(
                      selected: _selectedMethod == 'Aether Points',
                      icon: Icons.stars_outlined,
                      title: 'Aether Points',
                      subtitle: 'Use your resident reward points',
                      onTap: () {
                        setState(() => _selectedMethod = 'Aether Points');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment simulated successfully.'),
                    ),
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TenantOrderDetailPage(order: order),
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
                  'Pay Now',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Your payment is secure',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: marketplaceMuted,
                    fontWeight: FontWeight.w600,
                  ),
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

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
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

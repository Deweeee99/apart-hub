import 'package:flutter/material.dart';

import '../../../core/widgets/white_premium_card.dart';
import 'tenant_marketplace_models.dart';
import 'tenant_order_completed_page.dart';

class TenantOrderTrackingPage extends StatelessWidget {
  const TenantOrderTrackingPage({super.key, required this.order});

  final MarketplaceOrderFlowData order;

  @override
  Widget build(BuildContext context) {
    final isPickup = order.deliveryOption == 'Pickup at Tenant';
    final title = isPickup ? 'Pickup Ready' : 'Order On The Way';
    final message = isPickup
        ? 'Your order is ready for pickup at ${order.tenant.name}.'
        : 'Your order is on the way!';

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
                title: title,
                onBack: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 16),
              WhitePremiumCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        color: marketplaceSoftGold,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isPickup
                            ? Icons.storefront_outlined
                            : Icons.delivery_dining_outlined,
                        color: marketplaceGold,
                        size: 46,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: marketplaceNavy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isPickup
                          ? 'Please pick it up from ${order.tenant.name}.'
                          : 'We will deliver it to your unit.',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: marketplaceMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              WhitePremiumCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F7FC),
                        shape: BoxShape.circle,
                        border: Border.all(color: marketplaceLine),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: marketplaceBlue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rider',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: marketplaceMuted,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            order.riderName,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: marketplaceNavy,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'ETA: ${order.riderEta}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: marketplaceMuted),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                        backgroundColor: marketplaceSoftGold,
                        foregroundColor: marketplaceGold,
                      ),
                      icon: const Icon(Icons.call_outlined),
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
                      isPickup ? 'Pickup At' : 'Delivered To',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: marketplaceMuted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isPickup ? order.tenant.name : order.deliveryTo,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: marketplaceNavy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tracking rider Andi...')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: marketplaceBlue,
                      side: BorderSide(
                        color: marketplaceBlue.withValues(alpha: 0.32),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Track Order',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              TenantOrderCompletedPage(order: order),
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
                      'Mark as Received',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
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

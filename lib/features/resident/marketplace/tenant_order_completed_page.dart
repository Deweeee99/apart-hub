import 'package:flutter/material.dart';

import '../../../core/widgets/white_premium_card.dart';
import 'tenant_marketplace_models.dart';
import 'tenant_review_history_page.dart';

class TenantOrderCompletedPage extends StatelessWidget {
  const TenantOrderCompletedPage({super.key, required this.order});

  final MarketplaceOrderFlowData order;

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
                title: 'Order Completed',
                onBack: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 16),
              WhitePremiumCard(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F9F1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.green.shade700,
                        size: 52,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Order Delivered!',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: marketplaceNavy,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Thank you for your order.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: marketplaceMuted),
                    ),
                    const SizedBox(height: 18),
                    _InfoRow(label: 'Order ID', value: order.orderId),
                    _InfoRow(label: 'Delivered To', value: order.deliveryTo),
                    _InfoRow(
                      label: 'Delivered On',
                      value: marketplaceDateTime.format(
                        order.orderTime.add(
                          const Duration(hours: 1, minutes: 21),
                        ),
                      ),
                    ),
                    _InfoRow(
                      label: 'Total',
                      value: marketplaceCurrency.format(order.total),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Order detail preview is shown above.',
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: marketplaceNavy,
                            side: BorderSide(
                              color: marketplaceNavy.withValues(alpha: 0.24),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'View Order Detail',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => TenantReviewHistoryPage(
                                  order: order,
                                  openReview: true,
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
                            'Rate Your Experience',
                            style: TextStyle(fontWeight: FontWeight.w800),
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: marketplaceMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: marketplaceNavy,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/data/data_dummy.dart';
import '../../../core/widgets/white_premium_card.dart';
import 'tenant_marketplace_models.dart';

class TenantReviewHistoryPage extends StatefulWidget {
  const TenantReviewHistoryPage({
    super.key,
    this.order,
    this.openReview = false,
  });

  final MarketplaceOrderFlowData? order;
  final bool openReview;

  @override
  State<TenantReviewHistoryPage> createState() =>
      _TenantReviewHistoryPageState();
}

class _TenantReviewHistoryPageState extends State<TenantReviewHistoryPage> {
  final _commentController = TextEditingController(
    text: 'Great coffee and fast delivery! Thank you!',
  );
  int _rating = 5;

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
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final history = _history;

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
                title: 'Review & History',
                onBack: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 16),
              WhitePremiumCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rate Your Experience',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: marketplaceNavy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'How was your experience with ${widget.order?.tenant.name ?? 'Brew Cabin'}?',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: marketplaceMuted),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        for (var i = 1; i <= 5; i++)
                          IconButton(
                            onPressed: () => setState(() => _rating = i),
                            icon: Icon(
                              i <= _rating
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color: marketplaceGold,
                            ),
                          ),
                        const Spacer(),
                        Text(
                          'Excellent!',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: marketplaceNavy,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: _commentController,
                      style: const TextStyle(color: marketplaceNavy),
                      cursorColor: marketplaceGold,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Write a review',
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
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Review submitted. Thank you!'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: marketplaceGold,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Submit Review',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Order History',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: marketplaceNavy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: marketplaceGold,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                    ),
                    child: const Text(
                      'View All',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              for (final item in history) ...[
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
                        ),
                        child: Icon(
                          item.tenantName == 'Quick Wash'
                              ? Icons.local_laundry_service_outlined
                              : Icons.local_cafe_outlined,
                          color: marketplaceGold,
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
                          Text(
                            item.status,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w800,
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

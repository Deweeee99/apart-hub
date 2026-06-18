import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/white_premium_card.dart';

const _surface = Color(0xFFF8F5EF);
const _navy = Color(0xFF071B34);
const _blue = Color(0xFF173A67);
const _gold = Color(0xFFC08A1A);
const _softGold = Color(0xFFFFF6DF);
const _line = Color(0xFFE7DFD1);
const _muted = Color(0xFF687184);
const _softGreen = Color(0xFFF0F9F1);
const _softAmber = Color(0xFFFFF6E4);
const _softRed = Color(0xFFFFF4F2);

final _currency = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);
final _time = DateFormat('hh:mm a');

class TenantDashboardPage extends StatefulWidget {
  const TenantDashboardPage({super.key, required this.onNavigate});

  final Function(int) onNavigate;

  @override
  State<TenantDashboardPage> createState() => _TenantDashboardPageState();
}

class _TenantDashboardPageState extends State<TenantDashboardPage> {
  bool _isOnline = true;
  late final List<_DashboardOrder> _orders = [
    _DashboardOrder(
      id: '#240601',
      customer: 'Ahmad Rizky',
      item: 'Cappuccino x2',
      amount: 64000,
      time: DateTime(2026, 6, 17, 10, 30),
      status: 'New',
    ),
    _DashboardOrder(
      id: '#240602',
      customer: 'Sarah Wijaya',
      item: 'Latte x1',
      amount: 35000,
      time: DateTime(2026, 6, 17, 10, 28),
      status: 'New',
    ),
    _DashboardOrder(
      id: '#240603',
      customer: 'Budi Santoso',
      item: 'Croissant x1',
      amount: 64000,
      time: DateTime(2026, 6, 17, 10, 15),
      status: 'Preparing',
    ),
  ];

  void _toggleStoreStatus() {
    setState(() => _isOnline = !_isOnline);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isOnline ? 'Store is now online.' : 'Store is now offline.',
        ),
      ),
    );
  }

  void _showReportsPreview() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reports dashboard will be added later.')),
    );
  }

  void _updateOrderStatus(int index, String status) {
    setState(() {
      _orders[index] = _orders[index].copyWith(status: status);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _orders.where((order) => order.status == 'New').length;

    return ColoredBox(
      color: _surface,
      child: ListView(
        key: const ValueKey('tenant-dashboard'),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 132),
        children: [
          _MerchantHeroCard(
            totalOrder: 24,
            pending: pendingCount == 0 ? 5 : pendingCount,
            revenueLabel: _currency.format(1250000),
            onNotificationTap: () {},
            onProfileTap: () => widget.onNavigate(4),
            onLogoutTap: () => context.go('/login'),
          ),
          const SizedBox(height: 16),
          _StoreStatusCard(isOnline: _isOnline, onToggle: _toggleStoreStatus),
          const SizedBox(height: 20),
          _SectionTitle(title: 'Quick Menu'),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 116,
            ),
            itemBuilder: (context, index) {
              const items = [
                (
                  Icons.inventory_2_outlined,
                  AppColors.success,
                  _softGreen,
                  'Produk',
                ),
                (Icons.receipt_long_outlined, _gold, _softAmber, 'Pesanan'),
                (
                  Icons.local_offer_outlined,
                  AppColors.danger,
                  _softRed,
                  'Promo',
                ),
                (
                  Icons.bar_chart_rounded,
                  Color(0xFF6E5CE6),
                  Color(0xFFF4F2FF),
                  'Laporan',
                ),
              ];
              final item = items[index];
              return _QuickMenuCard(
                icon: item.$1,
                iconColor: item.$2,
                iconBackground: item.$3,
                label: item.$4,
                onTap: switch (index) {
                  0 => () => widget.onNavigate(1),
                  1 => () => widget.onNavigate(2),
                  2 => () => widget.onNavigate(3),
                  _ => _showReportsPreview,
                },
              );
            },
          ),
          const SizedBox(height: 20),
          _SectionTitle(
            title: 'Pesanan Masuk',
            actionLabel: 'Lihat Semua',
            onAction: () => widget.onNavigate(2),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < _orders.length; i++) ...[
            _IncomingOrderCard(
              order: _orders[i],
              onAccept: () => _updateOrderStatus(i, 'Accepted'),
              onReject: () => _updateOrderStatus(i, 'Rejected'),
            ),
            if (i != _orders.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _MerchantHeroCard extends StatelessWidget {
  const _MerchantHeroCard({
    required this.totalOrder,
    required this.pending,
    required this.revenueLabel,
    required this.onNotificationTap,
    required this.onProfileTap,
    required this.onLogoutTap,
  });

  final int totalOrder;
  final int pending;
  final String revenueLabel;
  final VoidCallback onNotificationTap;
  final VoidCallback onProfileTap;
  final VoidCallback onLogoutTap;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(18),
      child: Stack(
        children: [
          Positioned(
            top: -24,
            right: -10,
            child: Container(
              width: 132,
              height: 132,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFD98A).withValues(alpha: 0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 26,
            left: 34,
            child: Container(
              width: 180,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(120),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF173A67).withValues(alpha: 0.08),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFFBF3), _softGold],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _gold.withValues(alpha: 0.14)),
                    ),
                    child: const Icon(
                      Icons.local_cafe_outlined,
                      color: _navy,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Brew Cabin Coffee',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: _navy,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Lobby Floor',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: _muted,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F7FC),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: _blue.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Text(
                            'Cafe & Beverages',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: _blue,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _CircleIconButton(
                            icon: Icons.notifications_none_outlined,
                            onTap: onNotificationTap,
                          ),
                          const SizedBox(width: 8),
                          _CircleIconButton(
                            icon: Icons.exit_to_app_outlined,
                            onTap: onLogoutTap,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: onProfileTap,
                        borderRadius: BorderRadius.circular(999),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: _gold,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '4.8',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: _navy,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F2647), Color(0xFF173A67)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _navy.withValues(alpha: 0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _HeroMetric(value: '$totalOrder', label: 'Total Order'),
                    _MetricDivider(),
                    _HeroMetric(value: '$pending', label: 'Pending'),
                    _MetricDivider(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                revenueLabel,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Total Revenue',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.78),
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StoreStatusCard extends StatelessWidget {
  const _StoreStatusCard({required this.isOnline, required this.onToggle});

  final bool isOnline;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(14),
      onTap: onToggle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.power_settings_new_rounded,
                color: isOnline ? AppColors.success : _gold,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isOnline ? 'Store Online' : 'Store Offline',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: _navy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 50,
                height: 30,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isOnline ? AppColors.success : const Color(0xFFD6D9DF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Align(
                  alignment: isOnline
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _navy.withValues(alpha: 0.14),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      isOnline ? Icons.check_rounded : Icons.close_rounded,
                      color: isOnline ? AppColors.success : _muted,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Offline',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isOnline ? _muted : _navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: _line,
                  ),
                  child: Align(
                    alignment: isOnline
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.52,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          gradient: LinearGradient(
                            colors: isOnline
                                ? [const Color(0xFF6FD48F), AppColors.success]
                                : [_gold.withValues(alpha: 0.30), _gold],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Online',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isOnline ? _navy : _muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickMenuCard extends StatelessWidget {
  const _QuickMenuCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: iconColor.withValues(alpha: 0.18)),
            ),
            child: Icon(icon, color: iconColor, size: 23),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: _navy,
              fontWeight: FontWeight.w800,
              fontSize: 14.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _IncomingOrderCard extends StatelessWidget {
  const _IncomingOrderCard({
    required this.order,
    required this.onAccept,
    required this.onReject,
  });

  final _DashboardOrder order;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final isNew = order.status == 'New';
    final isRejected = order.status == 'Rejected';
    final badgeColor = switch (order.status) {
      'Accepted' => AppColors.success,
      'Preparing' => _gold,
      'Rejected' => AppColors.danger,
      _ => _gold,
    };
    final badgeBackground = switch (order.status) {
      'Accepted' => _softGreen,
      'Preparing' => _softAmber,
      'Rejected' => _softRed,
      _ => _softAmber,
    };

    return WhitePremiumCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Text(
                      order.id,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _navy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBackground,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: badgeColor.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Text(
                        order.status == 'New' ? 'Baru' : order.status,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: badgeColor,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _time.format(order.time),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            order.customer,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _navy,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            order.item,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: _muted),
          ),
          const SizedBox(height: 6),
          Text(
            _currency.format(order.amount),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _navy,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.end,
            children: [
              ElevatedButton(
                onPressed: isRejected ? null : onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isNew
                      ? AppColors.success
                      : const Color(0xFFEAF7EE),
                  foregroundColor: isNew ? Colors.white : AppColors.success,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 11,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  order.status == 'Accepted' ? 'Diproses' : 'Terima',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              OutlinedButton(
                onPressed: isRejected ? null : onReject,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 11,
                  ),
                  side: BorderSide(
                    color: AppColors.danger.withValues(alpha: 0.32),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Tolak',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.72),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 38,
      color: Colors.white.withValues(alpha: 0.14),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: _navy,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: _gold,
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

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7FC),
            shape: BoxShape.circle,
            border: Border.all(color: _blue.withValues(alpha: 0.12)),
          ),
          child: Icon(icon, color: _navy, size: 20),
        ),
      ),
    );
  }
}

class _DashboardOrder {
  const _DashboardOrder({
    required this.id,
    required this.customer,
    required this.item,
    required this.amount,
    required this.time,
    required this.status,
  });

  final String id;
  final String customer;
  final String item;
  final int amount;
  final DateTime time;
  final String status;

  _DashboardOrder copyWith({String? status}) {
    return _DashboardOrder(
      id: id,
      customer: customer,
      item: item,
      amount: amount,
      time: time,
      status: status ?? this.status,
    );
  }
}

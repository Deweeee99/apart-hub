import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
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
const _softRed = Color(0xFFFFF4F2);

final _currency = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);
final _time = DateFormat('hh:mm a');

class TenantOrdersPage extends StatefulWidget {
  const TenantOrdersPage({super.key});

  @override
  State<TenantOrdersPage> createState() => _TenantOrdersPageState();
}

class _TenantOrdersPageState extends State<TenantOrdersPage> {
  String _filter = 'All';
  late final List<_TenantOrder> _orders = [
    _TenantOrder(
      id: '#240501',
      customer: 'Ahmad Rizky',
      unit: 'Unit A-1203',
      item: 'Cappuccino x2',
      amount: 64000,
      time: DateTime(2026, 6, 17, 10, 30),
      status: 'Ready',
      driverName: 'Budi',
      eta: '10 min',
    ),
    _TenantOrder(
      id: '#240602',
      customer: 'Sarah Wijaya',
      unit: 'Unit C-1405',
      item: 'Latte x1',
      amount: 35000,
      time: DateTime(2026, 6, 17, 10, 28),
      status: 'Preparing',
    ),
    _TenantOrder(
      id: '#240603',
      customer: 'Jonathan Wijaya',
      unit: 'Unit 18-08',
      item: 'Croissant x1',
      amount: 64000,
      time: DateTime(2026, 6, 17, 10, 15),
      status: 'New',
    ),
    _TenantOrder(
      id: '#240604',
      customer: 'Dimas Putra',
      unit: 'Unit B-0911',
      item: 'Cappuccino x1, Latte x1',
      amount: 99000,
      time: DateTime(2026, 6, 17, 9, 55),
      status: 'Delivering',
      driverName: 'Raka',
      eta: '8 min',
    ),
    _TenantOrder(
      id: '#240605',
      customer: 'Maya Santoso',
      unit: 'Unit A-0912',
      item: 'Americano x1',
      amount: 28000,
      time: DateTime(2026, 6, 17, 9, 42),
      status: 'Completed',
      driverName: 'Budi',
      eta: 'Delivered',
    ),
    _TenantOrder(
      id: '#240606',
      customer: 'Reno Aditya',
      unit: 'Unit C-0710',
      item: 'Matcha Latte x1',
      amount: 42000,
      time: DateTime(2026, 6, 17, 9, 20),
      status: 'Rejected',
    ),
  ];

  List<_TenantOrder> get _filteredOrders {
    return _orders.where((order) {
      switch (_filter) {
        case 'New':
          return order.status == 'New';
        case 'Processing':
          return order.status == 'Accepted' || order.status == 'Preparing';
        case 'Ready':
          return order.status == 'Ready';
        case 'Delivery':
          return order.status == 'Delivering' || order.status == 'Delivered';
        case 'History':
          return order.status == 'Completed' || order.status == 'Rejected';
        case 'All':
        default:
          return order.status != 'Rejected';
      }
    }).toList();
  }

  void _updateOrder(
    int index,
    String status, {
    String? driverName,
    String? eta,
    bool preserveDriver = true,
  }) {
    setState(() {
      final current = _orders[index];
      _orders[index] = current.copyWith(
        status: status,
        driverName: preserveDriver
            ? (driverName ?? current.driverName)
            : driverName,
        eta: preserveDriver ? (eta ?? current.eta) : eta,
      );
    });
  }

  void _trackCourier(_TenantOrder order) {
    final driver = order.driverName ?? 'Courier';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Tracking courier $driver...')));
  }

  void _assignReadyOrders() {
    final readyIndexes = <int>[];
    for (var i = 0; i < _orders.length; i++) {
      if (_orders[i].status == 'Ready') {
        readyIndexes.add(i);
      }
    }

    if (readyIndexes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No ready orders to assign.')),
      );
      return;
    }

    setState(() {
      for (final index in readyIndexes) {
        _orders[index] = _orders[index].copyWith(
          status: 'Delivering',
          driverName: 'Budi',
          eta: '10 min',
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Courier assigned to ready orders.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _filteredOrders;
    final summary = {
      'New': _orders.where((order) => order.status == 'New').length,
      'Preparing': _orders.where((order) => order.status == 'Preparing').length,
      'Ready': _orders.where((order) => order.status == 'Ready').length,
      'Completed': _orders.where((order) => order.status == 'Completed').length,
    };

    return ColoredBox(
      color: _surface,
      child: ListView(
        key: const ValueKey('tenant-orders'),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 132),
        children: [
          const _OrdersIntroCard(),
          const SizedBox(height: 16),
          SizedBox(
            height: 142,
            child: ListView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              children: [
                _OrderSummaryCard(
                  icon: Icons.fiber_new_rounded,
                  iconColor: _gold,
                  iconBackground: _softAmber,
                  label: 'New',
                  value: '${summary['New']}',
                ),
                const SizedBox(width: 12),
                _OrderSummaryCard(
                  icon: Icons.coffee_outlined,
                  iconColor: _gold,
                  iconBackground: _softAmber,
                  label: 'Preparing',
                  value: '${summary['Preparing']}',
                ),
                const SizedBox(width: 12),
                _OrderSummaryCard(
                  icon: Icons.delivery_dining_outlined,
                  iconColor: _blue,
                  iconBackground: _softBlue,
                  label: 'Ready',
                  value: '${summary['Ready']}',
                ),
                const SizedBox(width: 12),
                _OrderSummaryCard(
                  icon: Icons.check_circle_outline,
                  iconColor: AppColors.success,
                  iconBackground: _softGreen,
                  label: 'Completed',
                  value: '${summary['Completed']}',
                ),
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
                  'New',
                  'Processing',
                  'Ready',
                  'Delivery',
                  'History',
                ]) ...[
                  _FilterChipButton(
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
          WhitePremiumCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            onTap: _assignReadyOrders,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _softBlue,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.assignment_ind_outlined,
                    color: _blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Assign Courier to Ready Orders',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: _navy,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: _gold),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (filteredOrders.isEmpty)
            WhitePremiumCard(
              padding: const EdgeInsets.all(18),
              child: Text(
                'No orders match this filter yet.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: _muted),
              ),
            )
          else
            for (final order in filteredOrders) ...[
              _TenantOrderCard(
                order: order,
                onAccept: () => _updateOrder(
                  _orders.indexOf(order),
                  'Accepted',
                  preserveDriver: false,
                ),
                onReject: () => _updateOrder(
                  _orders.indexOf(order),
                  'Rejected',
                  preserveDriver: false,
                ),
                onStartPreparing: () => _updateOrder(
                  _orders.indexOf(order),
                  'Preparing',
                  preserveDriver: false,
                ),
                onMarkReady: () => _updateOrder(
                  _orders.indexOf(order),
                  'Ready',
                  driverName: null,
                  eta: 'Waiting assignment',
                  preserveDriver: false,
                ),
                onAssignCourier: () => _updateOrder(
                  _orders.indexOf(order),
                  'Delivering',
                  driverName: 'Budi',
                  eta: '10 min',
                  preserveDriver: false,
                ),
                onTrack: () => _trackCourier(order),
                onMarkDelivered: () => _updateOrder(
                  _orders.indexOf(order),
                  'Delivered',
                  eta: 'Delivered',
                ),
                onComplete: () => _updateOrder(
                  _orders.indexOf(order),
                  'Completed',
                  eta: 'Delivered',
                ),
                onViewReceipt: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Receipt preview for ${order.id} will be added later.',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class _OrdersIntroCard extends StatelessWidget {
  const _OrdersIntroCard();

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(18),
      child: Stack(
        children: [
          Positioned(
            top: -18,
            right: -8,
            child: Container(
              width: 124,
              height: 124,
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
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Order Fulfillment',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: _navy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Manage resident orders from acceptance to delivery.',
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

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({
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
      width: 136,
      child: WhitePremiumCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 8),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: _navy,
                fontWeight: FontWeight.w900,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _muted,
                fontWeight: FontWeight.w600,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
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

class _TenantOrderCard extends StatelessWidget {
  const _TenantOrderCard({
    required this.order,
    required this.onAccept,
    required this.onReject,
    required this.onStartPreparing,
    required this.onMarkReady,
    required this.onAssignCourier,
    required this.onTrack,
    required this.onMarkDelivered,
    required this.onComplete,
    required this.onViewReceipt,
  });

  final _TenantOrder order;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onStartPreparing;
  final VoidCallback onMarkReady;
  final VoidCallback onAssignCourier;
  final VoidCallback onTrack;
  final VoidCallback onMarkDelivered;
  final VoidCallback onComplete;
  final VoidCallback onViewReceipt;

  bool get _showDeliverySection =>
      order.status == 'Ready' ||
      order.status == 'Delivering' ||
      order.status == 'Delivered';

  @override
  Widget build(BuildContext context) {
    final (badgeColor, badgeBackground) = _statusStyle(order.status);

    return WhitePremiumCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  order.id,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _navy,
                    fontWeight: FontWeight.w900,
                  ),
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
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                order.customer,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _navy,
                  fontWeight: FontWeight.w800,
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
                  border: Border.all(color: badgeColor.withValues(alpha: 0.18)),
                ),
                child: Text(
                  order.status,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: badgeColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            order.unit,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            order.item,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: _navy),
          ),
          const SizedBox(height: 6),
          Text(
            _currency.format(order.amount),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _navy,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (_showDeliverySection) ...[
            const SizedBox(height: 14),
            _DeliverySection(
              order: order,
              onAssignCourier: onAssignCourier,
              onTrack: onTrack,
            ),
          ],
          const SizedBox(height: 14),
          Wrap(spacing: 10, runSpacing: 10, children: _buildActions(context)),
        ],
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    switch (order.status) {
      case 'New':
        return [
          _FilledActionButton(
            label: 'Accept',
            color: AppColors.success,
            onTap: onAccept,
          ),
          _OutlinedActionButton(
            label: 'Reject',
            color: AppColors.danger,
            onTap: onReject,
          ),
        ];
      case 'Accepted':
        return [
          _FilledActionButton(
            label: 'Start Preparing',
            color: _gold,
            foreground: Colors.white,
            onTap: onStartPreparing,
          ),
        ];
      case 'Preparing':
        return [
          _FilledActionButton(
            label: 'Mark Ready',
            color: _gold,
            foreground: Colors.white,
            onTap: onMarkReady,
          ),
        ];
      case 'Ready':
        return [
          _FilledActionButton(
            label: 'Assign Courier',
            color: _navy,
            foreground: const Color(0xFFFFD98A),
            onTap: onAssignCourier,
          ),
        ];
      case 'Delivering':
        return [
          _OutlinedActionButton(label: 'Track', color: _blue, onTap: onTrack),
          _FilledActionButton(
            label: 'Mark Delivered',
            color: _blue,
            foreground: Colors.white,
            onTap: onMarkDelivered,
          ),
        ];
      case 'Delivered':
        return [
          _FilledActionButton(
            label: 'Complete Order',
            color: AppColors.success,
            onTap: onComplete,
          ),
        ];
      case 'Completed':
        return [
          _OutlinedActionButton(
            label: 'View Receipt',
            color: AppColors.success,
            onTap: onViewReceipt,
          ),
        ];
      case 'Rejected':
        return [
          Text(
            'Order was rejected.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.danger,
              fontWeight: FontWeight.w700,
            ),
          ),
        ];
      default:
        return const [];
    }
  }
}

class _DeliverySection extends StatelessWidget {
  const _DeliverySection({
    required this.order,
    required this.onAssignCourier,
    required this.onTrack,
  });

  final _TenantOrder order;
  final VoidCallback onAssignCourier;
  final VoidCallback onTrack;

  @override
  Widget build(BuildContext context) {
    final driverLabel = order.driverName ?? 'Not assigned';
    final etaLabel = order.status == 'Delivered'
        ? 'Delivered'
        : (order.eta ?? 'Waiting assignment');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _softBlue,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _blue.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: _blue.withValues(alpha: 0.10)),
                ),
                child: Icon(
                  order.driverName == null
                      ? Icons.person_search_outlined
                      : Icons.delivery_dining_outlined,
                  color: _blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Driver: $driverLabel',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _navy,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ETA: $etaLabel',
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
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _OutlinedActionButton(
                label: 'Track',
                color: _blue,
                onTap: order.driverName == null ? null : onTrack,
              ),
              _FilledActionButton(
                label: order.driverName == null
                    ? 'Assign Courier'
                    : 'Assign Courier',
                color: _navy,
                foreground: const Color(0xFFFFD98A),
                onTap: order.status == 'Ready' ? onAssignCourier : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilledActionButton extends StatelessWidget {
  const _FilledActionButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.foreground = Colors.white,
  });

  final String label;
  final Color color;
  final Color foreground;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: foreground,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  const _OutlinedActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        side: BorderSide(color: color.withValues(alpha: 0.30)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}

class _TenantOrder {
  const _TenantOrder({
    required this.id,
    required this.customer,
    required this.unit,
    required this.item,
    required this.amount,
    required this.time,
    required this.status,
    this.driverName,
    this.eta,
  });

  final String id;
  final String customer;
  final String unit;
  final String item;
  final int amount;
  final DateTime time;
  final String status;
  final String? driverName;
  final String? eta;

  _TenantOrder copyWith({String? status, String? driverName, String? eta}) {
    return _TenantOrder(
      id: id,
      customer: customer,
      unit: unit,
      item: item,
      amount: amount,
      time: time,
      status: status ?? this.status,
      driverName: driverName ?? this.driverName,
      eta: eta ?? this.eta,
    );
  }
}

(Color, Color) _statusStyle(String status) {
  return switch (status) {
    'Accepted' => (AppColors.success, _softGreen),
    'Preparing' => (_gold, _softAmber),
    'Ready' => (_blue, _softBlue),
    'Delivering' => (_blue, _softBlue),
    'Delivered' => (_blue, _softBlue),
    'Completed' => (AppColors.success, _softGreen),
    'Rejected' => (AppColors.danger, _softRed),
    _ => (_gold, _softAmber),
  };
}

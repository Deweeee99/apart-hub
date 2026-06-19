import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const marketplaceSurface = Color(0xFFF8F5EF);
const marketplaceNavy = Color(0xFF071B34);
const marketplaceBlue = Color(0xFF173A67);
const marketplaceGold = Color(0xFFC08A1A);
const marketplaceSoftGold = Color(0xFFFFF6DF);
const marketplaceMuted = Color(0xFF687184);
const marketplaceLine = Color(0xFFE7DFD1);

final marketplaceCurrency = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);
final marketplaceDateTime = DateFormat('dd MMM yyyy, hh:mm a', 'id_ID');

class MarketplaceTenant {
  const MarketplaceTenant({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.rating,
    required this.deliveryEta,
    required this.iconKey,
    required this.open,
  });

  final String id;
  final String name;
  final String category;
  final String location;
  final double rating;
  final String deliveryEta;
  final String iconKey;
  final bool open;
}

class MarketplaceProduct {
  const MarketplaceProduct({
    required this.id,
    required this.tenantId,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.imageKey,
    required this.available,
    required this.bestSeller,
  });

  final String id;
  final String tenantId;
  final String name;
  final String description;
  final String category;
  final int price;
  final String imageKey;
  final bool available;
  final bool bestSeller;
}

class MarketplaceCartItem {
  const MarketplaceCartItem({
    required this.product,
    this.quantity = 1,
    this.sizeLabel = 'Regular',
  });

  final MarketplaceProduct product;
  final int quantity;
  final String sizeLabel;

  int get total => product.price * quantity;

  MarketplaceCartItem copyWith({
    MarketplaceProduct? product,
    int? quantity,
    String? sizeLabel,
  }) {
    return MarketplaceCartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      sizeLabel: sizeLabel ?? this.sizeLabel,
    );
  }
}

class MarketplaceOrderFlowData {
  const MarketplaceOrderFlowData({
    required this.orderId,
    required this.tenant,
    required this.items,
    required this.orderTime,
    required this.deliveryTo,
    required this.deliveryOption,
    this.notes = '',
    this.paymentMethod = 'E-Wallet',
    this.status = 'Preparing',
    this.estimatedTime = '15 - 20 min',
    this.riderName = 'Andi',
    this.riderEta = '10 mins',
  });

  final String orderId;
  final MarketplaceTenant tenant;
  final List<MarketplaceCartItem> items;
  final DateTime orderTime;
  final String deliveryTo;
  final String deliveryOption;
  final String notes;
  final String paymentMethod;
  final String status;
  final String estimatedTime;
  final String riderName;
  final String riderEta;

  int get subtotal => items.fold<int>(0, (total, item) => total + item.total);
  int get deliveryFee => deliveryOption == 'Deliver to Unit' ? 5000 : 0;
  int get total => subtotal + deliveryFee;
  String get itemSummary =>
      items.map((item) => '${item.product.name} (${item.quantity})').join(', ');

  MarketplaceOrderFlowData copyWith({
    String? paymentMethod,
    String? status,
    String? estimatedTime,
    String? riderName,
    String? riderEta,
  }) {
    return MarketplaceOrderFlowData(
      orderId: orderId,
      tenant: tenant,
      items: items,
      orderTime: orderTime,
      deliveryTo: deliveryTo,
      deliveryOption: deliveryOption,
      notes: notes,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      riderName: riderName ?? this.riderName,
      riderEta: riderEta ?? this.riderEta,
    );
  }
}

class MarketplaceOrderHistory {
  const MarketplaceOrderHistory({
    required this.orderId,
    required this.tenantName,
    required this.itemSummary,
    required this.total,
    required this.status,
    required this.date,
  });

  final String orderId;
  final String tenantName;
  final String itemSummary;
  final int total;
  final String status;
  final String date;
}

IconData marketplaceIconForKey(String key) {
  return switch (key) {
    'coffee' => Icons.local_cafe_outlined,
    'pastry' => Icons.bakery_dining_outlined,
    'market' => Icons.storefront_outlined,
    'laundry' => Icons.local_laundry_service_outlined,
    'beauty' => Icons.content_cut_outlined,
    _ => Icons.storefront_outlined,
  };
}

IconData marketplacePromoIconForKey(String key) {
  return switch (key) {
    'laundry' => Icons.local_laundry_service_outlined,
    'market' => Icons.shopping_bag_outlined,
    _ => Icons.local_cafe_outlined,
  };
}

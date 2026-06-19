class TenantProductDummy {
  const TenantProductDummy({
    required this.name,
    required this.category,
    required this.price,
    required this.active,
    required this.iconKey,
    this.bestSeller = false,
  });

  final String name;
  final String category;
  final int price;
  final bool active;
  final bool bestSeller;
  final String iconKey;
}

class TenantPromoDummy {
  const TenantPromoDummy({
    required this.title,
    required this.description,
    required this.status,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.iconKey,
  });

  final String title;
  final String description;
  final String status;
  final String category;
  final String startDate;
  final String endDate;
  final String iconKey;
}

class TenantMerchantProfileDummy {
  const TenantMerchantProfileDummy({
    required this.name,
    required this.category,
    required this.location,
    required this.operatingHours,
    required this.phone,
    required this.rating,
    required this.reviewCount,
    required this.status,
    required this.visibility,
    required this.description,
  });

  final String name;
  final String category;
  final String location;
  final String operatingHours;
  final String phone;
  final double rating;
  final int reviewCount;
  final String status;
  final String visibility;
  final String description;
}

class MarketplaceTenantDummy {
  const MarketplaceTenantDummy({
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

class MarketplaceProductDummy {
  const MarketplaceProductDummy({
    required this.id,
    required this.tenantId,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.imageKey,
    required this.available,
    this.bestSeller = false,
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

class MarketplaceOrderHistoryDummy {
  const MarketplaceOrderHistoryDummy({
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

class DataDummy {
  const DataDummy._();

  static const tenantProducts = [
    TenantProductDummy(
      name: 'Cappuccino',
      category: 'Coffee',
      price: 32000,
      active: true,
      bestSeller: true,
      iconKey: 'coffee',
    ),
    TenantProductDummy(
      name: 'Latte',
      category: 'Coffee',
      price: 35000,
      active: true,
      iconKey: 'coffee',
    ),
    TenantProductDummy(
      name: 'Croissant',
      category: 'Pastry',
      price: 64000,
      active: true,
      iconKey: 'pastry',
    ),
    TenantProductDummy(
      name: 'Happy Hour Coffee',
      category: 'Coffee',
      price: 45000,
      active: true,
      iconKey: 'coffee',
    ),
    TenantProductDummy(
      name: 'Coffee Day',
      category: 'Beverage',
      price: 55000,
      active: false,
      iconKey: 'beverage',
    ),
    TenantProductDummy(
      name: 'Matcha Latte',
      category: 'Beverage',
      price: 42000,
      active: true,
      iconKey: 'beverage',
    ),
    TenantProductDummy(
      name: 'Americano',
      category: 'Coffee',
      price: 28000,
      active: true,
      iconKey: 'coffee',
    ),
  ];

  static const tenantPromos = [
    TenantPromoDummy(
      title: 'Happy Hour Coffee',
      description: '20% off all hot coffee from 2 PM - 4 PM.',
      status: 'Active',
      category: 'Coffee',
      startDate: '',
      endDate: 'Jun 30, 2026',
      iconKey: 'discount',
    ),
    TenantPromoDummy(
      title: 'Weekend Pastry Combo',
      description: 'Get a free croissant with any two latte purchases.',
      status: 'Active',
      category: 'Pastry',
      startDate: '',
      endDate: 'Jul 15, 2026',
      iconKey: 'gift',
    ),
    TenantPromoDummy(
      title: 'Morning Latte Deal',
      description: 'Special latte bundle for morning residents.',
      status: 'Scheduled',
      category: 'Beverage',
      startDate: 'Jul 01, 2026',
      endDate: 'Jul 10, 2026',
      iconKey: 'schedule',
    ),
    TenantPromoDummy(
      title: 'Coffee Day Bundle',
      description: 'Buy 2 cappuccinos and get 1 americano.',
      status: 'Scheduled',
      category: 'Coffee',
      startDate: 'Jul 05, 2026',
      endDate: 'Jul 12, 2026',
      iconKey: 'campaign',
    ),
    TenantPromoDummy(
      title: 'New Year Coffee Package',
      description: 'Seasonal coffee package for residents.',
      status: 'Past',
      category: 'Coffee',
      startDate: '',
      endDate: 'Jan 10, 2026',
      iconKey: 'history',
    ),
  ];

  static const tenantMerchantProfile = TenantMerchantProfileDummy(
    name: 'Brew Cabin Coffee',
    category: 'Cafe & Beverages',
    location: 'Lobby Floor',
    operatingHours: '08:00 - 22:00',
    phone: '0812-3456-7890',
    rating: 4.8,
    reviewCount: 120,
    status: 'Active',
    visibility: 'Online',
    description:
        'Premium coffee corner for residents, serving daily beverages and pastries.',
  );

  static const marketplaceTenants = [
    MarketplaceTenantDummy(
      id: 'brew-cabin',
      name: 'Brew Cabin',
      category: 'Coffee Shop',
      location: 'Lobby Floor',
      rating: 4.8,
      deliveryEta: '10-15 min',
      iconKey: 'coffee',
      open: true,
    ),
    MarketplaceTenantDummy(
      id: 'quick-wash',
      name: 'Quick Wash',
      category: 'Laundry',
      location: 'Tower A Ground',
      rating: 4.7,
      deliveryEta: 'Pickup today',
      iconKey: 'laundry',
      open: true,
    ),
    MarketplaceTenantDummy(
      id: 'freshmart',
      name: 'FreshMart',
      category: 'Minimarket',
      location: 'Retail Arcade',
      rating: 4.6,
      deliveryEta: '15-20 min',
      iconKey: 'market',
      open: true,
    ),
    MarketplaceTenantDummy(
      id: 'beauty-salon',
      name: 'Beauty & Salon',
      category: 'Beauty & Salon',
      location: 'Level 2',
      rating: 4.5,
      deliveryEta: 'Appointment',
      iconKey: 'beauty',
      open: false,
    ),
  ];

  static const marketplaceProducts = [
    MarketplaceProductDummy(
      id: 'brew-cap',
      tenantId: 'brew-cabin',
      name: 'Cappuccino',
      description: 'Rich espresso with steamed milk foam.',
      category: 'Coffee',
      price: 32000,
      imageKey: 'coffee',
      available: true,
      bestSeller: true,
    ),
    MarketplaceProductDummy(
      id: 'brew-latte',
      tenantId: 'brew-cabin',
      name: 'Latte',
      description: 'Smooth coffee with creamy milk.',
      category: 'Coffee',
      price: 35000,
      imageKey: 'coffee',
      available: true,
    ),
    MarketplaceProductDummy(
      id: 'brew-croissant',
      tenantId: 'brew-cabin',
      name: 'Croissant',
      description: 'Butter pastry baked fresh daily.',
      category: 'Pastry',
      price: 64000,
      imageKey: 'pastry',
      available: true,
    ),
    MarketplaceProductDummy(
      id: 'brew-americano',
      tenantId: 'brew-cabin',
      name: 'Americano',
      description: 'Classic black coffee.',
      category: 'Coffee',
      price: 28000,
      imageKey: 'coffee',
      available: true,
    ),
    MarketplaceProductDummy(
      id: 'qw-express',
      tenantId: 'quick-wash',
      name: 'Express Laundry',
      description: 'Same-day washing service for busy residents.',
      category: 'Laundry',
      price: 45000,
      imageKey: 'laundry',
      available: true,
    ),
    MarketplaceProductDummy(
      id: 'qw-ironing',
      tenantId: 'quick-wash',
      name: 'Premium Ironing',
      description: 'Crisp finishing for workwear and linens.',
      category: 'Laundry',
      price: 25000,
      imageKey: 'laundry',
      available: true,
    ),
    MarketplaceProductDummy(
      id: 'fm-water',
      tenantId: 'freshmart',
      name: 'Mineral Water',
      description: 'Chilled bottled water for your everyday needs.',
      category: 'Essentials',
      price: 8000,
      imageKey: 'market',
      available: true,
    ),
    MarketplaceProductDummy(
      id: 'fm-snack',
      tenantId: 'freshmart',
      name: 'Snack Bundle',
      description: 'Popular sweet and savory snacks in one bundle.',
      category: 'Essentials',
      price: 22000,
      imageKey: 'market',
      available: true,
    ),
  ];

  static const marketplaceOrderHistory = [
    MarketplaceOrderHistoryDummy(
      orderId: '#MC-070624-001',
      tenantName: 'Brew Cabin',
      itemSummary: 'Cappuccino',
      total: 37000,
      status: 'Completed',
      date: '07 Jun 2026',
    ),
    MarketplaceOrderHistoryDummy(
      orderId: '#MC-070624-002',
      tenantName: 'Quick Wash',
      itemSummary: 'Express Laundry',
      total: 45000,
      status: 'Processing',
      date: '08 Jun 2026',
    ),
  ];
}

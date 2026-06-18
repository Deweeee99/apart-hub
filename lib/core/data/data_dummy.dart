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
}

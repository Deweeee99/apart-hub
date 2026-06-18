import '../models/app_models.dart';

class DemoData {
  const DemoData._();

  static final today = DateTime(2026, 6, 4);

  static const residentUnit = Unit(
    tower: 'Tower A',
    number: '18-08',
    floor: 18,
    status: 'Owner Occupied',
  );

  static const primaryResident = Resident(
    name: 'Jonathan Wijaya',
    phone: '+62 812 8800 1808',
    email: 'jonathan.wijaya@email.com',
    unit: residentUnit,
    residencyStatus: 'Owner',
    billingStatus: 'Paid',
    accessStatus: 'Active',
  );

  static const residents = [
    primaryResident,
    Resident(
      name: 'Amelia Tan',
      phone: '+62 813 2290 2201',
      email: 'amelia.tan@email.com',
      unit: Unit(
        tower: 'Tower B',
        number: '22-01',
        floor: 22,
        status: 'Leased',
      ),
      residencyStatus: 'Tenant',
      billingStatus: 'Waiting Payment',
      accessStatus: 'Active',
    ),
    Resident(
      name: 'Richard Halim',
      phone: '+62 817 4400 0909',
      email: 'richard.halim@email.com',
      unit: Unit(
        tower: 'Tower C',
        number: '09-09',
        floor: 9,
        status: 'Owner Occupied',
      ),
      residencyStatus: 'Owner',
      billingStatus: 'Overdue',
      accessStatus: 'Limited',
    ),
  ];

  static final billings = [
    Billing(
      id: 'INV-IPL-0626',
      category: 'IPL',
      amount: 1850000,
      dueDate: DateTime(2026, 6, 12),
      status: 'Waiting Payment',
    ),
    Billing(
      id: 'INV-WTR-0626',
      category: 'Air',
      amount: 420000,
      dueDate: DateTime(2026, 6, 12),
      status: 'Paid',
    ),
    Billing(
      id: 'INV-ELC-0626',
      category: 'Listrik',
      amount: 600000,
      dueDate: DateTime(2026, 6, 12),
      status: 'Waiting Payment',
    ),
    Billing(
      id: 'INV-PRK-0626',
      category: 'Parkir',
      amount: 400000,
      dueDate: DateTime(2026, 6, 18),
      status: 'Overdue',
    ),
  ];

  static final visitors = [
    VisitorPass(
      code: 'VIS-A1808-2026-001',
      name: 'Michael Tan',
      phone: '+62 812 2211 0077',
      unit: 'Tower A / 18-08',
      visitTime: DateTime(2026, 6, 5, 19),
      purpose: 'Family Visit',
      status: 'Upcoming',
    ),
    VisitorPass(
      code: 'VIS-A1808-2026-002',
      name: 'Nadia Courier',
      phone: '+62 858 4433 1200',
      unit: 'Tower A / 18-08',
      visitTime: DateTime(2026, 6, 4, 16, 30),
      purpose: 'Delivery',
      status: 'Used',
    ),
    VisitorPass(
      code: 'VIS-A1808-2026-003',
      name: 'Alvin Hartono',
      phone: '+62 811 9077 1900',
      unit: 'Tower A / 18-08',
      visitTime: DateTime(2026, 6, 1, 11),
      purpose: 'Business',
      status: 'Expired',
    ),
  ];

  static final securityVisitorPasses = [
    SecurityVisitorPass(
      code: 'VST-2026-00125',
      visitorName: 'Ahmad Wijaya',
      visitorType: 'Guest',
      residentName: 'Rizky Pratama',
      unit: 'A-1203',
      phoneNumber: '0812 3456 7890',
      vehicleNumber: 'B 1234 XYZ',
      startTime: DateTime(2026, 5, 20, 10),
      endTime: DateTime(2026, 5, 20, 14),
      status: 'Valid',
    ),
    SecurityVisitorPass(
      code: 'VST-2026-00126',
      visitorName: 'Maya Santoso',
      visitorType: 'Family',
      residentName: 'Jonathan Wijaya',
      unit: 'A-1808',
      phoneNumber: '0813 2200 1188',
      vehicleNumber: 'B 8080 MAY',
      startTime: DateTime(2026, 5, 18, 9),
      endTime: DateTime(2026, 5, 18, 12),
      status: 'Expired',
    ),
    SecurityVisitorPass(
      code: 'VST-2026-00127',
      visitorName: 'Dimas Putra',
      visitorType: 'Technician',
      residentName: 'Amelia Tan',
      unit: 'B-2201',
      phoneNumber: '0817 4444 2201',
      vehicleNumber: 'B 2290 TAN',
      startTime: DateTime(2026, 5, 20, 13),
      endTime: DateTime(2026, 5, 20, 16),
      status: 'Checked In',
    ),
    SecurityVisitorPass(
      code: 'VST-2026-00128',
      visitorName: 'Reno Aditya',
      visitorType: 'Vendor',
      residentName: 'Richard Halim',
      unit: 'C-0909',
      phoneNumber: '0818 9900 0909',
      vehicleNumber: 'B 1900 RNO',
      startTime: DateTime(2026, 5, 19, 15),
      endTime: DateTime(2026, 5, 19, 17),
      status: 'Denied',
    ),
  ];

  static final securityAccessLogs = [
    SecurityAccessLog(
      visitorName: 'Ahmad Wijaya',
      unit: 'A-1203',
      timestamp: DateTime(2026, 5, 20, 9, 52),
      status: 'Valid',
      code: 'VST-2026-00125',
    ),
    SecurityAccessLog(
      visitorName: 'Dimas Putra',
      unit: 'B-2201',
      timestamp: DateTime(2026, 5, 20, 13, 18),
      status: 'Checked In',
      code: 'VST-2026-00127',
    ),
    SecurityAccessLog(
      visitorName: 'Reno Aditya',
      unit: 'C-0909',
      timestamp: DateTime(2026, 5, 19, 15, 6),
      status: 'Denied',
      code: 'VST-2026-00128',
    ),
    SecurityAccessLog(
      visitorName: 'Maya Santoso',
      unit: 'A-1808',
      timestamp: DateTime(2026, 5, 18, 12, 20),
      status: 'Expired',
      code: 'VST-2026-00126',
    ),
  ];

  static const tickets = [
    ServiceTicket(
      id: 'SR-2401',
      category: 'AC Rusak',
      title: 'AC master bedroom tidak dingin',
      description: 'Unit indoor menyala tetapi udara tidak keluar dingin.',
      priority: 'High',
      status: 'Progress',
      assignee: 'Budi - Engineering',
    ),
    ServiceTicket(
      id: 'SR-2402',
      category: 'Plumbing',
      title: 'Keran dapur bocor',
      description: 'Air menetes sejak pagi.',
      priority: 'Medium',
      status: 'Assigned',
      assignee: 'Rama - Plumbing',
    ),
    ServiceTicket(
      id: 'SR-2403',
      category: 'Internet',
      title: 'WiFi lobby tidak stabil',
      description: 'Koneksi terputus saat bekerja dari lounge.',
      priority: 'Low',
      status: 'Done',
      assignee: 'NOC Team',
    ),
  ];

  static final packages = [
    PackageDelivery(
      id: 'PKG-8841',
      sender: 'Tokopedia',
      courier: 'JNE',
      arrivalTime: DateTime(2026, 6, 4, 13, 10),
      status: 'Waiting Pickup',
      pickupCode: 'A1808-8841',
    ),
    PackageDelivery(
      id: 'PKG-8842',
      sender: 'Zara Home',
      courier: 'DHL',
      arrivalTime: DateTime(2026, 6, 4, 15, 45),
      status: 'Waiting Pickup',
      pickupCode: 'A1808-8842',
    ),
    PackageDelivery(
      id: 'PKG-8770',
      sender: 'Apple Store',
      courier: 'GrabExpress',
      arrivalTime: DateTime(2026, 6, 3, 18, 5),
      status: 'Waiting Pickup',
      pickupCode: 'A1808-8770',
    ),
    PackageDelivery(
      id: 'PKG-8701',
      sender: 'IKEA',
      courier: 'SiCepat',
      arrivalTime: DateTime(2026, 6, 2, 10, 25),
      status: 'Picked Up',
      pickupCode: 'A1808-8701',
    ),
  ];

  static final bookings = [
    FacilityBooking(
      id: 'BK-1001',
      facility: 'Gym',
      date: DateTime(2026, 6, 6),
      slot: '07:00 - 08:00',
      status: 'Approved',
      residentName: 'Jonathan Wijaya',
    ),
    FacilityBooking(
      id: 'BK-1002',
      facility: 'Function Hall',
      date: DateTime(2026, 6, 9),
      slot: '19:00 - 22:00',
      status: 'Waiting Approval',
      residentName: 'Amelia Tan',
    ),
    FacilityBooking(
      id: 'BK-1003',
      facility: 'Tennis Court',
      date: DateTime(2026, 6, 7),
      slot: '16:00 - 17:00',
      status: 'Rejected',
      residentName: 'Richard Halim',
    ),
  ];

  static final announcements = [
    Announcement(
      title: 'Pool maintenance on Sunday',
      category: 'Maintenance',
      message:
          'Pool area will be closed from 08:00 to 14:00 for monthly treatment.',
      publishedAt: DateTime(2026, 6, 4, 9),
    ),
    Announcement(
      title: 'Resident Gathering Night',
      category: 'Event',
      message: 'Join the rooftop dinner reception this Saturday at 19:00.',
      publishedAt: DateTime(2026, 6, 3, 17),
    ),
    Announcement(
      title: 'Fire drill schedule',
      category: 'Emergency',
      message: 'Tower A evacuation drill starts at 10:00 next Tuesday.',
      publishedAt: DateTime(2026, 6, 2, 10),
    ),
  ];

  static const communityPosts = [
    CommunityPost(
      title: 'Rekomendasi cleaning service?',
      category: 'Forum',
      author: 'Amelia Tan',
      description:
          'Butuh rekomendasi vendor untuk deep cleaning setelah renovasi minor.',
    ),
    CommunityPost(
      title: 'Car free day community this weekend',
      category: 'Forum',
      author: 'Rooftop Club',
      description: 'Start jam 06:00 dari lobby utama.',
    ),
    CommunityPost(
      title: 'Sofa minimalis',
      category: 'Marketplace',
      author: 'Richard Halim',
      description: 'Sofa 2-seater warna abu, kondisi 95%, Rp 2.500.000.',
    ),
    CommunityPost(
      title: 'Baby stroller',
      category: 'Marketplace',
      author: 'Nadia',
      description: 'Stroller travel compact, jarang dipakai.',
    ),
    CommunityPost(
      title: 'Kunci mobil ditemukan di lobby',
      category: 'Lost & Found',
      author: 'Concierge',
      description: 'Silakan ambil di front desk dengan bukti kepemilikan.',
    ),
    CommunityPost(
      title: 'Dompet hilang area basement',
      category: 'Lost & Found',
      author: 'Jonathan Wijaya',
      description: 'Dompet hitam terakhir terlihat di Basement B1.',
    ),
    CommunityPost(
      title: 'Yoga Morning Session',
      category: 'Events',
      author: 'Wellness Team',
      description: 'Every Sunday, 07:00 at Sky Garden.',
    ),
    CommunityPost(
      title: 'Resident Gathering Night',
      category: 'Events',
      author: 'Management Office',
      description: 'Rooftop dinner and live acoustic session.',
    ),
  ];

  static const communityAnnouncements = [
    CommunityAnnouncementItem(
      title: 'Maintenance Notice',
      message:
          'Elevator maintenance will be conducted on 07 Jun 2026, 10:00 - 14:00.',
      fullMessage:
          'Management will conduct preventive elevator maintenance on 07 Jun 2026 from 10:00 to 14:00. Please use the service elevator during the maintenance window and plan your activities accordingly.',
      category: 'Maintenance',
      date: '05 Jun 2026',
      priority: 'Important',
      iconType: 'maintenance',
      affectedArea: 'Tower A residential elevator',
      actionNote: 'Use service elevator and allow additional travel time.',
    ),
    CommunityAnnouncementItem(
      title: 'Water Shutdown',
      message:
          'Water supply will be temporarily unavailable on 06 Jun 2026, 22:00 - 04:00.',
      fullMessage:
          'A scheduled water system inspection will require temporary water shutdown from 06 Jun 2026 at 22:00 until 07 Jun 2026 at 04:00.',
      category: 'Important',
      date: '04 Jun 2026',
      priority: 'Important',
      iconType: 'water',
      affectedArea: 'Tower A and Tower B',
      actionNote: 'Store enough water before the maintenance window.',
    ),
    CommunityAnnouncementItem(
      title: 'Facility Closure',
      message: 'Swimming Pool will be closed on 08 Jun 2026 for maintenance.',
      fullMessage:
          'The swimming pool and pool deck will be closed for monthly deep cleaning and water treatment on 08 Jun 2026.',
      category: 'Maintenance',
      date: '04 Jun 2026',
      priority: 'General',
      iconType: 'pool',
      affectedArea: 'Swimming Pool, Level 5',
      actionNote: 'Facility access resumes after management approval.',
    ),
    CommunityAnnouncementItem(
      title: 'Fire Drill Notice',
      message: 'Tower A evacuation drill starts at 10:00 next Tuesday.',
      fullMessage:
          'Residents are invited to participate in a fire evacuation drill to improve emergency readiness across Tower A.',
      category: 'Important',
      date: '02 Jun 2026',
      priority: 'Important',
      iconType: 'fire',
      affectedArea: 'Tower A',
      actionNote: 'Follow security team instructions during the drill.',
    ),
    CommunityAnnouncementItem(
      title: 'Building Cleaning',
      message: 'Facade and corridor cleaning will run from 09-12 Jun 2026.',
      fullMessage:
          'Routine cleaning will be performed in shared corridors, lift lobbies, and selected facade areas from 09-12 Jun 2026.',
      category: 'General',
      date: '01 Jun 2026',
      priority: 'General',
      iconType: 'cleaning',
      affectedArea: 'Shared corridors and facade',
      actionNote: 'Keep personal items away from corridor areas.',
    ),
    CommunityAnnouncementItem(
      title: 'Ramadan Event',
      message: 'Resident iftar gathering will be held at the Sky Lounge.',
      fullMessage:
          'Management invites residents to a community iftar gathering with light dinner and acoustic entertainment at Sky Lounge.',
      category: 'General',
      date: '20 May 2026',
      priority: 'General',
      iconType: 'event',
      affectedArea: 'Sky Lounge',
      actionNote: 'Register interest through the community office.',
    ),
  ];

  static const communityEvents = [
    CommunityEventItem(
      title: 'Yoga Class',
      description: 'Morning wellness session for residents of all levels.',
      date: '14 Jun 2026',
      time: '07:00 - 08:00',
      location: 'Sky Lounge, Level 20',
      host: 'Wellness Team',
      capacity: '24 residents',
      status: 'Upcoming',
      iconType: 'wellness',
    ),
    CommunityEventItem(
      title: 'Community Gathering',
      description:
          'Casual gathering with refreshments and resident networking.',
      date: '21 Jun 2026',
      time: '16:00 - 18:00',
      location: 'Function Room',
      host: 'Management Office',
      capacity: '60 residents',
      status: 'Upcoming',
      iconType: 'gathering',
    ),
    CommunityEventItem(
      title: 'Kids Activity',
      description: 'Creative workshop and supervised games for children.',
      date: '28 Jun 2026',
      time: '10:00 - 12:00',
      location: 'Kids Room, Level 5',
      host: 'Family Club',
      capacity: '18 children',
      status: 'Ongoing',
      iconType: 'kids',
    ),
    CommunityEventItem(
      title: 'Blood Donation',
      description: 'Community health drive in partnership with local clinic.',
      date: '18 May 2026',
      time: '09:00 - 13:00',
      location: 'Main Lobby',
      host: 'Health Partner',
      capacity: '80 donors',
      status: 'Past',
      iconType: 'health',
    ),
    CommunityEventItem(
      title: 'Ramadan Event',
      description: 'Community iftar and evening gathering at Sky Lounge.',
      date: '20 May 2026',
      time: '17:30 - 20:00',
      location: 'Sky Lounge',
      host: 'Management Office',
      capacity: '90 residents',
      status: 'Past',
      iconType: 'ramadan',
    ),
  ];

  static const communityArchive = [
    CommunityArchiveItem(
      title: 'Fire Drill Notice',
      date: '28 May 2026',
      category: 'Announcements',
      summary: 'Emergency readiness announcement for Tower A residents.',
      iconType: 'fire',
    ),
    CommunityArchiveItem(
      title: 'Gym Closure',
      date: '25 May 2026',
      category: 'Announcements',
      summary: 'Temporary gym closure for equipment maintenance.',
      iconType: 'gym',
    ),
    CommunityArchiveItem(
      title: 'Ramadan Event',
      date: '20 May 2026',
      category: 'Events',
      summary: 'Community iftar gathering recap and attendance notes.',
      iconType: 'ramadan',
    ),
    CommunityArchiveItem(
      title: 'Blood Donation',
      date: '18 May 2026',
      category: 'Events',
      summary: 'Health drive event recap with resident participation.',
      iconType: 'health',
    ),
    CommunityArchiveItem(
      title: 'Building Cleaning',
      date: '16 May 2026',
      category: 'Forum',
      summary: 'Resident discussion about corridor and facade cleaning.',
      iconType: 'cleaning',
    ),
  ];

  static const incidents = [
    SecurityIncident(
      id: 'INC-2401',
      category: 'Kehilangan',
      location: 'Lobby',
      description: 'Resident melaporkan kehilangan kartu akses.',
      severity: 'Medium',
      status: 'Under Review',
    ),
    SecurityIncident(
      id: 'INC-2402',
      category: 'Kerusakan fasilitas',
      location: 'Gym',
      description: 'Handle treadmill kanan longgar.',
      severity: 'Low',
      status: 'Resolved',
    ),
  ];

  static const checkpoints = [
    PatrolCheckpoint(
      name: 'Lobby',
      area: 'Ground Floor',
      status: 'Checked',
      note: 'Clear',
    ),
    PatrolCheckpoint(
      name: 'Basement B1',
      area: 'Parking',
      status: 'Pending',
      note: 'Next route',
    ),
    PatrolCheckpoint(
      name: 'Pool Area',
      area: 'Amenity',
      status: 'Pending',
      note: 'Photo required',
    ),
    PatrolCheckpoint(
      name: 'Gym',
      area: 'Amenity',
      status: 'Checked',
      note: 'Equipment normal',
    ),
    PatrolCheckpoint(
      name: 'Rooftop',
      area: 'Sky Garden',
      status: 'Pending',
      note: 'Windy area',
    ),
  ];

  static const tenant = TenantMerchant(
    name: 'Meikarta Laundry & Care',
    category: 'Laundry',
    hours: '08:00 - 21:00',
    contact: '+62 821 4400 7788',
    status: 'Active',
    rating: 4.8,
  );

  static const tenants = [
    tenant,
    TenantMerchant(
      name: 'Sky Bento',
      category: 'Food & Beverage',
      hours: '10:00 - 22:00',
      contact: '+62 821 2233 0011',
      status: 'Active',
      rating: 4.6,
    ),
    TenantMerchant(
      name: 'Fresh Mini Market',
      category: 'Mini Market',
      hours: '07:00 - 23:00',
      contact: '+62 821 9933 4422',
      status: 'Active',
      rating: 4.5,
    ),
  ];

  static final merchantOrders = [
    MerchantOrder(
      id: 'ORD-9001',
      customer: 'Jonathan Wijaya',
      item: 'Premium laundry 8kg',
      amount: 168000,
      status: 'New',
      requestTime: DateTime(2026, 6, 4, 9, 15),
    ),
    MerchantOrder(
      id: 'ORD-9002',
      customer: 'Amelia Tan',
      item: 'Express ironing',
      amount: 82000,
      status: 'Preparing',
      requestTime: DateTime(2026, 6, 4, 11, 45),
    ),
    MerchantOrder(
      id: 'ORD-8998',
      customer: 'Richard Halim',
      item: 'Dry clean suit',
      amount: 215000,
      status: 'Completed',
      requestTime: DateTime(2026, 6, 3, 18, 20),
    ),
  ];
}

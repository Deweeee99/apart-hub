enum UserRole { resident, management, security, tenant }

class Unit {
  const Unit({
    required this.tower,
    required this.number,
    required this.floor,
    required this.status,
  });

  final String tower;
  final String number;
  final int floor;
  final String status;

  String get label => '$tower / $number';
}

class Resident {
  const Resident({
    required this.name,
    required this.phone,
    required this.email,
    required this.unit,
    required this.residencyStatus,
    required this.billingStatus,
    required this.accessStatus,
  });

  final String name;
  final String phone;
  final String email;
  final Unit unit;
  final String residencyStatus;
  final String billingStatus;
  final String accessStatus;
}

class Billing {
  const Billing({
    required this.id,
    required this.category,
    required this.amount,
    required this.dueDate,
    required this.status,
  });

  final String id;
  final String category;
  final int amount;
  final DateTime dueDate;
  final String status;

  Billing copyWith({String? status}) {
    return Billing(
      id: id,
      category: category,
      amount: amount,
      dueDate: dueDate,
      status: status ?? this.status,
    );
  }
}

class VisitorPass {
  const VisitorPass({
    required this.code,
    required this.name,
    required this.phone,
    required this.unit,
    required this.visitTime,
    required this.purpose,
    required this.status,
  });

  final String code;
  final String name;
  final String phone;
  final String unit;
  final DateTime visitTime;
  final String purpose;
  final String status;

  VisitorPass copyWith({String? status}) {
    return VisitorPass(
      code: code,
      name: name,
      phone: phone,
      unit: unit,
      visitTime: visitTime,
      purpose: purpose,
      status: status ?? this.status,
    );
  }
}

class ServiceTicket {
  const ServiceTicket({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.assignee,
  });

  final String id;
  final String category;
  final String title;
  final String description;
  final String priority;
  final String status;
  final String assignee;

  ServiceTicket copyWith({String? status, String? assignee}) {
    return ServiceTicket(
      id: id,
      category: category,
      title: title,
      description: description,
      priority: priority,
      status: status ?? this.status,
      assignee: assignee ?? this.assignee,
    );
  }
}

class PackageDelivery {
  const PackageDelivery({
    required this.id,
    required this.sender,
    required this.courier,
    required this.arrivalTime,
    required this.status,
    required this.pickupCode,
  });

  final String id;
  final String sender;
  final String courier;
  final DateTime arrivalTime;
  final String status;
  final String pickupCode;
}

class FacilityBooking {
  const FacilityBooking({
    required this.id,
    required this.facility,
    required this.date,
    required this.slot,
    required this.status,
    required this.residentName,
  });

  final String id;
  final String facility;
  final DateTime date;
  final String slot;
  final String status;
  final String residentName;

  FacilityBooking copyWith({String? status}) {
    return FacilityBooking(
      id: id,
      facility: facility,
      date: date,
      slot: slot,
      status: status ?? this.status,
      residentName: residentName,
    );
  }
}

class Announcement {
  const Announcement({
    required this.title,
    required this.category,
    required this.message,
    required this.publishedAt,
  });

  final String title;
  final String category;
  final String message;
  final DateTime publishedAt;
}

class CommunityPost {
  const CommunityPost({
    required this.title,
    required this.category,
    required this.author,
    required this.description,
  });

  final String title;
  final String category;
  final String author;
  final String description;
}

class SecurityIncident {
  const SecurityIncident({
    required this.id,
    required this.category,
    required this.location,
    required this.description,
    required this.severity,
    required this.status,
  });

  final String id;
  final String category;
  final String location;
  final String description;
  final String severity;
  final String status;

  SecurityIncident copyWith({String? status}) {
    return SecurityIncident(
      id: id,
      category: category,
      location: location,
      description: description,
      severity: severity,
      status: status ?? this.status,
    );
  }
}

class PatrolCheckpoint {
  const PatrolCheckpoint({
    required this.name,
    required this.area,
    required this.status,
    required this.note,
  });

  final String name;
  final String area;
  final String status;
  final String note;

  PatrolCheckpoint copyWith({String? status, String? note}) {
    return PatrolCheckpoint(
      name: name,
      area: area,
      status: status ?? this.status,
      note: note ?? this.note,
    );
  }
}

class TenantMerchant {
  const TenantMerchant({
    required this.name,
    required this.category,
    required this.hours,
    required this.contact,
    required this.status,
    required this.rating,
  });

  final String name;
  final String category;
  final String hours;
  final String contact;
  final String status;
  final double rating;
}

class MerchantOrder {
  const MerchantOrder({
    required this.id,
    required this.customer,
    required this.item,
    required this.amount,
    required this.status,
    required this.requestTime,
  });

  final String id;
  final String customer;
  final String item;
  final int amount;
  final String status;
  final DateTime requestTime;

  MerchantOrder copyWith({String? status}) {
    return MerchantOrder(
      id: id,
      customer: customer,
      item: item,
      amount: amount,
      status: status ?? this.status,
      requestTime: requestTime,
    );
  }
}

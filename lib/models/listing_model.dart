import 'package:eventsapp/core/api/end_ponits.dart';

class Meta {
  final int currentPage;
  final int lastPage;
  final int total;

  const Meta({
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json[ApiKey.currentPage] ?? 0,
      lastPage: json[ApiKey.lastPage] ?? 0,
      total: json[ApiKey.total] ?? 0,
    );
  }
}

class Category {
  final int id;
  final String name;

  const Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json[ApiKey.id] ?? 0, name: json[ApiKey.name] ?? '');
  }
}

class District {
  final int id;
  final String name;

  const District({required this.id, required this.name});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(id: json[ApiKey.id] ?? 0, name: json[ApiKey.name] ?? '');
  }
}

class Slot {
  final String id;
  final String? name;
  final DateTime startTime;
  final DateTime endTime;
  final int remainingCapacity;

  const Slot({
    required this.id,
    this.name,
    required this.startTime,
    required this.endTime,
    required this.remainingCapacity,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      id: json[ApiKey.id] ?? '',
      name: json[ApiKey.name],
      startTime:
          DateTime.tryParse(json[ApiKey.start_time] ?? '') ?? DateTime.now(),
      endTime: DateTime.tryParse(json[ApiKey.end_time] ?? '') ?? DateTime.now(),
      remainingCapacity: json[ApiKey.remaining_capacity] ?? 0,
    );
  }
}

class Availability {
  final String id;
  final DateTime availableDate;
  final bool isBlocked;
  final List<Slot> slots;

  const Availability({
    required this.id,
    required this.availableDate,
    required this.isBlocked,
    required this.slots,
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      id: json[ApiKey.id] ?? '',
      availableDate:
          DateTime.tryParse(json[ApiKey.available_date] ?? '') ??
          DateTime.now(),
      isBlocked: json[ApiKey.is_blocked] ?? false,
      slots:
          (json[ApiKey.slots] as List<dynamic>?)
              ?.map((item) => Slot.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class Variant {
  final String id;
  final Map<String, dynamic> name;
  final int price;
  final String currency;
  final String priceType;
  final dynamic stock;
  final dynamic attributes;
  final List<dynamic> images;
  final List<Availability> availabilities;

  const Variant({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.priceType,
    this.stock,
    this.attributes,
    required this.images,
    required this.availabilities,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json[ApiKey.id] ?? '',
      name: json[ApiKey.name] ?? {},
      price: json[ApiKey.price] ?? 0,
      currency: json[ApiKey.currency] ?? '',
      priceType: json[ApiKey.price_type] ?? '',
      stock: json[ApiKey.stock],
      attributes: json[ApiKey.attributes],
      images: json[ApiKey.images] ?? [],
      availabilities:
          (json[ApiKey.availabilities] as List<dynamic>?)
              ?.map((item) => Availability.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class ServiceItem {
  final String id;
  final Map<String, dynamic> title;
  final Map<String, dynamic> description;
  final String type;
  final String status;
  final dynamic materialComposition;
  final dynamic secondaryContactNumber;
  final bool cancelBeforeAcceptance;
  final bool cancelAfterAcceptance;
  final bool cancelBeforePayment;
  final bool isProviderLocationBased;
  final dynamic rejectionReason;
  final Category category;
  final District district;
  final List<dynamic> images;
  final List<Variant> variants;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ServiceItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    this.materialComposition,
    this.secondaryContactNumber,
    required this.cancelBeforeAcceptance,
    required this.cancelAfterAcceptance,
    required this.cancelBeforePayment,
    required this.isProviderLocationBased,
    this.rejectionReason,
    required this.category,
    required this.district,
    required this.images,
    required this.variants,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json[ApiKey.id] ?? '',
      title: json[ApiKey.title] ?? {},
      description: json[ApiKey.description] ?? {},
      type: json[ApiKey.type] ?? '',
      status: json[ApiKey.status] ?? '',
      materialComposition: json[ApiKey.material_composition],
      secondaryContactNumber: json[ApiKey.secondary_contact_number],
      cancelBeforeAcceptance: json[ApiKey.cancel_before_acceptance] ?? false,
      cancelAfterAcceptance: json[ApiKey.cancel_after_acceptance] ?? false,
      cancelBeforePayment: json[ApiKey.cancel_before_payment] ?? false,
      isProviderLocationBased: json[ApiKey.is_provider_location_based] ?? false,
      rejectionReason: json[ApiKey.rejection_reason],
      category: Category.fromJson(json[ApiKey.category] ?? {}),
      district: District.fromJson(json[ApiKey.district] ?? {}),
      images: json[ApiKey.images] ?? [],
      variants:
          (json[ApiKey.variants] as List<dynamic>?)
              ?.map((item) => Variant.fromJson(item))
              .toList() ??
          [],
      createdAt:
          DateTime.tryParse(json[ApiKey.created_at] ?? '') ?? DateTime.now(),
      updatedAt:
          DateTime.tryParse(json[ApiKey.updated_at] ?? '') ?? DateTime.now(),
    );
  }
}

class ListingResponse {
  final bool success;
  final List<ServiceItem> data;
  final Meta meta;

  ListingResponse({
    required this.success,
    required this.data,
    required this.meta,
  });

  factory ListingResponse.fromJson(Map<String, dynamic> json) {
    return ListingResponse(
      success: json[ApiKey.success] ?? false,
      data:
          (json[ApiKey.data] as List<dynamic>?)
              ?.map((item) => ServiceItem.fromJson(item))
              .toList() ??
          [],
      meta: Meta.fromJson(json[ApiKey.meta] ?? {}),
    );
  }
}

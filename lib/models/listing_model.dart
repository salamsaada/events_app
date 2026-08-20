import 'package:eventsapp/core/api/end_ponits.dart';

// 🛡️ دالة سحرية لحماية النصوص والخرائط
Map<String, dynamic> _safeMap(dynamic value) {
  if (value is String) return {'ar': value};
  if (value is Map) return Map<String, dynamic>.from(value);
  return {'ar': value?.toString() ?? 'بدون عنوان'};
}

// 🛡️ دالة سحرية لحماية الأرقام (تمنع خطأ String is not subtype of int)
int _safeInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is num) return value.toInt();
  return 0;
}

// 🛡️ دالة سحرية لحماية القوائم
List<Map<String, dynamic>> _safeListOfMaps(dynamic value) {
  if (value is! List) return [];
  return value
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
}

// 🆕 تجرب أكتر من اسم حقل محتمل (snake_case أو camelCase) وترجع أول قيمة غير null
dynamic _firstNonNull(Map<String, dynamic> json, List<String> keys) {
  for (final k in keys) {
    if (json.containsKey(k) && json[k] != null) return json[k];
  }
  return null;
}

double _safeDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

class ServiceReview {
  final double rating;
  final String comment;
  final String reviewerName;
  final DateTime? createdAt;

  const ServiceReview({
    required this.rating,
    required this.comment,
    required this.reviewerName,
    this.createdAt,
  });

  factory ServiceReview.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map
        ? Map<String, dynamic>.from(json['user'])
        : <String, dynamic>{};
    final reviewerName =
        _firstNonNull(json, ['reviewer_name', 'name']) ??
        _firstNonNull(user, ['name', 'full_name']) ??
        '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'.trim();

    return ServiceReview(
      rating: _safeDouble(_firstNonNull(json, ['rating', 'stars'])),
      comment: (_firstNonNull(json, ['comment', 'review', 'content']) ?? '')
          .toString(),
      reviewerName: reviewerName.toString().isEmpty
          ? 'Anonymous'
          : reviewerName.toString(),
      createdAt: DateTime.tryParse(
        (_firstNonNull(json, ['created_at', 'date']) ?? '').toString(),
      ),
    );
  }
}

class Meta {
  final int currentPage;
  final int lastPage;
  final int total;

  const Meta({
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const Meta(currentPage: 0, lastPage: 0, total: 0);
    return Meta(
      currentPage: _safeInt(json[ApiKey.currentPage]),
      lastPage: _safeInt(json[ApiKey.lastPage]),
      total: _safeInt(json[ApiKey.total]),
    );
  }
}

class Category {
  final int id;
  final String name;

  const Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const Category(id: 0, name: '');
    return Category(
      id: _safeInt(json[ApiKey.id]),
      name: json[ApiKey.name]?.toString() ?? '',
    );
  }
}

class District {
  final int id;
  final String name;

  const District({required this.id, required this.name});

  factory District.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const District(id: 0, name: '');
    return District(
      id: _safeInt(json[ApiKey.id]),
      name: json[ApiKey.name]?.toString() ?? '',
    );
  }
}

class Slot {
  final String id;
  final dynamic name;
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

  factory Slot.fromJson(Map<String, dynamic>? json) {
    if (json == null)
      return Slot(
        id: '',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        remainingCapacity: 0,
      );

    // دالة داخلية سريعة لتركيب تاريخ وهمي مع الوقت عشان tryParse ما يرجع null
    DateTime parseTime(String? t) {
      if (t == null || t.isEmpty) return DateTime.now();
      return DateTime.tryParse(t) ??
          DateTime.tryParse("1970-01-01 $t") ??
          DateTime.now();
    }

    return Slot(
      id: json[ApiKey.id]?.toString() ?? '',
      name: json[ApiKey.name],
      startTime: parseTime(json[ApiKey.start_time]?.toString()),
      endTime: parseTime(json[ApiKey.end_time]?.toString()),
      remainingCapacity: _safeInt(json[ApiKey.remaining_capacity]),
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

  factory Availability.fromJson(Map<String, dynamic>? json) {
    if (json == null)
      return Availability(
        id: '',
        availableDate: DateTime.now(),
        isBlocked: false,
        slots: [],
      );
    return Availability(
      id: json[ApiKey.id]?.toString() ?? '',
      availableDate:
          DateTime.tryParse(json[ApiKey.available_date]?.toString() ?? '') ??
          DateTime.now(),
      isBlocked:
          json[ApiKey.is_blocked] == 1 || json[ApiKey.is_blocked] == true,
      slots:
          (json[ApiKey.slots] as List<dynamic>?)
              ?.map((item) => Slot.fromJson(item))
              .toList() ??
          [],
    );
  }
}

// ==========================================
// 🆕 موديلات المنتجات المرفقة بالباقة (package_items)
// مبنية بالاعتماد على العلاقة الفعلية بالباك اند:
// variants.packageItems.includedVariant.listing.images
// ==========================================

// 🆕 صورة/عنوان الـ listing تبع المنتج المرفق (chair, table, ...)
class IncludedVariantListing {
  final Map<String, dynamic> title;
  final List<dynamic> images;

  const IncludedVariantListing({required this.title, required this.images});

  factory IncludedVariantListing.fromJson(Map<String, dynamic>? json) {
    if (json == null)
      return const IncludedVariantListing(title: {}, images: []);
    return IncludedVariantListing(
      title: _safeMap(json[ApiKey.title]),
      images: json[ApiKey.images] is List ? json[ApiKey.images] : [],
    );
  }
}

// 🆕 الـ Variant المرفق فعليًا (مثلاً "Chair" بسعر 120)
class IncludedVariant {
  final String id;
  final Map<String, dynamic> name;
  final int price;
  final String currency;
  final List<dynamic> images;
  final IncludedVariantListing? listing;

  const IncludedVariant({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.images,
    this.listing,
  });

  factory IncludedVariant.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const IncludedVariant(
        id: '',
        name: {},
        price: 0,
        currency: '',
        images: [],
      );
    }
    // 🔎 نجرب snake_case و camelCase مشان listing المتداخلة
    final listingJson = _firstNonNull(json, ['listing']);

    return IncludedVariant(
      id: json[ApiKey.id]?.toString() ?? '',
      name: _safeMap(json[ApiKey.name]),
      price: _safeInt(json[ApiKey.price]),
      currency: json[ApiKey.currency]?.toString() ?? '',
      images: json[ApiKey.images] is List ? json[ApiKey.images] : [],
      listing: listingJson is Map<String, dynamic>
          ? IncludedVariantListing.fromJson(listingJson)
          : null,
    );
  }

  // 🆕 هيلبر: أفضل صورة متاحة (من صور الـ variant نفسه، وإلا من صور الـ listing تبعه)
  String? get bestImageUrl {
    if (images.isNotEmpty) {
      final first = images.first;
      if (first is Map && first['url'] != null) return first['url'].toString();
      if (first is String) return first;
    }
    if (listing != null && listing!.images.isNotEmpty) {
      final first = listing!.images.first;
      if (first is Map && first['url'] != null) return first['url'].toString();
      if (first is String) return first;
    }
    return null;
  }
}

class PackageItem {
  final String id;
  final String variantId;
  final int quantity;
  final IncludedVariant? includedVariant;
  final Map<String, dynamic>
  rawData; // 🛡️ احتياط: كامل البيانات الخام لأي حقل غير متوقع

  const PackageItem({
    required this.id,
    required this.variantId,
    required this.quantity,
    this.includedVariant,
    required this.rawData,
  });

  factory PackageItem.fromJson(Map<String, dynamic> json) {
    // 🔎 نجرب أكتر من اسم محتمل للعلاقة المتداخلة included_variant
    final includedVariantJson = _firstNonNull(json, [
      'included_variant',
      'includedVariant',
      'variant',
    ]);

    return PackageItem(
      id: json['id']?.toString() ?? '',
      variantId:
          (_firstNonNull(json, ['variant_id', 'variantId']))?.toString() ?? '',
      quantity: _safeInt(_firstNonNull(json, ['quantity', 'qty'])),
      includedVariant: includedVariantJson is Map<String, dynamic>
          ? IncludedVariant.fromJson(includedVariantJson)
          : null,
      rawData: json,
    );
  }
}

// ==========================================
// 🆕 موديلات الفريلانسرز المرتبطين بالباقة (package_freelancers)
// العلاقة بالباك اند: variants.packageFreelancers.freelancer
// ==========================================

class FreelancerInfo {
  final String id;
  final String name;
  final String? role;
  final String? avatarUrl;

  const FreelancerInfo({
    required this.id,
    required this.name,
    this.role,
    this.avatarUrl,
  });

  factory FreelancerInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const FreelancerInfo(id: '', name: '');
    return FreelancerInfo(
      id: json[ApiKey.id]?.toString() ?? '',
      name: json[ApiKey.name]?.toString() ?? '',
      role: (_firstNonNull(json, ['role', 'type']))?.toString(),
      avatarUrl: (_firstNonNull(json, [
        'avatar_url',
        'avatarUrl',
        'image',
      ]))?.toString(),
    );
  }
}

class PackageFreelancer {
  final String id;
  final FreelancerInfo? freelancer;
  final Map<String, dynamic> rawData;

  const PackageFreelancer({
    required this.id,
    this.freelancer,
    required this.rawData,
  });

  factory PackageFreelancer.fromJson(Map<String, dynamic> json) {
    final freelancerJson = _firstNonNull(json, ['freelancer', 'Freelancer']);
    return PackageFreelancer(
      id: json['id']?.toString() ?? '',
      freelancer: freelancerJson is Map<String, dynamic>
          ? FreelancerInfo.fromJson(freelancerJson)
          : null,
      rawData: json,
    );
  }
}

class Variant {
  final String id;
  final Map<String, dynamic> name;
  final int price;
  final String currency;
  final String priceType;
  final int capacity;
  final dynamic stock;
  final dynamic attributes;
  final List<dynamic> images;
  final List<Availability> availabilities;
  final List<PackageItem> packageItems;
  final List<PackageFreelancer> packageFreelancers;

  const Variant({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.priceType,
    required this.capacity,
    this.stock,
    this.attributes,
    required this.images,
    required this.availabilities,
    this.packageItems = const [],
    this.packageFreelancers = const [],
  });

  factory Variant.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const Variant(
        id: '',
        name: {},
        price: 0,
        currency: '',
        priceType: '',
        capacity: 0,
        images: [],
        availabilities: [],
      );
    }

    final rawAttributes = json[ApiKey.attributes];
    final dynamic rawCapacity =
        json['capacity'] ??
        (rawAttributes is Map ? rawAttributes['capacity'] : null);

    // 🔎 نجرب snake_case و camelCase لاسمي الحقلين
    final rawPackageItems = _firstNonNull(json, [
      'package_items',
      'packageItems',
    ]);
    final rawPackageFreelancers = _firstNonNull(json, [
      'package_freelancers',
      'packageFreelancers',
    ]);

    List<PackageItem> parsedItems = [];
    for (final item in _safeListOfMaps(rawPackageItems)) {
      try {
        parsedItems.add(PackageItem.fromJson(item));
      } catch (e) {
        print("⚠️ Skipped a package item due to error: $e");
        print("⚠️ Raw package item that failed: $item");
      }
    }

    List<PackageFreelancer> parsedFreelancers = [];
    for (final item in _safeListOfMaps(rawPackageFreelancers)) {
      try {
        parsedFreelancers.add(PackageFreelancer.fromJson(item));
      } catch (e) {
        print("⚠️ Skipped a package freelancer due to error: $e");
        print("⚠️ Raw package freelancer that failed: $item");
      }
    }

    return Variant(
      id: json[ApiKey.id]?.toString() ?? '',
      name: _safeMap(json[ApiKey.name]),
      price: _safeInt(json[ApiKey.price]),
      currency: json[ApiKey.currency]?.toString() ?? '',
      priceType: json[ApiKey.price_type]?.toString() ?? '',
      capacity: _safeInt(rawCapacity),
      stock: json[ApiKey.stock],
      attributes: rawAttributes,
      images: json[ApiKey.images] ?? [],
      availabilities:
          (json[ApiKey.availabilities] as List<dynamic>?)
              ?.map((item) => Availability.fromJson(item))
              .toList() ??
          [],
      packageItems: parsedItems,
      packageFreelancers: parsedFreelancers,
    );
  }
}
 class ServiceItem {
  final String id;
  final String providerId;
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
  final double averageRating;
  final int reviewCount;
  final List<ServiceReview> reviews;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ServiceItem({
    required this.id,
    required this.providerId,
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
    required this.averageRating,
    required this.reviewCount,
    required this.reviews,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) throw Exception("ServiceItem json is null");

    try {
      // 🚀 استخدام is Map بدلاً من is Map<String, dynamic>
      var catData = json[ApiKey.category];
      Category category = (catData is Map)
          ? Category.fromJson(Map<String, dynamic>.from(catData))
          : Category(id: 0, name: catData?.toString() ?? 'N/A');

      var distData = json[ApiKey.district];
      District district = (distData is Map)
          ? District.fromJson(Map<String, dynamic>.from(distData))
          : District(id: 0, name: distData?.toString() ?? 'N/A');

      final rawVariants = json[ApiKey.variants] as List<dynamic>? ?? [];
      final List<Variant> parsedVariants = [];
      for (final v in rawVariants) {
        try {
          parsedVariants.add(Variant.fromJson(v));
        } catch (e) {
          print("⚠️ Skipped a variant due to error: $e");
          print("⚠️ Raw variant that failed: $v");
        }
      }

      // ==========================================
      // 💡 الكود الجديد لمعالجة صور المنتجات:
      // ==========================================
      String itemType = json[ApiKey.type]?.toString() ?? '';
      List<dynamic> finalImages = json[ApiKey.images] ?? [];

      // إذا كان العنصر "منتج" والمصفوفة الأساسية فارغة، نسحب الصور من الـ Variants
      if (itemType == 'physical_product' && finalImages.isEmpty && parsedVariants.isNotEmpty) {
        for (var variant in parsedVariants) {
          if (variant.images.isNotEmpty) {
            finalImages = variant.images;
            break; // نأخذ صور أول نسخة (Variant) ونتوقف
          }
        }
      }
      // ==========================================
 final reviewsData = _firstNonNull(json, ['reviews', 'review']);
      final rawReviews = reviewsData is List
          ? reviewsData
          : reviewsData is Map && reviewsData['data'] is List
          ? reviewsData['data'] as List
          : const [];
      final parsedReviews = rawReviews
          .whereType<Map>()
          .map(
            (review) =>
                ServiceReview.fromJson(Map<String, dynamic>.from(review)),
          )
          .toList();
          
      final ratingData = json['rating'];
      final ratingValue =
          _firstNonNull(json, [
            'average_rating',
            'avg_rating',
            'rating_average',
            'rating_avg',
            'averageRating',
          ]) ??
          (ratingData is Map
              ? _firstNonNull(Map<String, dynamic>.from(ratingData), [
                  'average',
                  'avg',
                  'value',
                ])
              : ratingData);
              
      final countValue =
          _firstNonNull(json, [
            'review_count',
            'reviews_count',
            'ratings_count',
            'total_reviews',
            'total_ratings',
            'reviewCount',
            'reviewsCount',
          ]) ??
          (ratingData is Map
              ? _firstNonNull(Map<String, dynamic>.from(ratingData), [
                  'count',
                  'total',
                ])
              : null);
              
      final calculatedRating = parsedReviews.isEmpty
          ? 0.0
          : parsedReviews.fold<double>(
                  0,
                  (sum, review) => sum + review.rating,
                ) /
                parsedReviews.length;
                
      final providerData = json[ApiKey.provider_id] ?? json['provider'];
      final providerId =
          json[ApiKey.provider_id]?.toString() ??
          (providerData is Map ? providerData[ApiKey.id]?.toString() : null) ??
          '';

      return ServiceItem(
        id: json[ApiKey.id]?.toString() ?? '',
        providerId: providerId,
        title: _safeMap(json[ApiKey.title]),
        description: _safeMap(json[ApiKey.description]),
        type: itemType, // 💡 تم تمرير المتغير الجديد هنا
        status: json[ApiKey.status]?.toString() ?? '',
        materialComposition: json[ApiKey.material_composition],
        secondaryContactNumber: json[ApiKey.secondary_contact_number],
        // 💡 تم تصحيح علامات الـ  هنا
      cancelBeforeAcceptance:
            json[ApiKey.cancel_before_acceptance] == 1 ||
            json[ApiKey.cancel_before_acceptance] == true,
        cancelAfterAcceptance:
            json[ApiKey.cancel_after_acceptance] == 1 ||
            json[ApiKey.cancel_after_acceptance] == true,
        cancelBeforePayment:
            json[ApiKey.cancel_before_payment] == 1 ||
            json[ApiKey.cancel_before_payment] == true,
        isProviderLocationBased:
            json[ApiKey.is_provider_location_based] == 1 || 
            json[ApiKey.is_provider_location_based] == true,
        rejectionReason: json[ApiKey.rejection_reason],
        category: category,
        district: district,
        images: finalImages, // 💡 تم تمرير المصفوفة المعالجة للصور هنا
        variants: parsedVariants,
        averageRating: ratingValue == null
            ? calculatedRating
            : _safeDouble(ratingValue),
        reviewCount: _safeInt(countValue ?? parsedReviews.length),
        reviews: parsedReviews,
        createdAt:
            DateTime.tryParse(json[ApiKey.created_at]?.toString() ?? '') ??
            DateTime.now(),
        updatedAt:
            DateTime.tryParse(json[ApiKey.updated_at]?.toString() ?? '') ??
            DateTime.now(),
      );
    } catch (e) {
      print("❌ CRITICAL ERROR in ServiceItem for ID ${json[ApiKey.id]}: $e");
      rethrow;
    }
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
    try {
      return ListingResponse(
        success: json[ApiKey.success] ?? true,
        data:
            (json['data'] as List<dynamic>?)
                ?.map((item) {
                  try {
                    return ServiceItem.fromJson(item);
                  } catch (e) {
                    print("⚠️ Skipped an item due to error: $e");
                    print("⚠️ Raw item that failed: $item");
                    return null;
                  }
                })
                .whereType<ServiceItem>()
                .toList() ??
            [],
        meta: Meta.fromJson(json['meta']),
      );
    } catch (e) {
      print("❌ FATAL ERROR in ListingResponse.fromJson: $e");
      rethrow;
    }
  }
}

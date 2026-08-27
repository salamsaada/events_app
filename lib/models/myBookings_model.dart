import 'package:eventsapp/core/api/end_ponits.dart';

// ==========================================
// 1. كلاسات مساعدة (بنفس نمط مشروعك)
// ==========================================
class ListingTitle {
  final String? en;
  final String? ar;

  const ListingTitle({this.en, this.ar});

  factory ListingTitle.fromJson(dynamic json) {
    if (json == null) return const ListingTitle();

    // ✨ إذا أرسل لارافيل النص كـ String مباشرة (بسبب إعدادات الترجمة)
    if (json is String) {
      return ListingTitle(en: json, ar: json);
    }

    // ✨ إذا أرسل لارافيل النص ككائن ترجمة صحيح { "ar": "...", "en": "..." }
    if (json is Map<String, dynamic>) {
      return ListingTitle(en: json['en'] as String?, ar: json['ar'] as String?);
    }

    return const ListingTitle();
  }
}

class BookingShift {
  final String? id;
  final ListingTitle? name;
  final DateTime? startTime;
  final DateTime? endTime;

  const BookingShift({this.id, this.name, this.startTime, this.endTime});

  factory BookingShift.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BookingShift();
    return BookingShift(
      id: json[ApiKey.id] as String?,
      name: ListingTitle.fromJson(json['name']),
      startTime: DateTime.tryParse(json['start_time'] ?? ''),
      endTime: DateTime.tryParse(json['end_time'] ?? ''),
    );
  }
}

class BookingVariant {
  final String? id;
  final ListingTitle? name;

  const BookingVariant({this.id, this.name});

  factory BookingVariant.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BookingVariant();
    return BookingVariant(
      id: json[ApiKey.id] as String?,
      name: ListingTitle.fromJson(json['name']),
    );
  }
}

class BookingListing {
  final String? id;
  final ListingTitle? title;
  final String? listingType;

  const BookingListing({this.id, this.title, this.listingType});

  factory BookingListing.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BookingListing();
    return BookingListing(
      id: json[ApiKey.id] as String?,
      title: ListingTitle.fromJson(json[ApiKey.title]),
      listingType: json['listing_type'] as String?,
    );
  }
}

// ==========================================
// 🆕 كلاس جديد: يمثل الـ object المتداخل "payment" (إضافة صديقك)
// ==========================================
class BookingPayment {
  final String? paymentStatus;

  const BookingPayment({this.paymentStatus});

  factory BookingPayment.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BookingPayment();
    return BookingPayment(
      paymentStatus: json['payment_status'] as String?,
    );
  }
}

// ==========================================
// 2. كلاس البيانات الرئيسي (مدمج ليحفظ إضافاتك + إضافات صديقك)
// ==========================================
class BookingData {
  final String? id;
  final String? status;
  final BookingPayment? payment; // 🌟 (كود صديقك)
  final String? price;
  final String? currency;
  final BookingShift? shift;
  final String? providerId;
  final BookingListing? listing;
  final BookingVariant? variant;
  final dynamic customer;
  final String? createdAtHuman;

  // 🚀 إضافاتك العبقرية والتفصيلية للحجوزات (لا تُحذف أبداً)
  final String? bookedDate;
  final String? bookedStartTime;
  final String? bookedEndTime;
  final int? quantity;
  final Map<String, dynamic>? metadata;
  final List<String>? freelancers;

  const BookingData({
    this.id,
    this.status,
    this.payment, // 🌟
    this.price,
    this.currency,
    this.shift,
    this.providerId,
    this.listing,
    this.variant,
    this.customer,
    this.createdAtHuman,
    // 🚀
    this.bookedDate,
    this.quantity,
    this.bookedStartTime,
    this.bookedEndTime,
    this.metadata,
    this.freelancers,
  });

  factory BookingData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BookingData();

    // 🚀 قراءة كائن shift أو slot بأمان (كودك)
    final shiftData = json['shift'] as Map<String, dynamic>? ?? json['slot'] as Map<String, dynamic>?;

    return BookingData(
      id: json[ApiKey.id] as String?,
      status: json[ApiKey.status] as String?,

      // 🌟 بارسينج الـ object المتداخل الخاص بالدفع (كود صديقك)
      payment: BookingPayment.fromJson(json['payment'] as Map<String, dynamic>?),

      // 🚀 قراءة السعر بأمان من total_price أو price
      price: json['total_price']?.toString() ?? json['price']?.toString(),

      currency: json[ApiKey.currency] as String?,
      shift: BookingShift.fromJson(shiftData), // 🚀 تمرير بيانات الوقت
      providerId: json[ApiKey.provider_id] as String?,
      listing: BookingListing.fromJson(json[ApiKey.listing] as Map<String, dynamic>?),
      variant: BookingVariant.fromJson(json['variant'] as Map<String, dynamic>?),
      customer: json['customer'],
      createdAtHuman: json['created_at_human'] as String?,

      // ==========================================
      // 🚀 قراءة الحقول التفصيلية الخاصة بك
      // ==========================================
      bookedDate: json['booked_date'] as String?,

      // 🚀 قراءة الوقت إما من الجذر أو من داخل shift
      bookedStartTime: json['booked_start_time'] as String? ?? shiftData?['start_time'] as String?,
      bookedEndTime: json['booked_end_time'] as String? ?? shiftData?['end_time'] as String?,

      // 🚀 قراءة الضيوف والخدمات المرفقة
      quantity: json['quantity'] != null ? int.tryParse(json['quantity'].toString()) : null,
      freelancers: (json['freelancers'] as List?)?.map((e) => e.toString()).toList(),
      metadata: json['metadata'] is Map ? Map<String, dynamic>.from(json['metadata']) : null,
    );
  }
}

// ==========================================
// 3. كلاس الاستجابة (تم تعديله لأن data عبارة عن List)
// ==========================================
class BookingResponsee {
  final bool success;
  final String? message;
  final List<BookingData> data;

  const BookingResponsee({
    required this.success,
    this.message,
    this.data = const [],
  });

  factory BookingResponsee.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BookingResponsee(success: false);

    try {
      final rawData = json[ApiKey.data];
      List<BookingData> bookingsList = [];

      if (rawData is List) {
        bookingsList = rawData
            .map((item) => BookingData.fromJson(item as Map<String, dynamic>?))
            .toList();
      }

      return BookingResponsee(
        success: json[ApiKey.success] ?? true,
        message: json[ApiKey.message] as String?,
        data: bookingsList,
      );
    } catch (e) {
      print("❌ FATAL ERROR in BookingResponse.fromJson: $e");
      rethrow;
    }
  }
}
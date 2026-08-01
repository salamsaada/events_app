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
      name: ListingTitle.fromJson(json['name'] as Map<String, dynamic>?),
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
// 2. كلاس البيانات الرئيسي (تم تعديله ليتطابق مع الـ JSON الجديد)
// ==========================================
class BookingData {
  final String? id;
  final String? status;
  final String? price; // تغيير من int إلى String لأنها تأتي كنص في الـ JSON
  final String? currency;
  final BookingShift? shift;
  final String? providerId;
  final BookingListing? listing;
  final BookingVariant? variant;
  final dynamic customer;
  final String? createdAtHuman;

  const BookingData({
    this.id,
    this.status,
    this.price,
    this.currency,
    this.shift,
    this.providerId,
    this.listing,
    this.variant,
    this.customer,
    this.createdAtHuman,
  });

  factory BookingData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BookingData();
    return BookingData(
      id: json[ApiKey.id] as String?,
      status: json[ApiKey.status] as String?,
      price: json['price']
          ?.toString(), // استخدام toString لتجنب الأخطاء إذا أرسلها السيرفر رقم أو نص
      currency: json[ApiKey.currency] as String?,
      shift: BookingShift.fromJson(json['shift'] as Map<String, dynamic>?),
      providerId: json[ApiKey.provider_id] as String?,
      listing: BookingListing.fromJson(
        json[ApiKey.listing] as Map<String, dynamic>?,
      ),
      variant: BookingVariant.fromJson(
        json['variant'] as Map<String, dynamic>?,
      ),
      customer: json['customer'],
      createdAtHuman: json['created_at_human'] as String?,
    );
  }
}

// ==========================================
// 3. كلاس الاستجابة (تم تعديله لأن data عبارة عن List)
// ==========================================
class BookingResponsee {
  final bool success;
  final String? message;
  final List<BookingData> data; // ✨ تغيير هام: من كائن مفرد إلى قائمة

  const BookingResponsee({
    required this.success,
    this.message,
    this.data = const [],
  });

  factory BookingResponsee.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BookingResponsee(success: false);

    try {
      // ✨ استخراج البيانات كمصفوفة
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

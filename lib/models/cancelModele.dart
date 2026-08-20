// ==========================================
// 1. كلاس مزود الخدمة (داخل الطلب الملغي)
// ==========================================
class CancelProviderData {
  final String? id;
  final String? userId;
  final String? moderationStatus;
  final String? brandName;
  final String? providerType;
  final String? rating;
  final int? isVerified;
  final int? isActive;

  const CancelProviderData({
    this.id,
    this.userId,
    this.moderationStatus,
    this.brandName,
    this.providerType,
    this.rating,
    this.isVerified,
    this.isActive,
  });

  factory CancelProviderData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CancelProviderData();
    return CancelProviderData(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      moderationStatus: json['moderation_status'] as String?,
      brandName: json['brand_name'] as String?,
      providerType: json['provider_type'] as String?,
      rating: json['rating']?.toString(), // التأكد من تحويله لنص
      isVerified: json['is_verified'] as int?,
      isActive: json['is_active'] as int?,
    );
  }
}

// ==========================================
// 2. كلاس بيانات الحجز الملغي
// ==========================================
class CancelBookingData {
  final String? id;
  final String? userId;
  final String? providerId;
  final String? listingId;
  final String? status;
  final String? paymentStatus;
  final int? quantity;
  final String? totalPrice;
  final String? currency;
  final String? bookedDate;
  final String? bookedStartTime;
  final String? bookedEndTime;
  final String? cancelledAt;
  final String? cancelledBy;
  final CancelProviderData? provider;

  const CancelBookingData({
    this.id,
    this.userId,
    this.providerId,
    this.listingId,
    this.status,
    this.paymentStatus,
    this.quantity,
    this.totalPrice,
    this.currency,
    this.bookedDate,
    this.bookedStartTime,
    this.bookedEndTime,
    this.cancelledAt,
    this.cancelledBy,
    this.provider,
  });

  factory CancelBookingData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CancelBookingData();
    return CancelBookingData(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      providerId: json['provider_id'] as String?,
      listingId: json['listing_id'] as String?,
      status: json['status'] as String?,
      paymentStatus: json['payment_status'] as String?,
      quantity: json['quantity'] as int?,
      totalPrice: json['total_price']?.toString(),
      currency: json['currency'] as String?,
      bookedDate: json['booked_date'] as String?,
      bookedStartTime: json['booked_start_time'] as String?,
      bookedEndTime: json['booked_end_time'] as String?,
      cancelledAt: json['cancelled_at'] as String?,
      cancelledBy: json['cancelled_by'] as String?,
      provider: CancelProviderData.fromJson(
        json['provider'] as Map<String, dynamic>?,
      ),
    );
  }
}

// ==========================================
// 3. كلاس الاستجابة العامة (الرئيسي)
// ==========================================
class CancelBookingResponsee {
  final String? message;
  final CancelBookingData? data;

  const CancelBookingResponsee({this.message, this.data});

  factory CancelBookingResponsee.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CancelBookingResponsee();
    return CancelBookingResponsee(
      message: json['message'] as String?,
      data: CancelBookingData.fromJson(json['data'] as Map<String, dynamic>?),
    );
  }
}

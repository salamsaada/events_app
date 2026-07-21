import 'package:eventsapp/core/api/end_ponits.dart';

class BookingMetadata {
  final String? eventType;
  final int? guestCount;
  final String? setupNeeds;
  final bool? isRental;
  final int? rentalDays;
  final String? deliveryAddress;
  final String? priceType;

  const BookingMetadata({
    this.eventType,
    this.guestCount,
    this.setupNeeds,
    this.isRental,
    this.rentalDays,
    this.deliveryAddress,
    this.priceType,
  });

  factory BookingMetadata.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BookingMetadata();
    return BookingMetadata(
      eventType: json[ApiKey.event_type] as String?,
      guestCount: json[ApiKey.guest_count] as int?,
      setupNeeds: json[ApiKey.setup_needs] as String?,
      isRental: json[ApiKey.is_rental] == 1 || json[ApiKey.is_rental] == true,
      rentalDays: json[ApiKey.rental_days] as int?,
      deliveryAddress: json[ApiKey.delivery_address] as String?,
      priceType: json[ApiKey.price_type] as String?,
    );
  }
}

class ListingTitle {
  final String? en;
  final String? ar;

  const ListingTitle({this.en, this.ar});

  factory ListingTitle.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ListingTitle();
    return ListingTitle(en: json['en'] as String?, ar: json['ar'] as String?);
  }
}

class BookingVariant {
  final String? id;
  final String? listingId;
  final ListingTitle? variantName;

  const BookingVariant({this.id, this.listingId, this.variantName});

  factory BookingVariant.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BookingVariant();
    return BookingVariant(
      id: json[ApiKey.id] as String?,
      listingId: json[ApiKey.listing_id] as String?,
      variantName: ListingTitle.fromJson(
        json[ApiKey.variant_name] as Map<String, dynamic>?,
      ),
    );
  }
}

class BookingListing {
  final String? id;
  final ListingTitle? title;
  final List<BookingVariant> variants;

  const BookingListing({this.id, this.title, this.variants = const []});

  factory BookingListing.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BookingListing();
    return BookingListing(
      id: json[ApiKey.id] as String?,
      title: ListingTitle.fromJson(json[ApiKey.title] as Map<String, dynamic>?),
      variants:
          (json[ApiKey.variants] as List<dynamic>?)
              ?.map(
                (item) =>
                    BookingVariant.fromJson(item as Map<String, dynamic>?),
              )
              .toList() ??
          [],
    );
  }
}

class BookingData {
  final String? userId;
  final String? providerId;
  final String? listingId;
  final String? listingVariantId;
  final String? listingSlotId;
  final String? bookingType;
  final String? status;
  final String? paymentStatus;
  final int? quantity;
  final int? totalPrice;
  final String? currency;
  final String? bookedDate;
  final dynamic bookedStartTime; // null in your JSON
  final dynamic bookedEndTime; // null in your JSON
  final BookingMetadata? metadata;
  final String? customerNotes;
  final String? id;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final BookingListing? listing;

  const BookingData({
    this.userId,
    this.providerId,
    this.listingId,
    this.listingVariantId,
    this.listingSlotId,
    this.bookingType,
    this.status,
    this.paymentStatus,
    this.quantity,
    this.totalPrice,
    this.currency,
    this.bookedDate,
    this.bookedStartTime,
    this.bookedEndTime,
    this.metadata,
    this.customerNotes,
    this.id,
    this.updatedAt,
    this.createdAt,
    this.listing,
  });

  factory BookingData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BookingData();
    return BookingData(
      userId: json[ApiKey.user_id] as String?,
      providerId: json[ApiKey.provider_id] as String?,
      listingId: json[ApiKey.listing_id] as String?,
      listingVariantId: json[ApiKey.listing_variant_id] as String?,
      listingSlotId: json[ApiKey.listing_slot_id] as String?,
      bookingType: json[ApiKey.booking_type] as String?,
      status: json[ApiKey.status] as String?,
      paymentStatus: json[ApiKey.payment_status] as String?,
      quantity: json[ApiKey.quantity] as int?,
      totalPrice: json[ApiKey.total_price] as int?,
      currency: json[ApiKey.currency] as String?,
      bookedDate: json[ApiKey.booked_date] as String?,
      bookedStartTime: json[ApiKey.booked_start_time],
      bookedEndTime: json[ApiKey.booked_end_time],
      metadata: BookingMetadata.fromJson(
        json[ApiKey.metadata] as Map<String, dynamic>?,
      ),
      customerNotes: json[ApiKey.customer_notes] as String?,
      id: json[ApiKey.id] as String?,
      updatedAt: DateTime.tryParse(json[ApiKey.updated_at] ?? ''),
      createdAt: DateTime.tryParse(json[ApiKey.created_at] ?? ''),
      listing: BookingListing.fromJson(
        json[ApiKey.listing] as Map<String, dynamic>?,
      ),
    );
  }
}

class BookingResponse {
  final bool success;
  final String? message;
  final BookingData? data;

  const BookingResponse({required this.success, this.message, this.data});

  factory BookingResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BookingResponse(success: false);

    try {
      return BookingResponse(
        success:
            json[ApiKey.success] ??
            true, // نفترض أنه true إذا لم يأتِ من السيرفر
        message: json[ApiKey.message] as String?,
        data: BookingData.fromJson(json[ApiKey.data] as Map<String, dynamic>?),
      );
    } catch (e) {
      print("❌ FATAL ERROR in BookingResponse.fromJson: $e");
      rethrow;
    }
  }
}

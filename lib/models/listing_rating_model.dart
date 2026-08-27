// lib/models/listing_rating_model.dart

class ListingRatingInfo {
  final double? average;
  final String? display;
  final int? count;
  final int? scale;

  const ListingRatingInfo({this.average, this.display, this.count, this.scale});

  factory ListingRatingInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ListingRatingInfo();
    return ListingRatingInfo(
      average: (json['average'] as num?)?.toDouble(),
      display: json['display'] as String?,
      count: json['count'] as int?,
      scale: json['scale'] as int?,
    );
  }
}

class ListingRatingItem {
  final String? listingId;
  final ListingRatingInfo? rating;

  const ListingRatingItem({this.listingId, this.rating});

  factory ListingRatingItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ListingRatingItem();
    return ListingRatingItem(
      listingId: json['listing_id'] as String?,
      rating: ListingRatingInfo.fromJson(json['rating'] as Map<String, dynamic>?),
    );
  }
}

class ListingRatingsResponse {
  final bool success;
  final List<ListingRatingItem> data;

  const ListingRatingsResponse({required this.success, this.data = const []});

  factory ListingRatingsResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ListingRatingsResponse(success: false);

    final rawData = json['data'];
    List<ListingRatingItem> list = [];
    if (rawData is List) {
      list = rawData
          .map((item) => ListingRatingItem.fromJson(item as Map<String, dynamic>?))
          .toList();
    }

    return ListingRatingsResponse(
      success: json['success'] ?? true,
      data: list,
    );
  }
}
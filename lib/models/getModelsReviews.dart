// ==========================================
// 1. كلاسات مساعدة (بيانات من قام التقييم)
// ==========================================
class ReviewerData {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? status;

  const ReviewerData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.status,
  });

  factory ReviewerData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ReviewerData();
    return ReviewerData(
      id: json['id'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      status: json['status'] as String?,
    );
  }

  // ✨ دالة مساعدة لدمج الاسمين
  String get fullName => '$firstName $lastName';
}

// ==========================================
// 2. كلاس بيانات التقييم الواحد
// ==========================================
class ReviewData {
  final String? id;
  final String? bookingId;
  final String? reviewerType;
  final String? reviewerId;
  final String? revieweeType;
  final String? revieweeId;
  final int? rating;
  final String? comment;
  final String? createdAt;
  final String? updatedAt;
  final ReviewerData? reviewer;

  const ReviewData({
    this.id,
    this.bookingId,
    this.reviewerType,
    this.reviewerId,
    this.revieweeType,
    this.revieweeId,
    this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.reviewer,
  });

  factory ReviewData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ReviewData();
    return ReviewData(
      id: json['id'] as String?,
      bookingId: json['booking_id'] as String?,
      reviewerType: json['reviewer_type'] as String?,
      reviewerId: json['reviewer_id'] as String?,
      revieweeType: json['reviewee_type'] as String?,
      revieweeId: json['reviewee_id'] as String?,
      rating: json['rating'] as int?,
      comment: json['comment'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      reviewer: ReviewerData.fromJson(
        json['reviewer'] as Map<String, dynamic>?,
      ),
    );
  }
}

// ==========================================
// 3. كلاس الاستجابة الرئيسي (يحتوي على الصفحات + القائمة)
// ==========================================
class ReviewsResponsee {
  final bool success;
  final String? message;

  // ✨ بيانات التقسيم (Pagination)
  final int? currentPage;
  final int? lastPage;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final int? total;

  // ✨ قائمة التقييمات
  final List<ReviewData> data;

  const ReviewsResponsee({
    required this.success,
    this.message,
    this.currentPage,
    this.lastPage,
    this.nextPageUrl,
    this.prevPageUrl,
    this.total,
    this.data = const [],
  });

  factory ReviewsResponsee.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ReviewsResponsee(success: false);

    try {
      // ✨ استخراج كائن الـ data الخارجي (الذي يحتوي على الصفحات والقائمة)
      final paginationData = json['data'];

      // تهيئة القيم الافتراضية للـ Pagination
      int? currentPage = 1;
      int? lastPage;
      String? nextPageUrl;
      String? prevPageUrl;
      int? total;
      List<ReviewData> reviewsList = const [];

      // ✨ التحقق أن الـ data عبارة عن Map (لأنه يحتوي على صفحات وليس List مباشر)
      if (paginationData is Map<String, dynamic>) {
        currentPage = paginationData['current_page'] as int?;
        lastPage = paginationData['last_page'] as int?;
        nextPageUrl = paginationData['next_page_url'] as String?;
        prevPageUrl = paginationData['prev_page_url'] as String?;
        total = paginationData['total'] as int?;

        // استخراج القائمة الحقيقية من داخل مفتاح data الثاني
        final rawData = paginationData['data'];
        if (rawData is List) {
          reviewsList = rawData
              .map((item) => ReviewData.fromJson(item as Map<String, dynamic>?))
              .toList();
        }
      }

      return ReviewsResponsee(
        success: json['success'] ?? false,
        message: json['message'] as String?,
        currentPage: currentPage,
        lastPage: lastPage,
        nextPageUrl: nextPageUrl,
        prevPageUrl: prevPageUrl,
        total: total,
        data: reviewsList,
      );
    } catch (e) {
      print("❌ FATAL ERROR in ReviewsResponsee.fromJson: $e");
      rethrow;
    }
  }
}

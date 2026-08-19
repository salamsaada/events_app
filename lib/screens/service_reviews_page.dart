import 'package:eventsapp/models/listing_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ✅ استبدل هذه المسارات بالمسارات الصحيحة في مشروعك
import '../cubit/user_cubit.dart';
import '../cubit/user_state.dart';
import '../core/widgets/service_reviews_section.dart';

class ServiceReviewsPage extends StatefulWidget {
  final String providerId;
  final String serviceName;

  const ServiceReviewsPage({
    super.key,
    required this.providerId,
    required this.serviceName,
  });

  @override
  State<ServiceReviewsPage> createState() => _ServiceReviewsPageState();
}

class _ServiceReviewsPageState extends State<ServiceReviewsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted && widget.providerId.isNotEmpty) {
        context.read<UserCubit>().getProviderReviews(widget.providerId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'تقييمات الخدمة' : 'Service Reviews'),
        centerTitle: true,
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          // 1. حالة التحميل
          if (state is GetReviewsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFD4AF37), // لون الذهب الخاص بك
              ),
            );
          }

          // 2. حالة الفشل
          if (state is GetReviewsFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    state.errMessage,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserCubit>().getProviderReviews(
                        widget.providerId,
                      );
                    },
                    child: Text(isArabic ? 'إعادة المحاولة' : 'Retry'),
                  ),
                ],
              ),
            );
          }

          // 3. حالة النجاح
          if (state is GetReviewsSuccess) {
            final reviewsData = state.reviewsResponse;

            // ✨ تحويل بيانات السيرفر (ReviewData) إلى الشكل الذي يتوقعه الكومبوننت القديم (ServiceReview)
            // لاحظ أنني وضعت قيم افتراضية للأشياء التي لا يرجعها السيرفر (مثل الاسم بدل الـ ID)
            final mappedReviews = reviewsData.data.map((review) {
              return ServiceReview(
                reviewerName: review.reviewer?.fullName ?? 'مستخدم',
                rating: review.rating?.toDouble() ?? 0.0,
                comment: review.comment ?? '',
                createdAt: DateTime.tryParse(review.createdAt ?? ''),
              );
            }).toList();

            // ✨ حساب متوسط التقييمات (لأن السيرفر لا يرجعه في هذا الـ API)
            double avgRating = 0.0;
            if (mappedReviews.isNotEmpty) {
              final total = mappedReviews.fold<double>(
                0,
                (sum, item) => sum + item.rating,
              );
              avgRating = total / mappedReviews.length;
            }

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // عرض اسم الخدمة (إذا كان متوفراً في الـ State، وإلا نعرض نص عام)
                Text(
                  widget.serviceName.isNotEmpty
                      ? widget.serviceName
                      : (isArabic ? 'جميع التقييمات' : 'All Reviews'),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                ServiceReviewsSection(
                  reviews: mappedReviews,
                  averageRating: avgRating,
                  reviewCount: reviewsData.total ?? 0,
                  isArabic: isArabic,
                  showSummary: false,
                ),

                // ✨ زر "تحميل المزيد" (Pagination) يظهر فقط إذا كانت هناك صفحة تالية
                if (reviewsData.nextPageUrl != null) ...[
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // إرسال رقم الصفحة التالية
                        context.read<UserCubit>().getProviderReviews(
                          widget.providerId,
                          page: reviewsData.currentPage! + 1,
                        );
                      },
                      child: Text(
                        isArabic ? 'تحميل المزيد...' : 'Load More...',
                        style: const TextStyle(
                          color: Color(0xFFD4AF37),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );
          }

          // 4. الحالة الافتراضية (قبل بدء التحميل)
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

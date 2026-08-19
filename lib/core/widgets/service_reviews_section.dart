import 'package:flutter/material.dart';
import '../../models/listing_model.dart';

class ServiceReviewsSection extends StatelessWidget {
  final List<ServiceReview> reviews;
  final double averageRating;
  final int reviewCount;
  final bool isArabic;
  final VoidCallback? onTap;
  final bool showSummary;

  const ServiceReviewsSection({
    super.key,
    required this.reviews,
    required this.averageRating,
    required this.reviewCount,
    required this.isArabic,
    this.onTap,
    this.showSummary = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = isArabic ? 'المراجعات والتقييمات' : 'Reviews & Ratings';
    final emptyText = isArabic
        ? 'لا توجد مراجعات لهذه الخدمة بعد'
        : 'No reviews for this service yet';
    final displayedRating = averageRating.clamp(0.0, 5.0);
    final ratingText = displayedRating > 0
        ? displayedRating.toStringAsFixed(1)
        : '0.0';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (showSummary) ...[
          const SizedBox(height: 14),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFD6B237).withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      final starPosition = index + 1;
                      final icon = displayedRating >= starPosition
                          ? Icons.star
                          : displayedRating >= starPosition - 0.5
                          ? Icons.star_half
                          : Icons.star_border;
                      return Icon(
                        icon,
                        color: const Color(0xFFD6B237),
                        size: 22,
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    ratingText,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '($reviewCount ${isArabic ? 'مراجعة' : 'reviews'})',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    isArabic ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                    size: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
        if (reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              emptyText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          )
        else
          ...reviews.map(
            (review) => _ReviewTile(review: review, isArabic: isArabic),
          ),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final ServiceReview review;
  final bool isArabic;

  const _ReviewTile({required this.review, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: const Color(
                  0xFFD6B237,
                ).withValues(alpha: 0.15),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFFD6B237),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  review.reviewerName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < review.rating.round()
                        ? Icons.star
                        : Icons.star_border,
                    color: const Color(0xFFD6B237),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(review.comment, style: theme.textTheme.bodyMedium),
          ],
          if (review.createdAt != null) ...[
            const SizedBox(height: 8),
            Text(
              '${review.createdAt!.day.toString().padLeft(2, '0')}/${review.createdAt!.month.toString().padLeft(2, '0')}/${review.createdAt!.year}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

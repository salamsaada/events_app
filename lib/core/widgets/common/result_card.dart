import 'package:flutter/material.dart';
import 'package:eventsapp/generated/app_localizations.dart';

class ResultCard extends StatelessWidget {
  final String title;
  final String companyName;
  final String price;
  final String imageUrl;
  final double rating;
  final String location;
  final String capacity;
  final VoidCallback onTap;
  final bool isFavorite; 
  final VoidCallback? onFavoriteToggle; 

  const ResultCard({
    super.key,
    required this.title,
    required this.companyName,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.location,
    required this.capacity,
    required this.onTap,
    this.isFavorite = false, 
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // استخدام Stack لوضع زر القلب فوق الصورة
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: imageUrl.startsWith('http')
                      ? Image.network(
                    imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
                    ),
                  )
                      : Image.asset(
                    imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                    ),
                  ),
                ),
                
                // زر المفضلة (القلب) المعدل
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: onFavoriteToggle, 
                      padding: EdgeInsets.zero, 
                      constraints: const BoxConstraints(
                        minWidth: 38,
                        minHeight: 38,
                      ), 
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 👇 الحل هنا: تغليف العنوان بـ Expanded لتجنب الانهيار
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1, // إجبار النص على البقاء في سطر واحد
                          overflow: TextOverflow.ellipsis, // وضع ثلاث نقاط في حال كان النص طويلاً
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8), // مسافة أمان صغيرة
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFF9C54D),
                            size: 18,
                          ),
                          Text(" $rating", style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppLocalizations.of(context)!.byLabel} $companyName',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (location.isNotEmpty || capacity.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          if (location.isNotEmpty) ...[
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey,
                            ),
                            Text(
                              " $location  ",
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                          if (capacity.isNotEmpty) ...[
                            const Icon(
                              Icons.people,
                              size: 14,
                              color: Colors.grey,
                            ),
                            Text(
                              " $capacity",
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),

                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: const Color(0xFFF9C54D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.viewDetails,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
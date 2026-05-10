import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String title;
  final String companyName;
  final String price;
  final String imageUrl;
  final double rating;
  final String? location;
  final String? capacity;
  final VoidCallback onTap;

  const ResultCard({
    super.key,
    required this.title,
    required this.companyName,
    required this.price,
    required this.imageUrl,
    required this.rating,
    this.location,
    this.capacity,
    required this.onTap,
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
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                    "By $companyName",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (location != null || capacity != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          if (location != null) ...[
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
                          if (capacity != null) ...[
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
                      const Text(
                        "View Details",
                        style: TextStyle(color: Colors.blue, fontSize: 12),
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

import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

Widget buildChoiceCard(
  BuildContext context, {
  required String title,
  required String description,
  required String imagePath,
  required String buttonText,
  required Widget destination,
  bool isPreferred = false,
}) {
  final theme = Theme.of(context);
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    decoration: BoxDecoration(
      // 1. التعديل هنا: استخدام لون السطح من الثيم
      color: theme.colorScheme.surface,

      borderRadius: BorderRadius.circular(15),

      // 2. إضافة ظل خفيف (BoxShadow) لتمييز الكارد عن الخلفية تماماً
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],

      border: isPreferred
          ? Border.all(color: theme.colorScheme.primary, width: 1)
          : null,
    ),
    child: Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: Image.asset(
            imagePath,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 180,
                color: Colors.grey[900],
                child: const Icon(
                  Icons.broken_image,
                  color: AppColors.greyText,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(description, style: theme.textTheme.bodySmall),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => destination),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,

                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

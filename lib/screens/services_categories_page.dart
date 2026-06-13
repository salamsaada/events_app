import 'package:flutter/material.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:eventsapp/models/listing_model.dart';

import 'service_details_page.dart';

class ServicesCategoriesPage extends StatelessWidget {
  ServicesCategoriesPage({super.key});

  final List<Map<String, dynamic>> categories = [
    {
      "id": "floral",
      "icon": Icons.local_florist,
      "image": "assets/flowers.jpg",
    },
    {
      "id": "photography",
      "icon": Icons.camera_alt,
      "image": "assets/camera.jpg",
    },
    {
      "id": "catering",
      "icon": Icons.restaurant,
      "image": "assets/catering.jpg",
    },
    {
      "id": "soundLight",
      "icon": Icons.surround_sound,
      "image": "assets/sound.jpg",
    },
    {"id": "cakesSweets", "icon": Icons.cake, "image": "assets/cake.jpg"},
    {"id": "djMusic", "icon": Icons.music_note, "image": "assets/music.jpg"},
  ];

  String _categoryName(AppLocalizations l10n, String categoryId) {
    switch (categoryId) {
      case 'floral':
        return l10n.servicesCategoryFloralDesign;
      case 'photography':
        return l10n.servicesCategoryPhotography;
      case 'catering':
        return l10n.servicesCategoryCatering;
      case 'soundLight':
        return l10n.servicesCategorySoundLight;
      case 'cakesSweets':
        return l10n.servicesCategoryCakesSweets;
      case 'djMusic':
        return l10n.servicesCategoryDjMusic;
      default:
        return l10n.individualServices;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.individualServices), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final categoryId = category['id'] as String;
            final categoryName = _categoryName(l10n, categoryId);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceDetailsPage(
                      categoryId: categoryId,
                      icon: category['icon'] as IconData,
                      item: ServiceItem.fromJson(const {}),
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      child: Icon(
                        category['icon'],
                        size: 35,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      categoryName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

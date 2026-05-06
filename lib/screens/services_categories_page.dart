import 'package:flutter/material.dart';

class ServicesCategoriesPage extends StatelessWidget {
  ServicesCategoriesPage({super.key});

  final List<Map<String, dynamic>> categories = [
    {
      "name": "Floral Design",
      "icon": Icons.local_florist,
      "image": "assets/flowers.jpg"
    },
    {
      "name": "Photography",
      "icon": Icons.camera_alt,
      "image": "assets/camera.jpg"
    },
    {
      "name": "Catering",
      "icon": Icons.restaurant,
      "image": "assets/catering.jpg"
    },
    {
      "name": "Sound & Light",
      "icon": Icons.surround_sound,
      "image": "assets/sound.jpg"
    },
    {
      "name": "Cakes & Sweets",
      "icon": Icons.cake,
      "image": "assets/cake.jpg"
    },
    {
      "name": "DJ & Music",
      "icon": Icons.music_note,
      "image": "assets/music.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Individual Services"),
        centerTitle: true,
      ),
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
            return GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ReadyMadePackagesPage(
                //       categoryName: category['name'],
                //     ),
                //   ),
                // );
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
                      category['name'],
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
import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:eventsapp/cubit/favorites_cubit.dart';
import 'package:eventsapp/cubit/favorites_state.dart';
import 'package:eventsapp/models/listing_model.dart'; 
import 'package:eventsapp/screens/detailsListings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "My Favorites",
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : AppColors.primary,
        ),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryGold));
          } else if (state is FavoritesError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          } else if (state is FavoritesLoaded) {
            final favorites = state.favorites; 

            if (favorites.isEmpty) {
              return Center(
                child: Text(
                  "No favorites yet.",
                  style: TextStyle(color: theme.hintColor, fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                return _buildHallCard(context, isDark, item);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildHallCard(BuildContext context, bool isDark, ServiceItem item) {
    final theme = Theme.of(context);

    // استخراج بيانات الصالة بأمان
    final String hallName = item.title['ar'] ?? item.title['en'] ?? 'Unknown Hall';
    final String price = item.variants.isNotEmpty
        ? '${item.variants[0].price} ${item.variants[0].currency}'
        : 'N/A';
    final String location = item.district.name;

    final String imageUrl = item.images.isNotEmpty
        ? item.images[0]['url'] ?? item.images[0].toString()
        : 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=1000';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // قسم الصورة وزر القلب
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
              Positioned(
                top: 15,
                left: 15,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: isDark ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.9),
                  child: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red, size: 20),
                    onPressed: () {
                      // إزالة أو تبديل حالة المفضلة عند الضغط على القلب
                      context.read<FavoritesCubit>().toggleHeart(item.id);
                    },
                  ),
                ),
              ),
            ],
          ),

          // قسم التفاصيل والنصوص
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        hallName,
                        style: theme.textTheme.displayLarge?.copyWith(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      price,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: isDark ? Colors.grey[500] : Colors.grey[400],
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(location, style: theme.textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 12),
                
                // زر عرض التفاصيل والحجز
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ServiceDetailsPage(item: item),
                        ),
                      );
                    },
                    style: theme.elevatedButtonTheme.style,
                    child: const Text("View Details & Book"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
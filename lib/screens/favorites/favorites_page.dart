import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:eventsapp/cubit/favorites_cubit.dart';
import 'package:eventsapp/cubit/favorites_state.dart';
import 'package:eventsapp/cubit/language_cubit.dart';
import 'package:eventsapp/core/utils/localized_value.dart';
import 'package:eventsapp/cubit/user_cubit.dart';
import 'package:eventsapp/models/listing_model.dart'; 
import 'package:eventsapp/screens/detailsListings.dart'; 
import 'package:eventsapp/screens/service_details_page.dart';
import 'package:eventsapp/screens/product_details_page.dart'; 
import 'package:eventsapp/screens/details_page.dart'; 
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

  // 🚀 [الدالة الذكية الموحدة: مطابقة 100% لكل الأقسام] 🚀
  String getUniversalSmartImageUrl(ServiceItem item) {
    if (item.images.isNotEmpty) {
      String url = (item.images[0] is Map ? item.images[0]['url'] : item.images[0].toString());
      if (url.isNotEmpty && url.startsWith('http') && !url.contains('localhost') && !url.contains('127.0.0.1') && !url.contains('placeholder') && !url.contains('example')) {
        return url; 
      }
    }

    final String title = item.title.toString().toLowerCase();
    final String type = item.type ?? ''; 
    
    // 🚀 السر هون لتوحيد الصورة بكل مكان (البصمة الفريدة)
    int uniqueNum = item.id.hashCode.abs();

    if (type == 'physical_product' || title.contains('chair') || title.contains('كرسي') || title.contains('كراسي')) {
      List<String> chairImages = [
        'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?auto=format&fit=crop&w=400&q=60', 
        'https://images.unsplash.com/photo-1592078615290-033ee584e267?auto=format&fit=crop&w=400&q=60', 
        'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?auto=format&fit=crop&w=400&q=60', 
        'https://images.unsplash.com/photo-1580480055273-228ff5388ef8?auto=format&fit=crop&w=400&q=60', 
        'https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=400&q=60', 
        'https://images.unsplash.com/photo-1560185007-cde436f6a4d0?auto=format&fit=crop&w=400&q=60', 
        'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=400&q=60', 
      ];
      return chairImages[uniqueNum % chairImages.length];
    } 
    else if (title.contains('table') || title.contains('طاولة') || title.contains('طاولات')) {
      List<String> tableImages = [
        'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&w=400&q=60',
        'https://images.unsplash.com/photo-1577140917170-285929fb55b7?auto=format&fit=crop&w=400&q=60',
        'https://images.unsplash.com/photo-1533090481720-856c6e3c1fdc?auto=format&fit=crop&w=400&q=60',
      ];
      return tableImages[uniqueNum % tableImages.length];
    }

    if (type == 'hall' || title.contains('صالة') || title.contains('hall')) {
      List<String> hallImages = [
        'assets/images/photo_2026-08-20_01-01-38.jpg', 
        'assets/images/photo_2026-08-20_01-01-52.jpg', 
        'assets/images/photo_2026-08-20_01-05-55.jpg', 
      ];
      return hallImages[uniqueNum % hallImages.length];
    }
    
    if (type == 'package' || title.contains('باقة') || title.contains('package')) {
      List<String> packageImages = [
        'assets/images/photo_2026-08-20_01-44-06.jpg',
        'assets/images/photo_2026-08-20_01-44-14.jpg',
        'assets/images/photo_2026-08-20_01-44-19.jpg',
      ];
      return packageImages[uniqueNum % packageImages.length];
    }

    // 🚀 التعديل الأهم: وحدنا صور الخدمات لتطابق صفحة الخدمات الأساسية
    List<String> serviceImages = [
      'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=1000&q=80', // كاميرا وعدسات
      'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?auto=format&fit=crop&w=1000&q=80', // مصور مع كاميرا
      'https://images.unsplash.com/photo-1452587925148-ce544e77e70d?auto=format&fit=crop&w=1000&q=80', // كاميرا كلاسيك
    ];
    return serviceImages[uniqueNum % serviceImages.length];
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
          style: TextStyle(color: isDark ? Colors.white : AppColors.primary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : AppColors.primary),
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
                child: Text("No favorites yet.", style: TextStyle(color: theme.hintColor, fontSize: 16)),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return _buildFavoriteCard(context, isDark, favorites[index]);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, bool isDark, ServiceItem item) {
    final theme = Theme.of(context);
    final languageCode = context.watch<LanguageCubit>().languageCode;
    final String itemName = localizedText(item.title, languageCode, fallback: 'Unknown Item');
    final String price = item.variants.isNotEmpty ? '${item.variants[0].price} ${item.variants[0].currency}' : 'N/A';
    final String location = item.district.name;

    final String imageUrl = getUniversalSmartImageUrl(item);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(isDark ? 0.4 : 0.08), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: imageUrl.startsWith('http')
                    ? Image.network(
                        imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        cacheWidth: 400,
                        errorBuilder: (context, error, stackTrace) {
                           int uniqueNum = item.id.hashCode.abs();
                           final List<String> localFallbacks = [
                             'assets/images/photo_2026-08-20_01-01-38.jpg', 
                             'assets/images/photo_2026-08-20_01-01-52.jpg', 
                             'assets/images/photo_2026-08-20_01-05-55.jpg', 
                           ];
                           return Image.asset(
                             localFallbacks[uniqueNum % localFallbacks.length],
                             height: 200,
                             width: double.infinity,
                             fit: BoxFit.cover,
                           );
                        },
                      )
                    : Image.asset(
                        imageUrl, 
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
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
                    onPressed: () => context.read<FavoritesCubit>().toggleHeart(item.id),
                  ),
                ),
              ),
            ],
          ),
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
                        itemName,
                        style: theme.textTheme.displayLarge?.copyWith(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      price,
                      style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.location_on, color: isDark ? Colors.grey[500] : Colors.grey[400], size: 18),
                    const SizedBox(width: 5),
                    Text(location, style: theme.textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      final currentCubit = context.read<UserCubit>(); 
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: currentCubit,
                            child: item.type == 'hall' 
                                ? HallDetailsPage(item: item, passedImageUrl: imageUrl) 
                                : item.type == 'package'
                                    ? DetailsPage(listingId: item.id, passedImageUrl: imageUrl)
                                    : item.type == 'physical_product' 
                                        ? ProductDetailsPage(item: item) 
                                        : ServiceDetailsPage(item: item),
                          ),
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
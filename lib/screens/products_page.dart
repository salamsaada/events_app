import 'package:eventsapp/core/widgets/common/favorite_button.dart';
import 'package:eventsapp/cubit/favorites_cubit.dart';
import 'package:eventsapp/cubit/favorites_state.dart';
import 'package:eventsapp/cubit/theme_cubit.dart';
import 'package:eventsapp/cubit/language_cubit.dart';
import 'package:eventsapp/core/utils/localized_value.dart';
import 'package:eventsapp/cubit/user_cubit.dart';
import 'package:eventsapp/cubit/user_state.dart';
import 'package:eventsapp/models/listing_model.dart';
import 'package:eventsapp/screens/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/core/api/end_ponits.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  // 🆕 خريطة تخزّن التقييم الحقيقي لكل منتج: listingId → average rating
  Map<String, double> _ratingsMap = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<UserCubit>().state;
      if (state is! GetListingLoading) {
        context.read<UserCubit>().getListing(type: 'physical_product');
      }
    });
  }

  // 🚀 [الدالة الذكية: النسخة النهائية المضادة للتكرار] 🚀
  String getSmartImageUrl(ServiceItem item) {
    final String activeHost = EndPoint.baseUrl.split('/api')[0];

    String? extractValidUrl(List<dynamic>? images) {
      if (images == null || images.isEmpty) return null;
      String url = (images[0] is Map ? images[0]['url'] : images[0].toString());
      if (url.isNotEmpty && url.startsWith('http') && !url.contains('placeholder')) {
        if (url.contains('127.0.0.1:8000') || url.contains('localhost:8000') || url.contains('10.0.2.2:8000')) {
          url = url.replaceAll(RegExp(r'http://(127\.0\.0\.1|localhost|10\.0\.2\.2):8000'), activeHost);
        }
        return url;
      }
      return null;
    }

    String? finalUrl = extractValidUrl(item.images);

    if (finalUrl == null && item.variants.isNotEmpty) {
      for (var variant in item.variants) {
        finalUrl = extractValidUrl(variant.images);
        if (finalUrl != null) break;
      }
    }

    if (finalUrl != null) return finalUrl;

    int uniqueNum = item.id.codeUnits.fold(0, (sum, char) => sum + char);
    final String title = item.title.toString().toLowerCase();

    if (title.contains('chair') || title.contains('كرسي') || title.contains('كراسي')) {
      List<String> chairImages = [
        'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1592078615290-033ee584e267?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?auto=format&fit=crop&w=1000&q=80',
      ];
      return chairImages[uniqueNum % chairImages.length];
    } else if (title.contains('table') || title.contains('طاولة') || title.contains('طاولات')) {
      List<String> tableImages = [
        'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1577140917170-285929fb55b7?auto=format&fit=crop&w=1000&q=80',
      ];
      return tableImages[uniqueNum % tableImages.length];
    }

    final List<String> fallbackImages = [
      'https://images.unsplash.com/photo-1519225421980-715cb0215aed?q=80&w=1000',
      'https://images.unsplash.com/photo-1520854221256-17451cc331bf?q=80&w=1000',
    ];
    return fallbackImages[uniqueNum % fallbackImages.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.read<ThemeCubit>().isDark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(isAr ? 'المنتجات' : 'Products'),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: theme.appBarTheme.iconTheme,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
      ),
      body: BlocConsumer<UserCubit, UserState>( // 👈 تغيّر من BlocBuilder لـ BlocConsumer
        listenWhen: (previous, current) =>
            current is GetListingSuccess || current is GetListingRatingsSuccess,
        listener: (context, state) {
          if (state is GetListingSuccess) {
            // 🆕 بعد ما تجيب المنتجات، اطلب تقييماتها الحقيقية فوراً
            final ids = state.listingResponse.data
                .where((item) => item.type == 'physical_product')
                .map((item) => item.id)
                .toList();
            if (ids.isNotEmpty) {
              context.read<UserCubit>().getListingRatings(ids);
            }
          } else if (state is GetListingRatingsSuccess) {
            // 🆕 خزّن التقييمات محلياً وحدّث الواجهة
            final Map<String, double> newRatings = {};
            for (final item in state.ratingsResponse.data) {
              if (item.listingId != null && item.rating?.average != null) {
                newRatings[item.listingId!] = item.rating!.average!;
              }
            }
            setState(() => _ratingsMap = newRatings);
          }
        },
        buildWhen: (previous, current) {
          return current is GetListingLoading ||
                 current is GetListingSuccess ||
                 current is GetListingFailure;
        },
        builder: (context, state) {
          if (state is GetListingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetListingFailure) {
            return Center(
              child: Text(
                state.errMessage,
                style: TextStyle(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (state is GetListingSuccess) {
            final listings = state.listingResponse.data
                .where((item) => item.type == 'physical_product')
                .toList();

            if (listings.isEmpty) {
              return Center(
                child: Text(
                  isAr ? 'لا توجد منتجات متاحة حاليًا' : 'No products available currently',
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<UserCubit>().getListing(type: 'physical_product'),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: listings.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(context, isDark, isAr, listings[index]);
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, bool isDark, bool isAr, ServiceItem item) {
    final theme = Theme.of(context);
    final languageCode = context.watch<LanguageCubit>().languageCode;

    final String productName = localizedText(
      item.title,
      languageCode,
      fallback: isAr ? 'منتج غير معروف' : 'Unknown Product',
    );
    final String price = item.variants.isNotEmpty
        ? '${item.variants[0].price} ${item.variants[0].currency}'
        : (isAr ? 'غير متوفر' : 'N/A');
    final String location = item.district.name;

    final String imageUrl = getSmartImageUrl(item);

    // 🆕 التقييم الحقيقي بدل الرقم الثابت 4.9
    final double rating = _ratingsMap[item.id] ?? 0.0;
    final String ratingDisplay = rating > 0 ? rating.toStringAsFixed(1) : '--';

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
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
                  ),
                ),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: theme.colorScheme.primary, size: 16),
                      Text(
                        " $ratingDisplay", // 👈 عدّلنا هون: تقييم حقيقي بدل 4.9 الثابتة
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 15,
                left: 15,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: isDark
                      ? Colors.black.withOpacity(0.6)
                      : Colors.white.withOpacity(0.9),
                  child: Center(
                    child: BlocBuilder<FavoritesCubit, FavoritesState>(
                      builder: (context, favState) {
                        bool isFav = false;
                        if (favState is FavoritesLoaded) {
                          isFav = favState.favorites.any((f) => f.id == item.id);
                        }
                        return FavoriteButton(
                          key: ValueKey('${item.id}_$isFav'),
                          listingId: item.id,
                          initialIsFavorite: isFav,
                        );
                      },
                    ),
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
                        productName,
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
                    Icon(Icons.location_on, color: isDark ? Colors.grey[500] : Colors.grey[400], size: 18),
                    const SizedBox(width: 5),
                    Text(location, style: theme.textTheme.bodySmall),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: theme.colorScheme.onSurface.withOpacity(0.1)),
                ),
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
                            child: ProductDetailsPage(item: item),
                          ),
                        ),
                      );
                    },
                    style: theme.elevatedButtonTheme.style,
                    child: Text(isAr ? 'عرض التفاصيل' : 'View Details'),
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
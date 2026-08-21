import 'package:eventsapp/core/widgets/common/favorite_button.dart';
import 'package:eventsapp/cubit/favorites_cubit.dart';
import 'package:eventsapp/cubit/favorites_state.dart';
import 'package:eventsapp/cubit/theme_cubit.dart';
import 'package:eventsapp/cubit/language_cubit.dart';
import 'package:eventsapp/core/utils/localized_value.dart';
import 'package:eventsapp/cubit/user_cubit.dart';
import 'package:eventsapp/cubit/user_state.dart';
import 'package:eventsapp/models/listing_model.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:eventsapp/screens/detailsListings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeddingHallsPage extends StatefulWidget {
  const WeddingHallsPage({super.key});

  @override
  State<WeddingHallsPage> createState() => _WeddingHallsPageState();
}

class _WeddingHallsPageState extends State<WeddingHallsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<UserCubit>().state;
      if (state is! GetListingLoading) {
        context.read<UserCubit>().getListing(type: 'hall');
      }
    });
  }

  // 🚀 [الدالة الذكية للصالات: باستخدام صور الـ Assets المحلية] 🚀
  String getSmartImageUrl(ServiceItem item) {
    // 1. فحص صارم جداً لرابط الويب (الداتا بيز)
    if (item.images.isNotEmpty) {
      String url = (item.images[0] is Map
          ? item.images[0]['url']
          : item.images[0].toString());

      // الفلتر: لازم يبدأ بـ http وممنوع يكون رابط محلي أو وهمي
      if (url.isNotEmpty &&
          url.startsWith('http') &&
          !url.contains('localhost') &&
          !url.contains('127.0.0.1') &&
          !url.contains('placeholder') &&
          !url.contains('example')) {
        return url;
      }
    }

    // 2. السر لتوزيع الصور بشكل عادل ومستحيل يتكرر
    int uniqueNum = item.id.toString().codeUnits.fold(
      0,
      (sum, char) => sum + char,
    );

    // 3. مسارات الصور الـ 3 اللي ضفتيهم بمشروعك
    final List<String> fallbackImages = [
      'assets/images/photo_2026-08-20_01-01-38.jpg',
      'assets/images/photo_2026-08-20_01-01-52.jpg',
      'assets/images/photo_2026-08-20_01-05-55.jpg',
    ];

    return fallbackImages[uniqueNum % fallbackImages.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.read<ThemeCubit>().isDark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.weddingHalls),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: theme.appBarTheme.iconTheme,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
      ),
      body: BlocBuilder<UserCubit, UserState>(
        // 🚀 السطرين هدول هنن الحل: نمنع الصفحة من الانهيار لما نرجع من التفاصيل
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
                .where((item) => item.type == 'hall')
                .toList();

            if (listings.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.pageWillBeAvailable),
              );
            }

            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<UserCubit>().getListing(type: 'hall'),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: listings.length,
                itemBuilder: (context, index) {
                  return _buildHallCard(context, isDark, listings[index]);
                },
              ),
            );
          }

          // هذا السطر اللي كان يعمل الشاشة البيضا، بس هلا مع الـ buildWhen ما عاد يوصله أبداً بعد الرجوع!
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildHallCard(BuildContext context, bool isDark, ServiceItem item) {
    final theme = Theme.of(context);
    final languageCode = context.watch<LanguageCubit>().languageCode;

    final String hallName = localizedText(
      item.title,
      languageCode,
      fallback: 'Unknown Hall',
    );
    final String price = item.variants.isNotEmpty
        ? '${item.variants[0].price} ${item.variants[0].currency}'
        : 'N/A';
    final String location = item.district.name;

    String capacityInfo = 'N/A';

    if (item.variants.isNotEmpty) {
      final capacity = item.variants[0].capacity;

      if (capacity != null && capacity > 0) {
        capacityInfo = 'Up to $capacity Guests';
      }
    }

    // 🚀 استدعاء الدالة الذكية للحصول على الصورة
    final String imageUrl = getSmartImageUrl(item);

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
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                // 🚀 الفحص الذكي: هل نعرض صورة من النت أم صورة محلية من التطبيق؟
                child: imageUrl.startsWith('http')
                    ? Image.network(
                        imageUrl, // رابط حقيقي من السيرفر
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        cacheWidth: 400,
                        errorBuilder: (context, error, stackTrace) {
                          // إذا الرابط الحقيقي ميت، نعرض صورة محلية كاحتياط
                          int uniqueNum = item.id.toString().codeUnits.fold(
                            0,
                            (sum, char) => sum + char,
                          );
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
                        imageUrl, // مسار صورة محلية (لأن الباك إند ما بعت صورة صالحة)
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),

              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: theme.colorScheme.primary,
                        size: 16,
                      ),
                      const Text(
                        " 4.9",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
                          isFav = favState.favorites.any(
                            (favItem) => favItem.id == item.id,
                          );
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
                        hallName,
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: 18,
                        ),
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
                    const SizedBox(width: 20),
                    Icon(
                      Icons.line_weight_sharp,
                      color: isDark ? Colors.grey[500] : Colors.grey[400],
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(capacityInfo, style: theme.textTheme.bodySmall),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(
                    color: theme.colorScheme.onSurface.withOpacity(0.1),
                  ),
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
                            child: HallDetailsPage(
                              item: item,
                              passedImageUrl:
                                  imageUrl, // 🚀 ضفنا هاد السطر لتمرير الصورة
                            ),
                          ),
                        ),
                      );
                    },
                    style: theme.elevatedButtonTheme.style,
                    child: Text(AppLocalizations.of(context)!.viewDetails),
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

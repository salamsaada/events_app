import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:eventsapp/cubit/language_cubit.dart';
import 'package:eventsapp/cubit/user_cubit.dart';
import 'package:eventsapp/cubit/user_state.dart';
import 'package:eventsapp/cubit/theme_cubit.dart';
import 'package:eventsapp/cubit/favorites_cubit.dart';
import 'package:eventsapp/cubit/favorites_state.dart';
import 'package:eventsapp/core/utils/localized_value.dart';
import 'package:eventsapp/core/widgets/common/favorite_button.dart';
import 'package:eventsapp/models/listing_model.dart';
import 'details_page.dart';

class ReadyMadePackagesPage extends StatefulWidget {
  final String categoryName;

  const ReadyMadePackagesPage({super.key, required this.categoryName});

  @override
  State<ReadyMadePackagesPage> createState() => _ReadyMadePackagesPageState();
}

class _ReadyMadePackagesPageState extends State<ReadyMadePackagesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<UserCubit>().state;
      if (state is! GetListingLoading && state is! GetListingSuccess) {
        context.read<UserCubit>().getListing(type: 'package');
      }
    });
  }

  // 🚀 [الدالة الذكية: تعتمد على البصمة الفريدة hashCode لمنع التغير] 🚀
  String getSmartImageUrl(ServiceItem item) {
    if (item.images.isNotEmpty) {
      String url = (item.images[0] is Map
          ? item.images[0]['url']
          : item.images[0].toString());
      if (url.isNotEmpty &&
          url.startsWith('http') &&
          !url.contains('localhost') &&
          !url.contains('placeholder') &&
          !url.contains('example')) {
        return url;
      }
    }

    final List<String> fallbackImages = [
      'assets/images/photo_2026-08-20_01-44-06.jpg',
      'assets/images/photo_2026-08-20_01-44-14.jpg',
      'assets/images/photo_2026-08-20_01-44-19.jpg',
    ];

    // 🚀 استخدام بصمة الـ ID لتثبيت الصورة
    int uniqueNum = item.id.hashCode.abs();
    return fallbackImages[uniqueNum % fallbackImages.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.read<ThemeCubit>().isDark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.categoryName),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: theme.appBarTheme.iconTheme,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
      ),
      body: BlocBuilder<UserCubit, UserState>(
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
              ),
            );
          }

          if (state is GetListingSuccess) {
            final listings = state.listingResponse.data
                .where((item) => item.type == 'package')
                .toList();

            if (listings.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.pageWillBeAvailable),
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchHint,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async =>
                        context.read<UserCubit>().getListing(type: 'package'),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: listings.length,
                      itemBuilder: (context, index) {
                        return _buildPackageCard(
                          context,
                          isDark,
                          listings[index],
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildPackageCard(
    BuildContext context,
    bool isDark,
    ServiceItem item,
  ) {
    final theme = Theme.of(context);
    final languageCode = context.watch<LanguageCubit>().languageCode;

    final String packageName = localizedText(
      item.title,
      languageCode,
      fallback: 'Unknown Package',
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
                            'assets/images/photo_2026-08-20_01-44-06.jpg',
                            'assets/images/photo_2026-08-20_01-44-14.jpg',
                            'assets/images/photo_2026-08-20_01-44-19.jpg',
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
                        packageName,
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
                            child: DetailsPage(
                              listingId: item.id,
                              passedImageUrl:
                                  imageUrl, // 🚀 تمرير الصورة لصفحة التفاصيل
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:eventsapp/cubit/language_cubit.dart';
import 'package:eventsapp/cubit/user_cubit.dart';
import 'package:eventsapp/cubit/user_state.dart';
import 'package:eventsapp/cubit/favorites_cubit.dart';
import 'package:eventsapp/cubit/favorites_state.dart';
import 'package:eventsapp/core/utils/localized_value.dart';
import 'package:eventsapp/core/widgets/common/result_card.dart';
import 'package:eventsapp/models/listing_model.dart';
import 'service_details_page.dart';

class ServicesCategoriesPage extends StatefulWidget {
  const ServicesCategoriesPage({super.key});

  @override
  State<ServicesCategoriesPage> createState() => _ServicesCategoriesPageState();
}

class _ServicesCategoriesPageState extends State<ServicesCategoriesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserCubit>().getListing(type: 'service');
    });
  }

  // 🚀 [الدالة الذكية لجلب الصورة الخاصة بالخدمات] 🚀
  String getSmartImageUrl(ServiceItem item) {
    final List<String> fallbackImages = [
      'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=1000&q=80', // كاميرا وعدسات
      'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?auto=format&fit=crop&w=1000&q=80', // مصور مع كاميرا
      'https://images.unsplash.com/photo-1452587925148-ce544e77e70d?auto=format&fit=crop&w=1000&q=80', // كاميرا فيلم قديمة/كلاسيك
    ];

    if (item.images.isNotEmpty) {
      String url = (item.images[0] is Map ? item.images[0]['url'] : item.images[0].toString());
      if (url.isNotEmpty && url.startsWith('http') && !url.contains('placeholder') && !url.contains('localhost')) {
        return url; 
      }
    }

    int hash = item.id.hashCode.abs();
    return fallbackImages[hash % fallbackImages.length];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.individualServices), 
        centerTitle: true,
      ),
      body: BlocBuilder<UserCubit, UserState>(
        // 🚀 السطرين هدول هنن الحل لمنع الشاشة البيضاء عند الرجوع
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
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is GetListingSuccess) {
            final products = state.listingResponse.data
                .where((item) => item.type == 'service')
                .toList();

            if (products.isEmpty) {
              return Center(child: Text(l10n.pageWillBeAvailable));
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<UserCubit>().getListing(type: 'service');
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final item = products[index];
                  final languageCode = context.watch<LanguageCubit>().languageCode;

                  final String title = localizedText(item.title, languageCode);
                  final String providerName = item.category.name; 
                  final String price = item.variants.isNotEmpty
                      ? '${item.variants[0].price} ${item.variants[0].currency}'
                      : 'غير متوفر';
                  
                  final String imageUrl = getSmartImageUrl(item);

                  // 🚀 [هنا التعديل: الدوران على كل الباقات لمعرفة السعة الحقيقية] 🚀
                  String capacityInfo = '';
                  if (item.variants.isNotEmpty) {
                    int maxCapacity = 0;
                    int maxStock = 0;

                    for (var variant in item.variants) {
                      if (variant.capacity != null && (variant.capacity as num).toInt() > maxCapacity) {
                        maxCapacity = (variant.capacity as num).toInt();
                      }
                      if (variant.stock != null && (variant.stock as num).toInt() > maxStock) {
                        maxStock = (variant.stock as num).toInt();
                      }
                    }

                    final isArabic = languageCode == 'ar';
                    
                    if (maxCapacity > 0) {
                      capacityInfo = isArabic ? 'السعة: $maxCapacity' : 'Capacity: $maxCapacity';
                    } else if (maxStock > 0) {
                      capacityInfo = isArabic ? 'الكمية: $maxStock' : 'Qty: $maxStock';
                    } else {
                      capacityInfo = isArabic ? 'السعة: 0' : 'Capacity: 0';
                    }
                  }

                  return BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, favState) {
                      bool isFavorite = false;
                      if (favState is FavoritesLoaded) {
                        isFavorite = favState.favorites.any((fav) => fav.id == item.id);
                      }

                      return ResultCard(
                        key: ValueKey('${item.id}_$isFavorite'),
                        title: title,
                        companyName: providerName,
                        price: price,
                        imageUrl: imageUrl, 
                        rating: 4.5,
                        location: item.district.name,
                        capacity: capacityInfo, // 👈 تم تمرير السعة الصحيحة هنا
                        isFavorite: isFavorite,
                        onFavoriteToggle: () {
                          context.read<FavoritesCubit>().toggleHeart(item.id); 
                        },
                        onTap: () {
                          final currentCubit = context.read<UserCubit>();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: currentCubit,
                                child: ServiceDetailsPage(
                                  item: item,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
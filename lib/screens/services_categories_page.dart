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
      // 🚀 التعديل الأول: طلب الـ service بدل المنتجات
      context.read<UserCubit>().getListing(type: 'service');
    });
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
            // 🚀 التعديل الثاني: فلترة النتائج لعرض الخدمات فقط
            final products = state.listingResponse.data
                .where((item) => item.type == 'service')
                .toList();

            if (products.isEmpty) {
              return Center(child: Text(l10n.pageWillBeAvailable));
            }

            return RefreshIndicator(
              onRefresh: () async {
                // 🚀 التعديل الثالث: تحديث الصفحة يجلب الخدمات فقط
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
                  
                  final String imageUrl = item.images.isNotEmpty
                      ? (item.images[0] is Map ? item.images[0]['url'] : item.images[0].toString())
                      : 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=1000';

                  // 🚀 التعديل الرابع: معالجة السعة أو الكمية بذكاء
                  String capacityInfo = '';
                  if (item.variants.isNotEmpty) {
                    if (item.variants[0].capacity != null) {
                      capacityInfo = 'السعة: ${item.variants[0].capacity}';
                    } else if (item.variants[0].stock != null) {
                      capacityInfo = 'الكمية: ${item.variants[0].stock}';
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
                        capacity: capacityInfo, 
                        isFavorite: isFavorite,
                        onFavoriteToggle: () {
                          // تأكدي من تمرير item المباشر أو item.id حسب دالة الكيوبت عندك
                          context.read<FavoritesCubit>().toggleHeart(item.id); 
                        },
                        // في ملف ServicesCategoriesPage
                        // ...
                        onTap: () {
                          // 🚀 1. نجلب الـ Cubit الحالي قبل الانتقال
                          final currentCubit = context.read<UserCubit>();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // 🚀 2. نغلف الصفحة الجديدة بـ BlocProvider.value لنفس الكيوبت
                              builder: (_) => BlocProvider.value(
                                value: currentCubit,
                                child: ServiceDetailsPage(
                                  // نمرر الـ id فقط أو الـ item كله، بس الأهم نستدعي الـ API
                                  item: item,
                                ),
                              ),
                            ),
                          );
                        },
                          // ...
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:eventsapp/cubit/language_cubit.dart';
import 'package:eventsapp/cubit/user_cubit.dart';
import 'package:eventsapp/cubit/user_state.dart';
import 'package:eventsapp/cubit/favorites_cubit.dart';
import 'package:eventsapp/cubit/favorites_state.dart';
import 'package:eventsapp/core/utils/localized_value.dart';
import 'package:eventsapp/core/widgets/common/result_card.dart'; // تأكدي من مسار الـ ResultCard لديك
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
    // 🚀 جلب المنتجات الملموسة فور فتح الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserCubit>().getListing(type: 'physical_product');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        // يمكنك وضع l10n.products إذا كانت موجودة بملف الترجمة
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
            // 🚀 فلترة إضافية للتأكد من عرض المنتجات فقط
            final products = state.listingResponse.data
                .where((item) => item.type == 'physical_product')
                .toList();

            if (products.isEmpty) {
              return Center(child: Text(l10n.pageWillBeAvailable));
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<UserCubit>().getListing(type: 'physical_product');
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final item = products[index];
                  final languageCode = context.watch<LanguageCubit>().languageCode;

                  final String title = localizedText(item.title, languageCode);
                  // قراءة اسم الشركة المزودة إن وجدت، وإلا نعرض التصنيف
                  // 🚀 نكتفي بعرض اسم التصنيف (Category) لعدم وجود provider في المودل حالياً
                  final String providerName = item.category.name; 
                  final String price = item.variants.isNotEmpty
                      ? '${item.variants[0].price} ${item.variants[0].currency}'
                      : 'غير متوفر';
                  
                  final String imageUrl = item.images.isNotEmpty
                      ? (item.images[0]['url'] ?? item.images[0].toString())
                      : 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=1000';

                  // 🚀 استخراج الكمية المتاحة (Stock)
                  String stockInfo = 'نفدت الكمية';
                  if (item.variants.isNotEmpty && item.variants[0].stock != null) {
                    stockInfo = 'الكمية المتوفرة: ${item.variants[0].stock}';
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
                        capacity: stockInfo, // إرسال المخزون بدلاً من السعة
                        isFavorite: isFavorite,
                        onFavoriteToggle: () {
                          context.read<FavoritesCubit>().toggleHeart(item.id);
                        },
                        onTap: () {
                          // التوجيه لصفحة التفاصيل وإرسال المنتج الحقيقي
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceDetailsPage(item: item), 
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
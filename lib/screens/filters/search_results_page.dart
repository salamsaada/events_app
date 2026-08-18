import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/cubit/user_cubit.dart';
import 'package:eventsapp/cubit/user_state.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:eventsapp/screens/details_page.dart';

class SearchResultsPage extends StatelessWidget {
  final String categoryName;

  const SearchResultsPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.searchResultsTitle(categoryName)),
        centerTitle: true,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          // ==========================================
          // 1. حالات الـ Listings (الصالات والباكجات والخدمات)
          // ==========================================

          // حالة التحميل للـ Listings
          if (state is GetListingLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFD6B237)),
            );
          }

          // حالة الخطأ للـ Listings
          if (state is GetListingFailure) {
            return Center(
              child: Text(
                state.errMessage,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // حالة النجاح للـ Listings
          if (state is GetListingSuccess) {
            final listings = state.listingResponse.data;

            if (listings.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noResultsForFilters,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listings.length,
              itemBuilder: (context, index) {
                final item = listings[index];

                final String imageUrl = item.images.isNotEmpty
                    ? item.images[0]
                    : 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=1000';

                final String price = item.variants.isNotEmpty
                    ? '${item.variants[0].price} ${item.variants[0].currency}'
                    : l10n.priceNotAvailable;

                final localeCode = Localizations.localeOf(context).languageCode;
                final String localizedTitle =
                    item.title[localeCode] ??
                    item.title['en'] ??
                    item.title['ar'] ??
                    l10n.notAvailable;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(item: item),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Image.network(
                            imageUrl,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 180,
                                  color: Colors.grey.shade300,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      localizedTitle,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFD6B237,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      item.type.toUpperCase(),
                                      style: const TextStyle(
                                        color: Color(0xFFD6B237),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.district.name,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    '${l10n.startingFrom}: ',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    price,
                                    style: const TextStyle(
                                      color: Color(0xFFD6B237),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          // ==========================================
          // 2. حالات الـ Providers (مزودي الخدمة) 🚀
          // ==========================================

          // حالة التحميل للمزودين
          if (state is GetProvidersLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFD6B237)),
            );
          }

          // حالة الخطأ للمزودين
          if (state is GetProvidersFailure) {
            return Center(
              child: Text(
                state.errMessage,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // حالة النجاح للمزودين
          if (state is GetProvidersSuccess) {
            final providers = state.providers;

            if (providers.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.group_off,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noProvidersFound,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: providers.length,
              itemBuilder: (context, index) {
                final provider = providers[index];

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFD6B237),
                      radius: 25,
                      child: Icon(Icons.business_center, color: Colors.white),
                    ),
                    title: Text(
                      provider['name'] ?? l10n.providerUnnamed,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        provider['type'] == 'company'
                            ? l10n.providerTypeCompany
                            : l10n.providerTypeFreelancer,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xFFD6B237),
                    ),
                    onTap: () {
                      // هنا يمكنك لاحقاً إضافة الكود للانتقال إلى تفاصيل المزود
                      // Navigator.push(...);
                    },
                  ),
                );
              },
            );
          }

          // الحالة الافتراضية
          return const SizedBox();
        },
      ),
    );
  }
}

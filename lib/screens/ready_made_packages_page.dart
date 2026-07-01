import 'package:flutter/material.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:eventsapp/cubit/language_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/cubit/user_cubit.dart';
import 'package:eventsapp/cubit/user_state.dart';
import 'package:eventsapp/core/utils/localized_value.dart';
import '../../../core/widgets/common/result_card.dart';
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
    // جلب البيانات عند فتح الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<UserCubit>().state;
      if (state is! GetListingLoading && state is! GetListingSuccess) {
        context.read<UserCubit>().getListing();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName), centerTitle: true),
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
            final listings = state.listingResponse.data;

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
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: listings.length,
                    itemBuilder: (context, index) {
                      final item = listings[index];
                      final languageCode = context
                          .watch<LanguageCubit>()
                          .languageCode;

                      // استخراج البيانات لتلائم ResultCard
                      final String title = localizedText(
                        item.title,
                        languageCode,
                      );
                      final String companyName =
                          item.category.name; // كبديل لاسم الشركة
                      final String price = item.variants.isNotEmpty
                          ? '${item.variants[0].price} ${item.variants[0].currency}'
                          : 'N/A';
                      final String imageUrl = item.images.isNotEmpty
                          ? item.images[0]
                          : 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=1000';

                      String capacity = 'N/A';
                      if (item.variants.isNotEmpty &&
                          item.variants[0].availabilities.isNotEmpty &&
                          item.variants[0].availabilities[0].slots.isNotEmpty) {
                        capacity =
                            '${item.variants[0].availabilities[0].slots[0].remainingCapacity} Guests';
                      }

                      return ResultCard(
                        title: title,
                        companyName: companyName,
                        price: price,
                        imageUrl: imageUrl,
                        rating: 4.5, // قيمة افتراضية
                        location: item.district.name,
                        capacity: capacity,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // تمرير كائن ServiceItem بالكامل
                              builder: (context) => DetailsPage(item: item),
                            ),
                          );
                        },
                      );
                    },
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
}

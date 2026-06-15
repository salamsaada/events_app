import 'package:eventsapp/cubit/theme_cubit.dart';
import 'package:eventsapp/cubit/user_cubit.dart';
import 'package:eventsapp/cubit/user_state.dart';
import 'package:eventsapp/models/listing_model.dart'; // تأكد أن هذا الملف يحتوي على ServiceItem
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
    // استدعاء دالة جلب البيانات عند إنشاء الصفحة لأول مرة فقط
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<UserCubit>().state;
      if (state is! GetListingSuccess && state is! GetListingLoading) {
        context.read<UserCubit>().getListing();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isDark = context.read<ThemeCubit>().isDark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Wedding Halls"),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: theme.appBarTheme.iconTheme,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          // 1. حالة التحميل
          if (state is GetListingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. حالة الخطأ
          if (state is GetListingFailure) {
            return Center(
              child: Text(
                state.errMessage,
                style: TextStyle(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
            );
          }

          // 3. حالة النجاح ووجود البيانات
          if (state is GetListingSuccess) {
            final listings = state.listingResponse.data;

            if (listings.isEmpty) {
              return const Center(child: Text("No Wedding Halls Found"));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<UserCubit>().getListing();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: listings.length,
                itemBuilder: (context, index) {
                  return _buildHallCard(context, isDark, listings[index]);
                },
              ),
            );
          }

          // 4. الحالة الافتراضية
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildHallCard(BuildContext context, bool isDark, ServiceItem item) {
    final theme = Theme.of(context);

    // 1. استخراج الاسم (إنجليزي أو عربي)
    final String hallName =
        item.title['en'] ?? item.title['ar'] ?? 'Unknown Hall';

    // 2. استخراج السعر من أول باقة (variant)
    final String price = item.variants.isNotEmpty
        ? '${item.variants[0].price} ${item.variants[0].currency}'
        : 'N/A';

    // 3. استخراج الموقع من district
    final String location = item.district.name;

    // 4. استخراج السعة (Capacity) من داخل أول variant -> أول availability -> أول slot
    String capacityInfo = 'N/A';
    if (item.variants.isNotEmpty &&
        item.variants[0].availabilities.isNotEmpty &&
        item.variants[0].availabilities[0].slots.isNotEmpty) {
      final capacity =
          item.variants[0].availabilities[0].slots[0].remainingCapacity;
      capacityInfo = 'Up to $capacity Guests';
    }

    // 5. الصورة (مصفوفة فارغة حالياً في الـ API، لذلك نضع صورة افتراضية)
    final String imageUrl = item.images.isNotEmpty
        ? item.images[0]
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
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
                      Icons.people,
                      color: isDark ? Colors.grey[500] : Colors.grey[400],
                      size: 18,
                    ), // أيقونة الأشخاص
                    const SizedBox(width: 5),
                    Text(
                      capacityInfo, // عرض السعة المأخوذة من slots
                      style: theme.textTheme.bodySmall,
                    ),
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
                      // الانتقال لصفحة التفاصيل مع تمرير الـ item الكامل
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ServiceDetailsPagelist(item: item),
                        ),
                      );
                    },
                    style: theme.elevatedButtonTheme.style,
                    child: const Text("View Details"),
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

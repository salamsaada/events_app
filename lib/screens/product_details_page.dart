import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/cubit/theme_cubit.dart';
import 'package:eventsapp/cubit/language_cubit.dart';
import 'package:eventsapp/cubit/user_cubit.dart';
import 'package:eventsapp/cubit/user_state.dart';
import 'package:eventsapp/core/utils/localized_value.dart';
import 'package:eventsapp/models/listing_model.dart';
import 'package:eventsapp/screens/booking/Booking.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:eventsapp/core/widgets/service_reviews_section.dart';
import 'package:eventsapp/screens/service_reviews_page.dart';

class ProductDetailsPage extends StatefulWidget {
  final ServiceItem item;

  const ProductDetailsPage({super.key, required this.item});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String? _currentDisplayImage; 
  String? _selectedVariantId;
  @override
  void initState() {
    super.initState();
    // 🚀 استدعاء تفاصيل المنتج فور فتح الصفحة باستخدام الـ id
    context.read<UserCubit>().getListingDetails(widget.item.id);
  }

  // 🚀 [الدالة الذكية: النسخة النهائية المضادة للتكرار للمنتجات] 🚀
  String getSmartImageUrl(ServiceItem item) {
    if (item.images.isNotEmpty) {
      String url = (item.images[0] is Map ? item.images[0]['url'] : item.images[0].toString());
      if (url.isNotEmpty && url.startsWith('http') && !url.contains('localhost') && !url.contains('placeholder') && !url.contains('example')) {
        return url; 
      }
    }

    final String title = item.title.toString().toLowerCase();
    int uniqueNum = item.id.codeUnits.fold(0, (sum, char) => sum + char);

    if (title.contains('chair') || title.contains('كرسي') || title.contains('كراسي')) {
      List<String> chairImages = [
        'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?auto=format&fit=crop&w=1000&q=80', 
        'https://images.unsplash.com/photo-1592078615290-033ee584e267?auto=format&fit=crop&w=1000&q=80', 
        'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?auto=format&fit=crop&w=1000&q=80', 
        'https://images.unsplash.com/photo-1580480055273-228ff5388ef8?auto=format&fit=crop&w=1000&q=80', 
        'https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=1000&q=80', 
        'https://images.unsplash.com/photo-1560185007-cde436f6a4d0?auto=format&fit=crop&w=1000&q=80', 
        'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=1000&q=80', 
      ];
      return chairImages[uniqueNum % chairImages.length];
    } 
    else if (title.contains('table') || title.contains('طاولة') || title.contains('طاولات')) {
      List<String> tableImages = [
        'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1577140917170-285929fb55b7?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1533090481720-856c6e3c1fdc?auto=format&fit=crop&w=1000&q=80',
      ];
      return tableImages[uniqueNum % tableImages.length];
    }

    final List<String> fallbackImages = [
      'https://images.unsplash.com/photo-1519225421980-715cb0215aed?q=80&w=1000',
      'https://images.unsplash.com/photo-1520854221256-17451cc331bf?q=80&w=1000',
      'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?q=80&w=1000',
    ];
    
    return fallbackImages[uniqueNum % fallbackImages.length];
  }

  // 🛠 دالة مساعدة لتنسيق التاريخ بأمان
  String _formatDate(dynamic dateData) {
    if (dateData == null || dateData.toString().isEmpty) return 'Date not set';
    try {
      DateTime dt = dateData is DateTime ? dateData : DateTime.parse(dateData.toString());
      List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[dt.month - 1]}, ${dt.year} ${dt.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateData.toString().split('T').first;
    }
  }

  // 🛠 دالة مساعدة لتنسيق الوقت بأمان
  String _formatTime(dynamic timeData) {
    if (timeData == null || timeData.toString().isEmpty) return '';
    try {
      DateTime? dt;
      if (timeData is DateTime) {
        dt = timeData;
      } else {
        dt = DateTime.tryParse(timeData.toString());
      }

      if (dt != null) {
        int h = dt.hour;
        int m = dt.minute;
        String ampm = h >= 12 ? 'PM' : 'AM';
        h = h > 12 ? h - 12 : (h == 0 ? 12 : h);
        return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $ampm';
      } else {
        final parts = timeData.toString().split(':');
        int h = int.parse(parts[0].trim());
        int m = int.parse(parts[1].trim());
        String ampm = h >= 12 ? 'PM' : 'AM';
        h = h > 12 ? h - 12 : (h == 0 ? 12 : h);
        return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $ampm';
      }
    } catch (e) {
      return timeData.toString().split('.').first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is GetListingDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetListingDetailsFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errMessage, style: TextStyle(color: theme.colorScheme.error)),
                  TextButton(
                    onPressed: () => context.read<UserCubit>().getListingDetails(widget.item.id),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }
          if (state is GetListingDetailsSuccess) {
            // 🚀 نمرر العنصر المحدث (state.listing) لعرض التفاصيل الكاملة
            return _buildContent(context, state.listing, theme);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ServiceItem item, ThemeData theme) {
    final isDark = context.read<ThemeCubit>().isDark;
    final languageCode = context.watch<LanguageCubit>().languageCode;
    final loc = AppLocalizations.of(context)!;
     final String defaultImageUrl = getSmartImageUrl(item);
    final String imageUrl = _currentDisplayImage ?? defaultImageUrl;

    final String startingPrice = item.variants.isNotEmpty
        ? '${item.variants[0].price} ${item.variants[0].currency}'
        : loc.notAvailable;

    const Color goldColor = Color(0xFFD6B237);

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // === الصورة العلوية ===
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              stretch: true,
              backgroundColor: theme.scaffoldBackgroundColor,
              iconTheme: theme.appBarTheme.iconTheme,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // === تفاصيل المنتج ===
            SliverToBoxAdapter(
              child: Container(
                transform: Matrix4.translationValues(0, -20, 0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizedText(item.title, languageCode),
                      style: theme.textTheme.displayLarge?.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Starting from $startingPrice',
                      style: const TextStyle(color: goldColor, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    Divider(color: Colors.grey.shade300, thickness: 1),
                    const SizedBox(height: 16),

                    // الموقع والتصنيف
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: goldColor, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              item.district.name,
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 15),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.category, color: goldColor, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              item.category.name,
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.grey.shade300, thickness: 1),
                    const SizedBox(height: 24),

                    // الوصف
                    const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 12),
                    Text(
                      localizedText(item.description, languageCode, fallback: loc.noDescriptionAvailable),
                      style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[800], height: 1.5, fontSize: 15),
                    ),
                    const SizedBox(height: 32),

                    // 🚀 قسم المراجعات والتقييمات الجديد 🚀
                    ServiceReviewsSection(
                      reviews: item.reviews,
                      averageRating: item.averageRating,
                      reviewCount: item.reviewCount,
                      isArabic: languageCode == 'ar',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ServiceReviewsPage(
                            providerId: item.providerId,
                            serviceName: localizedText(item.title, languageCode),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // الخيارات/الباقات المتاحة
                    const Text('Available Packages', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 16),
  ...item.variants.map((variant) {
                      final isSelected = _selectedVariantId == variant.id;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedVariantId = variant.id;
                            // البحث عن صورة لهذا الـ Variant وتحديثها
                            if (variant.images.isNotEmpty) {
                              var vImg = variant.images.first;
                              String? newUrl;
                              if (vImg is Map) {
                                newUrl = vImg['url']?.toString();
                              } else {
                                // في حال كانت كائن (Object) من كلاس
                                try { newUrl = vImg.url; } catch (_) { newUrl = vImg.toString(); }
                              }
                              
                              if (newUrl != null && newUrl.isNotEmpty) {
                                _currentDisplayImage = newUrl;
                              }
                            }
                          });
                        },
                        child: _buildVariantCard(variant, isDark, languageCode, item.type, isSelected),
                      );
                    }).toList(),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        // === زر الحجز الثابت في الأسفل ===
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.surface,
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => _showBookingSheet(context, item),
                style: ElevatedButton.styleFrom(
                  backgroundColor: goldColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 🚀 تصميم كرت الخيارات المطور المشابه للصورة 🚀
  Widget _buildVariantCard(dynamic variant, bool isDark, String languageCode, String itemType, bool isSelected) {
    const Color goldColor = Color(0xFFD6B237);

    String variantName = 'Product Variant';
    if (variant.name != null && variant.name.toString().isNotEmpty && variant.name.toString() != "null") {
      variantName = variant.name is Map 
          ? (variant.name[languageCode] ?? variant.name['en'] ?? variant.name['ar'] ?? 'Product Variant') 
          : variant.name.toString();
    }

    String dateStr = 'No Date';
    String timeStr = '';

    if (variant.availabilities != null && variant.availabilities.isNotEmpty) {
      final avail = variant.availabilities[0];
      dateStr = _formatDate(avail.availableDate ?? avail.available_date);

      if (avail.slots != null && avail.slots.isNotEmpty) {
        final slot = avail.slots[0];
        final start = _formatTime(slot.startTime ?? slot.start_time);
        final end = _formatTime(slot.endTime ?? slot.end_time);
        if (start.isNotEmpty && end.isNotEmpty) {
          timeStr = '$start - $end';
        }
      }
    }

    String capacityStr = '';
    if (itemType == 'physical_product') {
      capacityStr = 'Qty: ${variant.stock ?? 0}';
    } else {
      if (variant.capacity != null && variant.capacity > 0) {
        capacityStr = 'Capacity: ${variant.capacity}';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // 💡 إبراز الكرت المختار بخلفية خفيفة جداً
        color: isSelected ? (isDark ? Colors.grey[800] : goldColor.withOpacity(0.05)) : (isDark ? Colors.grey[900] : Colors.white),
        borderRadius: BorderRadius.circular(16),
        // 💡 تلوين الإطار بالذهبي إذا كان مختاراً
        border: Border.all(
          color: isSelected ? goldColor : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${variant.currency ?? 'SYP'} ${variant.price}', style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 16)),
              Expanded(child: Text(variantName, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(dateStr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(width: 8),
              const Icon(Icons.calendar_today_outlined, color: goldColor, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (capacityStr.isNotEmpty)
                Text(capacityStr, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 13)),
              if (capacityStr.isEmpty) const SizedBox(),
              Row(
                children: [
                  Text(timeStr.isNotEmpty ? timeStr : 'Time not specified', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  const SizedBox(width: 8),
                  Icon(Icons.access_time, color: Colors.grey.shade500, size: 18),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBookingSheet(BuildContext context, ServiceItem currentItem) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookingRequestSheet(item: currentItem),
    );
  }
}
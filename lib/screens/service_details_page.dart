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
import 'package:intl/intl.dart';

// 🚀 أزيلي التعليق عن السطر التالي وتأكدي من مسار ملف EndPoint لديك
import 'package:eventsapp/core/api/end_ponits.dart'; // 👈 مسار ملف الـ EndPoint

class ServiceDetailsPage extends StatefulWidget {
  final ServiceItem item;

  const ServiceDetailsPage({super.key, required this.item});

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  // 🚀 متغيرات للتحكم بالصورة المعروضة والكرت المحدد
  String? _currentDisplayImage;
  String? _selectedVariantId;

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getListingDetails(widget.item.id);
  }

  // 🚀 دالة ذكية لتنظيف الرابط واستبدال السيرفر المحلي بـ ngrok/المحاكي
  String? getCleanImageUrl(List<dynamic> images) {
    if (images.isEmpty) return null;
    try {
      // 💡 قراءة الرابط الحالي من EndPoint
      final String activeHost = EndPoint.baseUrl.split('/api')[0];

      String url = (images[0] is Map ? images[0]['url'] : images[0].toString());
      if (url.isNotEmpty && url.startsWith('http') && !url.contains('placeholder')) {
        if (url.contains('127.0.0.1:8000') || url.contains('localhost:8000') || url.contains('10.0.2.2:8000')) {
          url = url.replaceAll(RegExp(r'http://(127\.0\.0\.1|localhost|10\.0\.2\.2):8000'), activeHost);
        }
        return url;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  // 🚀 الدالة الشاملة التي تبحث في كل مكان وتتأقلم مع الـ EndPoint
  String getSmartImageUrl(ServiceItem item) {
    // 1. البحث في الصور الأساسية للعنصر
    String? finalUrl = getCleanImageUrl(item.images);

    // 2. البحث في صور الخيارات (variants) لو الأساسية فارغة
    if (finalUrl == null && item.variants.isNotEmpty) {
      for (var variant in item.variants) {
        finalUrl = getCleanImageUrl(variant.images);
        if (finalUrl != null) break;
      }
    }

    if (finalUrl != null) return finalUrl;

    // 3. الفولباك (الصور الافتراضية)
    int hash = item.id.hashCode.abs();
    final List<String> fallbackImages = [
      'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1452587925148-ce544e77e70d?auto=format&fit=crop&w=1000&q=80',
    ];
    return fallbackImages[hash % fallbackImages.length];
  }

  String _formatDate(dynamic dateData) {
    if (dateData == null || dateData.toString().isEmpty) return 'Date not set';
    try {
      DateTime dt = dateData is DateTime ? dateData : DateTime.parse(dateData.toString());
      List<String> months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]}, ${dt.year}';
    } catch (e) {
      return dateData.toString().split('T').first;
    }
  }

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
                  Text(
                    state.errMessage,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  TextButton(
                    onPressed: () => context.read<UserCubit>().getListingDetails(widget.item.id),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is GetListingDetailsSuccess) {
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
                        width: double.infinity, height: double.infinity,
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

                    const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 12),

                    Text(
                      localizedText(item.description, languageCode, fallback: loc.noDescriptionAvailable),
                      style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[800], height: 1.5, fontSize: 15),
                    ),
                    const SizedBox(height: 32),

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

                    const Text('Available Packages', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 16),

                    // 🚀 توليد كروت الخيارات قابلة للضغط لتغيير الصورة
                    ...item.variants.map((variant) {
                      final isSelected = _selectedVariantId == variant.id;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedVariantId = variant.id;
                            String? vUrl = getCleanImageUrl(variant.images);
                            if (vUrl != null) {
                              _currentDisplayImage = vUrl;
                            }
                          });
                        },
                        child: _buildPackageCard(variant, isDark, languageCode, isSelected),
                      );
                    }).toList(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),

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

  // 🚀 الكرت الجديد المطور (يحتوي على صورة بداخل الكرت)
  Widget _buildPackageCard(dynamic variant, bool isDark, String languageCode, bool isSelected) {
    const Color goldColor = Color(0xFFD6B237);

    // 💡 جلب صورة الـ Variant للكرت
    String? variantImg = getCleanImageUrl(variant.images);

    String dateStr = 'No Date';
    String timeStr = '';

    if (variant.availabilities != null && variant.availabilities.isNotEmpty) {
      if (variant.availabilities.length > 1) {
        dateStr = languageCode == 'ar' ? 'عدة تواريخ متاحة' : 'Multiple dates';
        timeStr = languageCode == 'ar' ? 'أوقات متعددة (اختر للحجز)' : 'Multiple slots (Tap to book)';
      } else {
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
    }

    String capacityStr = '';
    if (variant.capacity != null) {
      capacityStr = 'Capacity: ${variant.capacity}';
    } else if (variant.stock != null) {
      capacityStr = 'Qty: ${variant.stock}';
    }

    String packageName = 'Package Name';
    if (variant.name != null) {
      if (variant.name is Map) {
        packageName = variant.name[languageCode] ?? variant.name['en'] ?? variant.name['ar'] ?? 'Package Name';
      } else {
        packageName = variant.name.toString();
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? (isDark ? Colors.grey[800] : goldColor.withOpacity(0.05)) : (isDark ? Colors.grey[900] : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? goldColor : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼️ عرض صورة الخيار (Variant) إذا كانت موجودة
          if (variantImg != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                variantImg,
                width: 75,
                height: 75,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 75, height: 75, color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 14),
          ],

          // 📝 باقي التفاصيل بجانب الصورة
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        packageName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${variant.price} ${variant.currency ?? 'SYP'}',
                      style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, color: goldColor, size: 16),
                    const SizedBox(width: 6),
                    Text(dateStr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.grey.shade500, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        timeStr.isNotEmpty ? timeStr : 'Time not specified',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (capacityStr.isNotEmpty)
                      Text(
                        capacityStr,
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                  ],
                ),
              ],
            ),
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/cubit/theme_cubit.dart';
import 'package:eventsapp/cubit/language_cubit.dart';
import 'package:eventsapp/core/utils/localized_value.dart';
import 'package:eventsapp/models/listing_model.dart';
import 'package:eventsapp/screens/booking/Booking.dart'; 
import 'package:eventsapp/generated/app_localizations.dart';

class ServiceDetailsPage extends StatelessWidget {
  final ServiceItem item;

  const ServiceDetailsPage({super.key, required this.item});

  // 🛠️ دالة مساعدة لتنسيق التاريخ (معدلة لتقبل DateTime و String بأمان)
  String _formatDate(dynamic dateData) {
    if (dateData == null || dateData.toString().isEmpty) return 'Date not set';
    try {
      DateTime dt = dateData is DateTime ? dateData : DateTime.parse(dateData.toString());
      List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]}, ${dt.year}';
    } catch (e) {
      return dateData.toString().split('T').first;
    }
  }

  // 🛠️ دالة مساعدة لتنسيق الوقت بأمان تام
  String _formatTime(dynamic timeData) {
    if (timeData == null || timeData.toString().isEmpty) return '';
    try {
      DateTime? dt;
      // إذا كان كائن تاريخ كامل أو نص يمثل تاريخ كامل
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
        // إذا كان جاي من الباك إند بصيغة "17:00:00"
        final parts = timeData.toString().split(':');
        int h = int.parse(parts[0].trim());
        int m = int.parse(parts[1].trim());
        String ampm = h >= 12 ? 'PM' : 'AM';
        h = h > 12 ? h - 12 : (h == 0 ? 12 : h);
        return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $ampm';
      }
    } catch (e) {
      // في حال فشل كل شيء، نرجع النص بدون أجزاء الثانية الطويلة
      return timeData.toString().split('.').first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.read<ThemeCubit>().isDark;
    final languageCode = context.watch<LanguageCubit>().languageCode;
    final loc = AppLocalizations.of(context)!;

    // استخراج الصورة
    final String imageUrl = item.images.isNotEmpty
        ? (item.images[0] is Map ? item.images[0]['url'] : item.images[0].toString())
        : 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=1000';

    // استخراج السعر الافتتاحي
    final String startingPrice = item.variants.isNotEmpty
        ? '${item.variants[0].price} ${item.variants[0].currency}'
        : loc.notAvailable;

    const Color goldColor = Color(0xFFD6B237);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // === 1. الصورة العلوية مع زر الرجوع ===
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            iconTheme: theme.appBarTheme.iconTheme,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
                ),
              ),
            ),
          ),

          // === 2. تفاصيل الخدمة (المحتوى) ===
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -20, 0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان الرئيسي
                  Text(
                    localizedText(item.title, languageCode),
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // السعر الافتتاحي (Starting from) باللون الذهبي
                  Text(
                    'Starting from $startingPrice',
                    style: const TextStyle(
                      color: goldColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // خط فاصل
                  Divider(color: Colors.grey.shade300, thickness: 1),
                  const SizedBox(height: 16),

                  // صف الموقع والتصنيف
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // الموقع
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: goldColor, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            item.district.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      // التصنيف (Category)
                      Row(
                        children: [
                          const Icon(Icons.category, color: goldColor, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            item.category.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // خط فاصل
                  Divider(color: Colors.grey.shade300, thickness: 1),
                  const SizedBox(height: 24),

                  // عنوان قسم الوصف
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // نص الوصف
                  Text(
                    localizedText(
                      item.description,
                      languageCode,
                      fallback: loc.noDescriptionAvailable,
                    ),
                    style: TextStyle(
                      color: isDark ? Colors.grey[300] : Colors.grey[800],
                      height: 1.5,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // عنوان قسم الباقات المتاحة
                  const Text(
                    'Available Packages',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // بناء كروت الباقات وتمرير لغة التطبيق لضمان قراءة اسم الباقة بشكل سليم
                  ...item.variants.map((variant) => _buildPackageCard(variant, isDark, languageCode)).toList(),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),

      // === 3. زر الحجز في الأسفل ===
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: theme.colorScheme.surface,
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () => _showBookingSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: goldColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Book Now',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🛠️ تصميم كرت الباقة (Package Card) ليتطابق مع الصورة
  Widget _buildPackageCard(dynamic variant, bool isDark, String languageCode) {
    const Color goldColor = Color(0xFFD6B237);
    
    // استخراج بيانات التاريخ والوقت بأمان
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

    // استخراج السعة أو الكمية
    String capacityStr = '';
    if (variant.capacity != null) {
      capacityStr = 'Capacity: ${variant.capacity}';
    } else if (variant.stock != null) {
      capacityStr = 'Qty: ${variant.stock}';
    }

    // 🚀 معالجة ذكية لاسم الباقة (يمنع الخطأ سواء كان قاموس لغات Map أو نص عادي String)
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
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصف الأول: اسم الباقة والسعر
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  packageName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                '${variant.price} ${variant.currency ?? 'SYP'}',
                style: const TextStyle(
                  color: goldColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // الصف الثاني: التاريخ
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, color: goldColor, size: 18),
              const SizedBox(width: 8),
              Text(
                dateStr,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // الصف الثالث: الوقت + السعة
          // الصف الثالث: الوقت + السعة
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.grey.shade500, size: 18),
              const SizedBox(width: 8),
              // 🚀 استخدام Expanded لحماية الشاشة من الطفحان (Overflow)
              Expanded(
                child: Text(
                  timeStr.isNotEmpty ? timeStr : 'Time not specified',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  overflow: TextOverflow.ellipsis, // وضع ... في حال كان النص طويلاً
                  maxLines: 1,
                ),
              ),
              if (capacityStr.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    capacityStr,
                    style: const TextStyle(
                      color: Colors.green, // اللون الأخضر للسعة
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBookingSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookingRequestSheet(item: item),
    );
  }
}
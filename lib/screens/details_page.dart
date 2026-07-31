import 'package:eventsapp/core/widgets/common/custom_gold_button.dart';
import 'package:eventsapp/cubit/language_cubit.dart';
import 'package:eventsapp/core/utils/localized_value.dart';
import 'package:eventsapp/models/listing_model.dart'; // استيراد الموديل
import 'package:eventsapp/screens/booking/Booking.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // لتنسيق التواريخ

class DetailsPage extends StatelessWidget {
  final ServiceItem item; // استبدال المتغيرات المتعددة بكائن واحد

  const DetailsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageCode = context.watch<LanguageCubit>().languageCode;
    final loc = AppLocalizations.of(context)!; // ✨ اختصار للوصول للترجمات

    // استخراج البيانات الأساسية
    final String title = localizedText(item.title, languageCode);
    final String description = localizedText(
      item.description,
      languageCode,
      fallback: loc.noDescriptionAvailable, // ✨ استخدام الترجمة
    );
    final String imageUrl = item.images.isNotEmpty
        ? item.images[0]
        : 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=1000';

    // ✨ تعديل طريقة عرض السعر ليكون موحداً
    final String startingPrice = item.variants.isNotEmpty
        ? '${loc.startingFrom} ${item.variants[0].price} ${item.variants[0].currency}'
        : loc.priceNotAvailable;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -20, 0),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الاسم والسعر
                  Text(
                    title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    startingPrice,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: const Color(0xFFF9C54D),
                    ),
                  ),
                  const Divider(height: 40),

                  // الموقع والنوع
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.district.name,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 20),
                      Icon(
                        Icons.category,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.category.name,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const Divider(height: 40),

                  // ✨ الوصف (تم التعديل)
                  Text(
                    loc.descriptionLabel,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 30),

                  // ✨ عرض الباقات (تم التعديل)
                  if (item.variants.isNotEmpty) ...[
                    Text(
                      loc.availablePackages,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: item.variants.length,
                      itemBuilder: (context, index) {
                        final variant = item.variants[index];
                        return _buildVariantCard(
                          variant,
                          theme,
                          languageCode,
                          loc,
                        ); // تمرير loc
                      },
                    ),
                  ],

                  const SizedBox(height: 100), // مسافة للزر السفلي
                ],
              ),
            ),
          ),
        ],
      ),

      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.transparent,
        child: CustomGoldButton(
          text: loc.bookRequest, // ✨ كان يستخدمها بالفعل
          onTap: () => _showBookingSheet(context),
        ),
      ),
    );
  }

  void _showBookingSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true, // ضروري ليأخذ مساحة كبيرة من الشاشة
      backgroundColor: Colors.transparent,
      builder: (context) =>
          BookingRequestSheet(item: item), // استدعاء ويدجت الحجز المشتركة
    );
  }

  // ✨ تم تمرير متغير loc للترجمة
  Widget _buildVariantCard(
    Variant variant,
    ThemeData theme,
    String languageCode,
    AppLocalizations loc,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  localizedText(
                    variant.name,
                    languageCode,
                    fallback: loc.package, // ✨ استخدام الترجمة
                  ),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                '${variant.price} ${variant.currency}',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          if (variant.availabilities.isNotEmpty)
            ...variant.availabilities
                .map(
                  (avail) => _buildAvailabilityRow(avail, theme, loc),
                ) // تمرير loc
                .toList(),
        ],
      ),
    );
  }

  // ✨ تم تمرير متغير loc للترجمة
  Widget _buildAvailabilityRow(
    Availability availability,
    ThemeData theme,
    AppLocalizations loc,
  ) {
    final dateFormat = DateFormat('dd MMM, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                dateFormat.format(availability.availableDate.toLocal()),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (availability.slots.isNotEmpty)
            ...availability.slots.map(
              (slot) => Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      '${timeFormat.format(slot.startTime.toLocal())} - ${timeFormat.format(slot.endTime.toLocal())}',
                    ),
                    const Spacer(),
                    Text(
                      '${loc.capacity}: ${slot.remainingCapacity}', // ✨ استخدام الترجمة
                      style: TextStyle(
                        color: slot.remainingCapacity > 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

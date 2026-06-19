import 'package:eventsapp/cubit/theme_cubit.dart';
import 'package:eventsapp/models/listing_model.dart';
import 'package:eventsapp/screens/booking.dart';
import 'package:flutter/material.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ServiceDetailsPagelist extends StatelessWidget {
  final ServiceItem item;

  const ServiceDetailsPagelist({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.read<ThemeCubit>().isDark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // === 1. الصورة الرئيسية مع الـ AppBar الشفاف ===
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
                    item.images.isNotEmpty
                        ? item.images[0]
                        : 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=1000',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // === 2. محتوى التفاصيل ===
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -20, 0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الاسم والنوع
                  Text(
                    item.title['en'] ?? item.title['ar'] ?? 'N/A',
                    style: theme.textTheme.displayLarge?.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.type.toUpperCase(),
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // الموقع والحالة
                  _buildInfoRow(
                    Icons.location_on,
                    item.district.name,
                    Icons.info_outline,
                    item.status,
                    theme,
                    isDark,
                  ),
                  const SizedBox(height: 20),

                  // الوصف
                  Text(
                    "Description",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description['en'] ??
                        item.description['ar'] ??
                        'No description available.',
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 25),

                  // عرض الباقات (Variants)
                  if (item.variants.isNotEmpty) ...[
                    Text(
                      "Available Packages",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: item.variants.length,
                      itemBuilder: (context, index) {
                        return _buildVariantCard(
                          item.variants[index],
                          theme,
                          isDark,
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),

      // === 3. زر الحجز السفلي الثابت ===
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.startingFrom,
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  item.variants.isNotEmpty
                      ? '${item.variants[0].price} ${item.variants[0].currency}'
                      : 'N/A',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 180,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _showBookingSheet(context),
                style: theme.elevatedButtonTheme.style,
                child: Text(AppLocalizations.of(context)!.bookRequest),
              ),
            ),
          ],
        ),
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

  // === ويدجت مساعدة لصف المعلومات ===
  Widget _buildInfoRow(
    IconData icon1,
    String text1,
    IconData icon2,
    String text2,
    ThemeData theme,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(icon1, color: theme.colorScheme.primary, size: 20),
        const SizedBox(width: 8),
        Text(text1, style: theme.textTheme.bodyMedium),
        const Spacer(),
        Icon(
          icon2,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(text2, style: theme.textTheme.bodyMedium),
      ],
    );
  }

  // === ويدجت مساعدة لبطاقة الباقة (Variant) ===
  Widget _buildVariantCard(Variant variant, ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  variant.name['en'] ?? variant.name['ar'] ?? 'Package',
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
          const SizedBox(height: 10),

          // عرض أوقات التوفر (Availabilities)
          if (variant.availabilities.isNotEmpty)
            ...variant.availabilities.map(
              (avail) => _buildAvailabilityRow(avail, theme),
            ),
        ],
      ),
    );
  }

  // === ويدجت مساعدة لعرض التوفر ===
  Widget _buildAvailabilityRow(Availability availability, ThemeData theme) {
    final dateFormat = DateFormat('dd MMM, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
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
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (availability.slots.isNotEmpty)
            ...availability.slots.map(
              (slot) => Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 4),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      '${timeFormat.format(slot.startTime.toLocal())} - ${timeFormat.format(slot.endTime.toLocal())}',
                      style: theme.textTheme.bodySmall,
                    ),
                    const Spacer(),
                    Text(
                      'Capacity: ${slot.remainingCapacity}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: slot.remainingCapacity > 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const Divider(),
        ],
      ),
    );
  }
}

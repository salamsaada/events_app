import 'package:eventsapp/cubit/theme_cubit.dart';
import 'package:eventsapp/cubit/language_cubit.dart';
import 'package:eventsapp/core/utils/localized_value.dart';
import 'package:eventsapp/models/listing_model.dart';
import 'package:eventsapp/screens/booking/Booking.dart';
import 'package:eventsapp/cubit/user_cubit.dart';
import 'package:eventsapp/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:eventsapp/core/widgets/service_reviews_section.dart';
import 'package:eventsapp/screens/service_reviews_page.dart';

class HallDetailsPage extends StatefulWidget {
  final ServiceItem item;
  final String? passedImageUrl; // 🚀 ضفنا هاد السطر لاستقبال الصورة من الخارج

  const HallDetailsPage({
    super.key, 
    required this.item,
    this.passedImageUrl, // 🚀 استقبلنا الصورة هنا
  });

  @override
  State<HallDetailsPage> createState() => _HallDetailsPageState();
}

class _HallDetailsPageState extends State<HallDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserCubit>().getListingDetails(widget.item.id);
    });
  }

  // 🚀 دالة ذكية بتعطي الأولوية للصورة الممررة من برا، لحتى تضل مطابقة 100%
  String getFinalImageUrl(ServiceItem item) {
    if (widget.passedImageUrl != null && widget.passedImageUrl!.isNotEmpty) {
      return widget.passedImageUrl!; // إذا إجت صورة من برا، اعرضها نفسها فوراً
    }
    
    // كاحتياط (نفس صور الـ Assets تبع صفحة الصالات)
    if (item.images.isNotEmpty) {
      String url = (item.images[0] is Map ? item.images[0]['url'] : item.images[0].toString());
      if (url.isNotEmpty && url.startsWith('http') && !url.contains('localhost')) return url; 
    }
    
    int uniqueNum = item.id.toString().codeUnits.fold(0, (sum, char) => sum + char);
    final List<String> localFallbacks = [
      'assets/images/photo_2026-08-20_01-01-38.jpg', 
      'assets/images/photo_2026-08-20_01-01-52.jpg', 
      'assets/images/photo_2026-08-20_01-05-55.jpg', 
    ];
    return localFallbacks[uniqueNum % localFallbacks.length];
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
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context
                        .read<UserCubit>()
                        .getListingDetails(widget.item.id),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is GetListingDetailsSuccess) {
            return _buildContent(context, state.listing, theme);
          }

          return _buildContent(context, widget.item, theme);
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ServiceItem item,
    ThemeData theme,
  ) {
    final isDark = context.read<ThemeCubit>().isDark;
    final languageCode = context.watch<LanguageCubit>().languageCode;
    final loc = AppLocalizations.of(context)!;

    // 🚀 جلب الصورة المتطابقة 100% مع الخارج
    final String imageUrl = getFinalImageUrl(item);

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
                    // 🚀 فحص ذكي לעرض الصورة بناءً على نوع الرابط
                    imageUrl.startsWith('http')
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image, color: Colors.grey, size: 50),
                            ),
                          )
                        : Image.asset(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
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
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizedText(item.title, languageCode),
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
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
                    _buildInfoRow(
                      Icons.location_on,
                      item.district.name,
                      Icons.info_outline,
                      item.status,
                      theme,
                      isDark,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      loc.descriptionLabel,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localizedText(
                        item.description,
                        languageCode,
                        fallback: loc.noDescriptionAvailable,
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                    const SizedBox(height: 25),
                    ServiceReviewsSection(
                      reviews: item.reviews,
                      averageRating: item.averageRating,
                      reviewCount: item.reviewCount,
                      isArabic: languageCode == 'ar',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ServiceReviewsPage(
                            providerId: item.providerId,
                            serviceName: localizedText(
                              item.title,
                              languageCode,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    if (item.variants.isNotEmpty) ...[
                      Text(
                        loc.availablePackages,
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
                            languageCode,
                            loc,
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

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.4 : 0.05),
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
                    Text(loc.startingFrom, style: theme.textTheme.bodySmall),
                    Text(
                      item.variants.isNotEmpty
                          ? '${item.variants[0].price} ${item.variants[0].currency}'
                          : loc.notAvailable,
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
                    onPressed: () => _showBookingSheet(context, item),
                    style: theme.elevatedButtonTheme.style,
                    child: Text(loc.bookRequest),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showBookingSheet(BuildContext context, ServiceItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookingRequestSheet(item: item),
    );
  }

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
        Expanded(child: Text(text1, style: theme.textTheme.bodyMedium)),
        Icon(
          icon2,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text2,
            style: theme.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildVariantCard(
    Variant variant,
    ThemeData theme,
    bool isDark,
    String languageCode,
    AppLocalizations loc,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
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
                    fallback: loc.package,
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
          const SizedBox(height: 10),
          if (variant.availabilities.isNotEmpty)
            ...variant.availabilities.map(
              (avail) => _buildAvailabilityRow(avail, variant, theme, loc),
            ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityRow(
    Availability availability,
    Variant variant,
    ThemeData theme,
    AppLocalizations loc,
  ) {
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
                      '${loc.capacity}: ${variant.capacity}',
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
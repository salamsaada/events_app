import 'package:eventsapp/core/widgets/common/custom_gold_button.dart';
import 'package:eventsapp/cubit/language_cubit.dart';
import 'package:eventsapp/cubit/user_cubit.dart';
import 'package:eventsapp/cubit/user_state.dart';
import 'package:eventsapp/core/utils/localized_value.dart';
import 'package:eventsapp/models/listing_model.dart';
import 'package:eventsapp/screens/booking/Booking.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:eventsapp/core/widgets/service_reviews_section.dart';
import 'package:eventsapp/screens/service_reviews_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DetailsPage extends StatefulWidget {
  final String listingId;

  const DetailsPage({super.key, required this.listingId});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
    // 🚀 جلب البيانات فور فتح الصفحة لضمان عدم بقاء الشاشة بيضاء
    context.read<UserCubit>().getListingDetails(widget.listingId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      // 🛡️ وضعنا زر رجوع افتراضي للحماية إذا علقت الحالة
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      extendBodyBehindAppBar: true,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is GetListingDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetListingDetailsFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.errMessage,
                      style: TextStyle(color: theme.colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context
                          .read<UserCubit>()
                          .getListingDetails(widget.listingId),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is GetListingDetailsSuccess) {
            return _buildDetailsBody(context, state.listing, theme, loc);
          }

          // 🛡️ شاشة تحميل مبدئية بدلاً من SizedBox (لتفادي الشعور بالتجميد)
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildDetailsBody(
    BuildContext context,
    ServiceItem item,
    ThemeData theme,
    AppLocalizations loc,
  ) {
    final languageCode = context.watch<LanguageCubit>().languageCode;

    final String title = localizedText(item.title, languageCode);
    final String description = localizedText(
      item.description,
      languageCode,
      fallback: loc.noDescriptionAvailable,
    );
    final String imageUrl = item.images.isNotEmpty
        ? (item.images[0] is Map
              ? (item.images[0]['url'] ??
                    'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=1000')
              : item.images[0].toString())
        : 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=1000';
    final String startingPrice = item.variants.isNotEmpty
        ? '${loc.startingFrom} ${item.variants[0].price} ${item.variants[0].currency}'
        : loc.priceNotAvailable;

    return Stack(
      children: [
        // المحتوى القابل للتمرير
        CustomScrollView(
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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.district.name,
                            style: theme.textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.category,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.category.name,
                            style: theme.textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 40),
                    Text(
                      loc.descriptionLabel,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                    const SizedBox(height: 30),
                    ServiceReviewsSection(
                      reviews: item.reviews,
                      averageRating: item.averageRating,
                      reviewCount: item.reviewCount,
                      isArabic: languageCode == 'ar',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ServiceReviewsPage(
                            providerId: item.providerId,
                            serviceName: title,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (item.variants.isNotEmpty) ...[
                      Text(
                        loc.availablePackages,
                        style: const TextStyle(
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

        // 🔘 شريط الحجز الثابت في الأسفل
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildBookingBottomBar(context, item, theme, loc),
        ),
      ],
    );
  }

  /// 🔘 عنصر شريط زر الحجز الثابت
  Widget _buildBookingBottomBar(
    BuildContext context,
    ServiceItem item,
    ThemeData theme,
    AppLocalizations loc,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: CustomGoldButton(
          text: 'احجز الآن', // استخدم المسمى الخاص باللغة (أو 'احجز الآن')
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled:
                  true, // مهم جداً لأنك تستخدم DraggableScrollableSheet
              backgroundColor:
                  Colors.transparent, // ضروري لتظهر الحواف الدائرية التي صممتها
              builder: (context) => BookingRequestSheet(
                item:
                    item, // تأكد أن تمرر item كما هو معرّف في كلاس BookingRequestSheet
              ),
            );
          },
        ),
      ),
    );
  }

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
                      '${loc.capacity}: ${variant.capacity}',
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

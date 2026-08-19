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

class HallDetailsPage extends StatefulWidget {
  final ServiceItem item;

  const HallDetailsPage({super.key, required this.item});

  @override
  State<HallDetailsPage> createState() => _HallDetailsPageState();
}

class _HallDetailsPageState extends State<HallDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ✅ مع Type الصريح — بيمنع الـ crash
      context.read<UserCubit>().getListingDetails(widget.item.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // ✅ BlocBuilder مع Type الصريح
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
                    // ✅ مع Type الصريح
                    onPressed: () => context.read<UserCubit>().getListingDetails(widget.item.id),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is GetListingDetailsSuccess) {
            // ✅ state.item (مش state.listing)
            return _buildContent(context, state.listing, theme);
          }

          // Fallback: نعرض البيانات الخفيفة القادمة من القائمة فورًا
          return _buildContent(context, widget.item, theme);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ServiceItem item, ThemeData theme) {
    // ✅ مع Type الصريح لكل context.read / context.watch
    final isDark = context.read<ThemeCubit>().isDark;
    final languageCode = context.watch<LanguageCubit>().languageCode;
    final loc = AppLocalizations.of(context)!;

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
                      item.images.isNotEmpty
                          ? (item.images[0] is Map
                              ? (item.images[0]['url'] ?? 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=1000')
                              : item.images[0].toString())
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
                      style: theme.textTheme.displayLarge?.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

        // === زر الحجز في الأسفل ===
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
        Icon(icon2, color: isDark ? Colors.grey[400] : Colors.grey[600], size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(text2, style: theme.textTheme.bodyMedium, overflow: TextOverflow.ellipsis)),
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
                  localizedText(variant.name, languageCode, fallback: loc.package),
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
              Icon(Icons.calendar_today, size: 14, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                dateFormat.format(availability.availableDate.toLocal()),
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
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
                        color: slot.remainingCapacity > 0 ? Colors.green : Colors.red,
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
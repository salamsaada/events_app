import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/common/bottom_navigation.dart';
import '../../core/utils/localized_value.dart'; // ✨ استيراد دالة الترجمة
import '../../cubit/user_cubit.dart'; // ✨ استيراد الـ Cubit
import '../../cubit/user_state.dart'; // ✨ استيراد الـ States
import '../home/home_page.dart';
import '../profile/profile_page.dart';
import '../chat/chat_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    // ✨ استدعاء دالة جلب الحجوزات بمجرد فتح الصفحة
    Future.microtask(() {
      if (mounted) {
        context.read<UserCubit>().getMyBookings();
      }
    });
  }

  // ✨ دالة مساعدة لترجمة الحالة (Pending, Confirmed, الخ..)
  String _translateStatus(String status) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    switch (status.toLowerCase()) {
      case 'pending':
        return isAr ? 'قيد الانتظار' : 'Pending';
      case 'confirmed':
        return isAr ? 'مؤكد' : 'Confirmed';
      case 'completed':
        return isAr ? 'مكتمل' : 'Completed';
      case 'cancelled':
        return isAr ? 'ملغي' : 'Cancelled';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      bottomNavigationBar: AppBottomNavigation(
        selectedIndex: 2,
        onItemSelected: (index) => _handleNavigation(context, index),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.background, AppColors.surface]
                : [const Color(0xFFF8F6F2), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: _OrdersHeader(theme: theme, l10n: l10n),
              ),
              // Tabs/Filters
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _OrdersFilter(theme: theme, l10n: l10n),
              ),

              // ✨ استبدال الـ ListView الثابت بـ BlocConsumer
              Expanded(
                child: BlocConsumer<UserCubit, UserState>(
                  listener: (context, state) {
                    if (state is GetBookingsFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.errMessage),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    // 1. حالة التحميل
                    if (state is GetBookingsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryGold,
                        ),
                      );
                    }

                    // 2. حالة النجاح (وجود بيانات)
                    if (state is GetBookingsSuccess) {
                      final bookings = state.bookingsResponse.data;
                      final languageCode = Localizations.localeOf(
                        context,
                      ).languageCode;

                      // إذا كانت القائمة فارغة
                      if (bookings.isEmpty) {
                        final isAr = languageCode == 'ar';
                        return Center(
                          child: Text(
                            isAr
                                ? 'لا توجد حجوزات حالياً'
                                : 'No bookings available',
                            style: AppTextStyles.subtitle,
                          ),
                        );
                      }

                      // عرض قائمة الحجوزات الديناميكية
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          final booking = bookings[index];

                          // تنسيق الوقت إذا كان متوفراً
                          String formattedTime = '--';
                          if (booking.shift?.startTime != null) {
                            formattedTime = DateFormat(
                              'hh:mm a',
                            ).format(booking.shift!.startTime!);
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _OrderCard(
                              orderNumber:
                                  '#${booking.id?.substring(0, 6) ?? 'N/A'}',
                              hallName:
                                  (languageCode == 'ar'
                                      ? booking.listing?.title?.ar
                                      : booking.listing?.title?.en) ??
                                  'بدون اسم',
                              date: booking.createdAtHuman ?? '--',
                              time: formattedTime,
                              guests:
                                  '--', // لم يوفرها الـ API في الـ JSON الحالي
                              status: _translateStatus(booking.status ?? ''),
                              amount:
                                  '${booking.price ?? '0'} ${booking.currency ?? ''}',
                            ),
                          );
                        },
                      );
                    }

                    // 3. الحالة الافتراضية (قبل تحميل البيانات)
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    if (index == 2) return;
    if (index == 0) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
      return;
    }
    if (index == 1) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const ChatPage()));
      return;
    }
    if (index == 3) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
      return;
    }
  }
}

// ==========================================
// باقي الويدجت بدون تغيير كبير (فقط توحيد للغة)
// ==========================================

class _OrdersHeader extends StatelessWidget {
  final ThemeData theme;
  final AppLocalizations l10n;

  const _OrdersHeader({required this.theme, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFB88A1B), Color(0xFFD4AF37)],
              ),
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  l10n.myOrders,
                  style: AppTextStyles.subtitle.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.activeOrders,
                  style: AppTextStyles.bodyGrey.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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

class _OrdersFilter extends StatefulWidget {
  final ThemeData theme;
  final AppLocalizations l10n;

  const _OrdersFilter({required this.theme, required this.l10n});

  @override
  State<_OrdersFilter> createState() => _OrdersFilterState();
}

class _OrdersFilterState extends State<_OrdersFilter> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final filters = isAr
        ? ['الكل', 'قيد الانتظار', 'مؤكد', 'مكتمل']
        : ['All', 'Pending', 'Confirmed', 'Completed'];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedIndex == index;

          return Padding(
            padding: EdgeInsets.only(right: index == 0 ? 0 : 12),
            child: GestureDetector(
              onTap: () => setState(() => selectedIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryGold
                      : widget.theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryGold
                        : AppColors.primaryGold.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  filter,
                  style: AppTextStyles.bodyGrey.copyWith(
                    color: isSelected
                        ? Colors.black
                        : widget.theme.colorScheme.onSurface,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String orderNumber;
  final String hallName;
  final String date;
  final String time;
  final String guests;
  final String status;
  final String amount;

  const _OrderCard({
    required this.orderNumber,
    required this.hallName,
    required this.date,
    required this.time,
    required this.guests,
    required this.status,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAr =
        Localizations.localeOf(context).languageCode == 'ar'; // ✨ توحيد اللغة

    Color statusColor;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'completed':
      case 'مكتمل':
        statusColor = const Color(0xFF10B981);
        statusIcon = Icons.check_circle;
        break;
      case 'confirmed':
      case 'مؤكد':
        statusColor = const Color(0xFF3B82F6);
        statusIcon = Icons.verified;
        break;
      case 'pending':
      case 'قيد الانتظار':
        statusColor = const Color(0xFFF59E0B);
        statusIcon = Icons.schedule;
        break;
      default:
        statusColor = const Color(0xFF6B7280);
        statusIcon = Icons.info;
    }

    return GestureDetector(
      onTap: () {
        final detailLabel = isAr ? 'تفاصيل الطلب' : 'Order Details';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$detailLabel: $orderNumber')));
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryGold.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderNumber,
                        style: AppTextStyles.subtitle.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hallName,
                        style: AppTextStyles.bodyGrey.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(statusIcon, color: statusColor, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          status,
                          style: AppTextStyles.bodyGrey.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: AppColors.primaryGold.withValues(alpha: 0.1),
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _DetailItem(
                        icon: Icons.calendar_today,
                        label: isAr ? 'التاريخ' : 'Date',
                        value: date,
                        theme: theme,
                      ),
                      _DetailItem(
                        icon: Icons.schedule,
                        label: isAr ? 'الوقت' : 'Time',
                        value: time,
                        theme: theme,
                      ),
                      _DetailItem(
                        icon: Icons.people,
                        label: isAr ? 'الضيوف' : 'Guests',
                        value: guests,
                        theme: theme,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isAr ? 'المبلغ الكلي' : 'Total Amount', // ✨ توحيد اللغة
                        style: AppTextStyles.bodyGrey.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      Text(
                        amount,
                        style: AppTextStyles.subtitle.copyWith(
                          color: AppColors.primaryGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.message, size: 18),
                          label: Text(isAr ? 'اتصل' : 'Call'), // ✨ توحيد اللغة
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryGold,
                            side: const BorderSide(
                              color: AppColors.primaryGold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.visibility, size: 18),
                          label: Text(
                            isAr ? 'عرض التفاصيل' : 'View Details',
                          ), // ✨ توحيد اللغة
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGold,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryGold, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.tileCaption.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.tileTitle.copyWith(
              color: theme.colorScheme.onSurface,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

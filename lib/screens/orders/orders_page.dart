import 'dart:io';

import 'package:eventsapp/cubit/payment_status.dart'; // تأكدي من مسار الملف
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/common/bottom_navigation.dart';
import '../../cubit/user_cubit.dart';
import '../../cubit/user_state.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';
import '../chat/chat_page.dart';
import 'rating_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final Set<String> _submittedBookingIds = {};
  String? _lastAttemptedBookingId;

  String _selectedStatusFilter = 'all';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<UserCubit>().getMyBookings();
      }
    });
  }

  String _translateStatus(String status) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    switch (status.toLowerCase()) {
      case 'pending':
        return isAr ? 'قيد الانتظار' : 'Pending';
      case 'accepted':
        return isAr ? 'مقبول' : 'Accepted';
      case 'confirmed':
        return isAr ? 'مؤكد' : 'Confirmed';
      case 'cancelled':
        return isAr ? 'ملغي' : 'Cancelled';
      default:
        return status;
    }
  }

  // 🚀 هل يقدر المستخدم يدفع لهاد الحجز؟
  bool _canPay(String bookingId, String? paymentStatus) {
    final normalizedStatus = (paymentStatus ?? '').toLowerCase().trim();

    if (normalizedStatus.isNotEmpty) {
      return !PaymentStatus.blockedStates.contains(normalizedStatus);
    }

    return !_submittedBookingIds.contains(bookingId);
  }

  // 🚀 شارة حالة الدفع
  ({String label, Color color, IconData icon})? _paymentStatusDisplay(
      BuildContext context,
      String? paymentStatus,
      ) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final normalized = (paymentStatus ?? '').toLowerCase().trim();

    switch (normalized) {
      case PaymentStatus.pending:
        return (
        label: isAr ? 'قيد المراجعة' : 'Under Review',
        color: const Color(0xFFF59E0B),
        icon: Icons.hourglass_top,
        );
      case PaymentStatus.confirmed: // 🚀 تم التعديل هنا لـ confirmed
        return (
        label: isAr ? 'تم تأكيد الدفع ✓' : 'Payment Confirmed ✓',
        color: const Color(0xFF10B981),
        icon: Icons.check_circle,
        );
      case PaymentStatus.failed:
        return (
        label: isAr
            ? 'مرفوض - يرجى إعادة الرفع'
            : 'Payment Rejected',
        color: const Color(0xFFEF4444),
        icon: Icons.error_outline,
        );
      case PaymentStatus.refunded:
        return (
        label: isAr ? 'تم استرداد المبلغ' : 'Amount Refunded',
        color: const Color(0xFF6B7280),
        icon: Icons.replay_circle_filled,
        );
      default:
        return null;
    }
  }

  Future<void> _pickAndUploadPdf(
      BuildContext context,
      String currentBookingId,
      String amount,
      ) async {
    if (_submittedBookingIds.contains(currentBookingId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال الدفعة مسبقاً لهذا الحجز.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
  final userCubit = context.read<UserCubit>(); // 👈 امسكه قبل أي await

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      double fileSizeInMB = file.lengthSync() / (1024 * 1024);

      if (mounted) {
      _lastAttemptedBookingId = currentBookingId;
      userCubit.uploadProof( // 👈 استخدم المرجع المحفوظ، مش context.read مرة تانية
        bookingId: currentBookingId,
        filePath: file.path,
        amount: amount,
      );
    }

      if (mounted) {
        _lastAttemptedBookingId = currentBookingId;
        context.read<UserCubit>().uploadProof(
          bookingId: currentBookingId,
          filePath: file.path,
          amount: amount,
        );
      }
    }
  }

  // 🆕 عرض QR الخاص بالمزود قبل ما يفتح المستخدم الملف
  Future<void> _showProviderQrThenUpload(
    BuildContext context,
    String providerId,
    String bookingId,
    String amount,
  ) async {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    if (providerId.isEmpty) {
      // ما في provider id أصلاً بالحجز — نتخطى الـ QR ونروح مباشرة لرفع الملف
      _pickAndUploadPdf(context, bookingId, amount);
      return;
    }

 final userCubit = context.read<UserCubit>(); // 👈 امسكه هون
  userCubit.getProviderQrCode(providerId);
    final proceed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocBuilder<UserCubit, UserState>(
                  bloc: userCubit, // 👈 مرره صراحة بدل ما يدور عليه بالشجرة

          builder: (context, state) {
            Widget content;

            if (state is GetProviderQrCodeLoading) {
              content = const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (state is GetProviderQrCodeSuccess) {
              content = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isAr
                        ? 'امسح الكود لإتمام الدفع، ثم ارفع إيصال الدفع'
                        : 'Scan the code to complete payment, then upload the proof',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Image.network(
                    state.qrUrl,
                    height: 220,
                    width: 220,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.qr_code_2,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
                ],
              );
            } else if (state is GetProviderQrCodeFailure) {
              content = Text(
                state.errMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              );
            } else {
              content = const SizedBox.shrink();
            }

            return AlertDialog(
              title: Text(isAr ? 'كود الدفع' : 'Payment QR Code'),
              content: content,
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(isAr ? 'إلغاء' : 'Cancel'),
                ),
                FilledButton(
                  onPressed: state is GetProviderQrCodeLoading
                      ? null
                      : () => Navigator.of(dialogContext).pop(true),
                  child: Text(
                    isAr ? 'دفعت، تابع لرفع الإيصال' : 'Paid, continue to upload',
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (proceed == true && mounted) {
      _pickAndUploadPdf(context, bookingId, amount);
    }
  }

  Future<void> _confirmCancelBooking(String bookingId) async {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isAr ? 'إلغاء الحجز' : 'Cancel Booking'),
        content: Text(
          isAr
              ? 'هل أنت متأكد من رغبتك في إلغاء هذا الحجز؟'
              : 'Are you sure you want to cancel this booking?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(isAr ? 'تراجع' : 'Back'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(isAr ? 'إلغاء الحجز' : 'Cancel Booking'),
          ),
        ],
      ),
    );

    if (shouldCancel == true && mounted) {
      context.read<UserCubit>().cancelBooking(bookingId);
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
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: _OrdersHeader(theme: theme, l10n: l10n),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _OrdersFilter(
                  theme: theme,
                  l10n: l10n,
                  selectedFilter: _selectedStatusFilter,
                  onFilterChanged: (filter) {
                    setState(() => _selectedStatusFilter = filter);
                  },
                ),
              ),
              Expanded(
                child: BlocConsumer<UserCubit, UserState>(
                    buildWhen: (previous, current) => // 👈 أضف هاد كامل
        current is GetBookingsLoading ||
        current is GetBookingsSuccess ||
        current is GetBookingsFailure ||
        current is UploadProofLoading ||
        current is CancelBookingLoading,
                  listener: (context, state) {
                    if (state is GetBookingsFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errMessage), backgroundColor: Colors.red),
                      );
                    } else if (state is UploadProofSuccess) {
                      if (_lastAttemptedBookingId != null) {
                        setState(() {
                          _submittedBookingIds.add(_lastAttemptedBookingId!);
                        });
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم رفع الإيصال بنجاح! جاري التحديث...'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      context.read<UserCubit>().getMyBookings();
                    } else if (state is UploadProofFailure) {
                      if (state.errMessage.contains('مسجّلة') && _lastAttemptedBookingId != null) {
                        setState(() {
                          _submittedBookingIds.add(_lastAttemptedBookingId!);
                        });
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errMessage), backgroundColor: Colors.red),
                      );
                    } else if (state is CancelBookingSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message), backgroundColor: Colors.green),
                      );
                      context.read<UserCubit>().getMyBookings();
                    } else if (state is CancelBookingFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errMessage), backgroundColor: Colors.red),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is GetBookingsLoading ||
                        state is UploadProofLoading ||
                        state is CancelBookingLoading) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primaryGold));
                    }

                    if (state is GetBookingsSuccess) {
                      final allBookings = state.bookingsResponse.data;
                      final languageCode = Localizations.localeOf(context).languageCode;
                      final isAr = languageCode == 'ar';

                      final bookings = _selectedStatusFilter == 'all'
                          ? allBookings
                          : allBookings
                          .where((b) => (b.status ?? '').toLowerCase() == _selectedStatusFilter)
                          .toList();

                      return Column(
                        children: [
                          if (_selectedStatusFilter == 'accepted')
                            Container(
                              margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.orange.withValues(alpha: 0.15) : Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      isAr
                                          ? 'مقبول (غير مدفوع) أو غير موافق عليه من الأدمن.'
                                          : 'Accepted (unpaid) or not approved by the admin.',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.orange[300] : Colors.orange[800],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          Expanded(
                            child: bookings.isEmpty
                                ? Center(
                              child: Text(
                                isAr ? 'لا توجد حجوزات ضمن هذا التصنيف' : 'No bookings in this category',
                                style: AppTextStyles.subtitle,
                              ),
                            )
                                : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                              itemCount: bookings.length,
                              itemBuilder: (context, index) {
                                final booking = bookings[index];

                                String formattedTime = '--';
                                if (booking.bookedStartTime != null && booking.bookedEndTime != null) {
                                  try {
                                    formattedTime = '${booking.bookedStartTime!.substring(0, 5)} - ${booking.bookedEndTime!.substring(0, 5)}';
                                  } catch (e) {
                                    formattedTime = '${booking.bookedStartTime} - ${booking.bookedEndTime}';
                                  }
                                }

                                String guests = booking.quantity?.toString() ?? '--';
                                String staff = (booking.freelancers?.isNotEmpty ?? false) ? booking.freelancers!.join('، ') : '';

                                bool isAccepted = (booking.status ?? '').toLowerCase() == 'accepted';
                                bool canPay = _canPay(booking.id ?? '', booking.payment?.paymentStatus);

                                // 🚀 تحديد إذا كانت حالة الدفع مرفوضة (لإظهار رسالة التنبيه)
                                bool isPaymentFailed = (booking.payment?.paymentStatus ?? '').toLowerCase() == PaymentStatus.failed;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _OrderCard(
                                    bookingId: booking.id ?? '',
                                    orderNumber: '#${booking.id?.substring(0, 6) ?? 'N/A'}',
                                    hallName: (languageCode == 'ar' ? booking.listing?.title?.ar : booking.listing?.title?.en) ?? 'بدون اسم',
                                    date: booking.bookedDate ?? booking.createdAtHuman ?? '--',
                                    time: formattedTime,
                                    guests: guests,
                                    staff: staff,
                                    status: _translateStatus(booking.status ?? ''),
                                    amount: '${booking.price ?? '0'} ${booking.currency ?? ''}',
                                    showPayButton: isAccepted && canPay,
                                    isPaymentFailed: isPaymentFailed, // 🚀 تمرير حالة الرفض
                                    paymentStatusDisplay: _paymentStatusDisplay(context, booking.payment?.paymentStatus),
                                    onPayPressed: () {
                                      // 🆕 عرض الـ QR أولاً، وبعدين نفتح الملف
                                      _showProviderQrThenUpload(
                                        context,
                                        booking.providerId ?? '',
                                        booking.id ?? '',
                                        booking.price?.toString() ?? '0',
                                      );
                                    },
                                    onRatePressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => RatingPage(
                                            bookingId: booking.id ?? '',
                                            serviceName: (languageCode == 'ar' ? booking.listing?.title?.ar : booking.listing?.title?.en) ?? 'بدون اسم',
                                          ),
                                        ),
                                      );
                                    },
                                    onCancelPressed: () => _confirmCancelBooking(booking.id ?? ''),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
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
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomePage()), (route) => false);
      return;
    }
    if (index == 1) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChatPage()));
      return;
    }
    if (index == 3) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
      return;
    }
  }
}

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
            width: 52, height: 52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Color(0xFFB88A1B), Color(0xFFD4AF37)]),
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(l10n.myOrders, style: AppTextStyles.subtitle.copyWith(color: theme.colorScheme.onSurface)),
                const SizedBox(height: 4),
                Text(l10n.activeOrders, style: AppTextStyles.bodyGrey.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersFilter extends StatelessWidget {
  final ThemeData theme;
  final AppLocalizations l10n;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const _OrdersFilter({required this.theme, required this.l10n, required this.selectedFilter, required this.onFilterChanged});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final List<MapEntry<String, String>> filters = [
      MapEntry('all', isAr ? 'الكل' : 'All'),
      MapEntry('pending', isAr ? 'قيد الانتظار' : 'Pending'),
      MapEntry('accepted', isAr ? 'مقبول (غير مدفوع)' : 'Accepted (Unpaid)'),
      MapEntry('confirmed', isAr ? 'مؤكد' : 'Confirmed'),
      MapEntry('completed', isAr ? 'مكتمل' : 'Completed'),
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filterKey = filters[index].key;
          final filterLabel = filters[index].value;
          final isSelected = selectedFilter == filterKey;

          return Padding(
            padding: EdgeInsets.only(right: index == 0 ? 0 : 12),
            child: GestureDetector(
              onTap: () => onFilterChanged(filterKey),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryGold : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryGold : AppColors.primaryGold.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  filterLabel,
                  style: AppTextStyles.bodyGrey.copyWith(
                    color: isSelected ? Colors.black : theme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
  final String bookingId;
  final String orderNumber;
  final String hallName;
  final String date;
  final String time;
  final String guests;
  final String status;
  final String amount;
  final bool showPayButton;
  final bool isPaymentFailed; // 🚀 متغير جديد لمعرفة الرفض
  final ({String label, Color color, IconData icon})? paymentStatusDisplay;
  final String staff;
  final VoidCallback onPayPressed;
  final VoidCallback onRatePressed;
  final VoidCallback onCancelPressed;

  const _OrderCard({
    required this.bookingId,
    required this.orderNumber,
    required this.hallName,
    required this.date,
    required this.time,
    required this.guests,
    required this.status,
    required this.amount,
    required this.showPayButton,
    required this.isPaymentFailed, // 🚀
    this.paymentStatusDisplay,
    required this.staff,
    required this.onPayPressed,
    required this.onRatePressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    Color statusColor;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'accepted':
      case 'مقبول':
        statusColor = const Color(0xFF6366F1);
        statusIcon = Icons.thumb_up_alt_outlined;
        break;
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

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.1), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(orderNumber, style: AppTextStyles.subtitle.copyWith(color: theme.colorScheme.onSurface)),
                      const SizedBox(height: 4),
                      Text(
                        hallName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyGrey.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 16),
                      const SizedBox(width: 6),
                      Text(status, style: AppTextStyles.bodyGrey.copyWith(color: statusColor, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.primaryGold.withValues(alpha: 0.1), height: 1, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _DetailItem(icon: Icons.calendar_today, label: isAr ? 'التاريخ' : 'Date', value: date, theme: theme),
                    _DetailItem(icon: Icons.schedule, label: isAr ? 'الوقت' : 'Time', value: time, theme: theme),
                    _DetailItem(icon: Icons.people, label: isAr ? 'الضيوف' : 'Guests', value: guests, theme: theme),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAr ? 'المبلغ الكلي' : 'Total Amount',
                      style: AppTextStyles.bodyGrey.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                    ),
                    Text(amount, style: AppTextStyles.subtitle.copyWith(color: AppColors.primaryGold, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),

                if (staff.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(Icons.badge_outlined, size: 18, color: AppColors.primaryGold),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${isAr ? "طاقم العمل:" : "Staff:"} $staff',
                          style: AppTextStyles.bodyGrey.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.8), fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                if (paymentStatusDisplay != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: paymentStatusDisplay!.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: paymentStatusDisplay!.color.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(paymentStatusDisplay!.icon, color: paymentStatusDisplay!.color, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            paymentStatusDisplay!.label,
                            style: AppTextStyles.bodyGrey.copyWith(color: paymentStatusDisplay!.color, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // 🚀 إضافة التنبيه الأحمر الخاص برفض الدفع فوق الزر تماماً
                if (isPaymentFailed && showPayButton) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isAr
                                ? 'تم رفض إيصال الدفع من قبل الإدارة، يرجى إعادة رفع إيصال صالح لتأكيد حجزك.'
                                : 'Payment receipt rejected by admin. Please upload a valid receipt to confirm your booking.',
                            style: AppTextStyles.bodyGrey.copyWith(
                              color: Colors.red[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                if (showPayButton) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: onPayPressed,
                      icon: const Icon(Icons.upload_file, size: 20),
                      label: Text(
                        isAr ? 'رفع إيصال الدفع' : 'Upload Payment Proof',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryGold,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onCancelPressed,
                        icon: const Icon(Icons.cancel_outlined, size: 18),
                        label: Text(isAr ? 'إلغاء' : 'Cancel'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onRatePressed,
                        icon: const Icon(Icons.star_outline, size: 18),
                        label: Text(isAr ? 'تقييم' : 'Rate'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryGold,
                          side: const BorderSide(color: AppColors.primaryGold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  const _DetailItem({required this.icon, required this.label, required this.value, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryGold, size: 20),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.tileCaption.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, textDirection: TextDirection.ltr, style: AppTextStyles.tileTitle.copyWith(color: theme.colorScheme.onSurface, fontSize: 13)),
        ],
      ),
    );
  }
}
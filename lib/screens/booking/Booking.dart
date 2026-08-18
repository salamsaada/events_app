import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:eventsapp/cubit/notification_cubit.dart';
import 'package:eventsapp/cubit/theme_cubit.dart';
import 'package:eventsapp/cubit/language_cubit.dart';
import 'package:eventsapp/cubit/user_cubit.dart'; 
import 'package:eventsapp/cubit/user_state.dart';
import 'package:eventsapp/core/utils/localized_value.dart';
import 'package:eventsapp/models/listing_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BookingRequestSheet extends StatefulWidget {
  final ServiceItem item;

  BookingRequestSheet({required this.item});

  @override
  State<BookingRequestSheet> createState() => _BookingRequestSheetState();
}

class _BookingRequestSheetState extends State<BookingRequestSheet> {
  final TextEditingController _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  String _selectedTime = '16:00';
  int _guestCount = 50;
  int _selectedPackageIndex = 0;

  final List<String> _timeSlots = const ['16:00', '19:00', '21:00'];

  // ✨ دالة الترجمة المضافة لتوحيد اللغة في هذه الصفحة
  String _tr(String en, String ar) {
    final languageCode = context.read<LanguageCubit>().languageCode;
    return languageCode == 'ar' ? ar : en;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // 🚀 دالة لاختيار ملف الـ PDF ورفعه
 Future<void> _pickAndUploadPdf(BuildContext context, String currentBookingId, String amount) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'], 
  );

  if (result != null) {
    File file = File(result.files.single.path!);
    
    int fileSizeInBytes = file.lengthSync();
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    
    if (fileSizeInMB > 2.0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_tr('File is too large! Max 2MB allowed.', 'حجم الملف كبير جداً! الحد الأقصى 2 ميغابايت.')),
            backgroundColor: Colors.red,
          ),
        );
      }
      return; 
    }

    // استدعاء دالة الرفع من الكيوبت مع تمرير المبلغ
    if (mounted) {
      context.read<UserCubit>().uploadProof(
        bookingId: currentBookingId,
        filePath: file.path,
        amount: amount, // 👈 صار معرف ومتاح هنا تماماً
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.read<ThemeCubit>().isDark;
    final languageCode = context.watch<LanguageCubit>().languageCode;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final selectedVariant = widget.item.variants.isNotEmpty
        ? widget.item.variants[_selectedPackageIndex]
        : null;
    final title = localizedText(widget.item.title, languageCode);
    final location = widget.item.district.name;

    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is CreateBookingSuccess) {
          Navigator.pop(context); // إغلاق نافذة الحجز

          // 🚀 تحديث الإشعارات فوراً
          context.read<NotificationCubit>().fetchNotifications();

          // استخراج الـ ID الخاص بالحجز (حسب شكل البيانات العائدة من السيرفر)
          String currentBookingId = '';
          try {
            // نستخدم النقطة للوصول للمتغيرات لأن هذا موديل (Object)
            currentBookingId = state.bookingResponse.data!.id.toString();
          } catch (e) {
            print("خطأ في استخراج رقم الحجز: $e");
          }

          // 🚀 عرض نافذة خيارات الدفع (فترة السماح)
          // 🚀 عرض نافذة خيارات الدفع (فترة السماح)
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              icon: const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 60,
              ),
              title: Text(
                _tr('Request Sent Successfully!', 'تم إرسال طلبك بنجاح!'),
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              content: Text(
                _tr(
                  'You have 48 hours to upload the payment proof to confirm your booking, otherwise it will be cancelled automatically.',
                  'لديك 48 ساعة لرفع إيصال الدفع وتأكيد حجزك بشكل نهائي، وإلا سيتم إلغاء الحجز تلقائياً.',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(height: 1.5),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actionsOverflowDirection: VerticalDirection.down,
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(dialogContext); // إغلاق النافذة
                      
                      // ✅ تم التعديل هنا: تمرير سعر الباقة المحددة بدلاً من booking.price
                      _pickAndUploadPdf(
                        context, 
                        currentBookingId, 
                        selectedVariant?.price.toString() ?? '0'
                      );
                    },
                    child: Text(
                      _tr('Upload Proof Now', 'رفع إيصال الدفع الآن'),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext); // إغلاق النافذة
                    },
                    child: Text(
                      _tr('Pay Later', 'الدفع لاحقاً'),
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ),
              ],
            );
          },
        );
        } else if (state is CreateBookingFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is UploadProofSuccess) { // 🚀 في حال نجاح رفع الإيصال
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_tr('Payment proof uploaded successfully!', 'تم رفع الإيصال بنجاح!')),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is UploadProofFailure) { // 🚀 في حال فشل الرفع
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateBookingLoading || state is UploadProofLoading; // أضفنا حالة الرفع للـ Loading

        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.65,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 48,
                          height: 5,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _tr('Booking request', 'طلب حجز'),
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _tr(
                                    'Complete the details and send your request in a polished booking flow.',
                                    'أكمل التفاصيل وأرسل طلبك في مسار حجز احترافي.',
                                  ),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary.withValues(alpha: 0.16),
                              theme.colorScheme.primary.withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.15,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              location,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                _buildSummaryBadge(
                                  theme,
                                  icon: Icons.event_available_outlined,
                                  label: DateFormat(
                                    'EEE, dd MMM',
                                  ).format(_selectedDate),
                                ),
                                const SizedBox(width: 10),
                                _buildSummaryBadge(
                                  theme,
                                  icon: Icons.schedule_outlined,
                                  label: _selectedTime,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: _buildSummaryBadge(
                                theme,
                                icon: Icons.groups_outlined,
                                label: _tr(
                                  '$_guestCount guests',
                                  '$_guestCount ضيف',
                                ),
                                fullWidth: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _tr('Choose a package', 'اختر باقة'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (widget.item.variants.isNotEmpty)
                        SizedBox(
                          height: 48,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.item.variants.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 10),
                            itemBuilder: (context, index) {
                              final variant = widget.item.variants[index];
                              final isSelected = index == _selectedPackageIndex;
                              final packageName = localizedText(
                                variant.name,
                                languageCode,
                                fallback: _tr('Package', 'باقة'),
                              );

                              return ChoiceChip(
                                selected: isSelected,
                                label: Text(packageName),
                                onSelected: (_) {
                                  setState(() => _selectedPackageIndex = index);
                                },
                                selectedColor: theme.colorScheme.primary,
                                labelStyle: theme.textTheme.bodyMedium
                                    ?.copyWith(
                                      color: isSelected
                                          ? Colors.white
                                          : theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                              );
                            },
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.06,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _tr(
                              'No package variants are available for this listing.',
                              'لا توجد باقات متاحة لهذه الخدمة.',
                            ),
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      const SizedBox(height: 20),
                      Text(
                        _tr('Event date', 'تاريخ المناسبة'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );

                          if (picked != null) {
                            setState(() => _selectedDate = picked);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  DateFormat(
                                    'EEEE, dd MMMM yyyy',
                                  ).format(_selectedDate),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: theme.colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _tr('Preferred time', 'الوقت المفضل'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ..._timeSlots.map((slot) {
                            final isSelected = _selectedTime == slot;
                            return ChoiceChip(
                              selected: isSelected,
                              label: Text(slot),
                              onSelected: (_) =>
                                  setState(() => _selectedTime = slot),
                              selectedColor: theme.colorScheme.primary,
                              labelStyle: theme.textTheme.bodyMedium?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _tr('Guest count', 'عدد الضيوف'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: _guestCount >= 10
                                  ? () => setState(() => _guestCount -= 10)
                                  : null,
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  '$_guestCount',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  setState(() => _guestCount += 10),
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _tr('Special notes', 'ملاحظات خاصة'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _notesController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: _tr(
                            'Add any special requests, event theme, or setup details...',
                            'أضف أي طلبات خاصة، أو موضوع للمناسبة، أو تفاصيل الإعداد...',
                          ),
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  String? selectedSlotId;
                                  if (selectedVariant != null &&
                                      selectedVariant.availabilities.isNotEmpty) {
                                    if (selectedVariant.availabilities[0].slots.isNotEmpty) {
                                      selectedSlotId = selectedVariant.availabilities[0].slots[0].id;
                                    }
                                  }

                                  context.read<UserCubit>().createBooking(
                                    listingId: widget.item.id,
                                    listingVariantId: selectedVariant?.id,
                                    listingSlotId: selectedSlotId,
                                    bookingType: 'request',
                                    quantity: _guestCount,
                                    bookedDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
                                    bookedStartTime: _selectedTime,
                                    customerNotes: _notesController.text.trim(),
                                  );
                                },
                          style: theme.elevatedButtonTheme.style?.copyWith(
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  selectedVariant == null
                                      ? _tr(
                                          'Send booking request',
                                          'إرسال طلب الحجز',
                                        )
                                      : _tr(
                                          'Send booking request - ${selectedVariant.price} ${selectedVariant.currency}',
                                          'إرسال طلب حجز - ${selectedVariant.price} ${selectedVariant.currency}',
                                        ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          _tr(
                            'Our team will review your request and contact you shortly.',
                            'سيقوم فريقنا بمراجعة طلبك والتواصل معك قريباً.',
                          ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSummaryBadge(
    ThemeData theme, {
    required IconData icon,
    required String label,
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : 140,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
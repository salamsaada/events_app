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
  // 🚀 Map لحفظ الكميات المخصصة: المفتاح هو variant_id والقيمة هي الكمية المطلوبة
  Map<String, int> _customItemsQuantities = {};
  List<String> _selectedFreelancerIds = [];
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController(text: '1');
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  String _selectedTime = '16:00';
  String? _selectedSlotId;
  int _guestCount = 1;
  int _selectedPackageIndex = 0;

  String _tr(String en, String ar) {
    final languageCode = context.read<LanguageCubit>().languageCode;
    return languageCode == 'ar' ? ar : en;
  }

  @override
  void initState() {
    super.initState();
    // 🚀 تهيئة المنتجات المخصصة لأول باقة عند فتح النافذة
    _initCustomItems(0);
  }

  // 🚀 دالة لتعبئة المنتجات بالكميات القصوى كقيمة افتراضية
  // 🚀 دالة لتعبئة المنتجات بالكميات القصوى وتحديد أول تاريخ متاح
  void _initCustomItems(int index) {
    _customItemsQuantities.clear();
    _selectedFreelancerIds.clear();

    if (widget.item.variants.isNotEmpty) {
      final variant = widget.item.variants[index];
      for (var pItem in variant.packageItems) {
        final vId = pItem.includedVariant?.id;
        if (vId != null && vId.isNotEmpty) {
          _customItemsQuantities[vId] = pItem.quantity;
        }
      }
      for (var fItem in variant.packageFreelancers) {
        final fId = fItem.freelancer?.id;
        if (fId != null && fId.isNotEmpty) {
          _selectedFreelancerIds.add(fId);
        }
      }

      // 🚀 التعديل هنا: جلب أول تاريخ متاح للباقة وتعيينه كالتاريخ الافتراضي!
      if (variant.availabilities != null && variant.availabilities.isNotEmpty) {
        var firstAvailDate = variant.availabilities[0].availableDate;        if (firstAvailDate != null) {
          // نستخدم Future.microtask لتجنب أخطاء بناء الواجهة أثناء تحديث الحالة
          Future.microtask(() {
            if (mounted) {
              setState(() {
                _selectedDate = firstAvailDate; // 🚀 مباشر وبدون تحويل
                _selectedSlotId = null;

              });
            }
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

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
          Navigator.pop(context);
        }
        return;
      }
      if (mounted) {
        context.read<UserCubit>().uploadProof(bookingId: currentBookingId, filePath: file.path, amount: amount);
      }
    } else {
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.read<ThemeCubit>().isDark;
    final languageCode = context.watch<LanguageCubit>().languageCode;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final selectedVariant = widget.item.variants.isNotEmpty ? widget.item.variants[_selectedPackageIndex] : null;
    final title = localizedText(widget.item.title, languageCode);
    final location = widget.item.district.name;

    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is CreateBookingSuccess) {
          context.read<NotificationCubit>().fetchNotifications();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                icon: const Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
                title: Text(
                  _tr('Request Sent Successfully!', 'تم إرسال طلبك بنجاح!'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  _tr(
                    'Your booking request is under review. Once accepted, you can upload the payment proof from your orders page.',
                    'طلب الحجز الخاص بك قيد المراجعة. بمجرد قبوله من قبل المزود، ستتمكن من رفع إيصال الدفع لإتمام الحجز من صفحة طلباتي.',
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(height: 1.5),
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        Navigator.pop(context);
                      },
                      child: Text(_tr('Done', 'حسناً'), style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              );
            },
          );
        } else if (state is CreateBookingFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errMessage), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
        } else if (state is UploadProofSuccess) {
          if (mounted) Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_tr('Payment proof uploaded successfully!', 'تم رفع الإيصال بنجاح!')), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
        } else if (state is UploadProofFailure) {
          if (mounted) Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errMessage), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateBookingLoading || state is UploadProofLoading;

        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.65,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
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
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
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
                                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _tr('Complete the details and send your request in a polished booking flow.', 'أكمل التفاصيل وأرسل طلبك في مسار حجز احترافي.'),
                                  style: theme.textTheme.bodyMedium?.copyWith(color: isDark ? Colors.grey[400] : Colors.grey[600], height: 1.4),
                                ),
                              ],
                            ),
                          ),
                          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [theme.colorScheme.primary.withValues(alpha: 0.16), theme.colorScheme.primary.withValues(alpha: 0.05)],
                            begin: Alignment.topLeft, end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.15)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(location, style: theme.textTheme.bodyMedium?.copyWith(color: isDark ? Colors.grey[400] : Colors.grey[600])),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                _buildSummaryBadge(theme, icon: Icons.event_available_outlined, label: DateFormat('EEE, dd MMM').format(_selectedDate)),
                                const SizedBox(width: 10),
                                _buildSummaryBadge(theme, icon: Icons.schedule_outlined, label: _selectedTime),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: _buildSummaryBadge(
                                theme,
                                icon: widget.item.type == 'physical_product' ? Icons.inventory_2_outlined : Icons.groups_outlined,
                                label: widget.item.type == 'physical_product'
                                    ? _tr('$_guestCount items', '$_guestCount قطعة')
                                    : _tr('$_guestCount guests', '$_guestCount ضيف'),
                                fullWidth: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(_tr('Choose a package', 'اختر باقة/منتج'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      if (widget.item.variants.isNotEmpty)
                        SizedBox(
                          height: 48,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.item.variants.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                            itemBuilder: (context, index) {
                              final variant = widget.item.variants[index];
                              final isSelected = index == _selectedPackageIndex;
                              final packageName = localizedText(variant.name, languageCode, fallback: _tr('Package', 'باقة'));

                              return ChoiceChip(
                                selected: isSelected,
                                label: Text(packageName),
                                onSelected: (_) {
                                  setState(() {
                                    _selectedPackageIndex = index;
                                    _initCustomItems(index);

                                    int maxForPackage = variant.capacity > 0 ? variant.capacity : (variant.stock ?? 10000);
                                    if (_guestCount > maxForPackage && maxForPackage > 0) _guestCount = maxForPackage;
                                    _qtyController.text = _guestCount.toString();
                                  });
                                },
                                selectedColor: theme.colorScheme.primary,
                                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                                  color: isSelected ? Colors.white : theme.colorScheme.onSurface,
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
                          decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(16)),
                          child: Text(_tr('No package variants are available for this listing.', 'لا توجد خيارات متاحة لهذا العنصر.'), style: theme.textTheme.bodyMedium),
                        ),
                      const SizedBox(height: 20),
                      Text(_tr('Event date', 'تاريخ المناسبة'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now().subtract(const Duration(days: 1)),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                            // 🚀 السحر هنا: قفل الأيام التي لا يتوفر فيها حجز لهذا الخيار
                            selectableDayPredicate: (DateTime date) {
                              if (selectedVariant == null || selectedVariant.availabilities.isEmpty) return true;

                              return selectedVariant.availabilities.any((avail) {
                                DateTime aDate = avail.availableDate; // 🚀 سطر واحد مباشر
                                return aDate.year == date.year && aDate.month == date.month && aDate.day == date.day;
                              });
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedDate = picked;
                              _selectedSlotId = null; // تصفير الوقت لكي يختار المستخدم وقتاً جديداً لليوم الجديد
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity, padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: theme.scaffoldBackgroundColor, borderRadius: BorderRadius.circular(18), border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1))),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_month_outlined, color: theme.colorScheme.primary),
                              const SizedBox(width: 12),
                              Expanded(child: Text(DateFormat('EEEE, dd MMMM yyyy').format(_selectedDate), style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600))),
                              Icon(Icons.chevron_right, color: theme.colorScheme.primary),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(_tr('Available Time Slots', 'الفترات الزمنية المتاحة'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      if (selectedVariant != null && selectedVariant.availabilities.isNotEmpty)
                        Wrap(
                          spacing: 10, runSpacing: 10,
                          children: [
                            ...selectedVariant.availabilities
                                .where((avail) => DateFormat('yyyy-MM-dd').format(avail.availableDate.toLocal()) == DateFormat('yyyy-MM-dd').format(_selectedDate))
                                .expand((avail) => avail.slots)
                                .map((slot) {
                              final timeFormat = DateFormat('hh:mm a');
                              final slotTime = '${timeFormat.format(slot.startTime.toLocal())} - ${timeFormat.format(slot.endTime.toLocal())}';
                              final isSelected = _selectedSlotId == slot.id;

                              final int slotCapacity = slot.remainingCapacity ?? 0;
                              final bool isSlotAvailable = slotCapacity > 0;
                              final bool isProduct = widget.item.type == 'physical_product';
                              final String chipLabel = isProduct
                                  ? '$slotTime (${isSlotAvailable ? "$slotCapacity ${_tr('available', 'متاح')}" : _tr('Full', 'مكتمل')})'
                                  : '$slotTime (${isSlotAvailable ? _tr('Available', 'متاح') : _tr('Full', 'مكتمل')})';

                              return ChoiceChip(
                                selected: isSelected,
                                label: Text(chipLabel),
                                onSelected: (chosen) {
                                  if (isSlotAvailable) {
                                    setState(() {
                                      _selectedSlotId = slot.id;
                                      _selectedTime = timeFormat.format(slot.startTime.toLocal());

                                      // 🚀 تحديد الحد الأقصى الصحيح عند اختيار الوقت
                                      int maxAllowed = isProduct ? slotCapacity : (selectedVariant.capacity ?? 0);
                                      if (maxAllowed <= 0) maxAllowed = selectedVariant.stock ?? 10000;

                                      if (_guestCount > maxAllowed) {
                                        _guestCount = maxAllowed;
                                        // 🚀 التحديث الآمن لمنع تعليق الحقل
                                        final newText = _guestCount.toString();
                                        _qtyController.value = TextEditingValue(
                                          text: newText,
                                          selection: TextSelection.collapsed(offset: newText.length),
                                        );
                                      }
                                    });
                                  }
                                },
                                selectedColor: theme.colorScheme.primary,
                                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                                  color: isSelected ? Colors.white : (isSlotAvailable ? theme.colorScheme.onSurface : Colors.grey),
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }),
                          ],
                        )
                      else
                        Container(
                          width: double.infinity, padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(16)),
                          child: Text(_tr('No available time slots for this date.', 'لا توجد فترات زمنية متاحة لهذا التاريخ.'), style: theme.textTheme.bodyMedium),
                        ),
                      const SizedBox(height: 20),
                      Text(
                        widget.item.type == 'physical_product'
                            ? _tr('Desired quantity', 'الكمية المرادة')
                            : _tr('Guest count (Hall/Service)', 'عدد الضيوف للصالة/الخدمة'),
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          children: [
                            // 🔴 زر التنقيص
                            IconButton(
                              onPressed: _guestCount > 1
                                  ? () {
                                setState(() {
                                  _guestCount -= 1;
                                  // 🚀 التحديث الآمن
                                  final newText = _guestCount.toString();
                                  _qtyController.value = TextEditingValue(
                                    text: newText,
                                    selection: TextSelection.collapsed(offset: newText.length),
                                  );
                                });
                              }
                                  : null,
                              icon: const Icon(Icons.remove_circle_outline),
                            ),

                            // ⌨️ حقل الإدخال الآمن
                            Expanded(
                              child: TextField(
                                controller: _qtyController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                onChanged: (value) {
                                  // 🚀 السماح بمسح الحقل دون إجبار المستخدم على العودة للرقم 1 فوراً
                                  if (value.isEmpty) {
                                    setState(() => _guestCount = 1);
                                    return;
                                  }

                                  int maxAllowed = 10000;
                                  final bool isProduct = widget.item.type == 'physical_product';

                                  if (selectedVariant != null) {
                                    if (isProduct) {
                                      // 🚀 حساب الحد الأقصى بذكاء (سواء اختار وقت أو لا)
                                      if (selectedVariant.availabilities.isNotEmpty && _selectedSlotId != null) {
                                        int foundCap = -1;
                                        for (var a in selectedVariant.availabilities) {
                                          for (var s in a.slots) {
                                            if (s.id == _selectedSlotId) {
                                              foundCap = s.remainingCapacity ?? 0;
                                            }
                                          }
                                        }
                                        maxAllowed = foundCap != -1 ? foundCap : (selectedVariant.stock ?? 10000);
                                      } else {
                                        // إذا لم يختر وقتاً بعد، نسمح له بالكتابة بناءً على المخزون العام
                                        maxAllowed = selectedVariant.stock ?? 10000;
                                      }
                                    } else {
                                      int cap = selectedVariant.capacity ?? 0;
                                      maxAllowed = cap > 0 ? cap : (selectedVariant.stock ?? 10000);
                                    }
                                  }

                                  if (maxAllowed <= 0) maxAllowed = 1;

                                  int parsedValue = int.tryParse(value) ?? 1;

                                  // إذا كتب رقم أكبر من المسموح
                                  if (parsedValue > maxAllowed) {
                                    parsedValue = maxAllowed;
                                    final String newText = maxAllowed.toString();
                                    _qtyController.value = TextEditingValue(
                                      text: newText,
                                      selection: TextSelection.collapsed(offset: newText.length),
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(_tr('Maximum capacity reached.', 'وصلت للحد الأقصى المسموح ($maxAllowed).')),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                  } else if (parsedValue <= 0) {
                                    // منع الصفر أو الأرقام السالبة
                                    parsedValue = 1;
                                    _qtyController.value = const TextEditingValue(
                                      text: '1',
                                      selection: TextSelection.collapsed(offset: 1),
                                    );
                                  }

                                  setState(() {
                                    _guestCount = parsedValue;
                                  });
                                },
                              ),
                            ),

                            // 🟢 زر الزيادة
                            IconButton(
                              onPressed: () {
                                int maxAllowed = 10000;
                                final bool isProduct = widget.item.type == 'physical_product';

                                if (selectedVariant != null) {
                                  if (isProduct) {
                                    if (selectedVariant.availabilities.isNotEmpty && _selectedSlotId != null) {
                                      int foundCap = -1;
                                      for (var a in selectedVariant.availabilities) {
                                        for (var s in a.slots) {
                                          if (s.id == _selectedSlotId) {
                                            foundCap = s.remainingCapacity ?? 0;
                                          }
                                        }
                                      }
                                      maxAllowed = foundCap != -1 ? foundCap : (selectedVariant.stock ?? 10000);
                                    } else {
                                      maxAllowed = selectedVariant.stock ?? 10000;
                                    }
                                  } else {
                                    int cap = selectedVariant.capacity ?? 0;
                                    maxAllowed = cap > 0 ? cap : (selectedVariant.stock ?? 10000);
                                  }
                                }

                                if (maxAllowed <= 0) maxAllowed = 1;

                                if (_guestCount < maxAllowed) {
                                  setState(() {
                                    _guestCount += 1;
                                    final String newText = _guestCount.toString();
                                    _qtyController.value = TextEditingValue(
                                      text: newText,
                                      selection: TextSelection.collapsed(offset: newText.length),
                                    );
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(_tr('Maximum capacity reached.', 'وصلت للحد الأقصى المسموح ($maxAllowed).')),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      ),

                      if (selectedVariant != null && selectedVariant.packageItems.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Text(_tr('Customize Package Items', 'تخصيص مكونات الباقة (المنتجات)'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        ...selectedVariant.packageItems.map((pItem) {
                          final variantId = pItem.includedVariant?.id ?? '';
                          if (variantId.isEmpty) return const SizedBox();

                          final titleMap = pItem.includedVariant?.listing?.title ?? {};
                          final String itemName = titleMap[languageCode] ?? titleMap['en'] ?? titleMap['ar'] ?? 'Product';
                          final int maxQty = pItem.quantity;
                          final int currentQty = _customItemsQuantities[variantId] ?? maxQty;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(itemName, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                                      Text('${_tr('Max available:', 'الحد الأقصى:')} $maxQty', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: currentQty > 0 ? () => setState(() => _customItemsQuantities[variantId] = currentQty - 1) : null,
                                      icon: const Icon(Icons.remove_circle_outline),
                                      color: currentQty > 0 ? theme.colorScheme.primary : Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 25,
                                      child: Center(child: Text('$currentQty', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                                    ),
                                    IconButton(
                                      onPressed: currentQty < maxQty ? () => setState(() => _customItemsQuantities[variantId] = currentQty + 1) : null,
                                      icon: const Icon(Icons.add_circle_outline),
                                      color: currentQty < maxQty ? theme.colorScheme.primary : Colors.grey,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                      if (selectedVariant != null && selectedVariant.packageFreelancers.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Text(_tr('Included Staff', 'طاقم العمل (اختياري)'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        ...selectedVariant.packageFreelancers.map((fItem) {
                          final freelancerId = fItem.freelancer?.id ?? '';
                          if (freelancerId.isEmpty) return const SizedBox();
                          final name = fItem.freelancer?.name ?? 'Staff';
                          final isSelected = _selectedFreelancerIds.contains(freelancerId);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: theme.scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.1)),
                            ),
                            child: CheckboxListTile(
                              value: isSelected,
                              activeColor: theme.colorScheme.primary,
                              title: Text(name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                              subtitle: Text(_tr('Include in booking', 'تضمين في الحجز'), style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                              onChanged: (val) {
                                setState(() {
                                  if (val == true) {
                                    _selectedFreelancerIds.add(freelancerId);
                                  } else {
                                    _selectedFreelancerIds.remove(freelancerId);
                                  }
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ],
                      const SizedBox(height: 20),
                      Text(_tr('Special notes', 'ملاحظات خاصة'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _notesController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: _tr('Add any special requests...', 'أضف أي طلبات خاصة، أو موضوع للمناسبة، أو تفاصيل الإعداد...'),
                          filled: true, fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.1))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.1))),
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
                            final bool hasSlots = selectedVariant?.availabilities.isNotEmpty ?? false;
                            if (hasSlots && _selectedSlotId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(_tr('Please select an available time slot.', 'يرجى اختيار فترة زمنية متاحة.')),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }

                            List<Map<String, dynamic>> customItemsToSend = _customItemsQuantities.entries.map((entry) {
                              return {
                                "variant_id": entry.key,
                                "quantity": entry.value,
                              };
                            }).toList();

                            context.read<UserCubit>().createBooking(
                              listingId: widget.item.id,
                              listingVariantId: selectedVariant?.id,
                              listingSlotId: _selectedSlotId,
                              bookingType: 'request',
                              quantity: _guestCount,
                              bookedDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
                              bookedStartTime: null,
                              customerNotes: _notesController.text.trim(),
                              customItems: customItemsToSend,
                              customFreelancers: _selectedFreelancerIds,
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
                              : Builder(
                            builder: (context) {
                              if (selectedVariant == null) {
                                return Text(_tr('Send booking request', 'إرسال طلب الحجز'));
                              }

                              // 🚀 1. جلب السعر الأساسي
                              double basePrice = (selectedVariant.price).toDouble();
                              double totalPrice = basePrice;

                              // 🚀 2. تحديد المنطق بناءً على النوع الدقيق للعنصر
                              if (widget.item.type == 'physical_product') {
                                // 📦 المنتج المادي: السعر للقطعة الواحدة، يضرب بالكمية المطلوبة
                                totalPrice = basePrice * _guestCount;

                              } else if (widget.item.type == 'package') {
                                // 🎨 التنسيق (Package): السعر هو للسعة الكلية، نقسمه على السعة ثم نضربه بعدد الضيوف
                                int capacity = selectedVariant.capacity > 0
                                    ? selectedVariant.capacity
                                    : (selectedVariant.stock ?? 1);

                                // حماية إضافية لمنع القسمة على صفر
                                if (capacity <= 0) capacity = 1;

                                totalPrice = (basePrice / capacity) * _guestCount;

                              } else if (widget.item.type == 'service') {
                                // 🏢 الصالة (Service): السعر ثابت للفترة المحجوزة بالكامل ولا يتأثر بالعدد
                                totalPrice = basePrice;
                              }

                              return Text(
                                _tr(
                                  'Send request - SYP ${totalPrice.toStringAsFixed(0)}',
                                  'إرسال طلب حجز - SYP ${totalPrice.toStringAsFixed(0)}',
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(child: Text(_tr('Our team will review your request and contact you shortly.', 'سيقوم فريقنا بمراجعة طلبك والتواصل معك قريباً.'), style: theme.textTheme.bodySmall?.copyWith(color: isDark ? Colors.grey[400] : Colors.grey[600]), textAlign: TextAlign.center)),
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

  Widget _buildSummaryBadge(ThemeData theme, {required IconData icon, required String label, bool fullWidth = false}) {
    return Container(
      width: fullWidth ? double.infinity : 140,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
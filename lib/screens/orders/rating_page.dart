import 'package:eventsapp/cubit/user_cubit.dart';
import 'package:eventsapp/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // ✅ إضافة استيراد الـ Bloc

// ✅ استبدل هذه المسارات بالمسارات الصحيحة في مشروعك
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class RatingPage extends StatefulWidget {
  final String bookingId;
  final String serviceName;

  const RatingPage({
    super.key,
    required this.bookingId,
    required this.serviceName,
  });

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  final _commentController = TextEditingController();
  int _selectedRating = 0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitRating() {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    // 1. التحقق من اختيار النجوم أولاً
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isAr ? 'اختر عدد النجوم أولاً' : 'Choose a star rating first',
          ),
        ),
      );
      return;
    }

    // 2. استدعاء دالة الـ Cubit لإرسال التقييم للسيرفر
    context.read<UserCubit>().sendRating(
      bookingId: widget.bookingId,
      rating: _selectedRating,
      // نرسل null إذا كان حقل التعليق فارغاً، وسيقوم الـ Repository بوضع "بدون تعليق" افتراضياً
      comment: _commentController.text.trim().isEmpty
          ? null
          : _commentController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return BlocListener<UserCubit, UserState>(
      // ✅ الاستماع لتغييرات الحالة (النجاح والفشل)
      listener: (context, state) {
        if (state is SendRatingSuccess) {
          // إغلاق صفحة التقييم
          Navigator.of(context).pop();
          // عرض رسالة النجاح القادمة من الـ Model
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is SendRatingFailure) {
          // عرض رسالة الخطأ
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isAr ? 'تقييم الخدمة' : 'Rate Service'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.rate_review_outlined,
                size: 64,
                color: AppColors.primaryGold,
              ),
              const SizedBox(height: 20),
              Text(
                widget.serviceName,
                textAlign: TextAlign.center,
                style: AppTextStyles.subtitle.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isAr ? 'كيف كانت تجربتك؟' : 'How was your experience?',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyGrey.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starNumber = index + 1;
                  return IconButton(
                    onPressed: () =>
                        setState(() => _selectedRating = starNumber),
                    icon: Icon(
                      starNumber <= _selectedRating
                          ? Icons.star
                          : Icons.star_border,
                      color: AppColors.primaryGold,
                      size: 42,
                    ),
                    tooltip: '$starNumber/5',
                  );
                }),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _commentController,
                maxLines: 5,
                textAlign: isAr ? TextAlign.right : TextAlign.left,
                decoration: InputDecoration(
                  labelText: isAr ? 'التعليق' : 'Comment',
                  hintText: isAr
                      ? 'اكتب ملاحظاتك عن الخدمة'
                      : 'Write your feedback about the service',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primaryGold,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ✅ استخدام BlocBuilder لتحديث واجهة زر الإرسال فقط (بدون إعادة بناء الصفحة كاملة)
              BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  // التحقق مما إذا كنا في حالة تحميل
                  final isLoading = state is SendRatingLoading;

                  return SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      // تعطيل الزر أثناء التحميل لمنع الإرسال المتكرر
                      onPressed: isLoading ? null : _submitRating,
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.send),
                      label: Text(
                        isLoading
                            ? (isAr ? 'جاري الإرسال...' : 'Submitting...')
                            : (isAr ? 'إرسال التقييم' : 'Submit Rating'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGold,
                        foregroundColor: Colors.black,
                        // تغيير لون الزر قليلاً ليعطي إحساس بأنه معطل أثناء التحميل
                        disabledBackgroundColor: AppColors.primaryGold
                            .withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

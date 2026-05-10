import 'package:flutter/material.dart';

class CustomGoldButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap; // ✅ تم إضافة علامة الاستفهام ليسمح بـ null
  final double width;
  final IconData? icon;

  const CustomGoldButton({
    super.key,
    required this.text,
    this.onTap, // ✅ تم إزالة required
    this.width = double.infinity,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // نتحقق مما إذا كان الزر معطلاً أم لا لتغيير شكله
    final bool isDisabled = onTap == null;

    return SizedBox(
      width: width,
      height: 55,
      child: ElevatedButton(
        // إذا كان onTap null سيقوم ElevatedButton تلقائياً بتعطيل الزر وتغيير لونه
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          // إذا كان معطلاً (أثناء التحميل) اجعله باهتاً قليلاً
          backgroundColor: isDisabled
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
              : null, // إذا لم يكن معطلاً اترك اللون الافتراضي
        ),
        child: Text(
          text,
          style:
              Theme.of(
                context,
              ).elevatedButtonTheme.style?.textStyle?.resolve({}) ??
              const TextStyle(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomGoldButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap; 
  final double width;
  final IconData? icon;

  const CustomGoldButton({
    super.key,
    required this.text,
    this.onTap, 
    this.width = double.infinity,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onTap == null;

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: isDisabled
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
          : null, 
    );

    // تجهيز تنسيق النص الموحد
    final textWidget = Text(
      text,
      style: Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve({}) ??
          const TextStyle(),
    );

    return SizedBox(
      width: width,
      height: 55,
      // 🌟 الفحص الذكي: إذا تم تمرير أيقونة نستخدم التصميم المدعوم بالأيقونات، وإلا نستخدم الزر العادي
      child: icon != null
          ? ElevatedButton.icon(
              onPressed: onTap,
              style: buttonStyle,
              icon: Icon(icon), 
              label: textWidget,
            )
          : ElevatedButton(
              onPressed: onTap,
              style: buttonStyle,
              child: textWidget,
            ),
    );
  }
}
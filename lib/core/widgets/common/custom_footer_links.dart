import 'package:flutter/material.dart';

class CustomFooterLinks extends StatelessWidget {
  final String leftText;
  final String? rightText;
  final VoidCallback onLeftTap;
  final VoidCallback? onRightTap;

  const CustomFooterLinks({
    super.key,
    required this.leftText,   
    this.rightText,  
    required this.onLeftTap,  
    this.onRightTap, 
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onLeftTap,
          child: Text(
            leftText,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GestureDetector(
          onTap: onRightTap,
          child: Text(
            rightText ?? ' ',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
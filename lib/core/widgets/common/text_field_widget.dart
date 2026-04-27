import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    required this.icon,
    this.isPassword = false, 
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      obscureText: isPassword,
      maxLines: maxLines,
      style: const TextStyle(color: AppColors.whiteText),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon, 
          color: theme.primaryColor, 
          size: 22
        ),
      ),
    );
  }
}
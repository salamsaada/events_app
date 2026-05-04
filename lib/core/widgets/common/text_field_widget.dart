import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final int maxLines;
  TextEditingController controller;
  String? Function(String?)? validator;
  void Function(String)? onChanged;
  CustomTextField({
    super.key,
    this.onChanged,
    this.validator,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      validator: validator,
      obscureText: isPassword,
      maxLines: maxLines,
      style: const TextStyle(color: AppColors.whiteText),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: theme.primaryColor, size: 22),
      ),
    );
  }
}

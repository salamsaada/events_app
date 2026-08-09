import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final int maxLines;
  TextEditingController? controller;
  String? Function(String?)? validator;
  void Function(String)? onChanged;
  
  // 🚀 1. تعريف المتغير الخاص بنوع الكيبورد
  TextInputType? keyboardType; 

  CustomTextField({
    super.key,
    this.onChanged,
    this.validator,
    this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.maxLines = 1,
    // 🚀 2. إضافته هنا ليتم استقباله
    this.keyboardType, 
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
      
      // 🚀 3. تمريره للويدجت الأساسي
      keyboardType: keyboardType, 

      style: TextStyle(
        color: theme.brightness == Brightness.dark 
            ? AppColors.whiteText 
            : Colors.black,    
      ),
      
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: theme.brightness == Brightness.dark ? Colors.white70 : Colors.black54,
        ),
        prefixIcon: Icon(icon, color: theme.primaryColor, size: 22),
      ),
    );
  }
}
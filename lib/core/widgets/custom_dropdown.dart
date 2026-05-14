import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? value;
  final void Function(String?)? onChanged;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        // ربط ألوان الإطار بالثيم لضمان تناسق الـ Dark Mode
        labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      // تغيير خلفية القائمة المنسدلة لتناسب الثيم
      dropdownColor: theme.colorScheme.surface,
      style: TextStyle(color: theme.colorScheme.onSurface),
      items: items.map((e) {
        return DropdownMenuItem(
          value: e,
          child: Text(e),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
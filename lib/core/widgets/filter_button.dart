import 'package:flutter/material.dart';
import 'package:eventsapp/generated/app_localizations.dart';   // 👈 ضيف هاد الاستيراد

class FilterButton extends StatelessWidget {
  final VoidCallback onTap;

  const FilterButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outlineVariant), 
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune_rounded, 
                color: colorScheme.primary, 
                size: 22
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.filterOptions,   
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface, 
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
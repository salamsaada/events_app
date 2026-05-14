import 'package:eventsapp/core/widgets/common/custom_gold_button.dart';
import 'package:eventsapp/core/widgets/common/text_field_widget.dart';
import 'package:eventsapp/core/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';

class FilterSection extends StatefulWidget {
  const FilterSection({super.key});

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  // Local state for UI testing
  String selectedCategory = 'All';
  double maxPrice = 2500.0;

 String? selectedLocation; // حل خطأ selectedLocation
  String? guestsCount;      // حل خطأ guestsCount
  String? selectedStyle;     // حل خطأ selectedStyle
  String? searchQuery;      // لفلترة المنتجات (Products)

  final List<String> categories = const [
    'All', 'Event Planning', 'Products', 'Venues'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildChipsRow(colorScheme),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildConditionalFilters(colorScheme, textTheme),
          ),

          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ), 
            child: CustomGoldButton(
              text: "Apply Filters",
              onTap: () {
               Navigator.pop(context); 
              },
            ),
          ),
          const SizedBox(height: 16), 
        ],
      ),
    );
  }

  Widget _buildChipsRow(ColorScheme colorScheme) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final bool isSelected = selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (val) => setState(() => selectedCategory = category),
              selectedColor: colorScheme.primary,
              backgroundColor: colorScheme.surface,
              labelStyle: TextStyle(
                color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
      ),
    );
  }
Widget _buildConditionalFilters(ColorScheme colorScheme, TextTheme textTheme) {
  if (selectedCategory == 'Event Planning') {
    return Column(
      children: [
        CustomDropdown(
          label: "Location",
          items: const ['Damascus', 'Aleppo', 'Homs'],
          onChanged: (val) => setState(() => selectedLocation = val),
        ),
        
        const SizedBox(height: 16),

        CustomTextField(
          label: "Number of Guests",
          icon: Icons.people_outline,
          onChanged: (value) => setState(() => guestsCount = value),
        ),

        const SizedBox(height: 16),

        CustomDropdown(
          label: "Event Style",
          items: const ['Modern', 'Classic', 'Rustic'],
          onChanged: (val) => setState(() => selectedStyle = val),
        ),
      ],
    );
  } 

  else if (selectedCategory == 'Products') {
    return Column(
      children: [
        CustomTextField(
          label: "Product Name",
          icon: Icons.search,
          onChanged: (value) => setState(() => searchQuery = value),
        ),
        
        const SizedBox(height: 20),

        _buildPriceSlider(colorScheme, textTheme),
      ],
    );
  }

  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.category_outlined, size: 48, color: colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            "Select a category to see filters",
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    ),
  );
}

  // --- Helper UI Components ---
  
  Widget _buildPriceSlider(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Max Price: \$${maxPrice.toInt()}",
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        ),
        Slider(
          value: maxPrice,
          max: 5000,
          activeColor: colorScheme.primary,
          onChanged: (val) => setState(() => maxPrice = val),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/cubit/user_cubit.dart';
import 'package:eventsapp/core/widgets/common/custom_gold_button.dart';
import 'package:eventsapp/core/widgets/common/text_field_widget.dart';
import 'package:eventsapp/core/widgets/custom_dropdown.dart';
import 'package:intl/intl.dart'; 
import 'search_results_page.dart'; 

class FilterDialogWidget extends StatefulWidget {
  const FilterDialogWidget({super.key});

  @override
  State<FilterDialogWidget> createState() => _FilterDialogWidgetState();
}

class _FilterDialogWidgetState extends State<FilterDialogWidget> {
  // القسم الرئيسي
  String? selectedMainCategory;

  // متغيرات الفلاتر
  final TextEditingController searchController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  
  String? selectedLocation;
  String? selectedRating; 
  DateTime? selectedDate; 

  @override
  void dispose() {
    searchController.dispose();
    maxPriceController.dispose();
    capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: selectedMainCategory == null
              ? _buildCategorySelection(context)
              : _buildFiltersForm(context),
        ),
      ),
    );
  }

  // ==========================================
  // الشاشة الأولى: اختيار القسم
  // ==========================================
  Widget _buildCategorySelection(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      key: const ValueKey('Categories'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "What are you looking for?",
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildCategoryButton('Venues (Halls)', Icons.store, 'hall'),
          const SizedBox(height: 12),
          _buildCategoryButton('Ready Packages', Icons.card_giftcard, 'package'),
          const SizedBox(height: 12),
          // 🚀 هنا تم دمج الخدمات والمنتجات معاً في زر واحد
          _buildCategoryButton('Services & Products', Icons.room_service, 'service'),
          const SizedBox(height: 12),
          _buildCategoryButton('Providers', Icons.business_center, 'provider'),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String title, IconData icon, String type) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD6B237),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onPressed: () {
          setState(() {
            selectedMainCategory = type;
          });
        },
      ),
    );
  }

  // ==========================================
  // الشاشة الثانية: عرض فلاتر القسم المختار
  // ==========================================
  Widget _buildFiltersForm(BuildContext context) {
    final theme = Theme.of(context);
    
    // 🚀 تغيير عنوان النافذة ليعكس الدمج
    String title = "";
    if (selectedMainCategory == 'hall') title = "Filter Halls";
    if (selectedMainCategory == 'package') title = "Filter Packages";
    if (selectedMainCategory == 'service') title = "Filter Services & Products";
    if (selectedMainCategory == 'provider') title = "Filter Providers";

    return Padding(
      key: const ValueKey('Filters'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 18),
                onPressed: () {
                  setState(() {
                    selectedMainCategory = null;
                    _clearFilters(); 
                  });
                },
              ),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Divider(height: 20),

          // استدعاء الحقول بناءً على القسم
          _buildDynamicFields(),

          const SizedBox(height: 32),

          CustomGoldButton(
            text: "Apply Filters",
            onTap: () {
              String? formattedDate;
              if (selectedDate != null) {
                formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
              }

              context.read<UserCubit>().getListing(
                type: selectedMainCategory, // سيرسل كلمة 'service' للباك إند للبحث عنهما معاً
                search: searchController.text.isNotEmpty ? searchController.text : null,
                location: selectedLocation,
                capacity: capacityController.text.isNotEmpty ? capacityController.text : null,
                minPrice: null, 
                maxPrice: maxPriceController.text.isNotEmpty ? maxPriceController.text : null,
                rating: selectedRating,
                date: formattedDate,
              );

              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchResultsPage(categoryName: title),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _clearFilters() {
    searchController.clear();
    maxPriceController.clear();
    capacityController.clear();
    selectedLocation = null;
    selectedRating = null;
    selectedDate = null;
  }

  // ==========================================
  // بناء الحقول بشكل ديناميكي حسب القسم
  // ==========================================
  // ==========================================
  // بناء الحقول بشكل ديناميكي حسب القسم
  // ==========================================
  Widget _buildDynamicFields() {
    return Column(
      children: [
        CustomTextField(
          label: "Search Name...",
          icon: Icons.search,
          controller: searchController,
        ),
        const SizedBox(height: 12),

        // يظهر حقل المدينة للجميع عدا مزودي الخدمة (Providers)
        if (selectedMainCategory != 'provider') ...[
          CustomDropdown(
            label: "Location",
            items: const ['Damascus', 'Aleppo', 'Homs', 'Mazzeh'], 
            value: selectedLocation,
            onChanged: (val) => setState(() => selectedLocation = val),
          ),
          const SizedBox(height: 12),
        ],

        // 🚀 التعديل هنا: حقل التاريخ صار يظهر فقط للصالات والباكجات
        if (selectedMainCategory == 'hall' || selectedMainCategory == 'package') ...[
          _buildDatePicker(),
          const SizedBox(height: 12),
        ],

        // حقل السعة يظهر للصالات والباكجات
        if (selectedMainCategory == 'hall' || selectedMainCategory == 'package') ...[
          CustomTextField(
            label: "Capacity (Guests)",
            icon: Icons.people_outline,
            controller: capacityController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
        ],

        if (selectedMainCategory != 'provider') ...[
          CustomTextField(
            label: "Max Price (Budget)", 
            icon: Icons.attach_money,
            controller: maxPriceController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
        ],

        CustomDropdown(
          label: "Minimum Rating",
          items: const ['1', '2', '3', '4', '5'],
          value: selectedRating,
          onChanged: (val) => setState(() => selectedRating = val),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: colorScheme.primary, 
                ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          setState(() {
            selectedDate = date;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.grey.shade600),
            const SizedBox(width: 12),
            Text(
              selectedDate == null 
                  ? 'Select Available Date' 
                  : DateFormat('yyyy-MM-dd').format(selectedDate!),
              style: TextStyle(
                fontSize: 16,
                color: selectedDate == null ? Colors.grey.shade600 : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
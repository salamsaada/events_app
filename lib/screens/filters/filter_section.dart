import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/cubit/user_cubit.dart';
import 'package:eventsapp/core/widgets/common/custom_gold_button.dart';
import 'package:eventsapp/core/widgets/common/text_field_widget.dart';
import 'package:eventsapp/core/widgets/custom_dropdown.dart';
import 'package:eventsapp/generated/app_localizations.dart';
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

  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  final TextEditingController minCapacityController = TextEditingController();
  final TextEditingController maxCapacityController = TextEditingController();

  String? selectedRating;

  @override
  void dispose() {
    searchController.dispose();
    minPriceController.dispose();
    maxPriceController.dispose();
    minCapacityController.dispose();
    maxCapacityController.dispose();
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Padding(
      key: const ValueKey('Categories'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.filterWhatLookingFor,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildCategoryButton(l10n.filterCategoryVenues, Icons.store, 'hall'),
          const SizedBox(height: 12),
          _buildCategoryButton(
            l10n.filterCategoryPackages,
            Icons.card_giftcard,
            'package',
          ),
          const SizedBox(height: 12),
          _buildCategoryButton(
            l10n.filterCategoryServicesProducts,
            Icons.room_service,
            'service',
          ),
          const SizedBox(height: 12),
          _buildCategoryButton(
            l10n.filterCategoryProviders,
            Icons.business_center,
            'provider',
          ),
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
        label: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD6B237),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    String title = "";
    if (selectedMainCategory == 'hall') title = l10n.filterHallsTitle;
    if (selectedMainCategory == 'package') title = l10n.filterPackagesTitle;
    if (selectedMainCategory == 'service')
      title = l10n.filterServicesProductsTitle;
    if (selectedMainCategory == 'provider') title = l10n.filterProvidersTitle;

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
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),

          _buildDynamicFields(context),

          const SizedBox(height: 32),

          CustomGoldButton(
            text: l10n.applyFilters,
            onTap: () {
              if (selectedMainCategory == 'provider') {
                // ✨ التعديل هنا: إرسال النص المكتوب بحقل البحث
                context.read<UserCubit>().getProviders(
                  name: searchController.text.isNotEmpty
                      ? searchController.text
                      : null,
                );
              } else {
                // باقي الكود كما هو ...
                context.read<UserCubit>().getListing(
                  type: selectedMainCategory,
                  title: searchController.text.isNotEmpty
                      ? searchController.text
                      : null,
                  capacityMin: minCapacityController.text.isNotEmpty
                      ? minCapacityController.text
                      : null,
                  capacityMax: maxCapacityController.text.isNotEmpty
                      ? maxCapacityController.text
                      : null,
                  minPrice: minPriceController.text.isNotEmpty
                      ? minPriceController.text
                      : null,
                  maxPrice: maxPriceController.text.isNotEmpty
                      ? maxPriceController.text
                      : null,
                  rating: selectedRating,
                );
              }

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
    minPriceController.clear();
    maxPriceController.clear();
    minCapacityController.clear();
    maxCapacityController.clear();
    selectedRating = null;
  }

  // ==========================================
  // بناء الحقول بشكل ديناميكي حسب القسم
  // ==========================================
  Widget _buildDynamicFields(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        CustomTextField(
          label: l10n.filterSearchNameLabel,
          icon: Icons.search,
          controller: searchController,
        ),
        const SizedBox(height: 12),

        if (selectedMainCategory == 'hall' ||
            selectedMainCategory == 'package') ...[
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: l10n.filterMinCapacityLabel,
                  icon: Icons.people_outline,
                  controller: minCapacityController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  label: l10n.filterMaxCapacityLabel,
                  icon: Icons.people_alt_outlined,
                  controller: maxCapacityController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],

        if (selectedMainCategory != 'provider') ...[
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: l10n.filterMinPriceLabel,
                  icon: Icons.attach_money,
                  controller: minPriceController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  label: l10n.maxPriceLabel,
                  icon: Icons.money_off,
                  controller: maxPriceController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],

        CustomDropdown(
          label: l10n.filterMinimumRatingLabel,
          items: const ['1', '2', '3', '4', '5'],
          value: selectedRating,
          onChanged: (val) => setState(() => selectedRating = val),
        ),
      ],
    );
  }
}

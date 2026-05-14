// import 'package:eventsapp/cubit/filter_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class FilterChipsSection extends StatelessWidget {
//   const FilterChipsSection({super.key});

//   // Categories list
//   final List<String> categories = const [
//     'All',
//     'Event Planning',
//     'Products',
//     'Venues',
//     'Gifts'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     // نستخدم BlocBuilder للاستماع لتغير القيمة في الـ Cubit
//     return BlocBuilder<FilterCubit, FilterState>(
//       builder: (context, state) {
//         final cubit = context.read<FilterCubit>();

//         return SizedBox(
//           height: 40,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             itemCount: categories.length,
//             itemBuilder: (context, index) {
//               final category = categories[index];
//               // نتحقق من الفئة المختارة من داخل الـ Cubit مباشرة
//               bool isSelected = cubit.selectedCategory == category;

//               return Padding(
//                 padding: const EdgeInsets.only(right: 10),
//                 child: ChoiceChip(
//                   label: Text(category),
//                   selected: isSelected,
//                   onSelected: (bool selected) {
//                     // استدعاء دالة التحديث في الـ Cubit
//                     cubit.updateCategory(category);
//                   },
//                   // Styling
//                   selectedColor: const Color(0xFFF9C54D),
//                   backgroundColor: Theme.of(context).colorScheme.surface,
//                   labelStyle: TextStyle(
//                     color: isSelected ? Colors.black : Colors.grey[600],
//                     fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     side: BorderSide(
//                       color: isSelected ? Colors.transparent : Colors.grey[300]!,
//                     ),
//                   ),
//                   // لإزالة الظلال المزعجة
//                   elevation: 0,
//                   pressElevation: 0,
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
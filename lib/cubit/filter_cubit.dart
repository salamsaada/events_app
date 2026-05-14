// import 'package:eventsapp/repositories/user_repository.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// part 'filter_state.dart';

// class FilterCubit extends Cubit<FilterState> {
//   final UserRepository userRepository;

//   FilterCubit(this.userRepository) : super(FilterInitial());

//   // Current filter values
//   String selectedCategory = 'All';
//   String? location;
//   String? capacity;
//   double maxPrice = 5000.0;
//   String? eventStyle;

//   // 1. Update Category
//   void updateCategory(String category) {
//     selectedCategory = category;
//     // Reset filters when category changes if needed
//     fetchFilteredData();
//   }

//   // 2. Update Location
//   void updateLocation(String city) {
//     location = city;
//     fetchFilteredData();
//   }

//   // 3. Update Capacity (Number of people)
//   void updateCapacity(String value) {
//     capacity = value;
//     fetchFilteredData();
//   }

//   // 4. Update Price
//   void updatePrice(double price) {
//     maxPrice = price;
//     fetchFilteredData();
//   }

//   // 5. Update Style
//   void updateStyle(String style) {
//     eventStyle = style;
//     fetchFilteredData();
//   }

//   // Main function to talk to Laravel API
//   Future<void> fetchFilteredData() async {
//     emit(FilterLoading());

//     // Calling the Repository method we explained before
//     final result = await userRepository.getFilteredItems(
//       type: selectedCategory,
//       city: location,
//       capacity: capacity != null ? int.tryParse(capacity!) : null,
//       maxPrice: maxPrice,
//       style: eventStyle,
//     );

//     result.fold(
//       (error) => emit(FilterFailure(error)),
//       (items) => emit(FilterResultsLoaded(
//         items: items,
//         selectedCategory: selectedCategory,
//         location: location,
//         capacity: capacity,
//         maxPrice: maxPrice,
//       )),
//     );
//   }
//   // Add this inside FilterCubit class
//   void updateSearchQuery(String query) {
//     // You can add a variable named 'searchQuery' in your cubit if you want to store it
//     // For now, we will just trigger the fetch
//     fetchFilteredData(); 
//   }
// }
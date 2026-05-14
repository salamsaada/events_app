part of 'filter_cubit.dart';

abstract class FilterState {}

class FilterInitial extends FilterState {}

class FilterLoading extends FilterState {}

class FilterResultsLoaded extends FilterState {
  final List<dynamic> items; 
  final String selectedCategory;
  final String? location;
  final String? capacity;
  final double maxPrice;

  FilterResultsLoaded({
    required this.items,
    required this.selectedCategory,
    this.location,
    this.capacity,
    required this.maxPrice,
  });
}

class FilterFailure extends FilterState {
  final String message;
  FilterFailure(this.message);
}
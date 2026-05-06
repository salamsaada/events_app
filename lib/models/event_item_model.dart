class EventItemModel {
  final String title;
  final String companyName;
  final String price;
  final String imageUrl;
  final double rating;
  final String? location; 
  final String? capacity; 
  final String description;

  EventItemModel({
    required this.title,
    required this.companyName,
    required this.price,
    required this.imageUrl,
    required this.rating,
    this.location,
    this.capacity,
    required this.description,
  });
}
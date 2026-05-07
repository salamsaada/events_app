import 'package:flutter/material.dart';
import '../../../core/widgets/common/result_card.dart';
import '../../models/event_item_model.dart'; 
import 'details_page.dart';

class ReadyMadePackagesPage extends StatelessWidget {
  final String categoryName;

  final List<EventItemModel> dummyPackages = [
    EventItemModel(
      title: "Royal Wedding Hall",
      companyName: "Elite Events Co.",
      price: "15,000 SAR",
      imageUrl: "https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=1000",
      rating: 4.9,
      location: "Riyadh, Al-Nuzha",
      capacity: "500 Guests",
      description: "A luxurious hall equipped with the latest lighting and sound systems to make your wedding night unforgettable.",
    ),
    EventItemModel(
      title: "Modern Garden Setup",
      companyName: "Nature Party",
      price: "8,500 SAR",
      imageUrl: "https://images.unsplash.com/photo-1469334031218-e382a71b716b?q=80&w=1000",
      rating: 4.7,
      location: "Jeddah, Obhur",
      capacity: "200 Guests",
      description: "Enjoy an outdoor atmosphere with elegant modern designs suitable for small parties and graduations.",
    ),
    EventItemModel(
      title: "Classic Hotel Ballroom",
      companyName: "Grand Hyatt",
      price: "25,000 SAR",
      imageUrl: "https://images.unsplash.com/photo-1511795409834-ef04bbd61622?q=80&w=1000",
      rating: 4.8,
      location: "Riyadh, Olaya",
      capacity: "350 Guests",
      description: "The classic choice for high-end weddings with five-star catering services included.",
    ),
  ];

  ReadyMadePackagesPage({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
  
    final itemsToShow = dummyPackages;

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName), 
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search for packages...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: itemsToShow.length, 
              itemBuilder: (context, index) {
                final item = itemsToShow[index];

                return ResultCard(
                  title: item.title,
                  companyName: item.companyName,
                  price: item.price,
                  imageUrl: item.imageUrl,
                  rating: item.rating,
                  location: item.location,
                  capacity: item.capacity,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(
                          title: item.title,
                          description: item.description,
                          price: item.price,
                          imageUrl: item.imageUrl,
                          isGuest: true, 
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:eventsapp/core/widgets/common/custom_gold_button.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String imageUrl;
  final bool isGuest; 

  const DetailsPage({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isGuest,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(imageUrl, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(price, style: theme.textTheme.titleLarge?.copyWith(color: const Color(0xFFF9C54D))),
                  const Divider(height: 40),
                  const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(description, style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ),
        ],
      ),

      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.transparent,
        child: CustomGoldButton(
          text: "Book Now",
          onTap: () => _handleBooking(context),
        ),
      ),
    );
  }

  void _handleBooking(BuildContext context) {
    if (isGuest) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please log in to proceed with your booking."),
          backgroundColor: Colors.redAccent,
          action: SnackBarAction(
            label: "Login",
            textColor: Colors.white,
            onPressed: () {
              // هنا نوجهه لصفحة تسجيل الدخول
            },
          ),
        ),
      );
    } else {

      print("Proceeding to checkout...");
    }
  }
}
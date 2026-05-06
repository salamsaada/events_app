import 'package:eventsapp/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeddingHallsPage extends StatelessWidget {
  const WeddingHallsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        bool isDark = context.read<ThemeCubit>().isDark;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text("Wedding Halls"),
            centerTitle: true,
            backgroundColor: theme.appBarTheme.backgroundColor,
            elevation: 0,
            iconTheme: theme.appBarTheme.iconTheme,
            titleTextStyle: theme.appBarTheme.titleTextStyle,
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 4, 
            itemBuilder: (context, index) {
              return _buildHallCard(context, isDark);
            },
          ),
        );
      },
    );
  }

  Widget _buildHallCard(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=1000',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: theme.colorScheme.primary, size: 16),
                      const Text(
                        " 4.9",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Versailles Royal Hall",
                      style: theme.textTheme.displayLarge?.copyWith(fontSize: 18),
                    ),
                    Text(
                      "25,000 SR",
                      style: TextStyle(
                        color: theme.colorScheme.primary, 
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                
                Row(
                  children: [
                    Icon(Icons.location_on, color: isDark ? Colors.grey[500] : Colors.grey[400], size: 18),
                    const SizedBox(width: 5),
                    Text(
                      "Riyadh, Al-Aqiq",
                      style: theme.textTheme.bodySmall, 
                    ),
                    const SizedBox(width: 20),
                    Icon(Icons.people, color: isDark ? Colors.grey[500] : Colors.grey[400], size: 18),
                    const SizedBox(width: 5),
                    Text(
                      "Up to 600 Guests",
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: theme.colorScheme.onSurface.withOpacity(0.1)),
                ),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator...
                    },
                    style: theme.elevatedButtonTheme.style, 
                    child: const Text("View Details"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
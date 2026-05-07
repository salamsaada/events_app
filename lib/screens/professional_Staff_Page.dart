import 'package:eventsapp/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfessionalStaffPage extends StatelessWidget {
  final String eventName;

  const ProfessionalStaffPage({super.key, required this.eventName});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        bool isDark = context.read<ThemeCubit>().isDark;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              eventName,
              style: theme.appBarTheme.titleTextStyle,
            ),
            backgroundColor: theme.appBarTheme.backgroundColor,
            centerTitle: true,
            iconTheme: theme.appBarTheme.iconTheme,
          ),
          body: Column(
            children: [
              _buildModernFilter(context, isDark),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return _buildStaffGridCard(context, isDark);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStaffGridCard(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () => print("Navigating to Details..."),
      child: Container(
        decoration: BoxDecoration(
          // الربط مع surfaceColor من AppTheme
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  image: const DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/150'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Chef Fahad Ali",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Professional Catering",
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "700 SR",
                        style: TextStyle(
                          color: theme.colorScheme.primary, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: theme.colorScheme.primary, size: 14),
                          Text(
                            " 4.9",
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernFilter(BuildContext context, bool isDark) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _filterChip(context, "All", true, isDark),
          _filterChip(context, "Chefs", false, isDark),
          _filterChip(context, "Photographers", false, isDark),
          _filterChip(context, "Musicians", false, isDark),
        ],
      ),
    );
  }

  Widget _filterChip(BuildContext context, String label, bool isSelected, bool isDark) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.surface,
        labelStyle: TextStyle(
          color: isSelected 
            ? (isDark ? Colors.black : Colors.white) 
            : theme.colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isSelected ? Colors.transparent : theme.colorScheme.primary.withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}
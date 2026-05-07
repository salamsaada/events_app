// import 'package:eventsapp/screens/result_page.dart';
// import 'package:flutter/material.dart';

// class BookingPathPage extends StatelessWidget {
//   final String eventName; 

//   const BookingPathPage({super.key, required this.eventName});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('$eventName Planning'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 10),
//             Text(
//               "How would you like to plan your event?",
//               style: theme.textTheme.headlineSmall?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Choose your preferred booking path",
//               style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
//             ),
//             const SizedBox(height: 40),
            
//             _buildSelectionCard(
//               context,
//               title: "Ready-made Package",
//               description: "Complete setup including venue, services, and decor provided by companies.",
//               icon: Icons.auto_awesome_outlined,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ResultsPage(
//                       categoryName: eventName,
//                       isPackagePath: true, 
//                     ),
//                   ),
//                 );
//               },
//             ),

//             const SizedBox(height: 20),

//             _buildSelectionCard(
//               context,
//               title: "Custom Equipment",
//               description: "Select specific products individually to build your own event setup.",
//               icon: Icons.shopping_bag_outlined,
//              onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ResultsPage(
//                       categoryName: eventName,
//                       isPackagePath:
//                           false, 
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSelectionCard(
//     BuildContext context, {
//     required String title,
//     required String description,
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           color: isDark ? theme.colorScheme.surface : theme.colorScheme.primary.withOpacity(0.05),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: theme.colorScheme.primary.withOpacity(0.3),
//             width: 1.2,
//           ),
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 28,
//               backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
//               child: Icon(icon, color: theme.colorScheme.primary, size: 28),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     description,
//                     style: theme.textTheme.bodySmall?.copyWith(height: 1.3),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(Icons.arrow_forward_ios, size: 14, color: theme.colorScheme.primary),
//           ],
//         ),
//       ),
//     );
//   }
// }
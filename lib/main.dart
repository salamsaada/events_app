import 'package:eventsapp/screens/selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:eventsapp/core/theme/app_theme.dart';

void main() {
  runApp(const eventsapp());
}

class eventsapp extends StatelessWidget {
  const eventsapp({super.key});

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Royal Events',
      theme: AppTheme.darkTheme,
      home: SelectionScreen(),
    );
    
  }
}
import 'package:eventsapp/screens/auth/splash_screen.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class RoyalEventsApp extends StatelessWidget {
  const RoyalEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'رويال إيفينتس',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}

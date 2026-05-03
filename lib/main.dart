import 'package:eventsapp/cubit/theme_cubit.dart';
import 'package:eventsapp/screens/auth/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

import 'core/theme/app_theme.dart';
import 'cache/cache_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper().init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const RoyalEventsApp());
}

class RoyalEventsApp extends StatelessWidget {
  const RoyalEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {

          bool isDarkMode = context.read<ThemeCubit>().isDark;

          return MaterialApp(
            title: 'رويال إيفينتس',
            debugShowCheckedModeBanner: false,

            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
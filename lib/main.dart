import 'package:dio/dio.dart';
import 'package:eventsapp/core/api/dio_consumer.dart';
import 'package:eventsapp/cubit/auth_cubit.dart';
import 'package:eventsapp/cubit/theme_cubit.dart';
import 'package:eventsapp/cubit/language_cubit.dart';
import 'package:eventsapp/cubit/user_cubit.dart';
import 'package:eventsapp/repositories/user_repository.dart';
import 'package:eventsapp/screens/auth/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/app_localizations.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              UserCubit(UserRepository(api: DioConsumer(dio: Dio()))),
        ),
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => LanguageCubit()),
        BlocProvider(create: (context) => AuthCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, languageState) {
              bool isDarkMode = context.read<ThemeCubit>().isDark;
              String languageCode = context.read<LanguageCubit>().languageCode;

              return MaterialApp(
                onGenerateTitle: (context) =>
                    AppLocalizations.of(context)!.appTitle,
                debugShowCheckedModeBanner: false,
                locale: Locale(languageCode),
                supportedLocales: const [Locale('en'), Locale('ar')],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
                home: const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}

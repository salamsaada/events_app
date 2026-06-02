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
import 'core/services/deep_link_service.dart'; 

// تعريف مفتاح عام للتحكم بالتنقل من خارج شجرة الـ Widgets
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper().init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // إنشاء نسخة من خدمة الديب لينك وتمرير الـ navigatorKey بداخلها
  final deepLinkService = DeepLinkService(navigatorKey);
  // تشغيل الاستماع للروابط العميقة فور صعود التطبيق
  await deepLinkService.init();

  runApp(const RoyalEventsApp());
}

class RoyalEventsApp extends StatelessWidget {
  const RoyalEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 🌐 إنشاء نسخة واحدة مركزية ومشتركة من محرك الإنترنت الخاص بزميلكِ لخدمة كل الـ Cubits
    final dioConsumer = DioConsumer(dio: Dio());

    return MultiBlocProvider(
      providers: [
        // 1️⃣ الـ UserCubit يستخدم النسخة المركزية
        BlocProvider(
          create: (context) => UserCubit(UserRepository(api: dioConsumer)),
        ),
        
        // 2️⃣ الـ AuthCubit المحدث يستقبل الآن نفس النسخة ليتوافق مع الـ Interceptor والـ Cache تلقائياً
        BlocProvider(
          create: (context) => AuthCubit(dioConsumer),
        ),

        // باقي الـ Cubits الخاصة بالتطبيق كما هي دون أي تغيير
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => LanguageCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, languageState) {
              bool isDarkMode = context.read<ThemeCubit>().isDark;
              String languageCode = context.read<LanguageCubit>().languageCode;

              return MaterialApp(
                // ربط الـ navigatorKey لكي ينجح كلاس الـ Service في توجيه المستخدم
                navigatorKey: navigatorKey, 
                
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
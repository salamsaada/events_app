import 'package:dio/dio.dart';
import 'package:eventsapp/core/api/dio_consumer.dart';
import 'package:eventsapp/cubit/auth_cubit.dart';
import 'package:eventsapp/cubit/theme_cubit.dart';
import 'package:eventsapp/cubit/language_cubit.dart';
import 'package:eventsapp/cubit/user_cubit.dart';
import 'package:eventsapp/cubit/notification_cubit.dart'; 
import 'package:eventsapp/repositories/user_repository.dart';
import 'package:eventsapp/screens/auth/splash_screen.dart';
import 'package:eventsapp/screens/home/home_page.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'cache/cache_helper.dart';
import 'core/services/deep_link_service.dart'; 
import 'core/api/end_ponits.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; 
import 'firebase_options.dart'; 
import 'core/services/notification_service.dart';

// تعريف مفتاح عام للتحكم بالتنقل من خارج شجرة الـ Widgets
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  // ضمان تهيئة الـ Widgets الخاصة بفلاتر أولاً
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة كلاس الكاش محلياً ليصبح جاهزاً لحفظ البيانات والتوكنات
  await CacheHelper().init();
  
  // تهيئة الفايربيز بناءً على منصة التشغيل (Android / iOS)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // [إجباري لأندرويد 13 فما فوق] طلب إذن الإشعارات من المستخدم فور تشغيل التطبيق
  try {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('User granted notification permission: ${settings.authorizationStatus}');
  } catch (e) {
    print("Error requesting notification permission: $e");
  }
  
  // تشغيل خدمة الإشعارات المركزية وجلب الـ Token الأصلي للجهاز
  NotificationService notificationService = NotificationService();
  await notificationService.initialize();

  // [الـ Auto-Login الذكي] جلب التوكن المحفوظ وفحص الوجهة المناسبة
  final String? savedToken = CacheHelper().getData(key: ApiKey.token);
  print("🚀 هل يوجد توكن في الكاش؟: $savedToken");
  
  Widget initialScreen;
  bool shouldUploadTokenImmediately = false; // 🌟 متغير سحري لفحص حالة الإرسال الفوري للسيرفر

  if (savedToken != null && savedToken.isNotEmpty) {
    initialScreen = const HomePage(); // الانتقال المباشر للهوم بيج
    shouldUploadTokenImmediately = true; // 🌟 نعم، المستخدم مسجل مسبقاً ولديه صلاحية، نرفع التوكن فوراً
  } else {
    initialScreen = const SplashScreen(); // البدء من السبلش سكرين
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // إنشاء نسخة من خدمة الديب لينك وتمرير الـ navigatorKey بداخلها
  try {
    final deepLinkService = DeepLinkService(navigatorKey);
    await deepLinkService.init();
  } catch (e) {
    print("Deep link initialization error: $e");
  }

  // تمرير الشاشة الابتدائية والشرط الجديد للتطبيق الرئيسي
  runApp(RoyalEventsApp(
    startScreen: initialScreen,
    uploadTokenAtStart: shouldUploadTokenImmediately, // 👈 تمرير المتغير الجديد
  ));
}

class RoyalEventsApp extends StatelessWidget {
  final Widget startScreen;
  final bool uploadTokenAtStart; // 👈 استقبال متغير حالة رفع التوكن

  const RoyalEventsApp({
    super.key, 
    required this.startScreen,
    required this.uploadTokenAtStart, // 👈 تهيئة المتغير
  });

  @override
  Widget build(BuildContext context) {
    final dioConsumer = DioConsumer(dio: Dio());

    return MultiBlocProvider(
      providers: [
        // 1️⃣ الـ UserCubit يستخدم النسخة المركزية للـ API
        BlocProvider(
          create: (context) => UserCubit(UserRepository(api: dioConsumer)),
        ),
        
        // 2️⃣ الـ AuthCubit يستقبل الـ DioConsumer والـ CacheHelper الموحدين
        BlocProvider(
          create: (context) => AuthCubit(dioConsumer, CacheHelper()),
        ),

        // 🌟 3️⃣ [إنشاء الـ NotificationCubit والتحقق من الـ Auto-Login]
        BlocProvider(
          create: (context) {
            final cubit = NotificationCubit(dioConsumer);
            // إذا كان المستخدم داخل التطبيق مسبقاً، نحدّث التوكن في الباكيند صامتاً عند الإقلاع
            if (uploadTokenAtStart) {
              cubit.uploadDeviceToken();
            }
            return cubit;
          },
        ),

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
                home: startScreen, 
              );
            },
          );
        },
      ),
    );
  }
}
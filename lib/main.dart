import 'package:flutter/material.dart';
import 'package:proto_hair/pages/login_screen.dart';
import 'package:proto_hair/pages/splash_screen.dart';
import 'package:proto_hair/theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSplashScreen = true;

  void _finishSplash() {
    setState(() {
      _showSplashScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AR Hair Color',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        textTheme: TextTheme(
          headlineLarge: AppTextStyles.h1,
          headlineMedium: AppTextStyles.h2,
          headlineSmall: AppTextStyles.h3,
          titleLarge: AppTextStyles.h4,
          bodyLarge: AppTextStyles.p,
          bodyMedium: AppTextStyles.p,
          labelLarge: AppTextStyles.buttonPrimary,
        ),
        fontFamily: 'Inter',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.primaryForeground,
            textStyle: AppTextStyles.buttonPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.buttonSecondary,
        )),
      ),
      home: _showSplashScreen
          ? SplashScreen(onFinish: _finishSplash)
          : const LoginScreen(),
    );
  }
}
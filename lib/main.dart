// import 'package:flutter/material.dart';
// import 'package:proto_hair/pages/login_screen.dart';
// import 'package:proto_hair/pages/splash_screen.dart';
// import 'package:proto_hair/theme/app_theme.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   bool _showSplashScreen = true;
//
//   // Callback function yang akan dipanggil oleh SplashScreen saat selesai
//   void _finishSplash() {
//     setState(() {
//       _showSplashScreen = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'AR Hair Color',
//       debugShowCheckedModeBanner: false,
//
//       // --- Terapkan Tema Global Anda ---
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: AppColors.background,
//         primaryColor: AppColors.primary,
//
//         // Atur style teks default dari app_theme.dart
//         textTheme: TextTheme(
//           headlineLarge: AppTextStyles.h1,
//           headlineMedium: AppTextStyles.h2,
//           headlineSmall: AppTextStyles.h3,
//           titleLarge: AppTextStyles.h4, // Mungkin perlu dicek penggunaannya
//           bodyLarge: AppTextStyles.p,
//           bodyMedium: AppTextStyles.p,
//           labelLarge: AppTextStyles.buttonPrimary, // ⬇️ PERBAIKAN DI SINI
//         ),
//
//         // Atur font default (jika Anda menambahkannya)
//         fontFamily: 'Inter', // Ganti 'Inter' jika Anda pakai font kustom
//
//         // Styling tambahan untuk widget spesifik bisa ditambahkan di sini
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.primary,
//             foregroundColor: AppColors.primaryForeground,
//             textStyle: AppTextStyles.buttonPrimary,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(24), // Default rounded-full
//             ),
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//           ),
//         ),
//          textButtonTheme: TextButtonThemeData(
//           style: TextButton.styleFrom(
//             foregroundColor: AppColors.primary,
//              textStyle: AppTextStyles.buttonSecondary,
//           )
//          )
//       ),
//
//       // --- Logika Tampilan Halaman ---
//       home: _showSplashScreen
//           ? SplashScreen(onFinish: _finishSplash)
//           : const LoginScreen(),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const HairARApp());

class HairARApp extends StatelessWidget {
  const HairARApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HairColorPage(),
    );
  }
}

class HairColorPage extends StatefulWidget {
  @override
  State<HairColorPage> createState() => _HairColorPageState();
}

class _HairColorPageState extends State<HairColorPage> {
  static const platform = MethodChannel('deepar_channel');

  Future<void> _startAR() async {
    await platform.invokeMethod('startAR');
  }

  Future<void> _changeHairColor(String color) async {
    await platform.invokeMethod('changeHairColor', {"color": color});
  }

  @override
  void initState() {
    super.initState();
    _startAR();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hair Recolor Prototype')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: const Text(
                'Kamera AR di sini',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _colorButton(Colors.red, 'red'),
                _colorButton(Colors.brown, 'brown'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorButton(Color c, String name) {
    return GestureDetector(
      onTap: () => _changeHairColor(name),
      child: CircleAvatar(backgroundColor: c, radius: 25),
    );
  }
}

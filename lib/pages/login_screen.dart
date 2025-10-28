import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:proto_hair/pages/home_screen.dart';
import 'package:proto_hair/pages/register_screen.dart';
import 'package:proto_hair/widgets/auth_text_field.dart';
import 'package:proto_hair/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // State
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  // Hapus warna brand karena sudah ada di tema
  // static const Color _brandColor = Color(0xFFFF6B35); <-- DIHAPUS
  static const Color _gradientStart = Color(0xFF1C2526); // Tetap untuk gradient spesifik

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- Navigasi ---
  void _onLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _onNavigateToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_gradientStart, Colors.black], // Gradient tetap
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // --- Header ---
              Padding(
                padding: const EdgeInsets.only(
                    top: 80, bottom: 32, left: 24, right: 24),
                child: Column(
                  children: [
                    Text(
                      'Welcome Back',
                      // Gunakan style tema, override warna putih terang
                      style: AppTextStyles.h1.copyWith(color: AppColors.foreground),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Login to continue',
                       // Gunakan style tema, override warna muted foreground
                      style: AppTextStyles.p.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),

              // --- Login Form ---
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Email
                      AuthTextField(
                        label: 'Email',
                        hintText: 'your@email.com',
                        controller: _emailController,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      AuthTextField(
                        label: 'Password',
                        hintText: 'Enter your password',
                        controller: _passwordController,
                        isPassword: true,
                        obscureText: !_showPassword,
                        onToggleObscure: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            // Style diambil dari TextButtonTheme di main.dart
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _onLogin,
                          // Style diambil dari ElevatedButtonTheme di main.dart
                          child: const Text('Login'), // Text style diambil dari ElevatedButtonTheme
                        ),
                      ),

                      // Register Link
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 24, bottom: 16),
                        child: RichText(
                          text: TextSpan(
                            style: AppTextStyles.small.copyWith( // Gunakan style small
                              color: AppColors.mutedForeground,
                            ),
                            children: [
                              const TextSpan(text: "Don't have an account? "),
                              TextSpan(
                                text: 'Register',
                                style: TextStyle(color: AppColors.primary), // Warna oranye
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _onNavigateToRegister,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- Footer ---
              Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'By continuing, you agree to our Terms & Privacy Policy',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.small.copyWith( // Gunakan style small
                     color: AppColors.mutedForeground.withOpacity(0.7), // Lebih redup lagi
                     fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
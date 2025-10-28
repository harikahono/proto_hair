import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:proto_hair/pages/home_screen.dart';
import 'package:proto_hair/widgets/auth_text_field.dart';
import 'package:proto_hair/theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  static const Color _gradientStart = Color(0xFF1C2526);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _onNavigateToLogin() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_gradientStart, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 64, bottom: 24, left: 24, right: 24),
                child: Column(
                  children: [
                    Text(
                      'Create Account',
                      style: AppTextStyles.h1.copyWith(color: AppColors.foreground),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Join us today',
                      style: AppTextStyles.p.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      AuthTextField(
                        label: 'Full Name',
                        hintText: 'Your name',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        label: 'Email',
                        hintText: 'your@email.com',
                        controller: _emailController,
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        label: 'Password',
                        hintText: 'Create a password',
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
                      AuthTextField(
                        label: 'Confirm Password',
                        hintText: 'Confirm your password',
                        controller: _confirmPasswordController,
                        isPassword: true,
                        obscureText: !_showConfirmPassword,
                        onToggleObscure: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _onRegister,
                          child: const Text('Register'),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 24, bottom: 16),
                        child: RichText(
                          text: TextSpan(
                             style: AppTextStyles.small.copyWith(
                              color: AppColors.mutedForeground,
                            ),
                            children: [
                              const TextSpan(
                                  text: "Already have an account? "),
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(color: AppColors.primary),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _onNavigateToLogin,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'By continuing, you agree to our Terms & Privacy Policy',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.small.copyWith(
                     // ⬇️ PERBAIKAN: withAlpha(179)
                     color: AppColors.mutedForeground.withAlpha(179), // opacity 0.7
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
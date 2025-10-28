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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  static const Color _gradientStart = Color(0xFF1C2526);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                    top: 80, bottom: 32, left: 24, right: 24),
                child: Column(
                  children: [
                    Text(
                      'Welcome Back',
                      style: AppTextStyles.h1.copyWith(color: AppColors.foreground),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Login to continue',
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
                        label: 'Email',
                        hintText: 'your@email.com',
                        controller: _emailController,
                      ),
                      const SizedBox(height: 16),
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _onLogin,
                          child: const Text('Login'),
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
                              const TextSpan(text: "Don't have an account? "),
                              TextSpan(
                                text: 'Register',
                                style: TextStyle(color: AppColors.primary),
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
              Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'By continuing, you agree to our Terms & Privacy Policy',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.small.copyWith(
                     color: AppColors.mutedForeground.withAlpha(179),
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
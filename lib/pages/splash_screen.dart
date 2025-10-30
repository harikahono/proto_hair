import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:proto_hair/theme/app_theme.dart'; // Import theme Anda

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const SplashScreen({
    super.key,
    required this.onFinish,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool _isAnimating = true;

  // Controller untuk animasi 'bounce' (Logo)
  late final AnimationController _bounceController;
  late final Animation<Offset> _bounceAnimation;

  // --- PERBAIKAN: Controller untuk animasi 'pulse' (Dots) ---
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim1;
  late final Animation<double> _pulseAnim2;
  late final Animation<double> _pulseAnim3;
  // --- AKHIR PERBAIKAN ---

  // Warna kustom dari TSX
  static const Color _brandColor = Color(0xFFFF6B35);
  static const Color _gradientStart = Color(0xFF1C2526);

  @override
  void initState() {
    super.initState();

    // Setup Animasi Bounce
    _bounceController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.15), // Seberapa tinggi pantulannya
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));

    // --- PERBAIKAN: Setup Animasi Pulse ---
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    // Bikin animasi pulse (fade in/out) yang di-stagger
    _pulseAnim1 = _createPulseAnimation(0.0, 0.6);
    _pulseAnim2 = _createPulseAnimation(0.2, 0.8);
    _pulseAnim3 = _createPulseAnimation(0.4, 1.0);
    // --- AKHIR PERBAIKAN ---

    // --- Logika Timer dari useEffect ---
    // Start fade out setelah 2 detik
    Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _isAnimating = false;
        });
      }
    });

    // Selesaikan splash screen setelah 2.5 detik (fade 0.5s)
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        widget.onFinish();
      }
    });
  }

  // --- PERBAIKAN: Helper untuk bikin sequence pulse (fade in/out) ---
  Animation<double> _createPulseAnimation(double begin, double end) {
    return TweenSequence<double>([
      // Fade In
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
      // Fade Out
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Interval(begin, end, curve: Curves.linear),
    ));
  }
  // --- AKHIR PERBAIKAN ---

  @override
  void dispose() {
    _bounceController.dispose();
    _pulseController.dispose(); // <-- PERBAIKAN: Jangan lupa dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      // Transisi opacity berdasarkan state _isAnimating
      opacity: _isAnimating ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          // bg-gradient-to-br from-[#1C2526] to-black
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_gradientStart, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // --- Konten Utama (Logo & Teks) ---
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --- Logo Animation ---
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: SlideTransition(
                        position: _bounceAnimation,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Glow Effect
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _brandColor.withAlpha(128),
                                    blurRadius: 24.0, // blur-xl
                                  ),
                                ],
                              ),
                            ),
                            // Logo Container
                            Container(
                              width: 96,
                              height: 96,
                              decoration: const BoxDecoration(
                                color: _brandColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  LucideIcons.sparkles,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0), // px-8
                      child: Column(
                        children: [
                          Text(
                            'AR Hair Color',
                            style: AppTextStyles.h1
                                .copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 8), // mb-2
                          Text(
                            'Try Before You Dye',
                            style: AppTextStyles.p.copyWith(
                              color: Colors.white.withAlpha(204),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --- PERBAIKAN: Terapkan animasi ke dots ---
                    _buildLoadingDot(animation: _pulseAnim1),
                    const SizedBox(width: 8),
                    _buildLoadingDot(animation: _pulseAnim2),
                    const SizedBox(width: 8),
                    _buildLoadingDot(animation: _pulseAnim3),
                    // --- AKHIR PERBAIKAN ---
                  ],
                ),
              ),

              // --- Version ---
              Positioned(
                bottom: 32,
                child: Text(
                  'v1.0 Prototype',
                  style: TextStyle(
                    color: Colors.white.withAlpha(153),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingDot({required Animation<double> animation}) {
    return FadeTransition(
      opacity: animation,
      child: Container(
        width: 8, // w-2
        height: 8, // h-2
        decoration: const BoxDecoration(
          color: _brandColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
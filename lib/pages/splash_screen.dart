import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:proto_hair/theme/app_theme.dart'; // Import theme Anda

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish;

  // ⬇️ PERBAIKAN LINTER: use_super_parameters
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

  // Controller untuk animasi 'bounce'
  late final AnimationController _bounceController;
  late final Animation<Offset> _bounceAnimation;

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

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ⬇️ PERBAIKAN LINTER: Hapus 'screenSize' yang tidak terpakai

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
              // flex flex-col items-center justify-center
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --- Logo Animation ---
                    Padding(
                      // mb-8 (margin-bottom: 2rem = 32px)
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: SlideTransition(
                        position: _bounceAnimation,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Glow Effect (disederhanakan pakai BoxShadow)
                            Container(
                              width: 96, // w-24
                              height: 96, // h-24
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    // ⬇️ PERBAIKAN LINTER: withAlpha(128)
                                    color: _brandColor.withAlpha(128),
                                    blurRadius: 24.0, // blur-xl
                                  ),
                                ],
                              ),
                            ),
                            // Logo Container
                            Container(
                              width: 96, // w-24
                              height: 96, // h-24
                              decoration: const BoxDecoration(
                                color: _brandColor, // bg-[#FF6B35]
                                shape: BoxShape.circle, // rounded-full
                              ),
                              // flex items-center justify-center
                              child: const Center(
                                child: Icon(
                                  LucideIcons.sparkles, // <Sparkles />
                                  size: 48, // w-12 h-12
                                  color: Colors.white, // text-white
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- App Name ---
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0), // px-8
                      child: Column(
                        children: [
                          Text(
                            'AR Hair Color',
                            // Ambil style h1 dari Theme
                            style: AppTextStyles.h1
                                .copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 8), // mb-2
                          Text(
                            'Try Before You Dye',
                            // Ambil style p dari Theme
                            style: AppTextStyles.p.copyWith(
                              // ⬇️ PERBAIKAN LINTER: withAlpha(204)
                              color: Colors.white.withAlpha(204),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // --- Loading Indicator ---
              Positioned(
                // absolute bottom-20
                bottom: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // flex gap-2
                  children: [
                    _buildLoadingDot(),
                    const SizedBox(width: 8),
                    _buildLoadingDot(),
                    const SizedBox(width: 8),
                    _buildLoadingDot(),
                  ],
                ),
              ),

              // --- Version ---
              Positioned(
                // absolute bottom-8
                bottom: 32,
                child: Text(
                  'v1.0 Prototype',
                  style: TextStyle(
                    // ⬇️ PERBAIKAN LINTER: withAlpha(153)
                    color: Colors.white.withAlpha(153),
                    fontSize: 14, // text-sm
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk loading dot
  // TODO: Terapkan 'animate-pulse' dengan AnimationController
  Widget _buildLoadingDot() {
    return Container(
      width: 8, // w-2
      height: 8, // h-2
      decoration: const BoxDecoration(
        color: _brandColor, // bg-[#FF6B35]
        shape: BoxShape.circle, // rounded-full
      ),
    );
  }
}
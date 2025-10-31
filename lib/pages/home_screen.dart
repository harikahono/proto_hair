import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:proto_hair/models.dart';
import 'package:proto_hair/pages/ar_camera_screen.dart';
import 'package:proto_hair/pages/before_after_screen.dart';
import 'package:proto_hair/pages/gallery_screen.dart';
import 'package:proto_hair/theme/app_theme.dart';
import 'package:uuid/uuid.dart';
import 'package:proto_hair/pages/hair_color_info_screen.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final List<SavedImage> _savedImages = [];
  HairColor _selectedColor = kHairColors.first;
  SavedImage? _capturedImage;
  final _uuid = Uuid();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onShareImage(SavedImage image) {
    Share.shareXFiles(
      [XFile(image.afterImage)],
      text: 'Cek warna rambut baru gue! Dibuat pake AR Hair Color app.',
    );
  }

  void _onNavigateToCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ARCameraScreen(
          selectedColor: _selectedColor,
          hasCapturedImage: _capturedImage != null,
          onBack: () => Navigator.pop(context),
          onColorSelect: (color) {
            setState(() {
              _selectedColor = color;
            });
          },
          onCapture: (before, after) {
            final newImage = SavedImage(
              id: _uuid.v4(),
              beforeImage: before,
              afterImage: after,
              colorUsed: _selectedColor,
              timestamp: DateTime.now(),
            );
            setState(() {
              _capturedImage = newImage;
            });
          },
          onOpenGallery: _onNavigateToGallery,
          onOpenBeforeAfter: () {
            if (_capturedImage != null) {
              _onNavigateToBeforeAfter(_capturedImage!);
            }
          },
        ),
      ),
    );
  }

  void _onNavigateToGallery() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryScreen(
          images: _savedImages,
          onBack: () => Navigator.pop(context),
          onShare: (image) {
            _onShareImage(image);
          },
          onDelete: (id) {
            setState(() {
              _savedImages.removeWhere((img) => img.id == id);
            });
          },
        ),
      ),
    );
  }

  void _onNavigateToBeforeAfter(SavedImage image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BeforeAfterScreen(
          image: image,
          onBack: () => Navigator.pop(context),
          onSave: () {
            setState(() {
              if (!_savedImages.any((img) => img.id == image.id)) {
                _savedImages.add(image);
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Disimpan ke galeri!'),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
          onShare: () {
            _onShareImage(image);
          },
        ),
      ),
    );
  }

  void _onNavigateToInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HairColorInfoScreen(
          onBack: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int savedImagesCount = _savedImages.length;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.background,
              AppColors.background.withValues(alpha: 0.95),
              Colors.black,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.only(
                      top: 48, bottom: 24, left: 24, right: 24),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.sparkles,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'AR Hair Color',
                        style: AppTextStyles.h1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try Before You Dye',
                        style: AppTextStyles.p.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Menu Cards
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _MenuCardButton(
                          title: 'Try AR Camera',
                          subtitle: 'Coba warna rambut dengan AR real-time',
                          icon: LucideIcons.camera,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          onPressed: _onNavigateToCamera,
                          isPrimary: true,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _CompactMenuCard(
                                title: 'My Gallery',
                                icon: LucideIcons.grid3x3,
                                badgeCount: savedImagesCount,
                                onPressed: _onNavigateToGallery,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _CompactMenuCard(
                                title: 'Color Info',
                                icon: LucideIcons.info,
                                onPressed: _onNavigateToInfo,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Footer
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'v1.0 Prototype',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuCardButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _MenuCardButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isPrimary
                ? AppColors.primary.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.2),
            blurRadius: isPrimary ? 24 : 16,
            spreadRadius: isPrimary ? 2 : 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration( // <-- Perubahan di sini
              color: AppColors.card, // <-- Ganti Colors.white menjadi AppColors.card
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.cardForeground, // <-- Ini seharusnya sekarang kontras
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: AppTextStyles.p.copyWith(
                          color: AppColors.mutedForeground, // <-- Ini seharusnya sekarang kontras
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  color: AppColors.mutedForeground, // <-- Ini seharusnya sekarang kontras
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompactMenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final int badgeCount;

  const _CompactMenuCard({
    required this.title,
    required this.icon,
    required this.onPressed,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration( // <-- Perubahan di sini
              color: AppColors.card, // <-- Ganti Colors.white menjadi AppColors.card
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 28,
                        color: AppColors.cardForeground, // <-- Ini sekarang akan kontras
                      ),
                    ),
                    if (badgeCount > 0)
                      Positioned(
                        top: -6,
                        right: -6,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            badgeCount > 9 ? '9+' : '$badgeCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: AppTextStyles.p.copyWith(
                    color: AppColors.cardForeground, // <-- Ini sekarang akan kontras
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
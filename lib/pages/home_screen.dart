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

class _HomeScreenState extends State<HomeScreen> {
  final List<SavedImage> _savedImages = [];
  HairColor _selectedColor = kHairColors.first;
  SavedImage? _capturedImage;
  final _uuid = Uuid();

  static const Color _brandColor = Color(0xFFFF6B35);
  static const Color _gradientStart = Color(0xFF1C2526);
  static const Color _cardIconBgDark = Color(0xFF1C2526);

  void _onShareImage(SavedImage image) {
    // Kita share file 'afterImage'-nya
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
                content: Text('Disimpan ke galeri!'),
                backgroundColor: _brandColor,
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
                    top: 64, bottom: 32, left: 24, right: 24),
                child: Column(
                  children: [
                    Text(
                      'AR Hair Color',
                      style: AppTextStyles.h1.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try Before You Dye',
                      style: AppTextStyles.p.copyWith(
                        color: Colors.white.withAlpha(204),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _MenuCardButton(
                        title: 'Try AR Camera',
                        subtitle: 'Coba warna rambut dengan AR real-time',
                        icon: LucideIcons.camera,
                        iconBgColor: _brandColor,
                        onPressed: _onNavigateToCamera,
                      ),
                      const SizedBox(height: 16),
                      _MenuCardButton(
                        title: 'My Gallery',
                        subtitle: savedImagesCount > 0
                            ? '$savedImagesCount foto tersimpan'
                            : 'Lihat foto yang kamu simpan',
                        icon: LucideIcons.grid3x3,
                        iconBgColor: _cardIconBgDark,
                        badgeCount: savedImagesCount,
                        onPressed: _onNavigateToGallery,
                      ),
                      const SizedBox(height: 16),
                      _MenuCardButton(
                        title: 'Hair Color Info',
                        subtitle: 'Pelajari tentang warna rambut',
                        icon: LucideIcons.info,
                        iconBgColor: const Color(0xFF4B5563),
                        onPressed: _onNavigateToInfo,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32),
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
}

class _MenuCardButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBgColor;
  final VoidCallback onPressed;
  final int badgeCount;

  const _MenuCardButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBgColor,
    required this.onPressed,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 8,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: iconBgColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(64),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6B35),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$badgeCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h3.copyWith(
                    color: const Color(0xFF1C2526),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.p.copyWith(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
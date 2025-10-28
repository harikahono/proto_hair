import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:proto_hair/models.dart';

class BeforeAfterScreen extends StatefulWidget {
  final SavedImage image;
  final VoidCallback onBack;
  final VoidCallback onSave;
  final VoidCallback onShare;

  const BeforeAfterScreen({
    super.key,
    required this.image,
    required this.onBack,
    required this.onSave,
    required this.onShare,
  });

  @override
  State<BeforeAfterScreen> createState() => _BeforeAfterScreenState();
}

class _BeforeAfterScreenState extends State<BeforeAfterScreen> {
  // sliderPosition adalah 0.0 - 1.0 (bukan 0-100)
  double _sliderPosition = 0.5;

  static const Color _brandColor = Color(0xFFFF6B35);
  static const Color _bgColor = Color(0xFF1C2526);

  // ⬇️ PERBAIKAN 'GestureDetector'
  void _handlePanStart(DragStartDetails details) {
    // Dapatkan posisi X lokal di dalam box
    final RenderBox box = context.findRenderObject() as RenderBox;
    final newPosition = box.globalToLocal(details.globalPosition).dx / box.size.width;
    setState(() {
      _sliderPosition = newPosition.clamp(0.0, 1.0);
    });
  }
  
  void _handlePanUpdate(DragUpdateDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final newPosition = box.globalToLocal(details.globalPosition).dx / box.size.width;
    setState(() {
      _sliderPosition = newPosition.clamp(0.0, 1.0);
    });
  }
  // ⬆️ AKHIR PERBAIKAN 'GestureDetector'

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // --- Before-After Comparison ---
          GestureDetector(
            // ⬇️ PERBAIKAN 'GestureDetector'
            onPanStart: _handlePanStart,
            onPanUpdate: _handlePanUpdate,
            // ⬆️ AKHIR PERBAIKAN 'GestureDetector'
            child: Stack(
              children: [
                // 1. After Image (Full)
                _buildImage(widget.image.afterImage),

                // 2. After Label
                Positioned(
                  top: 100,
                  right: 16,
                  child: _buildLabelChip('After'),
                ),

                // 3. Before Image (Clipped)
                ClipPath(
                  clipper: _ImageClipper(clipPercentage: _sliderPosition),
                  child: _buildImage(widget.image.beforeImage),
                ),

                // 4. Before Label
                Positioned(
                  top: 100,
                  left: 16,
                  child: _buildLabelChip('Before'),
                ),
              ],
            ),
          ),

          // --- Slider Line & Handle ---
          Positioned(
            left: (screenSize.width * _sliderPosition) - 2, // -2 untuk menengahkan
            child: Container(
              width: 4, // w-1
              height: screenSize.height,
              color: Colors.white,
              child: Center(
                // Handle
                child: Container(
                  width: 48, // w-12
                  height: 48, // h-12
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 2, height: 24, color: _bgColor),
                        const SizedBox(width: 4),
                        Container(width: 2, height: 24, color: _bgColor),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // --- Top Bar ---
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(LucideIcons.arrowLeft,
                          color: Colors.white, size: 28),
                      onPressed: widget.onBack,
                    ),
                    _buildBlurButton(
                      icon: LucideIcons.share2,
                      onPressed: widget.onShare,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- Bottom Controls ---
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildLabelChip('Warna: ${widget.image.colorUsed.name}'),
                    const SizedBox(height: 16),
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 48, // h-12
                      child: ElevatedButton.icon(
                        onPressed: widget.onSave,
                        icon: const Icon(LucideIcons.download, size: 20),
                        label: const Text('Save to Gallery'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _brandColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk image
  Widget _buildImage(String url) {
    // ⬇️ PERBAIKAN 'blendMode'
    return Image.network(
      url,
      fit: BoxFit.cover,
      color: widget.image.colorUsed.color.withAlpha(76), // opacity-30
      colorBlendMode: BlendMode.multiply,
    );
  }

  // Helper untuk tombol blur
  Widget _buildBlurButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24), // rounded-full
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // backdrop-blur-md
        child: Container(
          width: 40, // w-10
          height: 40, // h-10
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(51), // bg-white bg-opacity-20
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 20), // w-5 h-5
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }

  // Helper untuk label chip
  Widget _buildLabelChip(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(128), // bg-black bg-opacity-50
          ),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }
}

// CustomClipper untuk slider
class _ImageClipper extends CustomClipper<Path> {
  final double clipPercentage; // 0.0 to 1.0

  _ImageClipper({required this.clipPercentage});

  @override
  Path getClip(Size size) {
    Path path = Path();
    // Path dari kiri atas ke kanan atas, lalu ke bawah, lalu ke kiri
    path.addRect(Rect.fromLTWH(
      0,
      0,
      size.width * clipPercentage, // Lebar klip
      size.height,
    ));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true; // Selalu reclip saat slider bergerak
  }
}
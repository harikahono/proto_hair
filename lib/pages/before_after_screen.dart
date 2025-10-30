import 'dart:io';
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
  double _sliderPosition = 0.5;

  static const Color _brandColor = Color(0xFFFF6B35);
  static const Color _bgColor = Color(0xFF1C2526);

  void _handlePanStart(DragStartDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final newPosition =
        box.globalToLocal(details.globalPosition).dx / box.size.width;
    setState(() {
      _sliderPosition = newPosition.clamp(0.0, 1.0);
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final newPosition =
        box.globalToLocal(details.globalPosition).dx / box.size.width;
    setState(() {
      _sliderPosition = newPosition.clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onPanStart: _handlePanStart,
            onPanUpdate: _handlePanUpdate,
            child: Stack(
              children: [
                _buildImage(widget.image.afterImage),
                Positioned(
                  top: 100,
                  right: 16,
                  child: _buildLabelChip('After'),
                ),
                ClipPath(
                  clipper: _ImageClipper(clipPercentage: _sliderPosition),
                  child: _buildImage(widget.image.beforeImage),
                ),
                Positioned(
                  top: 100,
                  left: 16,
                  child: _buildLabelChip('Before'),
                ),
              ],
            ),
          ),
          Positioned(
            left: (screenSize.width * _sliderPosition) - 2,
            child: Container(
              width: 4,
              height: screenSize.height,
              color: Colors.white,
              child: Center(
                child: Container(
                  width: 48,
                  height: 48,
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLabelChip('Warna: ${widget.image.colorUsed.name}'),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
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

  Widget _buildImage(String url) {
    return Image.file(
      File(url),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[900],
          child: const Center(
            child: Icon(Icons.broken_image, color: Colors.grey),
          ),
        );
      },
    );
  }

  Widget _buildBlurButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(51),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 20),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }

  Widget _buildLabelChip(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(128),
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

class _ImageClipper extends CustomClipper<Path> {
  final double clipPercentage;

  _ImageClipper({required this.clipPercentage});

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addRect(Rect.fromLTWH(
      0,
      0,
      size.width * clipPercentage,
      size.height,
    ));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
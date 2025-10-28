import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:proto_hair/models.dart';

class ARCameraScreen extends StatefulWidget {
  final HairColor selectedColor;
  final bool hasCapturedImage;
  final Function(HairColor color) onColorSelect;
  final Function(String beforeImage, String afterImage) onCapture;
  final VoidCallback onOpenGallery;
  final VoidCallback onOpenBeforeAfter;
  final VoidCallback onBack;

  const ARCameraScreen({
    super.key,
    required this.selectedColor,
    required this.onColorSelect,
    required this.onCapture,
    required this.onOpenGallery,
    required this.onOpenBeforeAfter,
    required this.hasCapturedImage,
    required this.onBack,
  });

  @override
  State<ARCameraScreen> createState() => _ARCameraScreenState();
}

class _ARCameraScreenState extends State<ARCameraScreen> {
  bool _isScanning = false;
  final String _localImagePath = "assets/images/zee-selfie.jpg";
  static const Color _brandColor = Color(0xFFFF6B35);
  static const Color _bgColor = Color(0xFF1C2526);

  void _handleCapture() {
    setState(() {
      _isScanning = true;
    });

    Timer(const Duration(seconds: 1), () {
      widget.onCapture(_localImagePath, _localImagePath);
      setState(() {
        _isScanning = false;
      });
      widget.onOpenBeforeAfter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        children: [
          // --- Camera View (Mock) ---
          Positioned.fill(
            child: Image.asset(
              _localImagePath,
              fit: BoxFit.cover,
              color: widget.selectedColor.color.withAlpha(51), // opacity-20
              colorBlendMode: BlendMode.multiply,
              errorBuilder: (context, error, stackTrace) {
                // Jangan gunakan print di production, tapi oke untuk debug
                // print("Error loading asset: $error");
                return Container(
                  color: Colors.red.withAlpha(77), // opacity 0.3
                  child: const Center(child: Text("Gagal load asset!\nCek path & pubspec.yaml", textAlign: TextAlign.center, style: TextStyle(color: Colors.white))),
                );
              },
            ),
          ),

          // --- Top Controls ---
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
                    _buildBlurButton(
                      icon: LucideIcons.arrowLeft,
                      onPressed: widget.onBack,
                    ),
                    Row(
                      children: [
                        _buildBlurButton(
                          icon: LucideIcons.grid3x3,
                          onPressed: widget.onOpenGallery,
                        ),
                        const SizedBox(width: 8),
                        _buildBlurButton(
                          icon: LucideIcons.gitCompare,
                          onPressed: widget.hasCapturedImage
                              ? widget.onOpenBeforeAfter
                              : null,
                          color: widget.hasCapturedImage
                              ? _brandColor.withAlpha(230) // opacity 0.9
                              : Colors.white.withAlpha(26), // opacity 0.1
                        ),
                      ],
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
              child: Column(
                children: [
                  _buildColorSelector(),
                  const SizedBox(height: 24),
                  _buildCaptureButton(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // --- Scanning Overlay ---
          if (_isScanning)
            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha(153), // opacity 0.6
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Scanning Hair...',
                        style: TextStyle(color: Colors.white, fontSize: 16),
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

  Widget _buildBlurButton({
    required IconData icon,
    required VoidCallback? onPressed,
    Color? color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color ?? Colors.white.withAlpha(51), // opacity 0.2
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 24),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }

  Widget _buildColorSelector() {
    return Container(
      height: 52,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(77), // opacity 0.3
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: Colors.white.withAlpha(102), // opacity 0.4
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: kHairColors.map((color) {
                      final isSelected = widget.selectedColor.id == color.id;
                      return TextButton(
                        onPressed: () => widget.onColorSelect(color),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          backgroundColor:
                              isSelected ? color.color : Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text(
                          color.name,
                          style: TextStyle(
                            color: Colors.white.withAlpha(isSelected ? 255 : 179), // opacity 0.7
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureButton() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51), // opacity 0.2
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: IconButton(
        icon: Icon(LucideIcons.camera, color: _bgColor, size: 32),
        onPressed: _handleCapture,
      ),
    );
  }
}
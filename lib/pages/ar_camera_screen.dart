import 'dart:async';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:proto_hair/models.dart';
import 'package:proto_hair/services/ai_service.dart';

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
  static const Color _brandColor = Color(0xFFFF6B35);
  static const Color _bgColor = Color(0xFF1C2526);

  CameraController? _controller;
  bool _isScreenReady = false;
  final AIService _aiService = AIService();

  // --- STATE LOKAL BUAT WARNA (FIX 'BOLD' BUG) ---
  late HairColor _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor; // Inisialisasi state lokal
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      final bool modelLoaded = await _aiService.loadModel();
      if (!modelLoaded && mounted) {
        debugPrint("Error: Model AI gagal di-load.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal memuat engine AI.")),
        );
        return;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        debugPrint("Error: No cameras available.");
        return;
      }

      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (!mounted) return;

      setState(() {
        _isScreenReady = true;
      });
    } catch (e) {
      debugPrint("Failed to initialize services: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _aiService.dispose();
    super.dispose();
  }

  void _handleCapture() async {
    if (!_isScreenReady || _controller?.value.isTakingPicture == true) {
      return;
    }

    setState(() {
      _isScanning = true;
    });

    try {
      final XFile originalImage = await _controller!.takePicture();

      // Pake state lokal _selectedColor
      final String processedImagePath = await _aiService.processImage(
        originalImage,
        _selectedColor.color,
      );

      if (!mounted) return;

      widget.onCapture(originalImage.path, processedImagePath);

      setState(() {
        _isScanning = false;
      });

      widget.onOpenBeforeAfter();
    } catch (e) {
      debugPrint("Error taking picture or processing: $e");
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isScreenReady) {
      return Scaffold(
        backgroundColor: _bgColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                "Loading camera & AI engine...",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    }

    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    final cameraRatio = _controller!.value.aspectRatio;
    final scale = 1 / (cameraRatio * deviceRatio);

    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.center,
              child: CameraPreview(_controller!),
            ),
          ),
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                _selectedColor.color.withAlpha(51), // Pake state lokal
                BlendMode.multiply,
              ),
              child: Container(
                color: Colors.transparent,
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
                              ? _brandColor.withAlpha(230)
                              : Colors.white.withAlpha(26),
                        ),
                      ],
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
          if (_isScanning)
            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha(153),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Processing Image...',
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
            color: color ?? Colors.white.withAlpha(51),
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
                    color: Colors.black.withAlpha(77),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: Colors.white.withAlpha(102),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: kHairColors.map((color) {
                      // Cek 'isSelected' pake state lokal
                      final isSelected = _selectedColor.id == color.id;
                      return TextButton(
                        onPressed: () {
                          // Update state lokal (buat UI)
                          setState(() {
                            _selectedColor = color;
                          });
                          // Update state parent (buat HomeScreen)
                          widget.onColorSelect(color);
                        },
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
                            color: Colors.white
                                .withAlpha(isSelected ? 255 : 179),
                            fontSize: 14,
                            // Terapin 'bold' berdasarkan state lokal
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
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
            color: Colors.black.withAlpha(51),
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
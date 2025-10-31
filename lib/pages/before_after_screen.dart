import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:proto_hair/models.dart';
import 'package:proto_hair/theme/app_theme.dart';

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

class _BeforeAfterScreenState extends State<BeforeAfterScreen> with SingleTickerProviderStateMixin {
  double _sliderPosition = 0.5;
  bool _showLabels = true;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Auto-hide labels after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showLabels = false);
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handlePanStart(DragStartDetails details) {
    setState(() => _showLabels = true);
    _updateSliderPosition(details.globalPosition);
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    _updateSliderPosition(details.globalPosition);
  }

  void _handlePanEnd(DragEndDetails details) {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showLabels = false);
      }
    });
  }

  void _updateSliderPosition(Offset globalPosition) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box != null) {
      final localPosition = box.globalToLocal(globalPosition);
      final newPosition = localPosition.dx / box.size.width;
      setState(() {
        _sliderPosition = newPosition.clamp(0.0, 1.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main comparison area
          Positioned.fill(
            child: GestureDetector(
              onPanStart: _handlePanStart,
              onPanUpdate: _handlePanUpdate,
              onPanEnd: _handlePanEnd,
              child: Stack(
                children: [
                  // After image (background)
                  _buildImage(widget.image.afterImage),
                  
                  // Before image (clipped)
                  ClipPath(
                    clipper: _ImageClipper(clipPercentage: _sliderPosition),
                    child: _buildImage(widget.image.beforeImage),
                  ),
                  
                  // Labels with fade animation
                  AnimatedOpacity(
                    opacity: _showLabels ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 80,
                          left: 20,
                          child: _buildLabelChip('Before', isLeft: true),
                        ),
                        Positioned(
                          top: 80,
                          right: 20,
                          child: _buildLabelChip('After', isLeft: false),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Slider line and handle
          Positioned(
            left: (screenSize.width * _sliderPosition) - 1.5,
            top: 0,
            bottom: 0,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.3),
                          Colors.white,
                          Colors.white,
                          Colors.white.withValues(alpha: 0.3),
                        ],
                        stops: const [0.0, 0.3, 0.7, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Slider handle (draggable circle)
          Positioned(
            left: (screenSize.width * _sliderPosition) - 28,
            top: (screenSize.height / 2) - 28,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) => Transform.scale(
                scale: _pulseAnimation.value,
                child: child,
              ),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.chevronLeft,
                        size: 16,
                        color: AppColors.background,
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        LucideIcons.chevronRight,
                        size: 16,
                        color: AppColors.background,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildIconButton(
                        icon: LucideIcons.arrowLeft,
                        onPressed: widget.onBack,
                      ),
                      _buildIconButton(
                        icon: LucideIcons.share2,
                        onPressed: widget.onShare,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Bottom bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Color info
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: widget.image.colorUsed.color,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.image.colorUsed.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Save button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: widget.onSave,
                          icon: const Icon(LucideIcons.download, size: 22),
                          label: const Text(
                            'Save to Gallery',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.primaryForeground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(27),
                            ),
                            elevation: 8,
                            shadowColor: AppColors.primary.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String url) {
    return SizedBox.expand(
      child: Image.file(
        File(url),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.card,
            child: Center(
              child: Icon(
                LucideIcons.imageOff,
                color: AppColors.mutedForeground,
                size: 48,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 24),
        onPressed: onPressed,
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _buildLabelChip(String text, {required bool isLeft}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLeft) ...[
            Icon(
              LucideIcons.arrowLeft,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          if (!isLeft) ...[
            const SizedBox(width: 6),
            Icon(
              LucideIcons.arrowRight,
              color: Colors.white,
              size: 16,
            ),
          ],
        ],
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
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:proto_hair/models.dart';
import 'package:proto_hair/theme/app_theme.dart';
import 'package:intl/intl.dart';

class GalleryScreen extends StatefulWidget {
  final List<SavedImage> images;
  final VoidCallback onBack;
  final Function(String id) onDelete;
  final Function(SavedImage image) onShare;

  const GalleryScreen({
    super.key,
    required this.images,
    required this.onBack,
    required this.onDelete,
    required this.onShare,
  });

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  SavedImage? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: widget.images.isEmpty
                    ? _buildEmptyState()
                    : _buildGalleryGrid(),
              ),
            ],
          ),
          if (_selectedImage != null) _buildModalView(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              IconButton(
                icon: Icon(LucideIcons.arrowLeft, color: AppColors.foreground),
                onPressed: widget.onBack,
              ),
              const SizedBox(width: 12),
              Text(
                'Galeri',
                style: AppTextStyles.h2.copyWith(color: AppColors.foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                // ⬇️ PERBAIKAN: withAlpha(128)
                color: AppColors.muted.withAlpha(128), // opacity 0.5
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.grid3x3,
                size: 48,
                color: AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Galeri kosong',
              style: AppTextStyles.p.copyWith(color: AppColors.foreground),
            ),
            const SizedBox(height: 8),
            Text(
              'Foto yang kamu simpan akan muncul di sini',
              textAlign: TextAlign.center,
              style: AppTextStyles.p.copyWith(
                color: AppColors.mutedForeground,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: widget.images.length,
      itemBuilder: (context, index) {
        final image = widget.images[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedImage = image;
              });
            },
            child: Container(
              color: AppColors.card,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    image.afterImage,
                    fit: BoxFit.cover,
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) return child;
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: frame != null ? child : Container(color: AppColors.card),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        Center(child: Icon(Icons.broken_image, color: AppColors.mutedForeground.withAlpha(179))), // opacity 0.7
                    color: image.colorUsed.color.withAlpha(77), // opacity 0.3
                    colorBlendMode: BlendMode.multiply,
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(128), // opacity 0.5
                          ),
                          child: Text(
                            image.colorUsed.name,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalView() {
    if (_selectedImage == null) return const SizedBox.shrink();
    final image = _selectedImage!;

    return Positioned.fill(
      child: Container(
        color: AppColors.background.withAlpha(230), // opacity 0.9
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBlurButton(
                      icon: LucideIcons.x,
                      onPressed: () {
                        setState(() {
                          _selectedImage = null;
                        });
                      },
                    ),
                    Row(
                      children: [
                        _buildBlurButton(
                          icon: LucideIcons.share2,
                          onPressed: () => widget.onShare(image),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(LucideIcons.trash2,
                                color: AppColors.primaryForeground, size: 20),
                            onPressed: () {
                              widget.onDelete(image.id);
                              setState(() {
                                _selectedImage = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: InteractiveViewer(
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        image.afterImage,
                        fit: BoxFit.contain,
                        color: image.colorUsed.color.withAlpha(77), // opacity 0.3
                        colorBlendMode: BlendMode.multiply,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: double.infinity,
                  color: AppColors.background.withAlpha(128), // opacity 0.5
                  padding: const EdgeInsets.all(16.0),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        Text(
                          'Warna: ${image.colorUsed.name}',
                          style: AppTextStyles.p.copyWith(
                              color: AppColors.foreground),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('d MMMM yyyy', 'id_ID')
                              .format(image.timestamp),
                          style: AppTextStyles.small.copyWith(
                              color: AppColors.mutedForeground.withAlpha(153)), // opacity 0.6
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlurButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.background.withAlpha(77), // opacity 0.3
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: AppColors.foreground, size: 20),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
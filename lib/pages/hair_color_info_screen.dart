import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:proto_hair/theme/app_theme.dart';
import 'package:proto_hair/pages/ar_camera_screen.dart';
import 'package:proto_hair/models.dart';

// --- DATA MODEL ---
class HairColorItem {
  final String id;
  final String name;
  final String category;
  final Color color;
  final String assetPath;

  const HairColorItem({
    required this.id,
    required this.name,
    required this.category,
    required this.color,
    required this.assetPath,
  });
}

// --- DATA ---
const List<HairColorItem> kHairColorGallery = [
  HairColorItem(
    id: 'golden_honey',
    name: 'Golden Honey',
    category: 'Blondes',
    color: Color(0xFFF5E050),
    assetPath: 'assets/images/golden.jpg',
  ),
  HairColorItem(
    id: 'deep_espresso',
    name: 'Deep Espresso',
    category: 'Brunettes',
    color: Color(0xFF5C4033),
    assetPath: 'assets/images/deep.jpg',
  ),
  HairColorItem(
    id: 'cherry_noir',
    name: 'Cherry Noir',
    category: 'Reds',
    color: Color(0xFFFF0000),
    assetPath: 'assets/images/cherry.jpg',
  ),
  HairColorItem(
    id: 'platinum_ice',
    name: 'Platinum Ice',
    category: 'Blondes',
    color: Color(0xFFA9A9A9),
    assetPath: 'assets/images/ice.jpg',
  ),
  HairColorItem(
    id: 'lavender_dream',
    name: 'Lavender Dream',
    category: 'Pastels',
    color: Color(0xFFB39DDB),
    assetPath: 'assets/images/lavender.jpeg',
  ),
  HairColorItem(
    id: 'electric_blue',
    name: 'Electric Blue',
    category: 'Vivids',
    color: Color(0xFF29B6F6),
    assetPath: 'assets/images/blue.jpg',
  ),
];

// --- WIDGET ---
class HairColorInfoScreen extends StatefulWidget {
  final VoidCallback onBack;

  const HairColorInfoScreen({
    super.key,
    required this.onBack,
  });

  @override
  State<HairColorInfoScreen> createState() => _HairColorInfoScreenState();
}

class _HairColorInfoScreenState extends State<HairColorInfoScreen> {
  String selectedCategory = 'All';
  Set<String> favoriteIds = {};
  String? selectedColorItemId;
  final List<String> categories = ['All', 'Favorites', 'Blondes', 'Brunettes', 'Reds', 'Blacks'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              _buildAppBar(context),
              _buildCategoryTabs(),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = _filteredItems[index];
                    return _buildColorCard(item);
                  },
                ),
              ),
            ],
          ),
          // ✨ Floating Buttons - muncul kalo udah pilih warna (kecuali di Favorites)
          if (selectedColorItemId != null && selectedCategory != 'Favorites')
            Positioned(
              right: 16,
              bottom: 24,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Info Button
                  FloatingActionButton(
                    heroTag: 'info_btn',
                    onPressed: () => _showColorInfo(
                      kHairColorGallery.firstWhere((i) => i.id == selectedColorItemId)
                    ),
                    backgroundColor: AppColors.card,
                    foregroundColor: AppColors.primary,
                    elevation: 8,
                    child: Icon(LucideIcons.info, size: 24),
                  ),
                  SizedBox(width: 12),
                  // Try On Button
                  FloatingActionButton.extended(
                    heroTag: 'tryon_btn',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ARCameraScreen(
                            selectedColor: kHairColors.first,
                            hasCapturedImage: false,
                            onBack: () => Navigator.pop(context),
                            onColorSelect: (color) {},
                            onCapture: (before, after) {},
                            onOpenGallery: () {},
                            onOpenBeforeAfter: () {},
                          ),
                        ),
                      );
                    },
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.primaryForeground,
                    elevation: 8,
                    icon: Icon(LucideIcons.camera, size: 20),
                    label: Text(
                      'Try ${kHairColorGallery.firstWhere((i) => i.id == selectedColorItemId).name}',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<HairColorItem> get _filteredItems {
    if (selectedCategory == 'All') {
      return kHairColorGallery;
    } else if (selectedCategory == 'Favorites') {
      return kHairColorGallery.where((item) => favoriteIds.contains(item.id)).toList();
    } else {
      return kHairColorGallery.where((item) => item.category == selectedCategory).toList();
    }
  }

  void _toggleFavorite(HairColorItem item) {
    setState(() {
      if (favoriteIds.contains(item.id)) {
        favoriteIds.remove(item.id);
      } else {
        favoriteIds.add(item.id);
      }
    });
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            AppColors.background.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(LucideIcons.arrowLeft, color: AppColors.foreground),
            onPressed: widget.onBack,
            splashRadius: 20,
          ),
          const Spacer(),
          Text(
            'Color Gallery',
            style: AppTextStyles.h2.copyWith(
              color: AppColors.foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(LucideIcons.search, color: AppColors.foreground),
            onPressed: () {},
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: categories.map((category) {
          final isSelected = selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(
                category,
                style: TextStyle(
                  color: isSelected ? AppColors.primaryForeground : AppColors.foreground,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.primary,
              checkmarkColor: AppColors.primaryForeground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onSelected: (bool selected) {
                setState(() {
                  selectedCategory = selected ? category : 'All';
                  // Reset selection kalo pindah kategori
                  if (selectedCategory == 'Favorites') {
                    selectedColorItemId = null;
                  }
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  // Fungsi untuk show info detail
  void _showColorInfo(HairColorItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header dengan gambar
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      item.color.withValues(alpha: 0.3),
                      item.color.withValues(alpha: 0.6),
                    ],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    item.assetPath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(LucideIcons.palette, size: 64, color: item.color),
                    ),
                  ),
                ),
              ),
            ),
            // Info detail
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: item.color,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border, width: 2),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: AppTextStyles.h2.copyWith(
                                  color: AppColors.cardForeground,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                item.category,
                                style: AppTextStyles.p.copyWith(
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Favorite button di info dialog
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.card.withValues(alpha: 0.7),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              LucideIcons.heart,
                              color: favoriteIds.contains(item.id) ? Colors.red : AppColors.mutedForeground,
                              size: 20,
                            ),
                            onPressed: () => _toggleFavorite(item),
                            splashRadius: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    _buildInfoSection('Description', 
                      'A beautiful ${item.name.toLowerCase()} shade perfect for any occasion. This color brings out natural warmth and complements various skin tones.'),
                    SizedBox(height: 16),
                    _buildInfoSection('Best For', 
                      'Warm to neutral skin tones. Works great for both natural and bold looks.'),
                    SizedBox(height: 16),
                    _buildInfoSection('Maintenance', 
                      'Requires color-safe shampoo and regular touch-ups every 4-6 weeks.'),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          if (selectedCategory != 'Favorites') {
                            setState(() {
                              selectedColorItemId = item.id;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.primaryForeground,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(LucideIcons.camera),
                        label: Text('Try This Color', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.h3.copyWith(
            color: AppColors.cardForeground,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: AppTextStyles.p.copyWith(
            color: AppColors.mutedForeground,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildColorCard(HairColorItem item) {
    final isFavorite = favoriteIds.contains(item.id);
    final isSelected = selectedCategory != 'Favorites' && selectedColorItemId == item.id;
    
    return GestureDetector(
      onTap: () {
        if (selectedCategory != 'Favorites') {
          // Mode normal: pilih untuk try on
          setState(() {
            selectedColorItemId = isSelected ? null : item.id;
          });
        } else {
          // Mode favorites: langsung buka info
          _showColorInfo(item);
        }
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected 
                    ? AppColors.primary 
                    : AppColors.border.withValues(alpha: 0.3),
                width: isSelected ? 3 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: isSelected ? 12 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Image dengan Expanded biar auto-crop
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            item.color.withValues(alpha: 0.3),
                            item.color.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                      child: Image.asset(
                        item.assetPath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.palette,
                                size: 48,
                                color: item.color,
                              ),
                              SizedBox(height: 8),
                              Text(
                                item.name,
                                style: TextStyle(
                                  color: item.color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.cardForeground,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.category,
                        style: AppTextStyles.p.copyWith(
                          color: AppColors.mutedForeground,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Checkmark kalo selected
          if (isSelected)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.check,
                  color: AppColors.primaryForeground,
                  size: 20,
                ),
              ),
            ),
          // Heart button di kiri atas
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.card.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  LucideIcons.heart,
                  color: isFavorite ? Colors.red : AppColors.mutedForeground,
                  size: 20,
                ),
                onPressed: () => _toggleFavorite(item),
                splashRadius: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
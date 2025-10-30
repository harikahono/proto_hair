import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:proto_hair/theme/app_theme.dart';

// --- DATA MODEL & DATA ---
class HairInfo {
  final String id;
  final String name;
  final Color color;
  final String description;
  final String skinTones;
  final String maintenance;
  final String tips;

  const HairInfo({
    required this.id,
    required this.name,
    required this.color,
    required this.description,
    required this.skinTones,
    required this.maintenance,
    required this.tips,
  });
}

const List<HairInfo> kHairColorInfo = [
  HairInfo(
      id: 'blonde',
      name: 'Pirang',
      color: Color(0xFFF5E050),
      description: 'Warna terang yang memberikan kesan fresh dan youthful',
      skinTones: 'Cocok untuk kulit cerah hingga medium',
      maintenance: 'Membutuhkan perawatan ekstra untuk menjaga warna',
      tips: 'Gunakan shampoo khusus rambut pirang untuk mencegah warna kuning'),
  HairInfo(
      id: 'brown',
      name: 'Coklat',
      color: Color(0xFF5C4033),
      description: 'Warna natural yang versatile dan mudah dipadukan',
      skinTones: 'Cocok untuk semua warna kulit',
      maintenance: 'Perawatan sedang, warna lebih tahan lama',
      tips: 'Pilih shade coklat yang sesuai dengan undertone kulit kamu'),
  HairInfo(
      id: 'red',
      name: 'Merah',
      color: Color(0xFFFF0000),
      description: 'Warna bold yang membuat kamu stand out dari crowd',
      skinTones: 'Cocok untuk kulit cerah dan medium warm',
      maintenance: 'Warna cepat pudar, butuh touch-up rutin',
      tips: 'Hindari terlalu sering keramas untuk menjaga warna'),
  HairInfo(
      id: 'black',
      name: 'Hitam',
      color: Color(0xFF000000),
      description: 'Warna klasik yang memberikan kesan elegan dan sleek',
      skinTones: 'Cocok untuk semua warna kulit',
      maintenance: 'Perawatan mudah, warna sangat tahan lama',
      tips: 'Gunakan hair oil untuk menjaga kilau rambut hitam'),
  HairInfo(
      id: 'gray',
      name: 'Abu-abu',
      color: Color(0xFFA9A9A9),
      description: 'Warna trendy yang memberikan kesan edgy dan modern',
      skinTones: 'Cocok untuk kulit cerah dan cool undertone',
      maintenance: 'Membutuhkan bleaching, perawatan intensif',
      tips: 'Gunakan purple shampoo untuk mencegah warna kuning'),
];

// --- WIDGET ---
class HairColorInfoScreen extends StatelessWidget {
  final VoidCallback onBack;

  const HairColorInfoScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withValues(alpha: 0.9),
                  AppColors.background,
                ],
              ),
            ),
          ),
          Positioned(
            top: 156.0,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
              child: Column(
                children: [
                  ...kHairColorInfo.map((info) => Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: _buildInfoCard(context, info),
                      )),
                  const SizedBox(height: 8),
                  _buildGeneralTipsCard(context),
                ],
              ),
            ),
          ),
          _buildHeader(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.background.withValues(alpha: 0.9),
              AppColors.background.withValues(alpha: 0.7),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(LucideIcons.arrowLeft, color: AppColors.foreground),
                        onPressed: onBack,
                        splashRadius: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                      ),
                      child: Icon(LucideIcons.palette, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Hair Color Info',
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.foreground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Pilih warna rambut yang cocok untuk kamu',
                    style: AppTextStyles.p.copyWith(
                      color: AppColors.mutedForeground,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, HairInfo info) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: info.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.foreground.withAlpha(26),
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: info.color.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
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
                      info.name,
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.cardForeground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      info.description,
                      style: AppTextStyles.p.copyWith(
                        color: AppColors.mutedForeground,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.border.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _buildInfoRow("Warna Kulit:", info.skinTones),
              const SizedBox(height: 14),
              _buildInfoRow("Perawatan:", info.maintenance),
              const SizedBox(height: 14),
              _buildInfoRow("Tips:", info.tips),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: AppTextStyles.p.copyWith(
                color: AppColors.cardForeground, 
                fontSize: 14,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: '$title ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.cardForeground,
                  ),
                ),
                TextSpan(
                  text: text,
                  style: TextStyle(
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGeneralTipsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.9),
            AppColors.primary,
          ],
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.lightbulb, color: AppColors.primaryForeground, size: 20),
              const SizedBox(width: 8),
              Text(
                'Tips Umum Pewarnaan Rambut',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.primaryForeground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _buildTipRow('Lakukan skin test untuk menghindari alergi'),
              const SizedBox(height: 12),
              _buildTipRow('Konsultasi dengan hair stylist profesional'),
              const SizedBox(height: 12),
              _buildTipRow('Gunakan produk perawatan khusus rambut berwarna'),
              const SizedBox(height: 12),
              _buildTipRow('Hindari bleaching berlebihan untuk menjaga kesehatan rambut'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTipRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•  ',
            style: TextStyle(
              color: AppColors.primaryForeground, 
              fontSize: 16, 
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.p.copyWith(
                color: AppColors.primaryForeground, 
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

// ===============================================
// 🎨 APP COLORS (Tema Gelap Aksen Oranye)
// ===============================================
class AppColors {
  // --- Palette Utama ---
  static const Color background = Color(0xFF1C2526); // Background Gelap
  static const Color foreground = Color(0xFFFAFAFA); // Teks Utama Terang
  static const Color primary = Color(0xFFFF6B35);    // Aksen Oranye
  static const Color primaryForeground = Color(0xFFFFFFFF); // Teks di atas Oranye

  // --- Warna Tambahan untuk UI Umum ---
  // Warna Card sedikit lebih terang dari background
  static const Color card = Color(0xFF2D3B3D);
  static const Color cardForeground = Color(0xFFFAFAFA); // Teks di atas Card

  // Warna Sekunder
  static const Color secondary = Color(0xFF3A4B4D);
  static const Color secondaryForeground = Color(0xFFFAFAFA);

  // Warna Muted (lebih redup)
  static const Color muted = Color(0xFF4A5C5E);
  static const Color mutedForeground = Color(0xFFB0B0B0); // Teks Muted (abu-abu terang)

  // Warna Aksen Ringan
  static const Color accent = Color(0xFF6B8083);
  static const Color accentForeground = Color(0xFFFAFAFA);

  // Warna Border (cocok dengan muted)
  static const Color border = Color(0xFF4A5C5E);

  // Warna Input Field
  static const Color inputBackground = Color(0xFF2D3B3D); // Background Input
  static const Color inputBorder = Color(0xFF4A5C5E);    // Border Input
  static const Color inputPlaceholder = Color(0xFFB0B0B0); // Warna placeholder (muted)

  // Warna Ring/Fokus (sama dengan primary)
  static const Color ring = Color(0xFFFF6B35);

  // --- Warna Semantik ---
  static const Color destructive = Color(0xFFEF4444); // Merah
  static const Color destructiveForeground = Color(0xFFFFFFFF);
}

// ===============================================
// ✍️ APP TEXT STYLES (Disesuaikan untuk Tema Gelap)
// ===============================================
class AppTextStyles {
  // Bobot Font (Tidak berubah)
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight normal = FontWeight.w400;

  // Ukuran Font (Tidak berubah)
  static const double _text2xl = 24.0;
  static const double _textXl = 20.0;
  static const double _textLg = 18.0;
  static const double _textBase = 16.0;

  // Style Teks (Warna diupdate ke AppColors.foreground atau sesuai kebutuhan)
  static TextStyle get h1 => const TextStyle(
        fontSize: _text2xl,
        fontWeight: medium,
        color: AppColors.foreground, // Warna teks utama terang
      );

  static TextStyle get h2 => const TextStyle(
        fontSize: _textXl,
        fontWeight: medium,
        color: AppColors.foreground,
      );

  static TextStyle get h3 => const TextStyle(
        fontSize: _textLg,
        fontWeight: medium,
        color: AppColors.foreground,
      );

  static TextStyle get h4 => TextStyle(
        fontSize: _textBase,
        fontWeight: medium,
        color: AppColors.foreground,
      );

  static TextStyle get p => TextStyle(
        fontSize: _textBase,
        fontWeight: normal,
        color: AppColors.foreground,
      );

  static TextStyle get label => TextStyle(
        fontSize: _textBase,
        fontWeight: medium,
        color: AppColors.foreground,
      );

  // Style untuk teks di dalam tombol utama (misal di atas oranye)
  static TextStyle get buttonPrimary => TextStyle(
        fontSize: _textBase,
        fontWeight: medium,
        color: AppColors.primaryForeground, // Putih
      );

  // Style untuk teks di dalam tombol sekunder (misal teks saja)
  static TextStyle get buttonSecondary => TextStyle(
        fontSize: _textBase,
        fontWeight: medium,
        color: AppColors.primary, // Oranye
      );

  static TextStyle get input => TextStyle(
        fontSize: _textBase,
        fontWeight: normal,
        color: AppColors.foreground, // Teks input terang
      );
   // Style untuk teks kecil atau deskripsi
  static TextStyle get small => TextStyle(
        fontSize: 14.0,
        fontWeight: normal,
        color: AppColors.mutedForeground, // Abu-abu terang
      );
}

// ===============================================
// 📐 APP SIZING & RADIUS (Tidak berubah)
// ===============================================
class AppSizing {
  // --radius: 0.625rem; (0.625 * 16px = 10px)
  static const double radiusBase = 10.0;

  static BorderRadius get radiusSm => BorderRadius.circular(radiusBase - 4); // 6px
  static BorderRadius get radiusMd => BorderRadius.circular(radiusBase - 2); // 8px
  static BorderRadius get radiusLg => BorderRadius.circular(radiusBase); // 10px
  static BorderRadius get radiusXl => BorderRadius.circular(radiusBase + 4); // 14px
}
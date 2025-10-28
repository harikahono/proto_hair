import 'package:flutter/material.dart';

/// --- DATA MODEL UNTUK WARNA RAMBUT ---
class HairColor {
  final String id;
  final String name;
  final Color color; // Menggunakan Color dari Flutter

  const HairColor({
    required this.id,
    required this.name,
    required this.color,
  });
}

// ⬇️ PERBAIKAN: Mengganti nama variabel ini
// Mock data untuk kHairColors (sesuai TSX)
const List<HairColor> kHairColors = [
  HairColor(id: '1', name: 'Natural', color: Colors.transparent),
  HairColor(id: '2', name: 'Red', color: Color(0xFFE53935)),
  HairColor(id: '3', name: 'Blue', color: Color(0xFF1E88E5)),
  HairColor(id: '4', name: 'Green', color: Color(0xFF43A047)),
  HairColor(id: '5', name: 'Purple', color: Color(0xFF8E24AA)),
  HairColor(id: '6', name: 'Pink', color: Color(0xFFD81B60)),
  HairColor(id: '7', name: 'Orange', color: Color(0xFFF4511E)),
];
// ⬆️ AKHIR PERBAIKAN

/// --- DATA MODEL UNTUK GAMBAR TERSIMPAN ---
class SavedImage {
  final String id;
  final String beforeImage; // URL
  final String afterImage; // URL
  final HairColor colorUsed;
  final DateTime timestamp;

  SavedImage({
    required this.id,
    required this.beforeImage,
    required this.afterImage,
    required this.colorUsed,
    required this.timestamp,
  });
}
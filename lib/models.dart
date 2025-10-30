import 'package:flutter/material.dart';

/// --- DATA MODEL UNTUK WARNA RAMBUT ---
class HairColor {
  final String id;
  final String name;
  final Color color;

  const HairColor({
    required this.id,
    required this.name,
    required this.color,
  });
}

const List<HairColor> kHairColors = [
  HairColor(id: 'natural', name: 'Natural', color: Colors.transparent),

  // Data diambil dari kHairColorGallery di file hair_color_info_screen.dart
  HairColor(
    id: 'golden_honey',
    name: 'Golden Honey',
    color: Color(0xFFF5E050),
  ),
  HairColor(
    id: 'deep_espresso',
    name: 'Deep Espresso',
    color: Color(0xFF5C4033),
  ),
  HairColor(
    id: 'cherry_noir',
    name: 'Cherry Noir',
    color: Color(0xFFFF0000),
  ),
  HairColor(
    id: 'platinum_ice',
    name: 'Platinum Ice',
    color: Color(0xFFA9A9A9),
  ),
  HairColor(
    id: 'lavender_dream',
    name: 'Lavender Dream',
    color: Color(0xFFB39DDB),
  ),
  HairColor(
    id: 'electric_blue',
    name: 'Electric Blue',
    color: Color(0xFF29B6F6),
  ),
];

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
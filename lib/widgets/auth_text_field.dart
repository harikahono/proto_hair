import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

// Widget reusable untuk Input Form
class AuthTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleObscure;

  // ⬇️ PERBAIKAN LINTER: use_super_parameters
  const AuthTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleObscure,
  });

  // Warna kustom dari TSX
  static const Color _brandColor = Color(0xFFFF6B35);
  // ⬇️ PERBAIKAN LINTER: withAlpha()
  static final Color _inputFill = Colors.white.withAlpha(26);
  static final Color _borderColor = Colors.white.withAlpha(51);
  static final Color _placeholderColor = Colors.white.withAlpha(102);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // <label>
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14, // text-sm
          ),
        ),
        const SizedBox(height: 8), // mb-2

        // <input>
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: _placeholderColor),
            // bg-white bg-opacity-10
            filled: true,
            fillColor: _inputFill,

            // Suffix Icon (Eye/EyeOff)
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? LucideIcons.eyeOff : LucideIcons.eye,
                      size: 20, // w-5 h-5
                      // ⬇️ PERBAIKAN LINTER: withAlpha(153)
                      color: Colors.white.withAlpha(153),
                    ),
                    onPressed: onToggleObscure,
                  )
                : null,

            // Padding
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, // px-4
              vertical: 14, // Disesuaikan untuk h-12
            ),

            // border border-white border-opacity-20
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24), // rounded-full
              borderSide: BorderSide(color: _borderColor),
            ),

            // focus:border-[#FF6B35]
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24), // rounded-full
              // ⬇️ PERBAIKAN LINTER: withAlpha(153)
              borderSide: BorderSide(color: _brandColor.withAlpha(153)),
            ),
          ),
        ),
      ],
    );
  }
}
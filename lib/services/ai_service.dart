import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:uuid/uuid.dart';

class AIService {
  Interpreter? _interpreter;
  static const int _inputSize = 256;

  Future<bool> loadModel() async {
    try {
      final options = InterpreterOptions()..addDelegate(GpuDelegateV2());
      _interpreter = await Interpreter.fromAsset(
        'assets/models/selfie_multiclass_256x256.tflite',
        options: options,
      );
      _interpreter!.allocateTensors();
      debugPrint('Model AI sukses di-load.');
      return true;
    } catch (e) {
      debugPrint('Error loading model: $e');
      return false;
    }
  }

  Future<String> processImage(XFile imageFile, Color targetColor) async {
    if (_interpreter == null) {
      debugPrint("Error: Interpreter belum di-load.");
      return imageFile.path;
    }

    try {
      // 1. Decode & Resize Gambar
      final img.Image? originalImage =
          await img.decodeImageFile(imageFile.path);
      if (originalImage == null) return imageFile.path;

      // 1b. Skip processing jika warna "Natural"
      if (targetColor == Colors.transparent) {
        debugPrint("Warna 'Natural' dipilih, skip processing.");
        return imageFile.path;
      }

      final img.Image inputImage = img.copyResize(
        originalImage,
        width: _inputSize,
        height: _inputSize,
      );

      // 2. Normalisasi Gambar
      final inputBytes = inputImage.getBytes(order: img.ChannelOrder.rgb);
      final input = List.generate(
        1,
        (_) => List.generate(
          _inputSize,
          (y) => List.generate(
            _inputSize,
            (x) {
              final int index = (y * _inputSize + x) * 3;
              return [
                inputBytes[index] / 255.0,
                inputBytes[index + 1] / 255.0,
                inputBytes[index + 2] / 255.0,
              ];
            },
          ),
        ),
      );

      // 3. Siapkan output tensor
      final output = List.generate(
        1,
        (_) => List.generate(
          _inputSize,
          (_) => List.generate(_inputSize, (_) => List.filled(6, 0.0)),
        ),
      );

      // 4. Run Inference (Jalankan model AI)
      _interpreter!.run(input, output);

      // 5. Post-Processing (Buat Mask dari hasil AI)
      final img.Image hairMask =
          img.Image(width: _inputSize, height: _inputSize);
      final List<List<List<double>>> outputMask = output[0];

      const int hairClassIndex = 1; // Asumsi: index 1 adalah 'rambut'

      for (int y = 0; y < _inputSize; y++) {
        for (int x = 0; x < _inputSize; x++) {
          final List<double> pixelScores = outputMask[y][x];
          double maxScore = -1.0;
          int maxIndex = -1;
          for (int i = 0; i < pixelScores.length; i++) {
            if (pixelScores[i] > maxScore) {
              maxScore = pixelScores[i];
              maxIndex = i;
            }
          }

          if (maxIndex == hairClassIndex) {
            hairMask.setPixel(x, y, img.ColorRgb8(255, 255, 255));
          } else {
            hairMask.setPixel(x, y, img.ColorRgb8(0, 0, 0));
          }
        }
      }

      // 6. Resize mask ke ukuran gambar asli
      img.Image resizedMask = img.copyResize(
        hairMask,
        width: originalImage.width,
        height: originalImage.height,
        interpolation: img.Interpolation.linear,
      );

      // 7. Haluskan pinggiran mask
      resizedMask = img.gaussianBlur(resizedMask, radius: 5);

      // 8. Terapkan Warna (Logika Blending OVERLAY)
      final img.Image processedImage = img.Image.from(originalImage);

      for (int y = 0; y < processedImage.height; y++) {
        for (int x = 0; x < processedImage.width; x++) {
          // Dapatkan nilai alpha (0.0 - 1.0) dari mask yang sudah di-blur
          final double alpha = (resizedMask.getPixel(x, y).r / 255.0); 
          
          if (alpha > 0.1) { // Hanya proses jika bagian dari mask
            final originalPixel = originalImage.getPixel(x, y);

            // Ambil nilai R,G,B dari target dan original (skala 0-255)
            final double oR = originalPixel.r.toDouble();
            final double oG = originalPixel.g.toDouble();
            final double oB = originalPixel.b.toDouble();

            // ignore: deprecated_member_use
            final double tR = targetColor.red.toDouble();
            // ignore: deprecated_member_use
            final double tG = targetColor.green.toDouble();
            // ignore: deprecated_member_use
            final double tB = targetColor.blue.toDouble();

            // --- LOGIKA OVERLAY ---
            double r = (oR < 128)
                ? (2 * oR * tR) / 255
                : (255 - 2 * (255 - oR) * (255 - tR) / 255);
            
            double g = (oG < 128)
                ? (2 * oG * tG) / 255
                : (255 - 2 * (255 - oG) * (255 - tG) / 255);

            double b = (oB < 128)
                ? (2 * oB * tB) / 255
                : (255 - 2 * (255 - oB) * (255 - tB) / 255);
            // --- AKHIR LOGIKA OVERLAY ---

            // Blend antara warna baru (hasil overlay) dan warna asli menggunakan alpha
            r = (r * alpha + oR * (1.0 - alpha));
            g = (g * alpha + oG * (1.0 - alpha));
            b = (b * alpha + oB * (1.0 - alpha));

            processedImage.setPixelRgb(x, y, r.round(), g.round(), b.round());
          }
        }
      }

      // 9. Simpan gambar ke file temporary
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = '${tempDir.path}/${const Uuid().v4()}.jpg';
      
      await img.encodeJpgFile(tempPath, processedImage, quality: 90);

      debugPrint('Gambar selesai diproses (Metode Overlay), disimpan di: $tempPath');
      return tempPath;

    } catch (e) {
      debugPrint('Error processing image: $e');
      return imageFile.path;
    }
  }

  void dispose() {
    _interpreter?.close();
  }
}
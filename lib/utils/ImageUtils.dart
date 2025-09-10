import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  static Future<File?> compressImage(File file) async {
    try {
      // Print original image size
      int originalSizeInKB = await file.length() ~/ 1024;
      print("Original image size: $originalSizeInKB KB");

      // Define the output file path (temporary directory)
      final String targetPath = '${file.path}_compressed.jpg';

      int quality = 85;

      XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, // Input file path
        targetPath, // Output file path
        quality: quality, // Initial quality (0-100)
        minHeight: 800, // Optional: Set minimum height
        minWidth: 800, // Optional: Set minimum width
      );

      if (compressedXFile == null) return null;

      // Check file size and adjust quality if necessary
      File compressedFile = File(compressedXFile.path);
      int fileSizeInKB = await compressedFile.length() ~/ 1024;

      // If still larger than 500KB, reduce quality further
      while (fileSizeInKB > 500 && quality > 10) {
        quality -= 10; // Reduce quality incrementally
        final XFile? reCompressedXFile =
            await FlutterImageCompress.compressAndGetFile(
              file.absolute.path,
              targetPath,
              quality: quality,
              minHeight: 800,
              minWidth: 800,
            );
        if (reCompressedXFile == null) return null;
        compressedFile = File(reCompressedXFile.path);
        fileSizeInKB = await compressedFile.length() ~/ 1024;
      }

      // Print the final image size
      print("Final compressed image size: $fileSizeInKB KB");

      return compressedFile;
    } catch (e) {
      print("Error compressing image: $e");
      return null;
    }
  }
}

class ImageUtils1 {
  /// Read dimensions quickly using `image` package (no widget needed)
  static Future<({int width, int height})?> readDimensions(File file) async {
    try {
      final Uint8List bytes = await file.readAsBytes();
      final img.Image? im = img.decodeImage(bytes);
      if (im == null) return null;
      return (width: im.width, height: im.height);
    } catch (_) {
      return null;
    }
  }

  /// Validate if image is ~16:9 landscape.
  /// `tolerancePct`: how far from 16:9 you allow (e.g. 0.10 = ±10%)
  static Future<bool> isAcceptable16by9(
    File file, {
    double tolerancePct = 0.10,
    int? minWidth,
  }) async {
    final dims = await readDimensions(file);
    if (dims == null) return false;

    final w = dims.width.toDouble();
    final h = dims.height.toDouble();

    // Must be landscape
    if (w <= h) return false;

    // Optional minimum width gate (avoid blurry upscales)
    if (minWidth != null && w < minWidth) return false;

    final aspect = w / h;
    const sixteenByNine = 16 / 9; // ≈ 1.7777
    final lower = sixteenByNine * (1 - tolerancePct);
    final upper = sixteenByNine * (1 + tolerancePct);

    return aspect >= lower && aspect <= upper;
  }

  /// Resize and crop an image to a true 16:9 ratio.
  /// You provide the width (e.g. 1280, 1920, 380, etc.)
  /// Height is auto-calculated as width * 9/16.
  static Future<File?> resizeTo16by9(
    File file, {
    int targetWidth = 1280,
  }) async {
    try {
      final targetHeight = (targetWidth * 9 / 16).round();
      final targetAspect = targetWidth / targetHeight;

      final Uint8List bytes = await file.readAsBytes();
      final img.Image? src = img.decodeImage(bytes);
      if (src == null) return null;

      // --- Crop to 16:9 aspect ratio (center crop) ---
      final srcAspect = src.width / src.height;
      int cropW, cropH, cropX, cropY;

      if (srcAspect > targetAspect) {
        // Source is wider → crop width
        cropH = src.height;
        cropW = (cropH * targetAspect).round();
        cropX = ((src.width - cropW) / 2).round();
        cropY = 0;
      } else {
        // Source is taller → crop height
        cropW = src.width;
        cropH = (cropW / targetAspect).round();
        cropX = 0;
        cropY = ((src.height - cropH) / 2).round();
      }

      final img.Image cropped = img.copyCrop(
        src,
        x: cropX,
        y: cropY,
        width: cropW,
        height: cropH,
      );

      // --- Resize to target 16:9 size ---
      final img.Image resized = img.copyResize(
        cropped,
        width: targetWidth,
        height: targetHeight,
        interpolation: img.Interpolation.average,
      );

      // --- Encode JPEG and keep under 500 KB ---
      int quality = 90;
      late List<int> jpg;
      File? out;

      while (true) {
        jpg = img.encodeJpg(resized, quality: quality);
        final String targetPath =
            '${file.path}_16x9_${targetWidth}w_q$quality.jpg';
        out = await File(targetPath).writeAsBytes(jpg, flush: true);

        final kb = await out.length() ~/ 1024;
        if (kb <= 500 || quality <= 40) {
          print('Final 16:9 image size: ${kb}KB at $targetWidth×$targetHeight');
          break;
        }
        quality -= 10;
      }

      return out;
    } catch (e) {
      print('Error in resizeTo16by9: $e');
      return null;
    }
  }
}

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  /// Show bottom sheet for choosing camera or gallery
  static Future<File?> pickImage(
    BuildContext context, {
    Color? iconColor,
  }) async {
    return await showModalBottomSheet<File?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: iconColor ?? Colors.blue,
                ),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  Navigator.pop(context, await _pickImageFromGallery());
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: iconColor ?? Colors.blue,
                ),
                title: const Text("Take a Photo"),
                onTap: () async {
                  Navigator.pop(context, await _pickImageFromCamera());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<File?> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      return await ImageUtils.compressImage(File(pickedFile.path));
    }
    return null;
  }

  static Future<File?> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      return await ImageUtils.compressImage(File(pickedFile.path));
    }
    return null;
  }
}

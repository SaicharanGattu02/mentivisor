import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:simple_pdf_compression/simple_pdf_compression.dart';

import '../../../utils/AppLogger.dart';

class FileImagePicker {
  static final ImagePicker _picker = ImagePicker();

  /// Pick file (only PDF)
  static Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  // static Future<File?> pickPdfFile({
  //   int maxSizeInMB = 200, // limit
  // }) async {
  //   try {
  //     final result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ["pdf"],
  //       withData: false,
  //     );
  //
  //     if (result != null && result.files.single.bytes != null) {
  //       final bytes = result.files.single.bytes!;
  //       final sizeInMB = bytes.length / (1024 * 1024);
  //
  //       // ⛔ Block files above limit
  //       if (sizeInMB > maxSizeInMB) {
  //         AppLogger.error(
  //             "File too large: ${sizeInMB.toStringAsFixed(2)} MB (limit: $maxSizeInMB MB)");
  //         return null;
  //       }
  //
  //       // Save file to app directory
  //       final appDir = await getApplicationDocumentsDirectory();
  //       final file = File('${appDir.path}/${result.files.single.name}');
  //       await file.writeAsBytes(bytes);
  //
  //       if (file.lengthSync() == 0) {
  //         AppLogger.error("Picked PDF is empty");
  //         return null;
  //       }
  //
  //       // 🔥 NO COMPRESSION – return as is
  //       AppLogger.info("Picked PDF size: ${file.lengthSync() / (1024 * 1024)} MB");
  //       return file;
  //     }
  //   } catch (e) {
  //     AppLogger.error("Error picking PDF file: $e");
  //   }
  //
  //   return null;
  // }

  static Future<File?> pickPdfFile({int maxSizeInMB = 200}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf',], // if images too
        withData: false, // ✅ important
      );

      if (result == null || result.files.single.path == null) {
        return null; // user cancelled
      }

      final file = File(result.files.single.path!);

      final sizeInBytes = await file.length();
      final sizeInMB = sizeInBytes / (1024 * 1024);

      // ⛔ Proper size check
      if (sizeInMB > maxSizeInMB) {
        AppLogger.error(
          "File too large: ${sizeInMB.toStringAsFixed(2)} MB (limit: $maxSizeInMB MB)",
        );
        return null;
      }

      AppLogger.info(
        "Picked file size: ${sizeInMB.toStringAsFixed(2)} MB",
      );

      return file;
    } catch (e) {
      AppLogger.error("Error picking file: $e");
      return null;
    }
  }

  // static Future<File?> pickPdfFile({
  //   int thresholdSizeInKB = 500,
  //   int quality = 60,
  // }) async {
  //   try {
  //     final result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ["pdf"],
  //       withData: true, // important
  //     );
  //
  //     if (result != null && result.files.single.bytes != null) {
  //       final bytes = result.files.single.bytes!;
  //       final appDir = await getApplicationDocumentsDirectory();
  //       final file = File('${appDir.path}/${result.files.single.name}');
  //       await file.writeAsBytes(bytes);
  //
  //       if (file.lengthSync() == 0) {
  //         AppLogger.error("Picked PDF is empty");
  //         return null;
  //       }
  //
  //       // Optional compression
  //       final compressor = PDFCompression();
  //       final compressedPdf = await compressor.compressPdf(
  //         file,
  //         thresholdSize: thresholdSizeInKB * 1024,
  //         quality: quality,
  //       );
  //
  //       AppLogger.info(
  //         "Compressed PDF size: ${compressedPdf.lengthSync() / 1024} KB",
  //       );
  //
  //       return compressedPdf;
  //     }
  //   } catch (e) {
  //     AppLogger.error("Error picking PDF file: $e");
  //   }
  //   return null;
  // }


  /// Show bottom sheet for picking image
  static Future<File?> pickImageBottomSheet(BuildContext context) async {
    return await showModalBottomSheet<File?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Colors.blue),
                  title: const Text('Choose from Gallery'),
                  onTap: () async {
                    Navigator.pop(
                      context,
                      await _pickAndResize(ImageSource.gallery),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.green),
                  title: const Text('Take a Photo'),
                  onTap: () async {
                    Navigator.pop(
                      context,
                      await _pickAndResize(ImageSource.camera),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Internal: pick + resize image
  static Future<File?> _pickAndResize(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile == null) return null;

    File originalFile = File(pickedFile.path);
    return await _resizeImage(originalFile, maxWidth: 1080, maxHeight: 1080);
  }

  /// Resize image to avoid huge px size
  static Future<File?> _resizeImage(
    File file, {
    int maxWidth = 1080,
    int maxHeight = 1080,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final img.Image? image = img.decodeImage(bytes);

      if (image == null) return file;

      final img.Image resized = img.copyResize(
        image,
        width: maxWidth,
        height: maxHeight,
      );

      final newPath = file.path.replaceAll(
        RegExp(r'\.(jpg|jpeg|png)$'),
        '_resized.jpg',
      );

      final resizedFile = File(newPath)
        ..writeAsBytesSync(img.encodeJpg(resized, quality: 85));

      return resizedFile;
    } catch (e) {
      debugPrint("Resize failed: $e");
      return file;
    }
  }
}

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImageBottomSheet(
    BuildContext context, {
    int maxDimension = 1080, // optional resize limit for large images
  }) async {
    return await showModalBottomSheet<File?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🟦 Drag Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF315DEA).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // 📂 Choose from Gallery
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: Color(0xff315DEA),
                  ),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  onTap: () async {
                    final file = await _pickAndResize(
                      ImageSource.gallery,
                      maxDimension: maxDimension,
                    );
                    Navigator.pop(context, file);
                  },
                ),

                // 📷 Take a Photo
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Color(0xff315DEA),
                  ),
                  title: const Text(
                    'Take a Photo',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  onTap: () async {
                    final file = await _pickAndResize(
                      ImageSource.camera,
                      maxDimension: maxDimension,
                    );
                    Navigator.pop(context, file);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 🖼 Pick + (optionally) resize image for optimization
  static Future<File?> _pickAndResize(
    ImageSource source, {
    int maxDimension = 1080,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return null;

      final File originalFile = File(pickedFile.path);
      return await _resizeIfTooLarge(originalFile, maxDimension: maxDimension);
    } catch (e) {
      debugPrint("Image picking failed: $e");
      return null;
    }
  }

  /// 🧩 Resize large images proportionally — but keep full height (no crop)
  static Future<File?> _resizeIfTooLarge(
    File file, {
    int maxDimension = 1080,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final img.Image? image = img.decodeImage(bytes);
      if (image == null) return file;

      // if image already small, keep as-is
      if (image.width <= maxDimension && image.height <= maxDimension) {
        return file;
      }

      final double scale = image.width > image.height
          ? maxDimension / image.width
          : maxDimension / image.height;

      final img.Image resized = img.copyResize(
        image,
        width: (image.width * scale).round(),
        height: (image.height * scale).round(),
      );

      final newPath = file.path.replaceAll(
        RegExp(r'\.(jpg|jpeg|png)$'),
        '_resized.jpg',
      );

      final resizedFile = File(newPath)
        ..writeAsBytesSync(img.encodeJpg(resized, quality: 85));

      return resizedFile;
    } catch (e) {
      debugPrint("Resize failed: $e");
      return file;
    }
  }
}

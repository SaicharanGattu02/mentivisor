import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
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

  static Future<File?> pickPdfFile({
    int thresholdSizeInKB = 500,
    int quality = 60,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["pdf"],
      );

      if (result != null && result.files.single.path != null) {
        final pickedFile = File(result.files.single.path!);

        if (pickedFile.path.toLowerCase().endsWith('.pdf')) {
          final compressor = PDFCompression();
          final compressedPdf = await compressor.compressPdf(
            pickedFile,
            thresholdSize: thresholdSizeInKB * 1024,
            quality: quality,
          );

          AppLogger.info(
            "Compressed size: ${compressedPdf.lengthSync() / 1024} KB",
          );

          return compressedPdf;
        } else {
          return pickedFile;
        }
      }
    } catch (e) {
      AppLogger.error("Error picking PDF file: $e");
    }

    return null;
  }

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

// class PdfFileImagePicker {
//   static Future<File?> pickFile() async {
//     try {
//       // 1️⃣ Pick file
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf'],
//       );
//
//       if (result == null || result.files.single.path == null) return null;
//
//       File file = File(result.files.single.path!);
//       final int sizeInBytes = await file.length();
//       final double sizeInMB = sizeInBytes / (1024 * 1024);
//       print('📄 Picked file size: ${sizeInMB.toStringAsFixed(2)} MB');
//
//       // 2️⃣ If already under 5MB, no need to compress
//       if (sizeInMB <= 5.0) return file;
//
//       // 3️⃣ Compress file
//       final Directory tempDir = await getTemporaryDirectory();
//       final String outPath =
//           '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.pdf';
//
//       print('🔧 Compressing PDF...');
//       await PdfCompressor.compressPdfFile(
//         file.path,
//         outPath,
//         CompressQuality.LOW,
//       );
//
//       // 4️⃣ Verify new size
//       final File compressed = File(outPath);
//       final int newSize = await compressed.length();
//       final double newSizeMB = newSize / (1024 * 1024);
//
//       print('✅ Compressed size: ${newSizeMB.toStringAsFixed(2)} MB');
//
//       if (newSizeMB > 5.0) {
//         print(
//           '⚠️ File still too large (${newSizeMB.toStringAsFixed(2)} MB). Please choose a smaller file.',
//         );
//         return null;
//       }
//
//       return compressed;
//     } catch (e) {
//       print('❌ Error compressing PDF: $e');
//       return null;
//     }
//   }
// }

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class FileImagePicker {
  static final ImagePicker _picker = ImagePicker();

  /// Pick file (only PDF)
  static Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Restrict to PDF files only
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
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
                    Navigator.pop(context,
                        await _pickAndResize(ImageSource.gallery));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.green),
                  title: const Text('Take a Photo'),
                  onTap: () async {
                    Navigator.pop(context,
                        await _pickAndResize(ImageSource.camera));
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
  static Future<File?> _resizeImage(File file,
      {int maxWidth = 1080, int maxHeight = 1080}) async {
    try {
      final bytes = await file.readAsBytes();
      final img.Image? image = img.decodeImage(bytes);

      if (image == null) return file;

      final img.Image resized =
      img.copyResize(image, width: maxWidth, height: maxHeight);

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

import 'dart:developer' as AppLogger;
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import '../../../../Components/CustomSnackBar.dart';
import '../../../../utils/ImageUtils.dart';
import '../../../../utils/color_constants.dart';

class ProfileSetupScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const ProfileSetupScreen({required this.data, Key? key}) : super(key: key);

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final ValueNotifier<File?> _imageFile = ValueNotifier<File?>(null);
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    showModalBottomSheet(
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
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: primarycolor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                ListTile(
                  leading: Icon(Icons.photo_library, color: primarycolor),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromGallery();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt, color: primarycolor),
                  title: const Text(
                    'Take a Photo',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromCamera();
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      File? compressedFile = await ImageUtils.compressImage(
        File(pickedFile.path),
      );
      if (compressedFile != null) {
        _imageFile.value = compressedFile;
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      File? compressedFile = await ImageUtils.compressImage(
        File(pickedFile.path),
      );
      if (compressedFile != null) {
        _imageFile.value = compressedFile;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    AppLogger.log("Final data:${widget.data}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: kCommonGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Join Mentivisor',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Profile Setup',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'segeo',
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '1 of 3',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: [
                      Container(height: 6, color: Colors.grey.shade300),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final progress = 0.33;
                          return Container(
                            height: 6,
                            width: constraints.maxWidth * progress,
                            decoration: BoxDecoration(
                              gradient: kCommonGradient,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "What's your name?",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'This is how others will see you on the platform',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'segeo',
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ValueListenableBuilder<File?>(
                              valueListenable: _imageFile,
                              builder: (context, file, _) {
                                return Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: file == null
                                        ? const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xFF9333EA),
                                              Color(0xFF3B82F6),
                                            ],
                                          )
                                        : null,
                                    image: file != null
                                        ? DecorationImage(
                                            image: FileImage(file),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: file == null
                                      ? const Icon(
                                          Icons.person,
                                          color: Colors.white70,
                                          size: 48,
                                        )
                                      : null,
                                );
                              },
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Color(0xFF7F00FF),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Full Name',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'segeo',
                            fontWeight: FontWeight.w400,
                            color: Color(0xff666666),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter your full Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xffE5E7EB),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xffE5E7EB),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xffE5E7EB),
                              width: 1,
                            ),
                          ),
                          errorStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff222222),
                          fontFamily: 'segeo',
                        ),
                      ),
                    ),
                    CustomAppButton1(
                      text: "Next",
                      radius: 10,
                      width: 100,
                      height: 42,
                      onPlusTap: () {
                        if (_nameController.text.trim().isEmpty) {
                          CustomSnackBar1.show(
                            context,
                            "Please enter your name.",
                          );
                        } else if (_imageFile.value == null) {
                          CustomSnackBar1.show(
                            context,
                            "Please select a profile picture.",
                          );
                        } else {
                          final Map<String, dynamic> data = {
                            ...widget.data,
                            "name": _nameController.text.trim(),
                            "profile": _imageFile.value!.path,
                          };
                          context.push('/profile_about', extra: data);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

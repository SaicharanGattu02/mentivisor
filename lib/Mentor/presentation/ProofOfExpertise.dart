import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Mentor/data/Cubits/NewExpertiseRequest/NewExpertiseRequestCubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/NewExpertiseRequest/NewExpertiseRequestStates.dart';

import '../../Components/CustomAppButton.dart';
import '../../Components/CutomAppBar.dart';
import '../../Mentee/presentation/Widgets/CommonImgeWidget.dart';

class ProofOfExpertise extends StatefulWidget {
  final Map<String, dynamic> data;
  const ProofOfExpertise({Key? key, required this.data}) : super(key: key);

  @override
  State<ProofOfExpertise> createState() => _ProofOfExpertiseState();
}

class _ProofOfExpertiseState extends State<ProofOfExpertise> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ValueNotifier<File?> selectedResumeFile = ValueNotifier<File?>(null);

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _pickResumeFile() async {
    _isLoading.value = true; // start loading

    try {
      final file = await FileImagePicker.pickPdfFile();

      if (file != null) {
        selectedResumeFile.value = file;
      }
    } catch (e) {
      debugPrint('File selection error: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _submit() async {
    final link = _linkController.text.trim();
    final description = _descriptionController.text.trim();

    if (link.isEmpty && selectedResumeFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a link or upload a document'),
        ),
      );
      return;
    }

    if (link.isNotEmpty) {
      final ok = RegExp(
        r'^(http|https)://',
        caseSensitive: false,
      ).hasMatch(link);
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid http/https link')),
        );
        return;
      }
    }

    final proof = <String, dynamic>{};
    if (link.isNotEmpty) {
      proof['proof_link'] = link;
    }

    if (description.isNotEmpty) {
      proof['description'] = description;
    }

    if (selectedResumeFile.value != null) {
      final file = selectedResumeFile.value!;
      proof["proof_doc"] = await MultipartFile.fromFile(
        file.path,
        filename: path.basename(file.path),
      );
    }
    final request = <String, dynamic>{...widget.data, ...proof};
    request.removeWhere(
      (k, v) => v == null || (v is String && v.trim().isEmpty),
    );
    await context.read<NewExpertiseRequestCubit>().newExpertiseRequest(request);
  }

  @override
  Widget build(BuildContext context) {
    const bg = LinearGradient(
      colors: [Color(0xFFF6F7FF), Color(0xFFFFF5FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar1(title: "Expertise", actions: []),
      body: Container(
        decoration: const BoxDecoration(gradient: bg),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Illustration
                const SizedBox(height: 24),
                Center(
                  child: Image.asset(
                    'assets/images/expertiseslinkimg.png',
                    height: 329,
                    width: 329,
                    fit: BoxFit.fill,
                  ),
                ),
                // Headline + subtext
                const Text(
                  'Please provide the proof for your skills',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: "segeo",
                    color: Color(0xff222222),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Any case studies,link or any other doc that supports \nyour skills',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "segeo",
                    color: Color(0xFF666666), // grey-600
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),

                // Link label
                Row(
                  children: [
                    Image.asset(
                      "assets/images/linksimple.png",
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Link',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "segeo",
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151).withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _linkController,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  cursorColor: const Color(0xFF121212),
                  decoration: InputDecoration(
                    hint: Text(
                      "https://",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "segeo",
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151).withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  maxLines: 4,
                  cursorColor: const Color(0xFF121212),
                  decoration: InputDecoration(
                    hint: Text(
                      "Enter Description",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                Row(
                  children: [
                    Image.asset(
                      "assets/images/UploadSimple.png",
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Upload any Doc’s",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "segeo",
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151).withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                ValueListenableBuilder<bool>(
                  valueListenable: _isLoading,
                  builder: (context, isLoading, _) {
                    return GestureDetector(
                      onTap: isLoading
                          ? null
                          : _pickResumeFile, // Disable tap while loading
                      child: DottedBorder(
                        color: Colors.grey,
                        strokeWidth: 1.2,
                        dashPattern: const [6, 4],
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(8),
                        padding: const EdgeInsets.all(12),
                        child: SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.upload_file, color: Colors.grey),
                              const SizedBox(width: 10),

                              // 🔹 Inner listener to react to selected file
                              Expanded(
                                child: ValueListenableBuilder<File?>(
                                  valueListenable: selectedResumeFile,
                                  builder: (context, file, _) {
                                    // 🌀 CASE 1: Loading state
                                    if (isLoading) {
                                      return Row(
                                        children: [
                                          const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Expanded(
                                            child: Text(
                                              "Compressing and uploading file...",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Color(0xff555555),
                                                fontFamily: 'segeo',
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      );
                                    }

                                    // 📄 CASE 2: File selected
                                    if (file != null) {
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              file.path.split('/').last,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                                fontFamily: 'segeo',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                selectedResumeFile.value = null,
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                              size: 18,
                                            ),
                                          ),
                                        ],
                                      );
                                    }

                                    return const Text(
                                      "Tap to select your resume (PDF)",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff777777),
                                        fontFamily: 'segeo',
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 100), // space for the sticky button
              ],
            ),
          ),
        ),
      ),

      // Sticky gradient "Submit" button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(16, 12, 16, 20),
          child: BlocConsumer<NewExpertiseRequestCubit, NewExpertiseRequestStates>(
            listener: (context, state) {
              if (state is NewExpertiseRequestLoaded) {
                context.go(
                  '/cost_per_minute_screen?coins=${state.updateExpertiseModel.coins}&path=${"mentor_dashboard"}',
                );
              } else if (state is NewExpertiseRequestFailure) {
                CustomSnackBar1.show(context, state.error);
              }
            },
            builder: (context, state) {
              final isLoading = state is NewExpertiseRequestLoading;
              return CustomAppButton1(
                text: 'Submit',
                isLoading: isLoading,
                onPlusTap: () {
                  _submit();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

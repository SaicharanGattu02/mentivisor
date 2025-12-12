import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import '../../../Components/CustomAppButton.dart';
import '../../../Components/CutomAppBar.dart';
import 'package:simple_pdf_compression/simple_pdf_compression.dart';

class BecomeMentorData extends StatefulWidget {
  final Map<String, dynamic> data;
  const BecomeMentorData({Key? key, required this.data}) : super(key: key);

  @override
  State<BecomeMentorData> createState() => _BecomeMentorDataState();
}

class _BecomeMentorDataState extends State<BecomeMentorData> {
  final _formKey = GlobalKey<FormState>();

  File? selectedResumeFile;

  final TextEditingController _portfolioUrlController = TextEditingController();
  final TextEditingController _linkdnUrlController = TextEditingController();
  final TextEditingController _githubUrlController = TextEditingController();

  Future<void> _pickResumeFile() async {
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
          thresholdSize: 500 * 1024,
          quality: 60,
        );

        AppLogger.info(
          "Compressed size: ${compressedPdf.lengthSync() / 1024} KB",
        );

        setState(() {
          selectedResumeFile = compressedPdf;
        });
      } else {
        setState(() {
          selectedResumeFile = pickedFile;
        });
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> data = {
        ...widget.data,
        "portfolio": _portfolioUrlController.text.trim(),
        "linked_in": _linkdnUrlController.text.trim(),
        "git_hub": _githubUrlController.text.trim(),
        "resume": selectedResumeFile != null ? selectedResumeFile!.path : null,
      };

      context.push("/language_selection", extra: data);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAF5FF),
      appBar: CustomAppBar1(title: '', actions: []),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Center(
                child: Image.asset('assets/images/linkimg.png', height: 140),
              ),
              const SizedBox(height: 24),

              Text(
                "Woohoo! You did the thing!🎉",
                style: const TextStyle(
                  color: Color(0xff2563EC),
                  fontSize: 24,
                  fontFamily: 'segeo',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'Small step or big leap - it all counts. Well done on your \nachievement!',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff666666),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'segeo',
                ),
              ),
              const SizedBox(height: 16),

              _buildLabel("Share your Portfolio"),
              const SizedBox(height: 8),
              TextFormField(
                controller: _portfolioUrlController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(hintText: 'Portfolio URL'),
                validator: (value) {
                  // Only validate if user entered something
                  if (value != null && value.trim().isNotEmpty) {
                    final urlPattern =
                        r'^(http|https):\/\/([a-zA-Z0-9\-_]+\.)+[a-zA-Z]{2,6}(:[0-9]{1,5})?(\/.*)?$';
                    final result = RegExp(urlPattern).hasMatch(value.trim());
                    if (!result) {
                      return "Enter a valid URL";
                    }
                  }
                  return null; // No validation if empty
                },
              ),
              const SizedBox(height: 20),

              _buildLabel("Linked-in"),
              const SizedBox(height: 8),
              TextFormField(
                controller: _linkdnUrlController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(hintText: 'LinkedIn URL'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "LinkedIn URL is required";
                  }

                  final urlPattern =
                      r'^(http|https):\/\/([a-zA-Z0-9\-_]+\.)+[a-zA-Z]{2,6}(:[0-9]{1,5})?(\/.*)?$';
                  final isValid = RegExp(urlPattern).hasMatch(value.trim());

                  if (!isValid) {
                    return "Enter a valid LinkedIn URL";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),

              _buildLabel("GitHub link"),
              const SizedBox(height: 8),
              TextFormField(
                controller: _githubUrlController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(hintText: 'GitHub URL'),
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    final urlPattern =
                        r'^(http|https):\/\/([a-zA-Z0-9\-_]+\.)+[a-zA-Z]{2,6}(:[0-9]{1,5})?(\/.*)?$';
                    final result = RegExp(urlPattern).hasMatch(value.trim());
                    if (!result) {
                      return "Enter a valid URL";
                    }
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              _buildLabel("Upload your Resume"),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickResumeFile,
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
                      children: [
                        const Icon(Icons.upload_file, color: Colors.grey),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            selectedResumeFile != null
                                ? selectedResumeFile!.path.split('/').last
                                : "Tap to select your resume (PDF, DOC, DOCX)",
                            style: TextStyle(
                              fontSize: 14,
                              color: selectedResumeFile != null
                                  ? Colors.black87
                                  : Colors.grey[600],
                              fontFamily: 'segeo',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "※ Sharing more details about yourself increases your chances of becoming a mentor, though additional information is optional.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Color(0xff444444),
                fontFamily: 'segeo',
              ),
            ),
            const SizedBox(height: 10),
            SafeArea(
              child: CustomAppButton1(text: "Okay", onPlusTap: _submitForm),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xff444444),
        fontWeight: FontWeight.w600,
        fontFamily: 'segeo',
      ),
    );
  }
}

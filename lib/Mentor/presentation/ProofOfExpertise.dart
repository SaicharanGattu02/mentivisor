import 'dart:io';

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

class ProofOfExpertise extends StatefulWidget {
  final Map<String, dynamic> data;
  const ProofOfExpertise({Key? key, required this.data}) : super(key: key);

  @override
  State<ProofOfExpertise> createState() => _ProofOfExpertiseState();
}

class _ProofOfExpertiseState extends State<ProofOfExpertise> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _linkController = TextEditingController();

  File? selectedResumeFile;

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _pickResumeFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf", "doc", "docx"],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedResumeFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submit() async {
    final link = _linkController.text.trim();

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

    // Build only the provided proof fields
    final proof = <String, dynamic>{
      if (link.isNotEmpty) 'proof_link': link,
      // Pass the File/Path – your repo can convert it to multipart if needed
      if (selectedResumeFile != null) 'proof_file': selectedResumeFile, // File
      if (selectedResumeFile != null)
        'proof_file_path': selectedResumeFile!.path, // optional
    };

    // Merge with the map you’re already receiving on this screen
    final request = <String, dynamic>{...widget.data, ...proof};

    // Remove empty/nulls so backend doesn’t get junk
    request.removeWhere(
      (k, v) => v == null || (v is String && v.trim().isEmpty),
    );

    // Fire the cubit
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
                const SizedBox(height: 16),

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

                // Link field
                TextFormField(
                  controller: _linkController,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  cursorColor: const Color(0xFF121212),
                  decoration: InputDecoration(hint: Text("https://")),
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

                // Link field
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
                const SizedBox(height: 8),

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
          child:
              BlocConsumer<NewExpertiseRequestCubit, NewExpertiseRequestStates>(
                listener: (context, state) {
                  if (state is NewExpertiseRequestLoaded) {
                    context.push("/mentor_review");
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

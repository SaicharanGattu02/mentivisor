import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';

class Expertiseaddlink extends StatefulWidget {

  const Expertiseaddlink({Key? key,}) : super(key: key);



  @override
  State<Expertiseaddlink> createState() => _BecomeMentorDataState();
}

class _BecomeMentorDataState extends State<Expertiseaddlink> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _linkController = TextEditingController();
  File? _selectedFile;

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final res = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'jpg', 'jpeg', 'png'],
    );
    if (res != null && res.files.single.path != null) {
      setState(() => _selectedFile = File(res.files.single.path!));
    }
  }

  void _submit() {
    final link = _linkController.text.trim();
    if (link.isEmpty && _selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a link or upload a document')),
      );
      return;
    }
    // Optional: if link provided, validate it roughly
    if (link.isNotEmpty) {
      final ok = RegExp(r'^(http|https)://', caseSensitive: false).hasMatch(link);
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid http/https link')),
        );
        return;
      }
    }

    final payload = {

      'proof_link': link,
      'proof_file_path': _selectedFile?.path,
    };
    context.push('/language_selection', extra: payload);
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF7C5CFF), width: 1.2),
      borderRadius: BorderRadius.circular(12),
    ),
  );

  @override
  Widget build(BuildContext context) {
    const bg = LinearGradient(
      colors: [Color(0xFFF6F7FF), Color(0xFFFFF5FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:CustomAppBar1(title: "Expertise", actions: []),
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
                const SizedBox(height: 8),
                Center(
                  child: Image.asset(

                    'assets/images/expertiseslinkimg.png',
                    height: 329,
                    width: 329,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),

                // Headline + subtext
                const Text(
                  'Please provide the proof for your skills',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Any case studies, link or any other doc that supports your\nskills',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.35,
                    color: Color(0xFF666666), // grey-600
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),

                // Link label
                Row(
                  children: const [
                    Icon(Icons.link_rounded, size: 18, color: Color(0xFF374151)),
                    SizedBox(width: 8),
                    Text(
                      'Link',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
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
                  decoration: _inputDecoration('Http/.....'),
                ),

                const SizedBox(height: 20),

                // Upload label
                Row(
                  children: const [
                    Icon(Icons.ios_share_rounded, size: 18, color: Color(0xFF374151)),
                    SizedBox(width: 8),
                    Text(
                      "Upload any Doc’s",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
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
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: SizedBox(
            height: 52,
            child: GestureDetector(
              onTap: _submit,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9C5BF7), Color(0xFF5EA2FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .2,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/services/AuthService.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../../Components/CutomAppBar.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const LanguageSelectionScreen({Key? key, required this.data})
    : super(key: key);

  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final List<String> _allLanguages = [
    'Telugu',
    'Hindi',
    'English',
    'Kannada',
    'Tamil',
    'Marathi',
    'Gujarati',
    'Bengali',
    'Odia',
  ];

  final Set<String> _selected = {};

  @override
  void initState() {
    super.initState();
    AppLogger.log("BecomeMentorData: ${widget.data}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5FF),
      appBar: CustomAppBar1(title: "", actions: []),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Center(
              child: Image.asset(
                'assets/images/languagesscreenimg.png',
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: AlignmentDirectional(-1, -1),
              child: Text(
                "That’s Cool!",
                style: TextStyle(
                  fontFamily: "segeo",
                  fontSize: 24,
                  color: Color(0xff2563EC),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "How many languages you know?",
              style: TextStyle(
                fontFamily: "segeo",
                fontSize: 16,
                color: Color(0xff666666),
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 12),

            Text(
              "Select languages you speak",
              style: TextStyle(
                fontFamily: "segeo",
                fontSize: 14,
                color: Color(0xff666666),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 32),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: _allLanguages.map((lang) {
                final isSelected = _selected.contains(lang);
                return _SelectablePill(
                  text: lang,
                  selected: isSelected,
                  onTap: () {
                    setState(() {
                      isSelected ? _selected.remove(lang) : _selected.add(lang);
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 36),
          child: CustomAppButton1(
            text: 'Next',
            onPlusTap: () {
              if (_selected.isEmpty) {
                CustomSnackBar1.show(
                  context,
                  "Please select at least one language.",
                );
              } else {
                final Map<String, dynamic> data = {
                  ...widget.data,
                  "langages[]": _selected.toList(),
                };
                context.push("/subtopicselect_screen", extra: data);
              }
            },
          ),
        ),
      ),
    );
  }
}

class _SelectablePill extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _SelectablePill({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFF1A73E8) : Colors.transparent,
            width: 1.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'segeo',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? const Color(0xFF1A73E8) : const Color(0xFF222222),
          ),
        ),
      ),
    );
  }
}

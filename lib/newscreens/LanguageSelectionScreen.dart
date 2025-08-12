import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

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
    'Mahrati',
    'Gujarati',
    'Bengali',
    'Odia',
  ];

  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5FF),
      appBar: AppBar(
        backgroundColor: const Color(0xffFAF5FF),
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Illustration (200x200)
            Center(
              child: Image.asset(
                'assets/images/languagesscreenimg.png',
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 24),

            // Title
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
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 8),

            const Align(
              alignment: AlignmentDirectional(-1, -1),
              child: Text(
                "How many languages you know?",
                style: TextStyle(
                  fontFamily: "segeo",
                  fontSize: 16,
                  color: Color(0xff666666),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 4),

            const Align(
              alignment: AlignmentDirectional(-1, -1),
              child: Text(
                "Select languages you speak",
                style: TextStyle(
                  fontFamily: "segeo",
                  fontSize: 14,
                  color: Color(0xff666666),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 16),

            // Language chips (updated)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Wrap(
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
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: InkWell(
                onTap: () {
                  context.push("/topicselection");
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFA258F7),
                        Color(0xFF726CF7),
                        Color(0xFF4280F6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- helper: pill chip exactly like the screenshot ---
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical:11 ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFF1A73E8) : Colors.transparent,
            width: 1.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000), // very subtle drop shadow
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

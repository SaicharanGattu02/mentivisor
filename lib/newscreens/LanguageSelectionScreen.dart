import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Color(0xFFFAF5FF),
      appBar: AppBar(
        backgroundColor: Color(0xffFAF5FF),
        elevation: 0,
        leading: BackButton(color: Colors.black87),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 16),

            // Illustration (200x200)
            Center(
              child: Image.asset(
                'assets/images/languagesscreenimg.png', // your 200×200 asset
                width: 200,
                height: 200,
              ),
            ),
            SizedBox(height: 24),
            // Title
            Align(
              alignment: AlignmentGeometry.directional(-1, -1),

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
            SizedBox(height: 8),
            Align(
              alignment: AlignmentGeometry.directional(-1, -1),
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
            SizedBox(height: 4),
            Align(
              alignment: AlignmentGeometry.directional(-1, -1),
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
            SizedBox(height: 16),
            // Language chips
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _allLanguages.map((lang) {
                    final selected = _selected.contains(lang);
                    return ChoiceChip(
                      color: WidgetStateProperty.all(Colors.white),
                      label: Text(lang),
                      selected: selected,
                      onSelected: (_) {
                        setState(() {
                          if (selected)
                            _selected.remove(lang);
                          else
                            _selected.add(lang);
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: Color(0xFF1A73E8).withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: selected ? Color(0xFF1A73E8) : Colors.black87,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Next button
          ],
        ),
      ),
      bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min
        ,
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: InkWell(
                onTap: () {
                  // Next button action
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

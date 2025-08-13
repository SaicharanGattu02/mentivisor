import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/newscreens/CostPerMinuteScreen.dart';

import '../Components/CustomAppButton.dart';

class SubTopicSelectionScreen extends StatefulWidget {
  const SubTopicSelectionScreen({super.key});

  @override
  State<SubTopicSelectionScreen> createState() =>
      _SubTopicSelectionScreenState();
}

class _SubTopicSelectionScreenState extends State<SubTopicSelectionScreen> {
  String? selectedTopic;
  String? selectedSubTopic;

  final List<String> subTopics = [
    'AI in Ethics',
    'Deep Learning',
    'Machine Learning',
    'Natural Language Processing',
    'Neural network',
    'AI adds intelligence',
    'Robotics',
    'Ethics and bias',
    'Computer vision',
  ];

  final List<String> otherTopics = [
    'UIUX Design',
    'Project Management',
    'UX Research',
    'Data Analysis',
    'Devops',
    'Digital Marketing and SEO',
    'Cloud Computing',
    'Data Science',
    'Cyber Security',
  ];

  final Set<String> pickedSubTopics = {};
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSubs = subTopics
        .where((t) => t.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF5FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF5FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFAF5FF),
              Color(0xFFF5F6FF),
              Color(0xFFEFF6FF),
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  'Now Select topic you want to\nmentor',
                  style: TextStyle(
                    fontSize: 22,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'segeo',
                    color: Color(0xFF2563EC),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                      fontFamily: 'segeo',
                      color: Color(0xFF9AA3B2),
                    ),
                    prefixIcon: const Icon(Icons.search_rounded),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    filled: true,
                    fillColor: const Color(0xFFE9EDF2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'segeo',
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (selectedTopic != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7F00FF), Color(0xFF00BFFF)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedTopic ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => setState(() {
                            selectedTopic = null;
                            selectedSubTopic = null;
                          }),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.2),
                              border: Border.all(color: Colors.white, width: 1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (selectedTopic == null)
                        DottedBorder(
                          color: const Color(0xFFD9BFC4),
                          strokeWidth: 1.2,
                          dashPattern: const [6, 4],
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(16),
                          padding: const EdgeInsets.all(12),
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: otherTopics.map((t) {
                              return _PillChip(
                                text: t,
                                selected: false,
                                onTap: () {
                                  setState(() {
                                    selectedTopic = t;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      if (selectedTopic != null)
                        DottedBorder(
                          color: const Color(0xFFD9BFC4),
                          strokeWidth: 1.2,
                          dashPattern: const [6, 4],
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(16),
                          padding: const EdgeInsets.all(12),
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: filteredSubs.map((t) {
                              final isPicked = pickedSubTopics.contains(t);
                              return _PillChip(
                                text: t,
                                selected: isPicked,
                                onTap: () {
                                  setState(() {
                                    isPicked
                                        ? pickedSubTopics.remove(t)
                                        : pickedSubTopics.add(t);
                                    selectedSubTopic = t;
                                  });
                                },
                                selectedBorder: const Color(0xFFC9CED6),
                                selectedText: const Color(0xFF2F3B52),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: CustomAppButton1(
          text: "Next",
          onPlusTap: () {
            context.push("/costperminute_screen"); // Update with your actual route
          },
        ),
      ),
    );
  }
}

class _PillChip extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedBorder;
  final Color selectedText;

  const _PillChip({
    required this.text,
    required this.selected,
    required this.onTap,
    this.selectedBorder = const Color(0xFF1A73E8),
    this.selectedText = const Color(0xFF1A73E8),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? selectedBorder : Colors.transparent,
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
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: selected ? selectedText : const Color(0xFF2F3B52),
          ),
        ),
      ),
    );
  }
}

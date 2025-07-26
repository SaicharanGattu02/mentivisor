import 'package:flutter/material.dart';

import 'CostPerMinuteScreen.dart';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class SubTopicSelectionScreen extends StatefulWidget {
  @override
  _SubTopicSelectionScreenState createState() =>
      _SubTopicSelectionScreenState();
}

class _SubTopicSelectionScreenState extends State<SubTopicSelectionScreen> {
  final String selectedTopic = 'Artificial Intelligence';

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
    'UI/UX Design',
    'Project Management',
    'UX Research',
    'Data Analysis',
    'DevOps',
    'Digital Marketing and SEO',
    'Cloud Computing',
    'Data Science',
    'Cyber Security',
  ];

  final Set<String> pickedSubTopics = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F5FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ← Back arrow
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),

            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Select topic you want to mentor',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'segeo',
                  color: Color(0xff2563EC),
                ),
              ),
            ),

            SizedBox(height: 42),

            // Selected main topic pill
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF7F00FF),
                      Color(0xFF00BFFF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  selectedTopic,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            SizedBox(height: 26),

            // Sub-topics in a dashed box
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    DottedBorder(
                      dashPattern: [4, 4],
                      color: Color(0xffD2C1C1),
                      borderType: BorderType.RRect,
                      radius: Radius.circular(12),
                      padding: EdgeInsets.all(12),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: subTopics.map((t) {
                          final isPicked = pickedSubTopics.contains(t);
                          return ChoiceChip(
                            label: Text(t),
                            selected: isPicked,
                            onSelected: (sel) => setState(() {
                              sel
                                  ? pickedSubTopics.add(t)
                                  : pickedSubTopics.remove(t);
                            }),
                            backgroundColor: Colors.white,
                            selectedColor:
                            Colors.blueAccent.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: isPicked
                                  ? Colors.blueAccent
                                  : Colors.black87,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(height: 60),

                    // Other topics (unchosen) at bottom
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: otherTopics.map((t) {
                        return ChoiceChip(
                          label: Text(t),
                          selected: false,
                          onSelected: (_) {},
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(color: Colors.black87),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Next button
            Padding(
              padding: EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: (




                    ) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CostPerMinuteScreen()),
                  );
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF7F00FF),
                        Color(0xFF00BFFF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

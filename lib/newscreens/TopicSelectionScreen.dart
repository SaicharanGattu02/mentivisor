import 'package:flutter/material.dart';
import 'package:mentivisor/newscreens/SubTopicSelectionScreen.dart';



class TopicSelectionScreen extends StatefulWidget {
  @override
  _TopicSelectionScreenState createState() => _TopicSelectionScreenState();
}

class _TopicSelectionScreenState extends State<TopicSelectionScreen> {
  final List<String> topics = [
    'Artificial Intelligence',
    'Cyber Security',
    'Data Science',
    'UI/UX Design',
    'DevOps',
    'UX Research',
    'Data Analysis',
    'Project Management',
    'Digital Marketing and SEO',
    'Cloud Computing',
  ];

  final Set<String> selectedTopics = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F5FA), // light pastel bg
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // back arrow
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),

            // title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Now Select topic you want to mentor',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'segeo',
                  color: Color(0xff2563EC),
                  // matching your blue text
                ),
              ),
            ),

            // pills
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: topics.map((t) {
                    final isSelected = selectedTopics.contains(t);
                    return ChoiceChip(
                      label: Text(t),
                      selected: isSelected,
                      onSelected: (sel) {
                        setState(() {
                          sel ? selectedTopics.add(t) : selectedTopics.remove(t);
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: Colors.blueAccent.withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.blueAccent : Colors.black87,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubTopicSelectionScreen()),
                  );
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF7F00FF), // purple
                        Color(0xFF00BFFF), // blue
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'segeo',
                        fontSize: 14,

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


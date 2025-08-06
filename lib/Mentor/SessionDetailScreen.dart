import 'package:flutter/material.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';

import '../Components/CustomAppButton.dart';

class SessionDetailScreen extends StatelessWidget {
  const SessionDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Session Details", actions: []),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffFAF5FF), Color(0xffF5F6FF), Color(0xffEFF6FF)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '5th Jun 2025',
                          style: TextStyle(
                            fontFamily: 'Segeo',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'with Suresh from SVG collage',
                          style: TextStyle(
                            fontFamily: 'Segeo',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          width: 125,
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              '45 Minutes to go',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Segeo',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      "assets/images/image.png",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Session Topics',
              style: TextStyle(
                fontFamily: 'Segeo',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s...',
              style: TextStyle(
                fontFamily: 'Segeo',
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CustomAppButton(text: "Okay", onPlusTap: () {}),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: SessionDetailScreen()));
}

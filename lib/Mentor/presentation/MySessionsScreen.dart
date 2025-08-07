import 'package:flutter/material.dart';
import 'package:mentivisor/Mentor/presentation/widgets/SessionCard.dart';
import '../../Mentee/presentation/Widgets/FilterButton.dart';

class Session {
  final String status;
  final String sessionDate;
  final String sessionTime;
  final String sessionName;
  final String sessionImage;
  final String sessionTopics;
  final String buttonText;
  final String buttonIcon;
  final String? reason;

  Session({
    required this.status,
    required this.sessionDate,
    required this.sessionTime,
    required this.sessionName,
    required this.sessionImage,
    required this.sessionTopics,
    required this.buttonText,
    required this.buttonIcon,
    this.reason,
  });
}

class MySessionsScreen extends StatefulWidget {
  @override
  _MySessionsScreenState createState() => _MySessionsScreenState();
}

class _MySessionsScreenState extends State<MySessionsScreen> {
  // Initial list of sessions
  final List<Session> sessions = [
    // Upcoming session
    Session(
      status: 'Upcoming',
      sessionDate: '5th Jun 2025',
      sessionTime: '45 Minutes to go',
      sessionName: 'with Suresh from SVG collage',
      sessionImage: 'assets/images/image.png', // Replace with your image asset
      sessionTopics: 'Lorem Ipsum is simply dummy text of the printing...',
      buttonText: 'Message from Ramesh',
      buttonIcon: 'assets/icons/chaticon.png', // Replace with your icon asset
    ),
    // Completed session
    Session(
      status: 'Completed',
      sessionDate: '4th Jun 2025',
      sessionTime: 'Completed',
      sessionName: 'with Suresh from SVG collage',
      sessionImage: 'assets/images/image.png', // Replace with your image asset
      sessionTopics: 'Lorem Ipsum has been the...',
      buttonText: 'Report Mentee',
      buttonIcon: 'assets/icons/report.png', // Replace with your icon asset
    ),
    // Cancelled session
    Session(
      status: 'Cancelled',
      sessionDate: '3rd Jun 2025',
      sessionTime: 'Cancelled',
      sessionName: 'with Suresh from SVG collage',
      sessionImage: 'assets/images/image.png', // Replace with your image asset
      sessionTopics: 'Lorem Ipsum is simply dummy text...',
      buttonText: 'No Action',
      buttonIcon: 'assets/icons/chaticon.png', // Replace with your icon asset
      reason: 'Session was cancelled due to unforeseen circumstances.',
    ),
  ];

  // Add a variable to track the selected filter
  String selectedFilter = 'Upcoming'; // Default to 'Upcoming'

  // Method to filter sessions based on selected filter
  List<Session> getFilteredSessions() {
    return sessions.where((session) {
      if (selectedFilter == 'Upcoming') {
        return session.status == 'Upcoming';
      } else if (selectedFilter == 'Completed') {
        return session.status == 'Completed';
      } else {
        return session.status == 'Cancelled';
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffFAF5FF), Color(0xffF5F6FF), Color(0xffEFF6FF)],
          ),
        ),
        child: Column(
          spacing: 10,
          children: [
            Container(
              height: 53,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xffDBE5FB),
                borderRadius: BorderRadius.circular(36),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilterButton(
                    text: 'Upcoming',
                    isSelected: selectedFilter == 'Upcoming',
                    onPressed: () {
                      setState(() {
                        selectedFilter = 'Upcoming';
                      });
                    },
                  ),
                  FilterButton(
                    text: 'Completed',
                    isSelected: selectedFilter == 'Completed',
                    onPressed: () {
                      setState(() {
                        selectedFilter = 'Completed';
                      });
                    },
                  ),
                  FilterButton(
                    text: 'Cancelled',
                    isSelected: selectedFilter == 'Cancelled',
                    onPressed: () {
                      setState(() {
                        selectedFilter = 'Cancelled';
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // SliverList for filtered sessions
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      // Get filtered sessions
                      List<Session> filteredSessions = getFilteredSessions();

                      return SessionCard(
                        status: filteredSessions[index].status,
                        sessionDate: filteredSessions[index].sessionDate,
                        sessionTime: filteredSessions[index].sessionTime,
                        sessionName: filteredSessions[index].sessionName,
                        sessionImage: filteredSessions[index].sessionImage,
                        sessionTopics: filteredSessions[index].sessionTopics,
                        reason: filteredSessions[index].reason ?? '',
                        buttonText: filteredSessions[index].buttonText,
                        buttonIcon: filteredSessions[index].buttonIcon,
                        remainingTime:
                            filteredSessions[index].status == 'Upcoming'
                            ? filteredSessions[index].sessionTime
                            : '',
                      );
                    }, childCount: getFilteredSessions().length),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

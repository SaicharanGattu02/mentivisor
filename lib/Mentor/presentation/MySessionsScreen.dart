import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mentivisor/Mentor/presentation/widgets/SessionCard.dart';
import '../../Mentee/presentation/Widgets/FilterButton.dart';
import '../data/Cubits/Sessions/SessionsCubit.dart';
import '../data/Cubits/Sessions/SessionsStates.dart';

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
  String selectedFilter = 'upcoming';

  @override
  void initState() {
    super.initState();
    context.read<SessionCubit>().getSessions(selectedFilter);
  }

  String calculateDuration(String start, String end) {
    try {
      final format = DateFormat("hh:mm a"); // e.g. 11:35 AM
      final startTime = format.parse(start);
      final endTime = format.parse(end);

      final diff = endTime.difference(startTime);

      final hours = diff.inHours;
      final minutes = diff.inMinutes.remainder(60);

      if (hours > 0) {
        return "$hours hr ${minutes > 0 ? "$minutes min" : ""}".trim();
      } else {
        return "$minutes min";
      }
    } catch (e) {
      return "";
    }
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
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xffDBE5FB),
                borderRadius: BorderRadius.circular(36),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilterButton(
                    text: 'Upcoming',
                    isSelected: selectedFilter == 'upcoming',
                    onPressed: () {
                      setState(() {
                        selectedFilter = 'upcoming';
                        context.read<SessionCubit>().getSessions(
                          selectedFilter,
                        );
                      });
                    },
                  ),
                  FilterButton(
                    text: 'Completed',
                    isSelected: selectedFilter == 'completed',
                    onPressed: () {
                      setState(() {
                        selectedFilter = 'completed';
                        context.read<SessionCubit>().getSessions(
                          selectedFilter,
                        );
                      });
                    },
                  ),
                  FilterButton(
                    text: 'Cancelled',
                    isSelected: selectedFilter == 'cancelled',
                    onPressed: () {
                      setState(() {
                        selectedFilter = 'cancelled';
                        context.read<SessionCubit>().getSessions(
                          selectedFilter,
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<SessionCubit, SessionStates>(
                builder: (context, state) {
                  if (state is SessionLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is SessionLoaded) {
                    final Sessions = state.sessionsModel.data;
                    if (Sessions?.length == 0) {
                      return Center(child: Column());
                    }
                    return CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                              ) {
                            final session = Sessions?[index];
                            final duration = calculateDuration(
                              session?.startTime ?? "",
                              session?.endTime ?? "",
                            );
                            return SessionCard(
                              status: 'Upcoming',
                              sessionDate: session?.date ?? "",
                              sessionTime: '${duration} Minutes to go',
                              sessionName:
                              'G-Meet with Suresh from SVG Collage',
                              sessionImage:
                              session?.mentee?.menteeProfile ??
                                  "", // Image for upcoming sessions
                              sessionTopics: session?.topics ?? "",
                              reason: '',
                              buttonText:
                              'Message from ${session?.mentee?.name ?? ""}',
                              buttonIcon: 'assets/icons/chaticon.png',
                              remainingTime: '${duration} Minutes to go', // Time remaining for upcoming session
                            );
                          }, childCount: Sessions?.length),
                        ),
                      ],
                    );
                  } else {
                    return Center(child: Text("No Data Found"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

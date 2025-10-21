import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mentivisor/Mentor/presentation/widgets/SessionCard.dart';
import 'package:mentivisor/Mentor/presentation/widgets/SessionShimmerLoader.dart';
import '../../Components/CommonLoader.dart';
import '../../Mentee/presentation/Widgets/FilterButton.dart';
import '../../utils/constants.dart';
import '../../utils/media_query_helper.dart';
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
  final String? selectedFilter;
  const MySessionsScreen({super.key, this.selectedFilter});
  @override
  _MySessionsScreenState createState() => _MySessionsScreenState();
}

class _MySessionsScreenState extends State<MySessionsScreen> {
  late String selectedFilter;

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.selectedFilter ?? 'upcoming';
    context.read<SessionCubit>().getSessions(selectedFilter);
  }

  String calculateDuration(String start, String end) {
    try {
      final format = DateFormat("hh:mm a");
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
              decoration: BoxDecoration(
                color: Color(0xffDBE5FB),
                borderRadius: BorderRadius.circular(36),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
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
            ),

            Expanded(
              child: BlocBuilder<SessionCubit, SessionStates>(
                builder: (context, state) {
                  if (state is SessionLoading) {
                    return const SessionShimmerLoader(itemCount: 5);
                  } else if (state is SessionLoaded) {
                    final Sessions = state.sessionsModel.data;
                    if (Sessions?.length == 0) {
                      return Center(
                        child: Column(
                          spacing: 6,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/nodata.png"),
                            Text(
                              "Oops!",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff666666),
                              ),
                            ),
                            Text(
                              "No Sessions Found",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff444444),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return CustomScrollView(
                      slivers: [
                        // SliverList(
                        //   delegate: SliverChildBuilderDelegate((
                        //     context,
                        //     index,
                        //   ) {
                        //     final session = Sessions?[index];
                        //     final duration = calculateDuration(
                        //       session?.startTime ?? "",
                        //       session?.endTime ?? "",
                        //     );
                        //     return SessionCard(
                        //       attachment: session?.attachment ?? "",
                        //       menteeId: session?.mentee?.id ?? 0,
                        //       sessionId: session?.id ?? 0,
                        //       status: selectedFilter,
                        //       sessionStartTime: '${session?.startTime ?? ""}',
                        //       sessionEndTime: '${session?.endTime ?? ""}',
                        //       sessionDate: formatDate(session?.date ?? ""),
                        //       sessionTime: '${duration} to go',
                        //       sessionName:
                        //           'Zoom Meet with ${session?.mentee?.name}',
                        //       sessionImage:
                        //           session?.mentee?.menteeProfile ??
                        //           "", // Image for upcoming sessions
                        //       sessionTopics: session?.topics ?? "",
                        //       reason: session?.cancelledReason ?? "",
                        //       buttonText:
                        //           'Message from ${session?.mentee?.name ?? ""}',
                        //       buttonIcon: "assets/icons/ChatCircle.png",
                        //       remainingTime: '${duration} Minutes to go',
                        //       cancelreason: session?.cancelledReason ?? "",
                        //     );
                        //   }, childCount: Sessions?.length),
                        // ),
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: _getCrossAxisCount(context),
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: _getChildAspectRatio(context),
                              ),
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
                              attachment: session?.attachment ?? "",
                              menteeId: session?.mentee?.id ?? 0,
                              sessionId: session?.id ?? 0,
                              status: selectedFilter,
                              sessionStartTime: '${session?.startTime ?? ""}',
                              sessionEndTime: '${session?.endTime ?? ""}',
                              sessionDate: formatDate(session?.date ?? ""),
                              sessionTime: '${duration} to go',
                              sessionName:
                                  'Zoom Meet with ${session?.mentee?.name}',
                              sessionImage:
                                  session?.mentee?.menteeProfile ??
                                  "", // Image for upcoming sessions
                              sessionTopics: session?.topics ?? "",
                              reason: session?.cancelledReason ?? "",
                              buttonText:
                                  'Message from ${session?.mentee?.name ?? ""}',
                              buttonIcon: "assets/icons/ChatCircle.png",
                              remainingTime: '${duration} Minutes to go',
                              cancelreason: session?.cancelledReason ?? "",
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

  int _getCrossAxisCount(BuildContext context) {
    final width = SizeConfig.screenWidth;
    if (width < 600) {
      return 1; // 1 column for mobile
    } else if (width > 600) {
      return 2; // 2 columns for tablets and larger
    } else {
      return 2; // For exactly 600px (edge case), treat as tablet layout
    }
  }

  double _getChildAspectRatio(BuildContext context) {
    final screenWidth = SizeConfig.screenWidth;
    if (screenWidth < 600) {
      return 1.8;
    } else {
      return 1.8; // Slightly wider aspect for balanced layout
    }
  }
}

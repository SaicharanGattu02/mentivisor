import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/UpComingSessions/up_coming_session_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/UpComingSessions/up_coming_session_states.dart';
import 'package:mentivisor/utils/media_query_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Components/CommonLoader.dart';
import '../../Components/Shimmers.dart';
import '../../utils/color_constants.dart';
import '../../utils/constants.dart';

class UpcomingSessionsScreen extends StatefulWidget {
  const UpcomingSessionsScreen({Key? key}) : super(key: key);

  @override
  State<UpcomingSessionsScreen> createState() => _UpcomingSessionsScreenState();
}

class _UpcomingSessionsScreenState extends State<UpcomingSessionsScreen> {
  final ValueNotifier<Map<int, bool>> chatVisibilityNotifier = ValueNotifier(
    {},
  );

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(minutes: 1), (timer) {
      // Trigger recomputation for all items (or just refresh logic)
      final updatedMap = {...chatVisibilityNotifier.value};
      chatVisibilityNotifier.value = updatedMap;
    });
    context.read<UpComingSessionCubit>().upComingSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: CustomAppBar1(title: "Upcoming Sessions", actions: const []),
      body: SafeArea(
        child: BlocBuilder<UpComingSessionCubit, UpComingSessionStates>(
          builder: (context, state) {
            if (state is UpComingSessionsLoading) {
              return UpcomingSessionsShimmer();
            } else if (state is UpComingSessionLoaded) {
              final items = state.upComingSessionModel.data;

              if (items == null || items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/nodata/no_data.png", height: 120),
                      const SizedBox(height: 16),
                      const Text(
                        "No upcoming session available",
                        style: TextStyle(
                          fontFamily: "segeo",
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final upComingSessions = items[index];
                        if (upComingSessions == null) {
                          return const SizedBox.shrink();
                        }
                        final now = DateTime.now();
                        final sessionDateStr = upComingSessions.date ?? "";
                        final startTimeStr = upComingSessions.startTime ?? "";
                        final endTimeStr = upComingSessions.endTime ?? "";

                        bool showChatButton = false;

                        try {
                          final sessionDate = DateFormat(
                            "yyyy-MM-dd",
                          ).parse(sessionDateStr);
                          final startTime = DateFormat(
                            "h:mm a",
                          ).parse(startTimeStr);
                          final endTime = DateFormat(
                            "h:mm a",
                          ).parse(endTimeStr);

                          final sessionStart = DateTime(
                            sessionDate.year,
                            sessionDate.month,
                            sessionDate.day,
                            startTime.hour,
                            startTime.minute,
                          );

                          final sessionEnd = DateTime(
                            sessionDate.year,
                            sessionDate.month,
                            sessionDate.day,
                            endTime.hour,
                            endTime.minute,
                          );

                          if (now.isAfter(sessionStart) &&
                              now.isBefore(sessionEnd)) {
                            showChatButton = true;
                          }
                        } catch (e) {
                          print("DateTime parse error: $e");
                        }

                        if (chatVisibilityNotifier.value[upComingSessions.id] !=
                            showChatButton) {
                          final updatedMap = Map<int, bool>.from(
                            chatVisibilityNotifier.value,
                          );
                          updatedMap[upComingSessions.id ?? 0] = showChatButton;
                          chatVisibilityNotifier.value = updatedMap;
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: SizeConfig.screenWidth * 0.525,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      upComingSessions.topics?.isNotEmpty ??
                                              false
                                          ? upComingSessions.topics ?? ""
                                          : "No topics specified",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "segeo",
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      "With ${capitalize(upComingSessions.mentor?.name ?? "Unknown Mentor")}",

                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "segeo",
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 8,
                                      children: [
                                        _buildInfoChip(
                                          icon: Icons.calendar_today,
                                          label: formatDate(
                                            upComingSessions.date ?? "N/A",
                                          ),
                                          color: Colors.blue.shade50,
                                          textColor: Colors.blue.shade700,
                                        ),
                                        _buildInfoChip(
                                          icon: Icons.access_time,
                                          label:
                                              "${upComingSessions.startTime ?? 'N/A'} - ${upComingSessions.endTime ?? 'N/A'}",
                                          color: Colors.blue.shade50,
                                          textColor: Colors.blue.shade700,
                                        ),
                                        _buildInfoChip(
                                          icon: Icons.videocam,
                                          label:
                                              upComingSessions.zoomLink
                                                      ?.contains("zoom.us") ??
                                                  false
                                              ? "Zoom"
                                              : "Video Call",
                                          color: Colors.blue.shade50,
                                          textColor: Colors.blue.shade700,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // if()...[OutlinedButton.icon(
                                    //   onPressed: () {
                                    //     context.push(
                                    //       '/chat?receiverId=${upComingSessions.mentor?.id}&sessionId=${upComingSessions.id}',
                                    //     );
                                    //   },
                                    //   icon: Image.asset(
                                    //     "assets/icons/ChatCircle.png",
                                    //     width: 20,
                                    //     height: 20,
                                    //   ),
                                    //   label: SizedBox(
                                    //     width: SizeConfig.screenWidth * 0.28,
                                    //     child: Text(
                                    //       "Chat with ${upComingSessions.mentor?.name ?? 'Mentor'}",
                                    //       overflow: TextOverflow.ellipsis,
                                    //       style: const TextStyle(
                                    //         fontSize: 14,
                                    //         fontWeight: FontWeight.w600,
                                    //         fontFamily: "segeo",
                                    //         color: Color(0xff666666),
                                    //       ),
                                    //     ),
                                    //   ),
                                    //   style: OutlinedButton.styleFrom(
                                    //     side: BorderSide(
                                    //       color: Color(0xffCCCCCC),
                                    //       width: 1,
                                    //     ),
                                    //     shape: RoundedRectangleBorder(
                                    //       borderRadius: BorderRadius.circular(
                                    //         8,
                                    //       ),
                                    //     ),
                                    //     padding: EdgeInsets.symmetric(
                                    //       vertical: 8,
                                    //       horizontal: 12,
                                    //     ),
                                    //   ),
                                    // )]
                                    ValueListenableBuilder<Map<int, bool>>(
                                      valueListenable: chatVisibilityNotifier,
                                      builder: (context, visibilityMap, _) {
                                        final showChat =
                                            visibilityMap[upComingSessions
                                                .id] ??
                                            false;

                                        if (!showChat)
                                          return const SizedBox.shrink();

                                        return OutlinedButton.icon(
                                          onPressed: () {
                                            context.push(
                                              '/chat?receiverId=${upComingSessions.mentor?.id}&sessionId=${upComingSessions.id}',
                                            );
                                          },
                                          icon: Image.asset(
                                            "assets/icons/ChatCircle.png",
                                            width: 20,
                                            height: 20,
                                          ),
                                          label: SizedBox(
                                            width:
                                                SizeConfig.screenWidth * 0.28,
                                            child: Text(
                                              "Chat with ${upComingSessions.mentor?.name ?? 'Mentor'}",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "segeo",
                                                color: Color(0xff666666),
                                              ),
                                            ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                              color: Color(0xffCCCCCC),
                                              width: 1,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal: 12,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: SizeConfig.screenWidth * 0.34,
                                child: Column(
                                  children: [
                                    ClipOval(
                                      child: CachedNetworkImage(
                                        width: 56,
                                        height: 56,
                                        imageUrl:
                                            upComingSessions
                                                .mentor
                                                ?.mentorProfile ??
                                            "",
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          width: 56,
                                          height: 56,
                                          color: Colors.grey.shade200,
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.blue,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                              width: 56,
                                              height: 56,
                                              color: Colors.grey.shade200,
                                              child: Image.asset(
                                                "assets/images/profile.png",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ValueListenableBuilder<Map<int, bool>>(
                                      valueListenable: chatVisibilityNotifier,
                                      builder: (context, visibilityMap, _) {
                                        final showJoin =
                                            visibilityMap[upComingSessions.id ??
                                                0] ??
                                            false;

                                        if (!showJoin)
                                          return const SizedBox.shrink();

                                        return CustomAppButton1(
                                          height: 45,
                                          width: SizeConfig.screenWidth * 0.33,
                                          text: "Join Session",
                                          onPlusTap: () async {
                                            final url =
                                                upComingSessions.zoomLink;
                                            if (url != null &&
                                                await canLaunchUrl(
                                                  Uri.parse(url),
                                                )) {
                                              await launchUrl(Uri.parse(url));
                                            } else {
                                              CustomSnackBar1.show(
                                                context,
                                                "Unable to open Zoom link",
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }, childCount: items.length),
                    ),
                  ),
                ],
              );
            } else if (state is UpComingSessionFailure) {
              return Center(
                child: Text(
                  state.msg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: "segeo",
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              );
            }
            return const Center(
              child: Text(
                "No data available",
                style: TextStyle(
                  fontFamily: "segeo",
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _buildInfoChip({
  required IconData icon,
  required String label,
  required Color color,
  required Color textColor,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: textColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontFamily: "segeo",
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

class UpcomingSessionsShimmer extends StatelessWidget {
  const UpcomingSessionsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.525,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            shimmerText(200, 18, context),
                            SizedBox(height: 8),
                            shimmerText(150, 14, context),
                            SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              children: [
                                _buildChipShimmer(context, 100),
                                _buildChipShimmer(context, 120),
                                _buildChipShimmer(context, 80),
                              ],
                            ),

                            SizedBox(height: 16),
                            Row(
                              spacing: 10,
                              children: [
                                shimmerContainer(
                                  SizeConfig.screenWidth * 0.33,
                                  40,
                                  context,
                                ),
                                // shimmerContainer(
                                //   SizeConfig.screenWidth * 0.33,
                                //   40,
                                //   context,
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.34,
                        child: Column(children: [shimmerCircle(80, context)]),
                      ),
                    ],
                  ),
                );
              },
              childCount: 5, // Number of shimmer placeholders
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChipShimmer(BuildContext context, double width) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blue.shade50.withOpacity(0.5),
      ),
      child: shimmerText(width, 12, context),
    );
  }
}

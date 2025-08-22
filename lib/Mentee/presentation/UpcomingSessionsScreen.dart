import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/UpComingSessions/up_coming_session_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/UpComingSessions/up_coming_session_states.dart';
import 'package:mentivisor/utils/media_query_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/color_constants.dart';
import '../../utils/constants.dart';

class UpcomingSessionsScreen extends StatefulWidget {
  const UpcomingSessionsScreen({Key? key}) : super(key: key);

  @override
  State<UpcomingSessionsScreen> createState() => _UpcomingSessionsScreenState();
}

class _UpcomingSessionsScreenState extends State<UpcomingSessionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UpComingSessionCubit>().upComingSessions();
    });
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
              return Center(
                child: CircularProgressIndicator(color: primarycolor),
              );
            } else if (state is UpComingSessionLoaded) {
              final items = state.upComingSessionModel.data;

              if (items == null || items.isEmpty) {
                return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Image.asset(
                      "assets/nodata/no_data.png", // <-- your no-data image path
                      height: 120,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No data available",
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
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final upComingSessions = items[index];
                          if (upComingSessions == null) {
                            return const SizedBox.shrink();
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
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
                                        capitalize(
                                          upComingSessions.mentor?.name ??
                                              "Unknown Mentor",
                                        ),
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
                                            label:
                                            upComingSessions.date ?? "N/A",
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
                                            label: upComingSessions.zoomLink
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
                                      OutlinedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.chat_bubble_outline,
                                          size: 16,
                                          color: Colors.black87,
                                        ),
                                        label: Text(
                                          "Chat with ${upComingSessions.mentor?.name ?? 'Mentor'}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontFamily: "segeo",
                                            color: Colors.black87,
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: Colors.grey.shade300,
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
                                          imageUrl: upComingSessions
                                              .mentor?.mentorProfile ??
                                              "",
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                                width: 56,
                                                height: 56,
                                                color: Colors.grey.shade200,
                                                child: const Center(
                                                  child:
                                                  CircularProgressIndicator(
                                                    valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.blue),
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
                                      CustomAppButton1(
                                        height: 45,
                                        width: SizeConfig.screenWidth * 0.33,
                                        text: "Join Session",
                                        onPlusTap: () async {
                                          final url =
                                              upComingSessions.zoomLink;
                                          if (url != null &&
                                              await canLaunchUrl(
                                                  Uri.parse(url))) {
                                            await launchUrl(Uri.parse(url));
                                          } else {
                                            CustomSnackBar1.show(
                                              context,
                                              "Unable to open Zoom link",
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: items.length,
                      ),
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

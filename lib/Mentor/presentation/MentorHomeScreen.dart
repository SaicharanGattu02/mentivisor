import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorDashboardCubit/mentor_dashbaord_states.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorDashboardCubit/mentor_dashboard_cubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/Sessions/SessionsCubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/Sessions/SessionsStates.dart';
import 'package:mentivisor/Mentor/presentation/MentorDashBoard.dart';
import 'package:mentivisor/Mentor/presentation/widgets/SessionCard.dart';
import 'package:mentivisor/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Mentee/data/cubits/GetBanners/GetBannersCubit.dart';
import '../../Mentee/data/cubits/GetBanners/GetBannersState.dart';
import '../../utils/color_constants.dart';
import '../../utils/media_query_helper.dart';

class MentorHomeScreen extends StatefulWidget {
  const MentorHomeScreen({Key? key}) : super(key: key);

  @override
  State<MentorHomeScreen> createState() => _MentorHomeScreenState();
}

class _MentorHomeScreenState extends State<MentorHomeScreen> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  @override
  void initState() {
    super.initState();
    context.read<MentorDashboardCubit>().fetchDashboard();
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAF5FF), Color(0xFFF5F6FF), Color(0xFFEFF6FF)],
          ),
        ),
        child: BlocBuilder<MentorDashboardCubit, MentorDashBoardState>(
          builder: (context, state) {
            if (state is MentorDashBoardLoading) {
              return Center(child: DottedProgressWithLogo());
            } else if (state is MentorDashBoardLoaded) {
              final banners_data = state.getBannersRespModel;
              final session_data = state.sessionsModel;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      CarouselSlider.builder(
                        itemCount: banners_data?.data?.length ?? 0,
                        itemBuilder: (ctx, i, _) {
                          final b = banners_data?.data?[i];
                          return GestureDetector(
                            onTap: () {
                              if (b?.link != null) _launchUrl(b?.link ?? "");
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2.5,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  b?.imgUrl ?? '',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey[200],
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 180,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 4),
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            _currentIndex.value = index;
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      ValueListenableBuilder<int>(
                        valueListenable: _currentIndex,
                        builder: (context, currentIndex, _) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              banners_data?.data?.length ?? 0,
                              (index) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  height: SizeConfig.screenHeight * 0.008,
                                  width: currentIndex == index
                                      ? SizeConfig.screenWidth * 0.05
                                      : SizeConfig.screenWidth * 0.014,
                                  decoration: BoxDecoration(
                                    color: currentIndex == index
                                        ? primarycolor
                                        : Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'Upcoming Session',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'segeo',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: session_data?.data?.length == 0
                        ? Center(
                            child: Column(
                              spacing: 6,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/nodata.png"),
                                Text(
                                  "No mentees in sight!",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff666666),
                                  ),
                                ),
                                Text(
                                  "Share your profile for good reach",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff444444),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : CustomScrollView(
                            slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
                                  final session = session_data?.data?[index];
                                  final duration = calculateDuration(
                                    session?.startTime ?? "",
                                    session?.endTime ?? "",
                                  );
                                  return SessionCard(
                                    attachment: session?.attachment ?? "",
                                    sessionLink: session?.zoomLink ?? "",
                                    sessionId: session?.id ?? 0,
                                    status: 'upcoming',
                                    sessionDate: formatDate(
                                      session?.date ?? "",
                                    ),
                                    sessionStartTime:
                                        '${session?.startTime ?? ""}',
                                    sessionEndTime: '${session?.endTime ?? ""}',
                                    sessionTime: '${duration}  to go',
                                    sessionName:
                                        'Zoom Meet with ${session?.mentee?.name}',
                                    sessionImage:
                                        session?.mentee?.menteeProfile ?? "",
                                    sessionTopics: session?.topics ?? "",
                                    reason: '',
                                    buttonText:
                                        'Message from ${session?.mentee?.name ?? ""}',
                                    buttonIcon:  "assets/icons/ChatCircle.png",
                                    remainingTime:
                                        '${session?.startTime ?? ""}-${session?.endTime ?? ""}',
                                  );
                                }, childCount: session_data?.data?.length),
                              ),
                            ],
                          ),
                  ),
                ],
              );
            } else {
              return Center(child: Text("No Data"));
            }
          },
        ),
      ),
    );
  }
}

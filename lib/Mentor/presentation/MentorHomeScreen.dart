import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorDashboardCubit/mentor_dashbaord_states.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorDashboardCubit/mentor_dashboard_cubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/Sessions/SessionsCubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/Sessions/SessionsStates.dart';
import 'package:mentivisor/Mentor/presentation/MentorDashBoard.dart';
import 'package:mentivisor/Mentor/presentation/widgets/SessionCard.dart';
import 'package:mentivisor/Mentor/presentation/widgets/SessionShimmerLoader.dart';
import 'package:mentivisor/utils/constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Components/Shimmers.dart';
import '../../Mentee/data/cubits/GetBanners/GetBannersCubit.dart';
import '../../Mentee/data/cubits/GetBanners/GetBannersState.dart';
import '../../services/AuthService.dart';
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
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<MentorDashboardCubit>().fetchDashboard();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFAF5FF), Color(0xFFF5F6FF), Color(0xFFEFF6FF)],
            ),
          ),
          child: BlocBuilder<MentorDashboardCubit, MentorDashBoardState>(
            builder: (context, state) {
              if (state is MentorDashBoardLoading) {
                return const MentorDashboardShimmer();
              } else if (state is MentorDashBoardLoaded) {
                final banners_data = state.getBannersRespModel;
                final session_data = state.sessionsModel;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final size = MediaQuery.of(context).size;
                            final aspectRatio = size.width / size.height;

                            // ✅ Simple tablet detection (you can tweak this logic as needed)
                            final isTablet = size.shortestSide >= 600;

                            final carouselHeight = isTablet
                                ? size.height * 0.3
                                : size.height * 0.25;
                            return CarouselSlider.builder(
                              itemCount: banners_data?.data?.length ?? 0,
                              itemBuilder: (ctx, i, _) {
                                final b = banners_data?.data?[i];
                                return GestureDetector(
                                  onTap: () {
                                    if (b?.link != null)
                                      _launchUrl(b?.link ?? "");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2.5,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: CachedNetworkImage(
                                        imageUrl: b?.imgUrl ?? '',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        placeholder: (context, url) => Container(
                                          color: Colors.grey[200],
                                          child: const Center(
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Container(
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
                                height:
                                    carouselHeight, // 👈 height based on device type
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 4),
                                viewportFraction: 1.0,
                                onPageChanged: (index, reason) {
                                  _currentIndex.value = index;
                                },
                              ),
                            );
                          },
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
                                  OutlinedButton.icon(
                                    onPressed: () async {
                                      final profileId =
                                      await AuthService.getUSerId();
                                      final shareUrl =
                                          "https://mentivisor.com/profile/$profileId";
                                      Share.share(
                                        "Check out this profile on Mentivisor:\n$shareUrl",
                                        subject:
                                        "Mentivisor Profile",
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.share_rounded,
                                      size: 16,
                                      color: Color(0xff4A7CF6),
                                    ),
                                    label: const Text(
                                      'Share',
                                      style: TextStyle(
                                        fontFamily: 'segeo',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff4A7CF6),
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide.none,
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                          20,
                                        ),
                                      ),
                                      padding:
                                      const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : CustomScrollView(
                              slivers: [
                                SliverPadding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 0,
                                  ),
                                  sliver: SliverMasonryGrid.count(
                                    crossAxisCount: _getCrossAxisCount(context),
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 16,
                                    childCount: session_data?.data?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      final session =
                                          session_data?.data?[index];
                                      final duration = calculateDuration(
                                        session?.startTime ?? "",
                                        session?.endTime ?? "",
                                      );
                                      return SessionCard(
                                        menteeId: session?.mentee?.id,
                                        attachment: session?.attachment ?? "",
                                        sessionLink: session?.zoomLink ?? "",
                                        sessionId: session?.id ?? 0,
                                        status: 'upcoming',
                                        sessionDate: formatDate(
                                          session?.date ?? "",
                                        ),
                                        sessionStartTime:
                                            '${session?.startTime ?? ""}',
                                        sessionEndTime:
                                            '${session?.endTime ?? ""}',
                                        sessionTime: '$duration to go',
                                        sessionName:
                                            'Zoom Meet with ${session?.mentee?.name}',
                                        sessionImage:
                                            session?.mentee?.menteeProfile ??
                                            "",
                                        sessionTopics: session?.topics ?? "",
                                        reason: '',
                                        buttonText:
                                            'Message from ${session?.mentee?.name ?? ""}',
                                        buttonIcon:
                                            "assets/icons/ChatCircle.png",
                                        remainingTime:
                                            '${session?.startTime ?? ""}-${session?.endTime ?? ""}',
                                      );
                                    },
                                  ),
                                ),
                                // SliverGrid(
                                //   gridDelegate:
                                //       SliverGridDelegateWithFixedCrossAxisCount(
                                //         crossAxisCount: _getCrossAxisCount(
                                //           context,
                                //         ),
                                //         crossAxisSpacing: 16,
                                //         mainAxisSpacing: 16,
                                //         childAspectRatio: _getChildAspectRatio(
                                //           context,
                                //         ),
                                //       ),
                                //   delegate: SliverChildBuilderDelegate((
                                //     context,
                                //     index,
                                //   ) {
                                //     final session = session_data?.data?[index];
                                //     final duration = calculateDuration(
                                //       session?.startTime ?? "",
                                //       session?.endTime ?? "",
                                //     );
                                //     return SessionCard(
                                //       menteeId: session?.mentee?.id,
                                //       attachment: session?.attachment ?? "",
                                //       sessionLink: session?.zoomLink ?? "",
                                //       sessionId: session?.id ?? 0,
                                //       status: 'upcoming',
                                //       sessionDate: formatDate(
                                //         session?.date ?? "",
                                //       ),
                                //       sessionStartTime:
                                //           '${session?.startTime ?? ""}',
                                //       sessionEndTime: '${session?.endTime ?? ""}',
                                //       sessionTime: '${duration}  to go',
                                //       sessionName:
                                //           'Zoom Meet with ${session?.mentee?.name}',
                                //       sessionImage:
                                //           session?.mentee?.menteeProfile ?? "",
                                //       sessionTopics: session?.topics ?? "",
                                //       reason: '',
                                //       buttonText:
                                //           'Message from ${session?.mentee?.name ?? ""}',
                                //       buttonIcon: "assets/icons/ChatCircle.png",
                                //       remainingTime:
                                //           '${session?.startTime ?? ""}-${session?.endTime ?? ""}',
                                //     );
                                //   }, childCount: session_data?.data?.length),
                                // ),
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
}

class MentorDashboardShimmer extends StatelessWidget {
  const MentorDashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        SizedBox(
          height: 180,
          width: double.infinity,
          child: PageView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: shimmerContainer(
                    double.infinity,
                    double.infinity,
                    context,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // 🟣 Banner indicator shimmer
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: index == 0 ? 32 : 12,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(100),
              ),
            );
          }),
        ),

        const SizedBox(height: 24),
        Text(
          'Upcoming Session',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'segeo',
          ),
        ),
        const SizedBox(height: 8),

        // 🟣 Session shimmer grid
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverMasonryGrid.count(
                crossAxisCount: _getCrossAxisCount(context),
                mainAxisSpacing: SizeConfig.screenWidth < 600 ? 12 : 16,
                crossAxisSpacing: SizeConfig.screenWidth < 600 ? 12 : 16,
                childCount: 6,
                itemBuilder: (context, index) {
                  return shimmerSessionCard(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 🟣 Shimmer for individual session cards
  Widget shimmerSessionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0E1240),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerText(100, 16, context),
                  const SizedBox(height: 8),
                  shimmerText(180, 16, context),
                  const SizedBox(height: 8),
                  shimmerContainer(120, 28, context, isButton: true),
                ],
              ),
              shimmerRectangle(70, context),
            ],
          ),
          const SizedBox(height: 12),

          // 🔹 Session Topics
          shimmerText(80, 14, context),
          const SizedBox(height: 8),
          shimmerText(220, 12, context),
          const SizedBox(height: 4),
          shimmerText(180, 12, context),

          const SizedBox(height: 16),

          // 🔹 Bottom Buttons
          Row(
            children: [
              Expanded(
                child: shimmerContainer(
                  MediaQuery.of(context).size.width * 0.5,
                  48,
                  context,
                  isButton: true,
                ),
              ),
              const SizedBox(width: 12),
              shimmerContainer(80, 48, context, isButton: true),
            ],
          ),
        ],
      ),
    );
  }

  // 🟣 Responsive helpers
  int _getCrossAxisCount(BuildContext context) {
    final width = SizeConfig.screenWidth;
    if (width < 600) return 1;
    if (width < 900) return 2;
    return 3;
  }
}

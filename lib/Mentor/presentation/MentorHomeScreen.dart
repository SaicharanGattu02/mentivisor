import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mentivisor/Mentor/data/Cubits/Sessions/SessionsCubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/Sessions/SessionsStates.dart';
import 'package:mentivisor/Mentor/presentation/widgets/SessionCard.dart';
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
    context.read<Getbannerscubit>().getbanners();
    context.read<SessionCubit>().getSessions("upcoming");
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAF5FF), Color(0xFFF5F6FF), Color(0xFFEFF6FF)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            BlocBuilder<Getbannerscubit, Getbannersstate>(
              builder: (context, state) {
                if (state is GetbannersStateLoading) {
                  return const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is GetbannersStateFailure) {
                  return SizedBox(
                    height: 180,
                    child: Center(child: Text(state.msg)),
                  );
                }
                final banners =
                    (state as GetbannersStateLoaded).getbannerModel.data ?? [];
                if (banners.isEmpty) {
                  return const SizedBox(
                    height: 180,
                    child: Center(child: Text("No banners available")),
                  );
                }
                return Column(
                  children: [
                    CarouselSlider.builder(
                      itemCount: banners.length,
                      itemBuilder: (ctx, i, _) {
                        final b = banners[i];
                        return GestureDetector(
                          onTap: () {
                            if (b.link != null) _launchUrl(b.link!);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              b.imgUrl ?? '',
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
                        );
                      },
                      options: CarouselOptions(
                        height: 180,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 4),
                        viewportFraction: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ValueListenableBuilder<int>(
                      valueListenable: _currentIndex,
                      builder: (context, currentIndex, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(banners.length, (index) {
                            final isFirst = index == 0;
                            final isLast = index == banners.length - 1;
                            final isNear = (index - currentIndex).abs() <= 1;

                            if (!isFirst && !isLast && !isNear) {
                              return const SizedBox.shrink();
                            }
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
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
                          }),
                        );
                      },
                    ),
                  ],
                );
              },
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
                              remainingTime:
                                  '${duration} Minutes to go', // Time remaining for upcoming session
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

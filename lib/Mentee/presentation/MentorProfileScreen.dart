import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/presentation/Widgets/CommonBackground.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import '../../utils/spinkittsLoader.dart';
import '../data/cubits/MentorProfile/MentorProfileCubit.dart';
import '../data/cubits/MentorProfile/MentorProfileState.dart';
import 'Widgets/ReviewCard.dart';

class MentorProfileScreen extends StatefulWidget {
  final int id;
  MentorProfileScreen({super.key, required this.id});
  @override
  State<MentorProfileScreen> createState() => _MentorProfileScreenState();
}

class _MentorProfileScreenState extends State<MentorProfileScreen> {
  bool hasTodaySlots = false;
  bool hasTomorrowSlots = false;
  bool hasRemainingSlots = false;
  @override
  void initState() {
    super.initState();
    context.read<MentorProfileCubit>().fetchMentorProfile(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: 'Mentor profile', actions: []),
      body: Background(
        child: BlocBuilder<MentorProfileCubit, MentorProfileState>(
          builder: (context, state) {
            if (state is MentorProfileLoading) {
              return const Center(child: DottedProgressWithLogo());
            } else if (state is MentorProfileFailure) {
              return Center(child: Text(state.message));
            } else if (state is MentorProfileLoaded) {
              final mentorData = state.mentorProfileModel.data;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  hasTodaySlots = (mentorData?.todaySlots ?? []).isNotEmpty;
                  hasTomorrowSlots =
                      (mentorData?.tomorrowSlots ?? []).isNotEmpty;
                  hasRemainingSlots = (mentorData?.remainingSlots ?? 0) > 0;
                });
              });

              AppLogger.info(
                "hasTodaySlots:${hasTodaySlots}, hasTomorrowSlots:${hasTomorrowSlots} ,hasRemainingSlots:${hasRemainingSlots} ",
              );
              return Container(
                padding: EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xfff6faff), Color(0xffe0f2fe)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CachedNetworkImage(
                            imageUrl: mentorData?.user?.profilePicUrl ?? "",
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: imageProvider,
                                ),
                            placeholder: (context, url) => CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey,
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: Center(
                                  child: spinkits.getSpinningLinespinkit(),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(
                                    "assets/images/profile.png",
                                  ),
                                ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mentorData?.user?.name ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${mentorData?.user?.stream ?? ''} from ${mentorData?.user?.college?.name ?? ''}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff444444),
                                  fontFamily: "segeo",
                                ),
                              ),
                              Text(
                                "${mentorData?.user?.email ?? ''}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff444444),
                                  fontFamily: "segeo",
                                ),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/icons/language.png",
                                    width: 18,
                                    height: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    (mentorData?.langages ?? []).join(
                                      ', ',
                                    ), // Languages from data
                                    style: TextStyle(fontFamily: "Inter"),
                                  ),
                                ],
                              ),
                              if ((mentorData?.totalReviews ?? 0) > 0)
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow[700],
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '${mentorData?.averageRating ?? 0} (${mentorData?.totalReviews ?? 0} reviews)',
                                      style: TextStyle(fontFamily: "Inter"),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        _buildSection(
                          title: 'About',
                          child: Text(
                            mentorData?.user?.bio ??
                                'No information available', // About text from data
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Inter",
                              height: 1.8,
                            ),
                          ),
                        ),

                        _buildSection(
                          title: 'Expertise',
                          child: Wrap(
                            runSpacing: 10,
                            spacing: 8,
                            children: (mentorData?.expertises ?? [])
                                .expand<Widget>(
                                  (e) => [
                                    _buildChip(e.name ?? ""),
                                    ...(e.subExpertises ?? []).map(
                                      (sub) => _buildChip(sub.name ?? ""),
                                    ),
                                  ],
                                )
                                .toList(),
                          ),
                        ),

                        if (hasTodaySlots ||
                            hasTomorrowSlots ||
                            hasRemainingSlots)
                          _buildSection(
                            title: 'Available Slots',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (hasTodaySlots) ...[
                                  Text(
                                    'Today',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Wrap(
                                    runSpacing: 10,
                                    spacing: 8,
                                    children: (mentorData?.todaySlots ?? [])
                                        .map(
                                          (slot) => _buildTimeSlot(
                                            "${slot.startTime} - ${slot.endTime}",
                                            Color(0xFFdcfce7),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  SizedBox(height: 16),
                                ],
                                if (hasTomorrowSlots) ...[
                                  Text(
                                    'Tomorrow',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Wrap(
                                    runSpacing: 10,
                                    spacing: 8,
                                    children: (mentorData?.tomorrowSlots ?? [])
                                        .map(
                                          (slot) => _buildTimeSlot(
                                            "${slot.startTime} - ${slot.endTime}",
                                            Color(0xFFdbeafe),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  SizedBox(height: 20),
                                ],
                                if (hasRemainingSlots)
                                  Text(
                                    'More ${mentorData?.remainingSlots} Slots available within the week',
                                    style: TextStyle(
                                      color: Color(0xff666666),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'segeo',
                                      fontSize: 16,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                        if ((mentorData?.ratings ?? []).isNotEmpty)
                          _buildSection(
                            title: 'Recent Reviews',
                            child: Column(
                              children: (mentorData!.ratings!).map<Widget>((
                                review,
                              ) {
                                return ReviewCard(
                                  name: review.user?.name ?? "",
                                  rating: review.rating ?? 0,
                                  createdAt: review.createdAt ?? "",
                                  review: review.feedback ?? "",
                                  imgeUrl: review.user?.profilePicUrl ?? "",
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar:
          (hasTodaySlots || hasTomorrowSlots || hasRemainingSlots)
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: BlocBuilder<MentorProfileCubit, MentorProfileState>(
                  builder: (context, state) {
                    final mentorData = (state is MentorProfileLoaded)
                        ? state.mentorProfileModel.data
                        : null;
                    return SizedBox(
                      width: double.infinity,
                      child: CustomAppButton1(
                        text: 'Book Session',
                        onPlusTap: mentorData == null
                            ? null // disable until loaded
                            : () {
                                context.push(
                                  '/book_sessions_screen',
                                  extra:
                                      mentorData, // << pass the exact object you have
                                );
                              },
                      ),
                    );
                  },
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
              color: Color(0xff333333),
            ),
          ),
          SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildTimeSlot(String time, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(36),
      ),
      child: Text(time, style: TextStyle(color: Color(0xFF15803d))),
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: "Inter",
        ),
      ),
      side: BorderSide(color: Color(0xFFf3e8ff)),
      backgroundColor: Color(0xFFf3e8ff),
      labelStyle: TextStyle(color: Color(0xFF7e22ce), fontFamily: "Inter"),
      padding: EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(36), // change 12 to your need
      ),
    );
  }
}

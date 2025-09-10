import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/presentation/Widgets/CommonBackground.dart';

import '../../../utils/spinkittsLoader.dart';
import '../../data/cubits/MentorProfile/MentorProfileCubit.dart';
import '../../data/cubits/MentorProfile/MentorProfileState.dart';
import '../Widgets/ReviewCard.dart';

class ProfileDetails extends StatefulWidget {
  final int id;
  ProfileDetails({super.key, required this.id});
  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
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
        child: BlocConsumer<MentorProfileCubit, MentorProfileState>(
          listener: (context, state) {
            if (state is MentorProfileLoaded) {
              final d = state.mentorProfileModel.data;
              final t1 = (d?.todaySlots ?? []).isNotEmpty;
              final t2 = (d?.tomorrowSlots ?? []).isNotEmpty;
              final t3 = (d?.remainingSlots ?? 0) > 0;
              // if (t1 != hasTodaySlots || t2 != hasTomorrowSlots || t3 != hasRemainingSlots) {
              //   setState(() {
              //     hasTodaySlots = t1;
              //     hasTomorrowSlots = t2;
              //     hasRemainingSlots = t3;
              //   });
              // }
            }
          },
          builder: (context, state) {
            if (state is MentorProfileLoading) {
              return const Center(child: DottedProgressWithLogo());
            } else if (state is MentorProfileFailure) {
              return Center(child: Text(state.message));
            } else if (state is MentorProfileLoaded) {
              final mentorData = state.mentorProfileModel.data;

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
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: mentorData?.user?.profilePicUrl ?? "",
                              width: 150, // Set a fixed width for the image
                              height:
                                  150, // Set a fixed height to maintain the circle shape
                              fit: BoxFit
                                  .cover, // Ensures the image scales correctly to fit within the circle
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

                        // if (hasTodaySlots ||
                        //     hasTomorrowSlots ||
                        //     hasRemainingSlots)
                        //   _buildSection(
                        //     title: 'Available Slots',
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         if (hasTodaySlots) ...[
                        //           Text(
                        //             'Today',
                        //             style: TextStyle(
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //           ),
                        //           SizedBox(height: 8),
                        //           Wrap(
                        //             runSpacing: 10,
                        //             spacing: 8,
                        //             children: (mentorData?.todaySlots ?? [])
                        //                 .map(
                        //                   (slot) => _buildTimeSlot(
                        //                 "${slot.startTime} - ${slot.endTime}",
                        //                 Color(0xFFdcfce7),
                        //               ),
                        //             )
                        //                 .toList(),
                        //           ),
                        //           SizedBox(height: 16),
                        //         ],
                        //         if (hasTomorrowSlots) ...[
                        //           Text(
                        //             'Tomorrow',
                        //             style: TextStyle(
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //           ),
                        //           SizedBox(height: 8),
                        //           Wrap(
                        //             runSpacing: 10,
                        //             spacing: 8,
                        //             children: (mentorData?.tomorrowSlots ?? [])
                        //                 .map(
                        //                   (slot) => _buildTimeSlot(
                        //                 "${slot.startTime} - ${slot.endTime}",
                        //                 Color(0xFFdbeafe),
                        //               ),
                        //             )
                        //                 .toList(),
                        //           ),
                        //           SizedBox(height: 20),
                        //         ],
                        //         if (hasRemainingSlots)
                        //           Text(
                        //             'More ${mentorData?.remainingSlots} Slots available within the week',
                        //             style: TextStyle(
                        //               color: Color(0xff666666),
                        //               fontWeight: FontWeight.w400,
                        //               fontFamily: 'segeo',
                        //               fontSize: 16,
                        //             ),
                        //           ),
                        //       ],
                        //     ),
                        //   ),
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

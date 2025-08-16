import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';

import '../data/cubits/MentorProfile/MentorProfileCubit.dart';
import '../data/cubits/MentorProfile/MentorProfileState.dart';

class MentorProfileScreen extends StatefulWidget {
  final int id;
  MentorProfileScreen({super.key, required this.id});
  @override
  State<MentorProfileScreen> createState() => _MentorProfileScreenState();
}

class _MentorProfileScreenState extends State<MentorProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MentorProfileCubit>().fetchMentorProfile(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Mentor Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<MentorProfileCubit, MentorProfileState>(
        builder: (context, state) {
          if (state is MentorProfileLoading) {
            return const Center(child: CircularProgressIndicator());
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
                      // Profile Header
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
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: NetworkImage(
                                mentorData?.user?.profilePicUrl ?? "",
                              ), // Profile picture
                            ),
                            Text(
                              mentorData?.user?.name ?? 'Unknown',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              mentorData?.user?.designation ??
                                  'No designation available', // Designation from data
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontFamily: "Inter",
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow[700],
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${mentorData?.averageRating ?? 0} (${mentorData?.totalReviews ?? 0} reviews)', // Rating and reviews
                                  style: TextStyle(fontFamily: "Inter"),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.access_time,
                                  color: Colors.blue,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '< 2 hours', // You can update this dynamically based on the mentor's availability
                                  style: TextStyle(fontFamily: "Inter"),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.language,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  (mentorData?.languages ?? []).join(
                                    ', ',
                                  ), // Languages from data
                                  style: TextStyle(fontFamily: "Inter"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // About Section
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
                              .map<Widget>((e) => _buildChip(e))
                              .toList(), // Expertise chips from data
                        ),
                      ),

                      // Available Slots Section
                      _buildSection(
                        title: 'Available Slots',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              runSpacing: 10,
                              spacing: 8,
                              children: (mentorData?.todaySlots ?? [] ?? [])
                                  .map((slot) => _buildTimeSlot(slot))
                                  .toList(), // Today's slots from data
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Tomorrow',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              runSpacing: 10,
                              spacing: 8,
                              children: (mentorData?.tomorrowSlots ?? [])
                                  .map((slot) => _buildTimeSlot1(slot))
                                  .toList(), // Tomorrow's slots from data
                            ),
                            // SizedBox(height: 8),
                            // Text(
                            //   '${mentorData.other_slots_count ?? 0} more slots this week',
                            //   style: TextStyle(color: Colors.grey),
                            // ),
                          ],
                        ),
                      ),

                      // Recent Reviews Section
                      _buildSection(
                        title: 'Recent Reviews',
                        child: Column(
                          children: (mentorData?.reviews ?? []).map<Widget>((
                            review,
                          ) {
                            final data = review.length;
                            return _buildReview(
                              name: "data.", // Reviewer's name
                              rating: 0, // Rating from review
                              timeAgo: "review['time_ago']", // Time ago
                              review: "review['review']", // Review content
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

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: SizedBox(
            width: double.infinity,
            child: CustomAppButton1(
              text: 'Book Session',
              onPlusTap: () {
                context.push("/book_sessions_screen");
                // Your action here
              },
            ),
          ),
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
            title.toUpperCase(),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildAchievementCard(String icon, String title) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFfefce8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          Text(icon, style: TextStyle(fontSize: 20)),
          SizedBox(width: 8),
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(String time) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFdcfce7),
        borderRadius: BorderRadius.circular(36),
      ),
      child: Text(time, style: TextStyle(color: Color(0xFF15803d))),
    );
  }

  Widget _buildTimeSlot1(String time) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFdbeafe),
        borderRadius: BorderRadius.circular(36),
      ),
      child: Text(time, style: TextStyle(color: Color(0xFF1d4ed8))),
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
      padding: EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildReview({
    required String name,
    required int rating,
    required String timeAgo,
    required String review,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 4, height: 80, color: Color(0xFF6B48FF)),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "segeo",
                    ),
                  ),
                  Spacer(),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "segeo",
                    ),
                  ),
                ],
              ),
              Row(
                children: List.generate(
                  rating,
                  (index) =>
                      Icon(Icons.star, color: Colors.yellow[700], size: 16),
                ),
              ),
              SizedBox(height: 4),
              Text(review, style: TextStyle(fontSize: 12, fontFamily: "Inter")),
            ],
          ),
        ),
      ],
    );
  }
}

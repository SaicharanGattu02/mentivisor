import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import '../../Components/CutomAppBar.dart';
import '../../Components/Shimmers.dart';
import '../../Mentor/data/Cubits/MentorInfo/Mentor_Info_cubit.dart';
import '../../Mentor/data/Cubits/MentorInfo/Mentor_Info_states.dart';

class InfoScreen extends StatefulWidget {
  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  void initState() {
    context.read<MentorInfoCubit>().getMentorinfo("mentee");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(
        title: "Info",
        actions: [],
        color: Color(0xffFAF5FF),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffFAF5FF), // Starting color
                Color(0xffF5F6FF), // Ending color
                Color(0xffEFF6FF),
              ],
              begin: Alignment.topLeft, // Gradient start direction
              end: Alignment.bottomRight, // Gradient end direction
            ),
          ),
          child: BlocBuilder<MentorInfoCubit, MentorInfoStates>(
            builder: (context, state) {
              if (state is MentorinfoLoading) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: List.generate(
                      6, // number of shimmer placeholders
                      (index) => const MentorInfoCardShimmer(),
                    ),
                  ),
                );
              }

              if (state is MentorinfoFailure) {
                return Center(child: Text('Error: ${state.error}'));
              }

              if (state is MentorinfoLoaded) {
                final mentorData = state.mentorinfoResponseModel.info;



                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: mentorData?.data?.length,
                  itemBuilder: (context, index) {
                    final item = mentorData?.data?[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item?.heading ?? 'No Heading',
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'segeo',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item?.description ?? 'No description available',
                              style: const TextStyle(
                                color: Color(0xff666666),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                fontFamily: 'segeo',
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );

              }

              return Center(child: Text('Unexpected state'));
            },
          ),
        ),
      ),
    );
  }
}

class MentorInfoCardShimmer extends StatelessWidget {
  const MentorInfoCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Shimmer for heading
            shimmerText(120, 16, context),
            const SizedBox(height: 8),
            // 🔹 Shimmer for description (simulate 2–3 lines)
            shimmerText(double.infinity, 12, context),
            const SizedBox(height: 6),
            shimmerText(250, 12, context),
            const SizedBox(height: 6),
            shimmerText(180, 12, context),
          ],
        ),
      ),
    );
  }
}

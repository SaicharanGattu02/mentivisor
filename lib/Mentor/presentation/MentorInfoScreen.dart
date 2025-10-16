import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import 'package:mentivisor/Mentor/presentation/widgets/MentorInfoShimmerLoader.dart';
import '../../Components/CutomAppBar.dart';
import '../data/Cubits/MentorInfo/Mentor_Info_cubit.dart';
import '../data/Cubits/MentorInfo/Mentor_Info_states.dart';

class Mentorinfoscreen extends StatefulWidget {
  @override
  State<Mentorinfoscreen> createState() => _MentorinfoscreenState();
}

class _MentorinfoscreenState extends State<Mentorinfoscreen> {
  @override
  void initState() {
    context.read<MentorInfoCubit>().getMentorinfo("mentor");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Info", actions: [],color: Color(0xffFAF5FF),),
      body: SafeArea(
        child: Container(
          // Apply gradient background here
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffFAF5FF), // Starting color
                Color(0xffF5F6FF), // Ending color
                Color(0xffEFF6FF)
              ],
              begin: Alignment.topLeft, // Gradient start direction
              end: Alignment.bottomRight, // Gradient end direction
            ),
          ),
          child: BlocBuilder<MentorInfoCubit, MentorInfoStates>(
            builder: (context, state) {
              if (state is MentorinfoLoading) {
                return const MentorInfoShimmerLoader(itemCount: 6);
              }

              if (state is MentorinfoFailure) {
                return Center(child: Text('Error: ${state.error}'));
              }

              if (state is MentorinfoLoaded) {
                final mentorData = state.mentorinfoResponseModel.data;

                return ListView(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  children: [
                    // Dynamically created info cards
                    ...mentorData?.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.heading ?? 'No Heading',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'segeo',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 6),
                              // Description for each info card
                              Text(
                                item.description ?? 'No description available',
                                style: TextStyle(
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
                    }).toList() ?? [], // Iterate through the mentor data and create cards
                  ],
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

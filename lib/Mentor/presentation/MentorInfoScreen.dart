import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import 'package:mentivisor/Mentor/presentation/widgets/MentorInfoShimmerLoader.dart';
import '../../Components/CutomAppBar.dart';
import '../../Mentee/presentation/MenteeInfoScreen.dart';
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
      appBar: CustomAppBar1(
        title: "User Guide",
        actions: [],
        color: const Color(0xffFAF5FF),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffFAF5FF), Color(0xffF5F6FF), Color(0xffEFF6FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: BlocBuilder<MentorInfoCubit, MentorInfoStates>(
            builder: (context, state) {
              /// Initial loading
              if (state is MentorinfoLoading) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: List.generate(
                      6,
                      (index) => const MentorInfoCardShimmer(),
                    ),
                  ),
                );
              }

              if (state is MentorinfoFailure) {
                return Center(child: Text('Error: ${state.error}'));
              }

              if (state is MentorinfoLoaded || state is MentorinfoLoadingMore) {
                final isLoadingMore = state is MentorinfoLoadingMore;

                final mentorData = state is MentorinfoLoaded
                    ? state.mentorinfoResponseModel.info
                    : (state as MentorinfoLoadingMore)
                          .mentorinfoResponseModel
                          .info;

                final hasNextPage = state is MentorinfoLoaded
                    ? state.hasNextPage
                    : (state as MentorinfoLoadingMore).hasNextPage;

                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 200 &&
                        hasNextPage &&
                        !isLoadingMore) {
                      context.read<MentorInfoCubit>().fetchMoreMentorinfo(
                        "mentor",
                      );
                    }
                    return false;
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final item = mentorData?.data?[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
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
                                    item?.description ??
                                        'No description available',
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
                        }, childCount: mentorData?.data?.length ?? 0),
                      ),

                      /// Pagination loader
                      if (isLoadingMore)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                    ],
                  ),
                );
              }

              return const Center(child: Text('Unexpected state'));
            },
          ),
        ),
      ),
    );
  }
}

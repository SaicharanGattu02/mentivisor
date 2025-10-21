import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import 'package:mentivisor/Mentor/presentation/widgets/MenteeCard.dart';
import 'package:mentivisor/Mentor/presentation/widgets/MenteeShimmerLoader.dart';

import '../../Components/CutomAppBar.dart';
import '../../utils/media_query_helper.dart';
import '../data/Cubits/MyMentees/mymentees_cubit.dart';
import '../data/Cubits/MyMentees/mymentees_states.dart';

class MenteeListScreen extends StatefulWidget {
  const MenteeListScreen({super.key});

  @override
  State<MenteeListScreen> createState() => _MenteeListScreenState();
}

class _MenteeListScreenState extends State<MenteeListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MyMenteeCubit>().getMyMentees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEFF6FF),
      appBar: CustomAppBar1(title: "My Mentee", actions: []),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAF5FF), Color(0xFFF5F6FF), Color(0xFFEFF6FF)],
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 16.0,
                ),
                child: Text(
                  "List",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<MyMenteeCubit, MyMenteesStates>(
                builder: (context, state) {
                  if (state is MyMenteeLoading) {
                    return const MenteeShimmerLoader(itemCount: 6);
                  } else if (state is MyMenteeLoaded) {
                    return CustomScrollView(
                      slivers: [
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: _getCrossAxisCount(context),
                                crossAxisSpacing: SizeConfig.screenWidth < 600
                                    ? 12
                                    : 16,
                                mainAxisSpacing: SizeConfig.screenWidth < 600
                                    ? 0
                                    : 16,
                                childAspectRatio: _getChildAspectRatio(context),
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final menteeList =
                                  state.myMenteesModel.data?.menteeData?[index];
                              return MenteeCard(mentee: menteeList!);
                            },
                            childCount:
                                state.myMenteesModel.data?.menteeData?.length ??
                                0,
                          ),
                        ),
                        if (state is MyMenteeLoadingMore)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 0.8,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  } else if (state is MyMenteeFailure) {
                    return Center(child: Text(state.error));
                  }
                  return Center(child: Text("No Data"));
                },
              ),
            ),
          ],
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

  double _getChildAspectRatio(BuildContext context) {
    final screenWidth = SizeConfig.screenWidth;
    if (screenWidth < 600) {
      return 2; // Taller cards on mobile for better readability
    } else {
      return 2.2; // Slightly wider aspect on tablet/desktop for balanced layout
    }
  }
}

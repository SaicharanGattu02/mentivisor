import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/Milestones/milestones_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/Milestones/milestones_states.dart';
import 'package:mentivisor/utils/color_constants.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MilestonesScreen extends StatefulWidget {
  const MilestonesScreen({super.key});

  @override
  State<MilestonesScreen> createState() => _MilestonesScreenState();
}

class _MilestonesScreenState extends State<MilestonesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MilestonesCubit>().getMilestones();
  }

  // Friendly title mapping
  String getTitle(String type) {
    switch (type) {
      case 'study_zone':
        return "Upload notes in studyzone";
      case 'community_post':
        return "Upload posts in community";
      case 'session':
        return "Complete mentor sessions";
      case 'feedback':
        return "Give mentor feedback";
      case 'daily_checkin':
        return "Daily checkin streak";
      case 'ecc':
        return "Upload opportunities in ECC";
      default:
        return type;
    }
  }

  // Icon mapping
  IconData getIcon(String type) {
    switch (type) {
      case 'study_zone':
        return Icons.menu_book_outlined;
      case 'community_post':
        return Icons.chat_bubble_outline;
      case 'session':
        return Icons.video_call_outlined;
      case 'feedback':
        return Icons.feedback_outlined;
      case 'daily_checkin':
        return Icons.check_circle_outline;
      case 'ecc':
        return Icons.stars_outlined;
      default:
        return Icons.task_alt_rounded;
    }
  }

  // Card color mapping
  Color getCardColor(String type) {
    switch (type) {
      case 'study_zone':
        return Colors.blue.shade50;
      case 'community_post':
        return Colors.purple.shade50;
      case 'session':
        return Colors.green.shade50;
      case 'feedback':
        return Colors.orange.shade50;
      case 'daily_checkin':
        return Colors.teal.shade50;
      case 'ecc':
        return Colors.amber.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(
        title: "Monthly Milestones",
        actions: [
          IconButton(
            style: IconButton.styleFrom(padding: EdgeInsets.only(right: 15)),
            onPressed: () {
              context.push("/leaderboard");
            },
            icon: Image.asset(
              "assets/icons/competition.png",
              width: 30,
              height: 30,
              color: primarycolor,
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Adaptive logic: 1 column on mobile, 2 on tablets
          final crossAxisCount = constraints.maxWidth < 600 ? 1 : 2;
          return BlocBuilder<MilestonesCubit, MilesStoneStates>(
            builder: (context, state) {
              if (state is MilesStoneLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is MilesStoneLoaded) {
                final milestones = state.milestonesModel.milestones ?? [];
                if (milestones.isEmpty) {
                  return Center(child: Text("No Milestones Found!"));
                }
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFAF5FF),
                        Color(0xFFF5F6FF),
                        Color(0xffEFF6FF),
                      ],
                    ),
                  ),
                  child: AlignedGridView.count(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    itemCount: milestones.length,
                    itemBuilder: (context, index) {
                      final milestone = milestones[index];
                      final percent = (milestone.progressPercent ?? 0) / 100;
                      return Container(
                        decoration: BoxDecoration(
                          // color: getCardColor(milestone.type ?? ''),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  getIcon(milestone.type ?? ''),
                                  size: 28,
                                  color: Colors.black87,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    getTitle(milestone.type ?? ''),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Progress bar
                            LinearPercentIndicator(
                              lineHeight: 8,
                              percent: percent,
                              progressColor: percent == 1
                                  ? Colors.green
                                  : Colors.blueAccent,
                              backgroundColor: Colors.grey.shade300,
                              barRadius: const Radius.circular(10),
                            ),
                            const SizedBox(height: 8),

                            // Target & Completed
                            Text(
                              "Target: ${milestone.target} | Completed: ${milestone.completed}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Reward & Status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/Coins.png",
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${milestone.coinsReward} Coins Reward",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (milestone.status == "completed")
                                        ? Colors.green.withOpacity(0.2)
                                        : Colors.orange.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    // 👇 Display user-friendly label
                                    (milestone.status == "completed")
                                        ? "Completed"
                                        : (milestone.status == "in_progress")
                                        ? "In Progress"
                                        : (milestone.status
                                                  ?.toString()
                                                  .toUpperCase() ??
                                              'Unknown'),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: (milestone.status == "completed")
                                          ? Colors.green.shade700
                                          : Colors.orange.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Center(child: Text("No Data"));
              }
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/LeaderBoard/leaderboard_cubit.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../services/AuthService.dart';
import '../../utils/AppLogger.dart';
import '../Models/LeaderBoardModel.dart';
import '../data/cubits/LeaderBoard/leaderboard_states.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LeaderboardCubit>().getLeaderBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar1(title: "Leaderboard", actions: []),

      /// ✅ Listen for Cubit States
      body: BlocBuilder<LeaderboardCubit, LeaderBoardStates>(
        builder: (context, state) {
          if (state is LeaderBoardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LeaderBoardFailure) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          if (state is LeaderBoardLoaded) {
            final leaderboardModel = state.leaderBoardModel;
            final leaderboard = leaderboardModel.leaderboard ?? [];

            if (leaderboard.isEmpty) {
              return const Center(child: Text("No leaderboard data available"));
            }

            final top3 = leaderboard.take(3).toList();
            final others = leaderboard.skip(3).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    leaderboardModel.month ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🥇 Top 3 Podium
                  if (top3.isNotEmpty) _buildTopThree(top3),

                  const SizedBox(height: 20),

                  // 📋 Remaining Users
                  if (others.isNotEmpty)
                    Column(
                      children: others
                          .map((user) => _buildListItem(user))
                          .toList(),
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// 🥇 Podium for Top 3
  /// 🥇 Podium for Top 3
  Widget _buildTopThree(List<Leaderboard> top3) {
    final second = top3.length > 1 ? top3[1] : null;
    final first = top3.isNotEmpty ? top3[0] : null;
    final third = top3.length > 2 ? top3[2] : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (second != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 20), // ⬆ slightly lower
            child: _buildPodiumUser(second, 2, 120),
          ),
        if (first != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 60), // ⬆ raised higher
            child: _buildPodiumUser(first, 1, 150),
          ),
        if (third != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 20), // ⬆ slightly lower
            child: _buildPodiumUser(third, 3, 110),
          ),
      ],
    );
  }

  /// 🧍 Podium user card
  Widget _buildPodiumUser(Leaderboard user, int rank, double height) {
    Color medalColor;
    switch (rank) {
      case 1:
        medalColor = Colors.amber;
        break;
      case 2:
        medalColor = Colors.grey;
        break;
      case 3:
        medalColor = Colors.brown.shade400;
        break;
      default:
        medalColor = Colors.blueGrey;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            GestureDetector(
              onTap: () async {
                final userIdStr =
                    await AuthService.getUSerId(); // String? like "107"
                final userId = int.tryParse(
                  userIdStr ?? '',
                ); // Parse to int, default 0 if null/invalid
                AppLogger.info("userId::$userId (parsed as int: $userId)");
                if (userId == user.userId) {
                  context.push("/profile");
                } else {
                  context.push("/common_profile/${user.userId}");
                }
              },
              child: CircleAvatar(
                radius: 40,
                backgroundColor: medalColor.withOpacity(0.3),
                backgroundImage: CachedNetworkImageProvider(user.image ?? ''),
              ),
            ),
            CircleAvatar(
              radius: 12,
              backgroundColor: medalColor,
              child: Text(
                '$rank',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          user.name ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Text(
          "${user.score?.toStringAsFixed(1) ?? '0'} pts",
          style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
        ),
      ],
    );
  }

  /// 📋 List item for 4th onward
  Widget _buildListItem(Leaderboard user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: () async {
            final userIdStr =
                await AuthService.getUSerId(); // String? like "107"
            final userId = int.tryParse(
              userIdStr ?? '',
            ); // Parse to int, default 0 if null/invalid
            AppLogger.info("userId::$userId (parsed as int: $userId)");
            if (userId == user.userId) {
              context.push("/profile");
            } else {
              context.push("/common_profile/${user.userId}");
            }
          },
          child: CircleAvatar(
            radius: 24,
            backgroundImage: CachedNetworkImageProvider(user.image ?? ''),
          ),
        ),
        title: Text(
          user.name ?? '',
          maxLines: 2,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Row(
          children: [
            const Icon(
              Icons.emoji_events_rounded,
              size: 14,
              color: Colors.orange,
            ),
            const SizedBox(width: 4),
            Text(
              "${user.achievementTypes ?? 0} achievements • ${user.avgCompletionDays?.toStringAsFixed(1)} days avg",
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "#${user.rank}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            Text(
              "${user.score?.toStringAsFixed(1)}",
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

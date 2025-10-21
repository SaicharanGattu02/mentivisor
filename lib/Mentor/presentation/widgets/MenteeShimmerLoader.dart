import 'package:flutter/material.dart';

import '../../../Components/Shimmers.dart';
import '../../../utils/media_query_helper.dart';

class MenteeShimmerLoader extends StatelessWidget {
  final int itemCount;
  const MenteeShimmerLoader({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getCrossAxisCount(context),
            crossAxisSpacing: SizeConfig.screenWidth < 600 ? 12 : 16,
            mainAxisSpacing: SizeConfig.screenWidth < 600 ? 12 : 16,
            childAspectRatio: _getChildAspectRatio(context),
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            return shimmerMenteeCard(context);
          }, childCount: itemCount),
        ),
      ],
    );
  }

  /// 🟣 Builds a single shimmer card replicating [MenteeCard]
  Widget shimmerMenteeCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🧑‍🎓 Profile Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Image shimmer
                    shimmerRectangle(60, context),

                    const SizedBox(width: 16),

                    // Mentee info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          shimmerText(140, 16, context),
                          const SizedBox(height: 6),
                          shimmerText(180, 12, context),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // "Report mentee" button shimmer
                Align(
                  alignment: Alignment.centerLeft,
                  child: shimmerContainer(130, 32, context, isButton: true),
                ),
              ],
            ),
          ),

          // 🟣 Decorative bottom color patch shimmer placeholder
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   child: ClipRRect(
          //     borderRadius:
          //     const BorderRadius.only(bottomRight: Radius.circular(16)),
          //     child: Container(
          //       width: 80,
          //       height: 80,
          //       color: Colors.grey[300],
          //     ),
          //   ),
          // ),
        ],
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

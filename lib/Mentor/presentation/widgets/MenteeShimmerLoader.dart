import 'package:flutter/material.dart';

import '../../../Components/Shimmers.dart';

class MenteeShimmerLoader extends StatelessWidget {
  final int itemCount;
  const MenteeShimmerLoader({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              child: shimmerMenteeCard(context),
            ),
            childCount: itemCount,
          ),
        ),
      ],
    );
  }

  /// 🟣 Builds a single shimmer card replicating [MenteeCard]
  Widget shimmerMenteeCard(BuildContext context) {
    return Card(
      margin:  EdgeInsets.zero,
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
}

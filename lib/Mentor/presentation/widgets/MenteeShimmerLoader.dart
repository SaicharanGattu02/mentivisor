import 'package:flutter/material.dart';

import '../../../Components/Shimmers.dart';
import '../../../utils/media_query_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MenteeShimmerLoader extends StatelessWidget {
  final int itemCount;
  const MenteeShimmerLoader({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverMasonryGrid.count(
          crossAxisCount: _getCrossAxisCount(context), // ✅ Responsive count
          mainAxisSpacing: _getMainAxisSpacing(context),
          crossAxisSpacing: _getCrossAxisSpacing(context),
          childCount: itemCount,
          itemBuilder: (context, index) {
            // Keep your shimmer card intact
            return shimmerMenteeCard(context);
          },
        ),
      ],
    );
  }

  /// 📱💻 Responsive CrossAxisCount
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 1; // Mobile
    if (width < 900) return 2; // Tablet
    return 3; // Desktop
  }

  /// ✨ Responsive Main Axis Spacing
  double _getMainAxisSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < 600 ? 12 : 16;
  }

  /// ✨ Responsive Cross Axis Spacing
  double _getCrossAxisSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < 600 ? 12 : 16;
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
}

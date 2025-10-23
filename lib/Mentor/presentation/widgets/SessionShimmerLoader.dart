import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../Components/Shimmers.dart';
import '../../../utils/media_query_helper.dart';

class SessionShimmerLoader extends StatelessWidget {
  final int itemCount;
  const SessionShimmerLoader({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverMasonryGrid.count(
          crossAxisCount: _getCrossAxisCount(context),
          mainAxisSpacing: SizeConfig.screenWidth < 600 ? 12 : 16,
          crossAxisSpacing: SizeConfig.screenWidth < 600 ? 12 : 16,
          childCount: itemCount,
          itemBuilder: (context, index) {
            return shimmerSessionCard(context);
          },
        ),
      ],
    );
  }

  Widget shimmerSessionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, // base card color
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🟣 Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerText(100, 16, context),
                  const SizedBox(height: 8),
                  shimmerText(180, 16, context),
                  const SizedBox(height: 8),
                  shimmerContainer(120, 28, context, isButton: true),
                ],
              ),
              // Profile image shimmer
              shimmerRectangle(70, context),
            ],
          ),

          const SizedBox(height: 12),

          // 🟣 Session Topics Section
          shimmerText(80, 14, context),
          const SizedBox(height: 8),
          shimmerText(220, 12, context),
          const SizedBox(height: 4),
          shimmerText(180, 12, context),

          const SizedBox(height: 16),

          // 🟣 Bottom Row (Buttons)
          Row(
            children: [
              Expanded(
                child: shimmerContainer(
                  MediaQuery.of(context).size.width * 0.5,
                  48,
                  context,
                  isButton: true,
                ),
              ),
              const SizedBox(width: 12),
              shimmerContainer(80, 48, context, isButton: true),
            ],
          ),
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
      return 1.5;
    } else {
      return 1.6; // Slightly wider aspect for balanced layout
    }
  }
}

import 'package:flutter/material.dart';
import '../../../Components/Shimmers.dart';

class SessionShimmerLoader extends StatelessWidget {
  final int itemCount;
  const SessionShimmerLoader({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              child: shimmerSessionCard(context),
            ),
            childCount: itemCount,
          ),
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
}


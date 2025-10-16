import 'package:flutter/material.dart';

import '../../../Components/Shimmers.dart';

class MentorInfoShimmerLoader extends StatelessWidget {
  final int itemCount;
  const MentorInfoShimmerLoader({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: shimmerMentorInfoCard(context),
        );
      },
    );
  }

  /// 🟣 Single shimmer info card
  Widget shimmerMentorInfoCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading shimmer
          shimmerText(140, 16, context),
          const SizedBox(height: 10),

          // Description lines shimmer
          shimmerText(250, 12, context),
          const SizedBox(height: 6),
          shimmerText(220, 12, context),
          const SizedBox(height: 6),
          shimmerText(180, 12, context),
        ],
      ),
    );
  }
}

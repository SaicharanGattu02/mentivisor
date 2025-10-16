import 'package:flutter/material.dart';

import '../../../Components/Shimmers.dart';

class ExpertiseShimmerLoader extends StatelessWidget {
  final int itemCount;
  const ExpertiseShimmerLoader({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: shimmerExpertiseCard(context),
          );
        },
      ),
    );
  }

  /// 🟣 A single shimmer card similar to your expertise list tile
  Widget shimmerExpertiseCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140E1240),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // 🟣 Left icon shimmer
          shimmerCircle(42, context),
          const SizedBox(width: 12),

          // 🟣 Right info (title + subtitle)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerText(160, 16, context),
                const SizedBox(height: 6),
                shimmerText(120, 12, context),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // 🟣 Optional trailing shimmer (like arrow or status badge)
          shimmerCircle(20, context),
        ],
      ),
    );
  }
}

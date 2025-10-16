import 'package:flutter/material.dart';

import '../../../Components/Shimmers.dart';

class CoinHistoryShimmerLoader extends StatelessWidget {
  final int itemCount;
  const CoinHistoryShimmerLoader({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
            padding: EdgeInsets.only(bottom: index == itemCount - 1 ? 0 : 12),
            child: shimmerCoinRowCard(context),
          ),
          childCount: itemCount,
        ),
      ),
    );
  }

  /// 🟡 Mimics `_CoinRowCard` shimmer layout
  Widget shimmerCoinRowCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140E1240),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // 🟣 Left side — Title & Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerText(160, 16, context),
                const SizedBox(height: 8),
                Row(
                  children: [
                    shimmerCircle(16, context),
                    const SizedBox(width: 8),
                    shimmerText(100, 12, context),
                  ],
                ),
              ],
            ),
          ),

          // 🟣 Right side — Coin count
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              shimmerText(40, 16, context),
              const SizedBox(width: 6),
              shimmerCircle(24, context),
            ],
          ),
        ],
      ),
    );
  }
}

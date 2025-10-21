import 'package:flutter/material.dart';

import '../../../Components/Shimmers.dart';
import '../../../utils/media_query_helper.dart';

class CoinHistoryShimmerLoader extends StatelessWidget {
  final int itemCount;
  const CoinHistoryShimmerLoader({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getCrossAxisCount(context),
          crossAxisSpacing: SizeConfig.screenWidth < 600 ? 12 : 16,
          mainAxisSpacing: SizeConfig.screenWidth < 600 ? 12 : 16,
          childAspectRatio: _getChildAspectRatio(context),
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return shimmerCoinRowCard(context);
        }, childCount: itemCount),
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
      return 4.4; // Taller cards on mobile for better readability
    } else {
      return 4.5; // Slightly wider aspect on tablet/desktop for balanced layout
    }
  }
}

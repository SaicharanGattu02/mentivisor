import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mentivisor/utils/media_query_helper.dart';

import '../../Components/Shimmers.dart';
import '../data/Cubits/CouponsList/CouponsListCubit.dart';
import '../data/Cubits/CouponsList/CouponsListStates.dart';

class CouponsList extends StatefulWidget {
  final String categoryId;
  const CouponsList({super.key, required this.categoryId});

  @override
  State<CouponsList> createState() => _CouponsListState();
}

class _CouponsListState extends State<CouponsList> {
  @override
  void initState() {
    super.initState();
    AppLogger.info("categoryId:${widget.categoryId}");
    context.read<CouponsListCubit>().fetchCouponsList(
      widget.categoryId,
    ); // initial
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFE),
      appBar: CustomAppBar1(title: "Coupons List", actions: []),
      body: BlocBuilder<CouponsListCubit, CouponsListStates>(
        builder: (context, state) {
          if (state is CouponsListLoading) {
            return const CouponGridShimmer();
          } else if (state is CouponsListFailure) {
            return Center(child: Text(state.error));
          } else if (state is CouponsListLoaded ||
              state is CouponsListLoadingMore) {
            final model = (state is CouponsListLoaded)
                ? state.couponListModel
                : (state as CouponsListLoadingMore).couponListModel;

            final coupons = model.couponsList?.data ?? [];

            if (coupons.isEmpty) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.2),
                    Image.asset(
                      "assets/nodata/no_data.png",
                      width: 200,
                      height: 200,
                    ),
                    Text(
                      "No Coupons Available",
                      style: TextStyle(
                        color: Color(0xff333333),
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }

            final hasNextPage = (state is CouponsListLoaded)
                ? state.hasNextPage
                : (state as CouponsListLoadingMore).hasNextPage;

            return NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent * 0.9) {
                  if (hasNextPage) {
                    context.read<CouponsListCubit>().fetchMoreCouponsList(
                      widget.categoryId,
                    );
                  }
                }
                return false;
              },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      sliver: SliverMasonryGrid.count(
                        crossAxisCount: _getCrossAxisCount(context), // 2 or 3 based on device
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childCount: coupons.length,
                        itemBuilder: (context, index) {
                          final coupon = coupons[index];

                          return GestureDetector(
                            onTap: () {
                              context.push(
                                '/coupon_details?couponId=${coupon.id ?? ""}',
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x0F0E1240),
                                    blurRadius: 14,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ============================
                                  // TOP IMAGE + EXPIRY BADGE
                                  // ============================
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(16),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: coupon.image ?? "",
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(
                                            height: 150,
                                            color: Colors.grey.shade200,
                                            child: const Center(
                                              child: CircularProgressIndicator(strokeWidth: 1),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => Container(
                                            height: 150,
                                            color: Colors.grey.shade100,
                                            child: const Icon(Icons.broken_image, size: 40),
                                          ),
                                        ),
                                      ),

                                      if ((coupon.expiryDate ?? "").isNotEmpty)
                                        Positioned(
                                          right: 10,
                                          top: 10,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.6),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              "Expires: ${coupon.expiryDate}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'segeo',
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),

                                  // ============================
                                  // BOTTOM DETAILS
                                  // ============================
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                coupon.vendor ?? "Vendor",
                                                style: const TextStyle(
                                                  fontFamily: 'segeo',
                                                  fontSize: 12,
                                                  color: Color(0xFF666666),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            if ((coupon.website ?? "").isNotEmpty)
                                              Icon(
                                                Icons.language,
                                                size: 16,
                                                color: Colors.blueGrey.shade300,
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          coupon.title ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'segeo',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF222222),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          coupon.description ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'segeo',
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // ============================
                    // PAGINATION LOADER
                    // ============================
                    if (state is CouponsListLoadingMore)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 1.5),
                          ),
                        ),
                      ),
                  ],
                ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
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
      return 1.5; // Taller cards on mobile for better readability
    } else {
      return 4.5; // Slightly wider aspect on tablet/desktop for balanced layout
    }
  }
}

class CouponGridShimmer extends StatelessWidget {
  const CouponGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(context),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: _getChildAspectRatio(context),
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => const _CouponCardShimmer(),
              childCount: 6, // number of shimmer placeholders
            ),
          ),
        ),
      ],
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
      return 1.5; // Taller cards on mobile for better readability
    } else {
      return 4.5;
    }
  }
}

class _CouponCardShimmer extends StatelessWidget {
  const _CouponCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0E1240),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Top image shimmer with badge overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: shimmerContainer(double.infinity, 140, context),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: shimmerContainer(100, 18, context),
              ),
            ],
          ),

          // 🔹 Bottom content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vendor & Website shimmer
                Row(
                  children: [
                    shimmerContainer(60, 20, context),
                    const SizedBox(width: 8),
                    shimmerCircle(16, context),
                  ],
                ),
                const SizedBox(height: 10),

                // Coupon Title shimmer
                shimmerText(150, 14, context),
                const SizedBox(height: 6),

                // Description shimmer (2 lines)
                shimmerText(double.infinity, 12, context),
                const SizedBox(height: 4),
                shimmerText(180, 12, context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

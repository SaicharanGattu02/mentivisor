import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import 'package:mentivisor/utils/color_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600 ? 1 : 2;
    final aspectRatio = screenWidth < 600 ? 1.6 : 2.6;

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFE),
      appBar: CustomAppBar1(title: "Coupons List", actions: []),
      body: BlocBuilder<CouponsListCubit, CouponsListStates>(
        builder: (context, state) {
          if (state is CouponsListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CouponsListFailure) {
            return Center(child: Text(state.error));
          } else if (state is CouponsListLoaded ||
              state is CouponsListLoadingMore) {
            final model = (state is CouponsListLoaded)
                ? state.couponListModel
                : (state as CouponsListLoadingMore).couponListModel;

            final coupons = model.couponsList?.data ?? [];

            if (coupons.isEmpty) {
              return const Center(child: Text("No Coupons Available"));
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
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: aspectRatio,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final coupon = coupons[index];
                          return GestureDetector(
                            onTap: () {
                              context.push(
                                '/coupon_details?categoryId=${coupon.id ?? ""}',
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
                                children: [
                                  // Top Image with expiry badge
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: coupon.image ?? "",
                                          height: 140,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                                height: 140,
                                                color: Colors.grey.shade200,
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 1,
                                                      ),
                                                ),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                height: 140,
                                                color: Colors.grey.shade100,
                                                child: const Icon(
                                                  Icons.broken_image,
                                                  size: 40,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                        ),
                                      ),
                                      // expiry tag
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
                                              color: Colors.black.withOpacity(
                                                0.6,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
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

                                  // Content Section
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // vendor + website icon
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
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
                                              if ((coupon.website ?? "")
                                                  .isNotEmpty)
                                                Icon(
                                                  Icons.language,
                                                  size: 16,
                                                  color:
                                                      Colors.blueGrey.shade300,
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
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: coupons.length,
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: true,
                        addSemanticIndexes: false,
                      ),
                    ),
                  ),
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
}

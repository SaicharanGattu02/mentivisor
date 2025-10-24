import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentor/data/Cubits/RedeemedCoupons/RedeemedCouponsCubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/RedeemedCoupons/RedeemedCouponsStates.dart';
import 'package:mentivisor/utils/constants.dart';
import 'package:mentivisor/utils/media_query_helper.dart';

import '../../Components/CustomAppButton.dart';
import '../../Components/Shimmers.dart';

class RedeemedCouponsScreen extends StatefulWidget {
  const RedeemedCouponsScreen({super.key});

  @override
  State<RedeemedCouponsScreen> createState() => _RedeemedCouponsScreenState();
}

class _RedeemedCouponsScreenState extends State<RedeemedCouponsScreen> {
  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterSheet(initialValue: 'All Time'),
    );
  }

  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();
    CustomSnackBar1.show(context, "Code copied!");
  }

  @override
  void initState() {
    context.read<RedeemedCouponCubit>().fetchRedeemedCoupons("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Coupons", actions: []),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEFF6FF), Color(0xFFF5F6FF), Color(0xFFFAF5FF)],
          ),
        ),
        padding: EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Recent",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w700,
                    color: Color(0xff121212),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    _openFilterSheet(context);
                  },
                  child: Image.asset(
                    "assets/images/filterimg.png",
                    height: 32,
                    width: 32,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Expanded(
            //   child: BlocBuilder<RedeemedCouponCubit, RedeemedCouponStates>(
            //     builder: (context, state) {
            //       if (state is RedeemedCouponLoading) {
            //         return CouponShimmer();
            //       } else if (state is RedeemedCouponFailure) {
            //         return Center(child: Text(state.error));
            //       } else if (state is RedeemedCouponLoaded ||
            //           state is RedeemedCouponLoadingMore) {
            //         final redeemedModel = (state is RedeemedCouponLoaded)
            //             ? state.redeemedCouponsModel
            //             : (state as RedeemedCouponLoadingMore)
            //                   .redeemedCouponsModel;
            //
            //         final couponData = redeemedModel.data;
            //         final couponsList = couponData?.data ?? [];
            //
            //         if (couponsList.isEmpty) {
            //           return Center(
            //             child: SingleChildScrollView(
            //               physics: const AlwaysScrollableScrollPhysics(),
            //               child: Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   SizedBox(
            //                     height: 200,
            //                     width: 200,
            //                     child: Image.asset("assets/nodata/no_data.png"),
            //                   ),
            //                   const SizedBox(height: 10),
            //                   const Text(
            //                     'No Coupons Found!',
            //                     textAlign: TextAlign.center,
            //                     style: TextStyle(
            //                       color: Color(0xff333333),
            //                       fontSize: 18,
            //                       fontWeight: FontWeight.w500,
            //                       fontFamily: 'Poppins',
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           );
            //         }
            //
            //         return NotificationListener<ScrollNotification>(
            //           onNotification: (scrollInfo) {
            //             if (scrollInfo.metrics.pixels >=
            //                 scrollInfo.metrics.maxScrollExtent * 0.9) {
            //               if (state is RedeemedCouponLoaded &&
            //                   state.hasNextPage) {
            //                 context
            //                     .read<RedeemedCouponCubit>()
            //                     .fetchMoreRedeemedCoupons("");
            //               }
            //             }
            //             return false;
            //           },
            //           child:
            //               ListView.separated(
            //                 separatorBuilder: (context, index) {
            //                   return Padding(
            //                     padding: EdgeInsets.symmetric(vertical: 8),
            //                   );
            //                 },
            //                 itemCount:
            //                     couponsList.length +
            //                     (state is RedeemedCouponLoadingMore ? 1 : 0),
            //                 itemBuilder: (context, index) {
            //                   if (index == couponsList.length &&
            //                       state is RedeemedCouponLoadingMore) {
            //                     return const Padding(
            //                       padding: EdgeInsets.all(25.0),
            //                       child: Center(
            //                         child: CircularProgressIndicator(
            //                           strokeWidth: 1.2,
            //                         ),
            //                       ),
            //                     );
            //                   }
            //
            //                   final coupon = couponsList[index];
            //
            //                   return Container(
            //                     width: SizeConfig.screenWidth,
            //                     padding: const EdgeInsets.all(12.0),
            //                     decoration: BoxDecoration(
            //                       color: Color(0xffFFFFFF),
            //                       borderRadius: BorderRadius.circular(12),
            //                     ),
            //
            //                     child: Row(
            //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Column(
            //                           crossAxisAlignment: CrossAxisAlignment.start,
            //                           children: [
            //                             Row(
            //                               children: [
            //                                 Text(
            //                                   coupon.coins ?? "0",
            //                                   style: const TextStyle(
            //                                     fontSize: 20,
            //                                     fontWeight: FontWeight.bold,
            //                                   ),
            //                                 ),
            //                                 const SizedBox(width: 6),
            //                                 Image.asset(
            //                                   "assets/images/GoldCoins.png",
            //                                   height: 24,
            //                                   width: 24,
            //                                 ),
            //                               ],
            //                             ),
            //                             const SizedBox(height: 6),
            //                             Container(
            //                               padding: const EdgeInsets.symmetric(
            //                                 horizontal: 8,
            //                                 vertical: 4,
            //                               ),
            //                               decoration: BoxDecoration(
            //                                 color: const Color(0xff6595FF),
            //                                 borderRadius: BorderRadius.circular(12),
            //                               ),
            //                               child: const Text(
            //                                 "New",
            //                                 style: TextStyle(
            //                                   color: Colors.white,
            //                                   fontWeight: FontWeight.w600,
            //                                 ),
            //                               ),
            //                             ),
            //                             const SizedBox(height: 12),
            //                             Row(
            //                               children: [
            //                                 Icon(
            //                                   Icons.calendar_month,
            //                                   size: 16,
            //                                   color: Color(0xff999999),
            //                                 ),
            //                                 SizedBox(width: 5),
            //                                 Text(
            //                                   formatDate(coupon.createdAt ?? ""),
            //                                   style: TextStyle(
            //                                     fontWeight: FontWeight.w600,
            //                                     color: Color(0xff575757),
            //                                     fontFamily: "segeo",
            //                                     fontSize: 12,
            //                                   ),
            //                                 ),
            //                               ],
            //                             ),
            //                           ],
            //                         ),
            //
            //                         // Right Section - Coupon details
            //                         Column(
            //                           crossAxisAlignment: CrossAxisAlignment.end,
            //                           children: [
            //                             Text(
            //                               coupon.title ?? "",
            //                               style: const TextStyle(
            //                                 fontWeight: FontWeight.w600,
            //                                 color: Color(0xff333333),
            //                                 fontFamily: "segeo",
            //                                 fontSize: 12,
            //                               ),
            //                             ),
            //                             const SizedBox(height: 6),
            //                             GestureDetector(
            //                               onTap: () {
            //                                 _copy(context, coupon.code ?? "");
            //                               },
            //                               child: Container(
            //                                 padding: const EdgeInsets.symmetric(
            //                                   horizontal: 8,
            //                                   vertical: 12,
            //                                 ),
            //                                 decoration: BoxDecoration(
            //                                   color: const Color(0xffF5F5F5),
            //                                   borderRadius: BorderRadius.circular(
            //                                     4,
            //                                   ),
            //                                 ),
            //                                 child: Row(
            //                                   children: [
            //                                     Text(
            //                                       coupon.code ?? "",
            //                                       style: const TextStyle(
            //                                         fontWeight: FontWeight.w600,
            //                                         color: Color(0xff121212),
            //                                         fontFamily: "segeo",
            //                                         fontSize: 12,
            //                                       ),
            //                                     ),
            //                                     const SizedBox(width: 10),
            //                                     Image.asset(
            //                                       "assets/images/Copyimg.png",
            //                                       height: 16,
            //                                       width: 16,
            //                                     ),
            //                                   ],
            //                                 ),
            //                               ),
            //                             ),
            //                             const SizedBox(height: 6),
            //                             Text(
            //                               "Worth of ₹ ${coupon.coupon?.actualValue ?? "0"}",
            //                               style: const TextStyle(
            //                                 color: Color(0xff575757),
            //                                 fontFamily: "segeo",
            //                                 fontWeight: FontWeight.w600,
            //                                 fontSize: 12,
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ],
            //                     ),
            //                   );
            //                 },
            //               ),
            //         );
            //       } else {
            //         return Text("No Data");
            //       }
            //     },
            //   ),
            // ),
      Expanded(
        child: BlocBuilder<RedeemedCouponCubit, RedeemedCouponStates>(
          builder: (context, state) {
            if (state is RedeemedCouponLoading) {
              return const CouponShimmer();
            } else if (state is RedeemedCouponFailure) {
              return Center(child: Text(state.error));
            } else if (state is RedeemedCouponLoaded ||
                state is RedeemedCouponLoadingMore) {
              final redeemedModel = (state is RedeemedCouponLoaded)
                  ? state.redeemedCouponsModel
                  : (state as RedeemedCouponLoadingMore).redeemedCouponsModel;

              final couponData = redeemedModel.data;
              final couponsList = couponData?.data ?? [];

              if (couponsList.isEmpty) {
                return Center(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: Image.asset("assets/nodata/no_data.png"),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'No Coupons Found!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent * 0.9) {
                    if (state is RedeemedCouponLoaded && state.hasNextPage) {
                      context.read<RedeemedCouponCubit>().fetchMoreRedeemedCoupons("");
                    }
                  }
                  return false;
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverMasonryGrid.count(
                      crossAxisCount: _getCrossAxisCount(context),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childCount: couponsList.length +
                          (state is RedeemedCouponLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == couponsList.length &&
                            state is RedeemedCouponLoadingMore) {
                          return const Padding(
                            padding: EdgeInsets.all(25.0),
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 1.2),
                            ),
                          );
                        }

                        final coupon = couponsList[index];

                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: const Color(0xffFFFFFF),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// 🔹 Left Section
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          coupon.coins ?? "0",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Image.asset(
                                          "assets/images/GoldCoins.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xff6595FF),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        "New",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month,
                                          size: 16,
                                          color: Color(0xff999999),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          formatDate(coupon.createdAt ?? ""),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff575757),
                                            fontFamily: "segeo",
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 8),

                              /// 🔹 Right Section
                              Flexible(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      coupon.title ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff333333),
                                        fontFamily: "segeo",
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    GestureDetector(
                                      onTap: () {
                                        _copy(context, coupon.code ?? "");
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffF5F5F5),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                coupon.code ?? "",
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff121212),
                                                  fontFamily: "segeo",
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Image.asset(
                                              "assets/images/Copyimg.png",
                                              height: 16,
                                              width: 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Worth of ₹ ${coupon.coupon?.actualValue ?? "0"}",
                                      style: const TextStyle(
                                        color: Color(0xff575757),
                                        fontFamily: "segeo",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text("No Data"));
            }
          },
        ),
      )

      ],
        ),
      ),
    );
  }
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return 1; // 📱 Mobile
    } else if (width <900) {
      return 2; // 💻 Tablet
    } else {
      return 3; // 🖥 Desktop
    }
  }


}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initialValue});

  final String initialValue;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  final List<String> options = [
    'All Time',
    'This Week',
    'This Month',
    'This Quarter',
  ];
  late final ValueNotifier<String> selected;

  final Map<String, String> filterValues = {
    'All Time': '',
    'This Week': 'week',
    'This Month': 'month',
    'This Quarter': 'quarter',
  };

  @override
  void initState() {
    super.initState();
    selected = ValueNotifier(widget.initialValue);
  }

  @override
  void dispose() {
    selected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter',
            style: TextStyle(
              fontFamily: 'segeo',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xff444444),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Time',
            style: TextStyle(
              fontFamily: 'segeo',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF444444),
            ),
          ),
          const SizedBox(height: 8),

          // Options
          ...options.map(
            (o) => ValueListenableBuilder<String>(
              valueListenable: selected,
              builder: (context, currentSelected, _) {
                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    // Just update the selected value
                    selected.value = o;
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: currentSelected == o,
                        onChanged: (v) {
                          if (v == true) {
                            selected.value = o;
                          }
                        },
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        side: const BorderSide(
                          color: Color(0xFF98A2B3),
                          width: 1,
                        ),
                        activeColor: Color(0xFF7F00FF),
                        checkColor: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        o,
                        style: const TextStyle(
                          fontFamily: 'segeo',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF444444),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 20),
          SafeArea(
            child: ValueListenableBuilder<String>(
              valueListenable: selected,
              builder: (context, currentSelected, _) {
                return CustomAppButton1(
                  text: "Apply",
                  onPlusTap: () {
                    final filterValue = filterValues[currentSelected] ?? "";
                    context.read<RedeemedCouponCubit>().fetchRedeemedCoupons(
                      filterValue,
                    );
                    Navigator.pop(context, filterValue);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CouponShimmer extends StatelessWidget {
  const CouponShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverMasonryGrid.count(
          crossAxisCount: _getCrossAxisCount(context),
          mainAxisSpacing: 12, // same as separator height
          crossAxisSpacing: 12,
          childCount: 6,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 LEFT SECTION
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Coin Value + Icon
                        Row(
                          children: [
                            shimmerText(50, 20, context),
                            const SizedBox(width: 6),
                            shimmerCircle(24, context),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // "New" Badge shimmer
                        shimmerContainer(50, 24, context),

                        const SizedBox(height: 12),

                        // Date shimmer
                        Row(
                          children: [
                            shimmerCircle(16, context),
                            const SizedBox(width: 6),
                            shimmerText(80, 14, context),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// 🔹 RIGHT SECTION
                  Flexible(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Coupon title
                        shimmerText(120, 14, context),
                        const SizedBox(height: 8),

                        // Coupon code box shimmer
                        shimmerContainer(120, 36, context),

                        const SizedBox(height: 8),

                        // Worth text shimmer
                        shimmerText(100, 14, context),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 1; // Mobile
    if (width < 900) return 2; // Tablet
    return 3; // Desktop
  }
}

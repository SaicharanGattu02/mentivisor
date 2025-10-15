import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/utils/constants.dart';
import '../../Components/Shimmers.dart';
import '../../utils/spinkittsLoader.dart';
import '../data/Cubits/Coupons/CategoryCouponsCubit.dart';
import '../data/Cubits/Coupons/CouponsCategoryStates.dart';
import '../data/Cubits/MentorEarnings/MentorEarningsCubit.dart';
import '../data/Cubits/MentorEarnings/MentorEarningsStates.dart';

class CouponsHomeScreen extends StatefulWidget {
  const CouponsHomeScreen({super.key});

  @override
  State<CouponsHomeScreen> createState() => _CouponsHomeScreenState();
}

class _CouponsHomeScreenState extends State<CouponsHomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MentorEarningsCubit>().getMentorEarnings();
    context.read<CategoryCouponscubit>().getCouponsCategory();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: BlocBuilder<MentorEarningsCubit, MentorEarningsStates>(
        builder: (context, state) {
          if (state is MentorEarningsLoaded) {
            return Container(
              height: height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFAF5FF),
                    Color(0xFFF5F6FF),
                    Color(0xFFEFF6FF),
                  ],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Earnings',
                        style: TextStyle(
                          fontFamily: 'segeo',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF121212),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              textColor: Colors.black,
                              bgColor: const Color(0xFFFFE7B6),
                              title: 'Total Coins',
                              value:
                                  state.mentorEarningsModel.data?.currentBalance
                                      .toString() ??
                                  "0",
                              trailing: Image.asset(
                                'assets/images/coinsimage.png',
                                height: 36,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: _StatCard(
                              textColor: Color(0xffFFFFFF),
                              bgColor: Color(0xFF4076ED), // light blue
                              title: 'This Month',
                              value:
                                  state
                                      .mentorEarningsModel
                                      .data
                                      ?.thisMonthEarnings
                                      .toString() ??
                                  "0",
                              trailing: Image.asset(
                                'assets/images/calender.png',
                                height: 36,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        'Available Coupons',
                        style: TextStyle(
                          fontFamily: 'segeo',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF121212),
                        ),
                      ),
                      const SizedBox(height: 12),
                      BlocBuilder<CategoryCouponscubit, CouponsCategoryStates>(
                        builder: (context, state) {
                          if (state is CouponsCategoryLoading) {
                            return CategoryGridShimmer();
                          } else if (state is CouponsCategoryFailure) {
                            return Center(child: Text(state.error));
                          } else if (state is CouponsCategoryLoaded ||
                              state is CouponsCategoryLoadingMore) {
                            final model = (state is CouponsCategoryLoaded)
                                ? state.couponCategoryModel
                                : (state as CouponsCategoryLoadingMore)
                                      .couponCategoryModel;
                            final categories =
                                model.couponsCategory?.data ?? [];

                            if (categories.isEmpty) {
                              return const Center(
                                child: Text("No categories available."),
                              );
                            }

                            return NotificationListener<ScrollNotification>(
                              onNotification: (scrollInfo) {
                                if (scrollInfo.metrics.pixels >=
                                    scrollInfo.metrics.maxScrollExtent * 0.9) {
                                  if (state is CouponsCategoryLoaded &&
                                      state.hasNextPage) {
                                    context
                                        .read<CategoryCouponscubit>()
                                        .fetchMoreCouponsCategory();
                                  }
                                }
                                return false;
                              },
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width <
                                                    600
                                                ? 2
                                                : 3,
                                            mainAxisSpacing: 12,
                                            crossAxisSpacing: 12,
                                            childAspectRatio: 1.08,
                                          ),
                                      itemCount: categories.length,
                                      itemBuilder: (context, index) {
                                        final item = categories[index];
                                        return GestureDetector(
                                          onTap: () {
                                            context.push(
                                              '/coupon_list?categoryId=${item.id ?? ""}',
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                              12,
                                              12,
                                              12,
                                              10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16),
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
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: CachedNetworkImage(
                                                    width: 120,
                                                    height: 120,
                                                    imageUrl: item.image ?? "",
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (
                                                          context,
                                                          url,
                                                        ) => SizedBox(
                                                          width: 120,
                                                          height: 120,
                                                          child: Center(
                                                            child: spinkits
                                                                .getSpinningLinespinkit(),
                                                          ),
                                                        ),
                                                    errorWidget:
                                                        (
                                                          context,
                                                          url,
                                                          error,
                                                        ) => Container(
                                                          width: 120,
                                                          height: 120,
                                                          color: const Color(
                                                            0xffF8FAFE,
                                                          ),
                                                          child: const Icon(
                                                            Icons.broken_image,
                                                            size: 40,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  capitalize(item.name ?? ""),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontFamily: 'segeo',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF555555),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    if (state is CouponsCategoryLoadingMore)
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 20,
                                        ),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 0.8,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is MentorEarningsFailure) {
            return Center(child: Text(state.error));
          } else {
            return Center(child: Text("No Data"));
          }
        },
      ),
    );
  }
}

/// Single stat tile used in the "Earnings" row
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.bgColor,
    required this.title,
    required this.value,
    required this.trailing,
    required this.textColor,
  });

  final Color bgColor;
  final String title;
  final String value;
  final Widget trailing;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140E1240),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // left texts
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          trailing,
        ],
      ),
    );
  }
}

class CategoryGridShimmer extends StatelessWidget {
  const CategoryGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = MediaQuery.of(context).size.width < 600 ? 2 : 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.08,
      ),
      itemCount: 8, // You can change based on how many shimmer cards you want
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image shimmer
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: shimmerContainer(120, 120, context),
              ),
              const SizedBox(height: 8),
              // Text shimmer
              shimmerText(100, 16, context),
            ],
          ),
        );
      },
    );
  }
}

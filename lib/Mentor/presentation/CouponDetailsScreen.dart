import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentor/data/Cubits/BuyCoupon/BuyCouponCubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/BuyCoupon/BuyCouponStates.dart';
import 'package:mentivisor/Mentor/data/Cubits/CouponsDetails/CouponsDetailsStates.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Components/Shimmers.dart';
import '../../Mentee/data/cubits/MenteeProfile/GetMenteeProfile/MenteeProfileCubit.dart';
import '../../utils/constants.dart';
import '../../utils/spinkittsLoader.dart';
import '../data/Cubits/CouponsDetails/CouponsDetailsCubit.dart';
import '../../services/AuthService.dart';
import '../data/Cubits/MentorEarnings/MentorEarningsCubit.dart';

class CouponDetailsScreen extends StatefulWidget {
  final String couponId;
  const CouponDetailsScreen({super.key, required this.couponId});

  @override
  State<CouponDetailsScreen> createState() => _CouponDetailsScreenState();
}

class _CouponDetailsScreenState extends State<CouponDetailsScreen> {
  ValueNotifier<bool> enoughBalance = ValueNotifier<bool>(true);

  void _showConfirmDialog(
    BuildContext context,
    int coinsRequired,
    String title,
    int couponId,
  ) {
    showGeneralDialog(
      context: context,
      barrierLabel: 'Buy',
      barrierDismissible: true,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: BlocConsumer<BuyCouponCubit, BuyCouponStates>(
              listener: (context, state) {
                if (state is BuyCouponLoaded) {
                  context.pop();
                } else if (state is BuyCouponFailure) {
                  CustomSnackBar1.show(context, state.error);
                }
              },
              builder: (context, state) {
                return Material(
                  color: Colors.transparent,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 280,
                      maxWidth: 520,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.local_offer,
                              color: Colors.green.shade600,
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Are you sure to redeem\n"$title"?',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: "segeo",
                            color: Color(0xff666666),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "It will cost you $coinsRequired coins",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: "segeo",
                            color: Color(0xff999999),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 44,
                                child: OutlinedButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Color(0xFF8C3BFF),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Color(0xFF8C3BFF),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 44,
                                child:
                                    BlocConsumer<
                                      BuyCouponCubit,
                                      BuyCouponStates
                                    >(
                                      listener: (context, state) {
                                        if (state is BuyCouponLoaded) {
                                          context.pop();
                                          context.pushReplacement("/coupons");
                                          context
                                              .read<MentorEarningsCubit>()
                                              .getMentorEarnings();
                                        } else if (state is BuyCouponFailure) {
                                          CustomSnackBar1.show(
                                            context,
                                            state.error,
                                          );
                                        }
                                      },
                                      builder: (context, state) {
                                        return CustomAppButton1(
                                          isLoading: state is BuyCouponLoading,
                                          text: "Confirm",
                                          onPlusTap: () {
                                            context
                                                .read<BuyCouponCubit>()
                                                .buyCoupons(couponId);
                                          },
                                        );
                                      },
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: child,
          ),
        );
      },
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  void initState() {
    AppLogger.info("couponId:${widget.couponId}");
    context.read<CouponsDetailCubit>().fetchCouponsDetails(widget.couponId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: 'Coupon Details', actions: []),
      body: BlocBuilder<CouponsDetailCubit, CouponsDetailsStates>(
        builder: (context, state) {
          if (state is CouponsDetailsLoading) {
            return CouponDetailsShimmer();
          } else if (state is CouponsDetailsLoaded) {
            final couponsDetails = state.couponDetailsModel.data;
            final double actualValue =
                double.tryParse(couponsDetails?.actualValue ?? '0') ?? 0.0;
            final double purchaseValue =
                double.tryParse(couponsDetails?.purchaseValue ?? '0') ?? 0.0;
            final double savings = actualValue - purchaseValue;
            final int discountPercent = actualValue > 0
                ? ((savings / actualValue) * 100).round().toInt()
                : 0;
            final requiredCoins = couponsDetails?.coinsRequired ?? 0;
            context.read<MenteeProfileCubit>().fetchMenteeProfile();
            enoughBalance.value = AppState.coinsNotifier.value >= requiredCoins;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image with expiry overlay
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: couponsDetails?.image ?? "",
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 200,
                            color: Colors.grey.shade200,
                            child: Center(
                              child: spinkits.getSpinningLinespinkit(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey.shade100,
                            child: const Icon(
                              Icons.local_offer_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      // Expiry badge
                      if (couponsDetails?.expiryDate != null)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Expires: ${couponsDetails!.expiryDate}",
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

                  const SizedBox(height: 20),

                  // Vendor and Website
                  Row(
                    children: [
                      Text(
                        couponsDetails?.vendor ?? "",
                        style: TextStyle(
                          fontFamily: 'segeo',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (couponsDetails?.website != null)
                        GestureDetector(
                          onTap: () {
                            if (couponsDetails?.website != null)
                              _launchUrl(couponsDetails?.website ?? "");

                          },
                          child: Icon(
                            Icons.open_in_new,
                            size: 18,
                            color: Colors.blue,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (couponsDetails?.website != null)
                    Text(
                      couponsDetails!.website!,
                      style: TextStyle(
                        fontFamily: 'segoe',
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Title
                  Text(
                    couponsDetails?.title ?? "",
                    style: TextStyle(
                      fontFamily: 'segoe',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Description
                  Text(
                    couponsDetails?.description ?? "",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'segoe',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: Color(0xFF666666),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Discount Details Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Discount Details",
                          style: TextStyle(
                            fontFamily: 'segoe',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Original Price",
                                    style: TextStyle(
                                      fontFamily: 'segoe',
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    "₹${actualValue.toStringAsFixed(0)}",
                                    style: TextStyle(
                                      fontFamily: 'segoe',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              "→",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Discounted Price",
                                    style: TextStyle(
                                      fontFamily: 'segoe',
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    "₹${purchaseValue.toStringAsFixed(0)}",
                                    style: TextStyle(
                                      fontFamily: 'segoe',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "You Save: ₹${savings.toStringAsFixed(0)} (${discountPercent}%)",
                              style: TextStyle(
                                fontFamily: 'segoe',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade700,
                              ),
                            ),
                            if (couponsDetails?.totalCoupons != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "${couponsDetails!.totalCoupons} left",
                                  style: TextStyle(
                                    fontFamily: 'segoe',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange.shade700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (couponsDetails?.startDate != null ||
                      couponsDetails?.expiryDate != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.blue.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Validity Period",
                                  style: TextStyle(
                                    fontFamily: 'segoe',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade800,
                                  ),
                                ),
                                Text(
                                  "From ${couponsDetails!.startDate} to ${couponsDetails.expiryDate}",
                                  style: TextStyle(
                                    fontFamily: 'segoe',
                                    fontSize: 13,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/coinsgold.png",
                          height: 16,
                          width: 16,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Coins Required",
                                style: TextStyle(
                                  fontFamily: 'segoe',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.amber.shade800,
                                ),
                              ),
                              Text(
                                "${couponsDetails?.coinsRequired ?? 0} Coins",
                                style: TextStyle(
                                  fontFamily: 'segoe',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40), // Space for bottom nav
                ],
              ),
            );
          } else if (state is CouponsDetailsFailure) {
            return Center(child: Text(state.error));
          } else {
            return const Center(child: Text("No Data"));
          }
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: BlocBuilder<CouponsDetailCubit, CouponsDetailsStates>(
            builder: (context, state) {
              if (state is CouponsDetailsLoaded) {
                final couponsDetails = state.couponDetailsModel.data;
                final int couponId = couponsDetails?.id ?? 0;
                final int coinsRequired = couponsDetails?.coinsRequired ?? 0;
                return CustomAppButton1(
                  text: "Redeem Now",
                  onPlusTap: () {
                    if (enoughBalance.value == false) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: Text(
                            "Insufficient Coins",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.redAccent,
                            ),
                          ),
                          content: const Text(
                            "You don’t have enough coins to redeem this coupon.\n\nPlease purchase more coins to continue.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.push("/buy_coins_screens");
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text("Purchase Coins"),
                            ),
                          ],
                        ),
                      );
                      return;
                    } else {
                      _showConfirmDialog(
                        context,
                        coinsRequired,
                        couponsDetails?.title ?? "",
                        couponId,
                      );
                    }
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class CouponDetailsShimmer extends StatelessWidget {
  const CouponDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Image with expiry overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: shimmerContainer(double.infinity, 200, context),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: shimmerContainer(100, 20, context),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 🔹 Vendor + Website row
          Row(
            children: [
              shimmerText(100, 16, context),
              const SizedBox(width: 10),
              shimmerCircle(18, context),
            ],
          ),
          const SizedBox(height: 6),
          shimmerText(180, 12, context),

          const SizedBox(height: 20),

          // 🔹 Title shimmer
          shimmerText(200, 20, context),
          const SizedBox(height: 12),

          // 🔹 Description shimmer (3–4 lines)
          shimmerText(double.infinity, 12, context),
          const SizedBox(height: 6),
          shimmerText(double.infinity, 12, context),
          const SizedBox(height: 6),
          shimmerText(250, 12, context),

          const SizedBox(height: 20),

          // 🔹 Discount Details Card shimmer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerText(140, 14, context),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          shimmerText(100, 12, context),
                          const SizedBox(height: 6),
                          shimmerText(80, 18, context),
                        ],
                      ),
                    ),
                    const Text("→", style: TextStyle(color: Colors.grey)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          shimmerText(100, 12, context),
                          const SizedBox(height: 6),
                          shimmerText(80, 18, context),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    shimmerText(160, 14, context),
                    shimmerContainer(60, 18, context),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Validity Dates Card shimmer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                shimmerCircle(20, context),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      shimmerText(120, 14, context),
                      const SizedBox(height: 4),
                      shimmerText(200, 12, context),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Coins Required Card shimmer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                shimmerCircle(20, context),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      shimmerText(120, 14, context),
                      const SizedBox(height: 6),
                      shimmerText(100, 18, context),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

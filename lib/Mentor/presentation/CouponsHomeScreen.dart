import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../Components/CommonLoader.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: BlocBuilder<MentorEarningsCubit, MentorEarningsStates>(
        builder: (context, state) {
          if (state is MentorEarningsLoading) {
            return Center(child: DottedProgressWithLogo());
          } else if (state is MentorEarningsLoaded) {
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
                              bgColor: const Color(0xFFFFE7B6), // warm yellow
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

                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '= with out commission ₹2800',
                            style: TextStyle(
                              fontFamily: 'segeo',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff575757),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            '+ 15% from last month',
                            style: TextStyle(
                              fontFamily: 'segeo',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff575757),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ===== Available Coupons =====
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
                      // 2x2 grid of category cards
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.08,
                        children: const [
                          _CategoryCard(
                            title: 'Shopping',
                            asset: 'assets/images/bagsimg.png',
                          ),
                          _CategoryCard(
                            title: 'Restaurant',
                            asset: 'assets/images/personimg.png',
                          ),
                          _CategoryCard(
                            title: 'Grocery',
                            asset: 'assets/images/grosary.png',
                          ),
                          _CategoryCard(
                            title: 'Travel',
                            asset: 'assets/images/travelscreen.png',
                          ),
                        ],
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

/// Category tile used in the grid
class _CategoryCard extends StatelessWidget {
  final String title;
  final String asset;
  const _CategoryCard({required this.title, required this.asset});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/coupon_details');
      },
      child: Container(
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
          children: [
            Expanded(
              child: Center(child: Image.asset(asset, fit: BoxFit.contain)),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'segeo',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF222222),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

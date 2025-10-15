import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import 'package:mentivisor/Mentee/data/cubits/CoinsAchievements/CoinsAchievementCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/CoinsAchievements/CoinsAchievementState.dart';
import 'package:mentivisor/utils/constants.dart';

import '../../Components/CutomAppBar.dart';
import '../../Components/Shimmers.dart';
import '../../utils/media_query_helper.dart';
import '../data/cubits/WalletMoney/WalletMoney_Cubit.dart';
import '../data/cubits/WalletMoney/WalletMoney_State.dart';
import 'Widgets/CommonBackground.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ValueNotifier<bool> coinHistoryNotifier = ValueNotifier(true);
  final ValueNotifier<int> _currentBalence = ValueNotifier(0);
  final ValueNotifier<int> _totelEarned = ValueNotifier(0);
  final ValueNotifier<int> _totelSpent = ValueNotifier(0);

  int _safeParse(dynamic value) {
    if (value == null) return 0;
    final str = value.toString().trim();
    if (str.isEmpty || str.toLowerCase() == "null") return 0;
    return int.tryParse(str) ?? 0;
  }

  @override
  void initState() {
    super.initState();
    context.read<WalletmoneyCubit>().getWallet(0);
  }

  @override
  void dispose() {
    coinHistoryNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF8EC),
      appBar: CustomAppBar1(
        title: "",
        actions: [],
        color: const Color(0xffFFF8EC),
      ),
      body: SafeArea(
        child: Background1(
          child: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                floating: true,
                snap: true,
                pinned: false,
                expandedHeight: 400,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const Text(
                          "My Wallet",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            fontFamily: "segeo",
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Manage your coins and track your earnings",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff666666),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: "segeo",
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 37,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFAC11C),
                                Color(0xFFFB9B37),
                                Color(0xFFF69D0C),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(
                                    0xffFFFFFF,
                                  ).withOpacity(0.1),
                                ),
                                child: Image.asset(
                                  "assets/icons/Coins.png",
                                  color: Colors.white,
                                  width: SizeConfig.screenWidth * 0.064,
                                  height: SizeConfig.screenHeight * 0.03,
                                ),
                              ),
                              Text(
                                'Current Balance',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffE9E9E9),
                                  fontFamily: 'segeo',
                                ),
                              ),
                              ValueListenableBuilder<int>(
                                valueListenable: _currentBalence,
                                builder: (context, balance, _) {
                                  return Text(
                                    balance.toString(),
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'segeo',
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Total Earned',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontFamily: 'segeo',
                                        ),
                                      ),
                                      ValueListenableBuilder<int>(
                                        valueListenable: _totelEarned,
                                        builder: (context, earned, _) {
                                          return Text(
                                            earned.toString(),
                                            style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontFamily: 'segeo',
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'Total Spent',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontFamily: 'segeo',
                                        ),
                                      ),
                                      ValueListenableBuilder<int>(
                                        valueListenable: _totelSpent,
                                        builder: (context, spent, _) {
                                          return Text(
                                            spent.toString(),
                                            style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontFamily: 'segeo',
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () =>
                                    context.push('/buy_coins_screens'),
                                label: ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                        colors: [
                                          Color(0xFFFAC11C),
                                          Color(0xFFFB9B37),
                                          Color(0xFFF69D0C),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ).createShader(
                                        Rect.fromLTWH(0, 0, 200, 20),
                                      ),
                                  child: Text(
                                    'Buy Coins',
                                    style: TextStyle(
                                      fontFamily: 'segeo',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 14,
                                  ),
                                ),
                                icon: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFAC11C),
                                        Color(0xFFFB9B37),
                                        Color(0xFFF69D0C),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: coinHistoryNotifier,
                    builder: (context, coinHistory, _) {
                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                coinHistoryNotifier.value = true;
                                context.read<WalletmoneyCubit>().getWallet(0);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: coinHistory
                                          ? const Color(0xffFB9B37)
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Coin History",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    fontFamily: 'segeo',
                                    color: Color(0xff333333),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                coinHistoryNotifier.value = false;
                                context.read<WalletmoneyCubit>().getWallet(1);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: !coinHistory
                                          ? const Color(0xffFB9B37)
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Achievements",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    fontFamily: 'segeo',
                                    color: Color(0xff333333),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 12),
                  if (coinHistoryNotifier.value) ...[
                    Expanded(
                      child: BlocListener<WalletmoneyCubit, WalletmoneyState>(
                        listener: (context, state) {
                          if (state is WalletmoneyStateLoaded) {
                            final wallet =
                                state.walletResponseModel.data?.wallet;

                            _currentBalence.value = _safeParse(
                              wallet?.currentBalance,
                            );
                            _totelEarned.value = _safeParse(
                              wallet?.totalEarned,
                            );
                            _totelSpent.value = _safeParse(wallet?.totalSpent);
                          }
                        },
                        child: BlocBuilder<WalletmoneyCubit, WalletmoneyState>(
                          builder: (context, state) {
                            if (state is WalletmoneyStateLoading) {
                              return CoinsHistoryShimmer();
                            } else if (state is WalletmoneyStateLoaded ||
                                state is WalletmoneyStateLoadingMore) {
                              final walletModel =
                                  (state is WalletmoneyStateLoaded)
                                  ? (state as WalletmoneyStateLoaded)
                                        .walletResponseModel
                                  : (state as WalletmoneyStateLoadingMore)
                                        .walletResponseModel;
                              final coinsHistoryList =
                                  walletModel
                                      .data
                                      ?.transactions
                                      ?.transectionsData ??
                                  [];

                              if (coinsHistoryList.isEmpty) {
                                return Column(
                                  children: [
                                    Center(
                                      child: Image.asset(
                                        "assets/nodata/no_data.png",
                                        width: 200,
                                      ),
                                    ),
                                    Text(
                                      "No Coins History available",

                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'segeo',
                                      ),
                                    ),
                                  ],
                                );
                              }

                              return NotificationListener<ScrollNotification>(
                                onNotification: (scrollInfo) {
                                  if (scrollInfo.metrics.pixels >=
                                      scrollInfo.metrics.maxScrollExtent *
                                          0.9) {
                                    if (state is WalletmoneyStateLoaded &&
                                        state.hasNextPage) {
                                      if (coinHistoryNotifier.value == true) {
                                        context
                                            .read<WalletmoneyCubit>()
                                            .fetchMoreWallet(0);
                                      } else {
                                        context
                                            .read<WalletmoneyCubit>()
                                            .fetchMoreWallet(1);
                                      }
                                    }
                                  }
                                  return false;
                                },
                                child: CustomScrollView(
                                  slivers: [
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate((
                                        context,
                                        index,
                                      ) {
                                        final historyItem =
                                            coinsHistoryList[index];
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffFFFFFF),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: Color(0xffF3E8FF),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),
                                                ),
                                                child: Image.asset(
                                                  historyItem.type == "Debited"
                                                      ? "assets/icons/VideoConference.png"
                                                      : "assets/icons/CoinVertical.png",
                                                  width: 20,
                                                  height: 20,
                                                  fit: BoxFit.cover,
                                                  color: const Color(
                                                    0xffA351EE,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      historyItem.activity ??
                                                          'Unknown Activity',
                                                      style: const TextStyle(
                                                        color: Color(
                                                          0xff555555,
                                                        ),
                                                        fontFamily: 'segeo',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "on ${formatDate(historyItem.date ?? 'No Date')}",
                                                      style: const TextStyle(
                                                        color: Color(
                                                          0xff666666,
                                                        ),
                                                        fontFamily: 'segeo',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    historyItem.type ??
                                                        'Unknown',
                                                    style: const TextStyle(
                                                      color: Color(0xff333333),
                                                      fontFamily: 'segeo',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        "assets/icons/Coins.png",
                                                        width: 20,
                                                        height: 20,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        historyItem.coins
                                                                ?.toString() ??
                                                            "0",
                                                        style: const TextStyle(
                                                          color: Color(
                                                            0xff444444,
                                                          ),
                                                          fontFamily: 'segeo',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }, childCount: coinsHistoryList.length),
                                    ),
                                    if (state is WalletmoneyStateLoadingMore)
                                      const SliverToBoxAdapter(
                                        child: Padding(
                                          padding: EdgeInsets.all(25.0),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 0.8,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            } else if (state is WalletmoneyStateFailure) {
                              return Center(child: Text(state.msg));
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: BlocBuilder<CoinsAchievementCubit, CoinsAchievementState>(
                        builder: (context, state) {
                          if (state is CoinsAchievementLoading) {
                            return CoinsHistoryShimmer();
                          } else if (state is CoinsAchievementLoaded ||
                              state is CoinsAchievementLoadingMore) {
                            final coinsAchievements =
                                (state is CoinsAchievementLoaded)
                                ? state.coinsAchievementModel
                                : (state as CoinsAchievementLoadingMore)
                                      .coinsAchievementModel;

                            final achievementsList =
                                coinsAchievements.achievement?.data ?? [];

                            if (achievementsList.isEmpty) {
                              return Column(
                                children: [
                                  Center(
                                    child: Image.asset(
                                      "assets/nodata/no_data.png",
                                      width: 200,
                                    ),
                                  ),
                                  Text(
                                    "No Achievements available",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'segeo',
                                    ),
                                  ),
                                ],
                              );
                            }

                            return NotificationListener<ScrollNotification>(
                              onNotification: (scrollInfo) {
                                if (scrollInfo.metrics.pixels >=
                                    scrollInfo.metrics.maxScrollExtent * 0.9) {
                                  if (state is CoinsAchievementLoaded &&
                                      state.hasNextPage) {
                                    context
                                        .read<CoinsAchievementCubit>()
                                        .fetchMoreCoinsAchievements(0);
                                  }
                                }
                                return false;
                              },
                              child: CustomScrollView(
                                slivers: [
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate((
                                      context,
                                      index,
                                    ) {
                                      final achievement =
                                          achievementsList[index];
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffFFFFFF),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: const Color(0xffF3E8FF),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: Image.asset(
                                                "assets/icons/CoinVertical.png",
                                                width: 20,
                                                height: 20,
                                                fit: BoxFit.cover,
                                                color: const Color(0xffA351EE),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    achievement.type ??
                                                        'Unknown',
                                                    style: const TextStyle(
                                                      color: Color(0xff555555),
                                                      fontFamily: 'segeo',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    "From ${achievement.periodStartDate ?? '-'} to ${achievement.periodEndDate ?? '-'}",
                                                    style: const TextStyle(
                                                      color: Color(0xff666666),
                                                      fontFamily: 'segeo',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "${achievement.coinsReceived ?? 0} Coins",
                                                  style: const TextStyle(
                                                    color: Color(0xff333333),
                                                    fontFamily: 'segeo',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }, childCount: achievementsList.length),
                                  ),
                                  if (state is CoinsAchievementLoadingMore)
                                    const SliverToBoxAdapter(
                                      child: Padding(
                                        padding: EdgeInsets.all(25.0),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 0.8,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          } else if (state is CoinsAchievementFailure) {
                            return Center(child: Text(state.msg));
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CoinsHistoryShimmer extends StatelessWidget {
  const CoinsHistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        /// 🔹 Shimmer List
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    /// Left icon shimmer
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xffF3E8FF),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: shimmerCircle(28, context),
                    ),
                    const SizedBox(width: 12),

                    /// Middle text column shimmer
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          shimmerText(140, 14, context), // Activity title
                          const SizedBox(height: 4),
                          shimmerText(100, 12, context), // Date
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    /// Right column shimmer (Type + Coins)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        shimmerText(60, 12, context), // Type
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            shimmerCircle(20, context), // Coin icon
                            const SizedBox(width: 6),
                            shimmerText(40, 14, context), // Coin value
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            childCount: 6, // show 6 shimmer placeholders
          ),
        ),

        /// Optional shimmer loading indicator (for pagination)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 0.8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

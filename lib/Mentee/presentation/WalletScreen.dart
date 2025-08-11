import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/presentation/Widgets/CommonBackground.dart';
import 'package:mentivisor/Mentee/presentation/BuyCoinsScreens.dart';
import 'package:mentivisor/utils/color_constants.dart';
import 'package:mentivisor/utils/media_query_helper.dart';
import '../data/cubits/WalletMoney/WalletMoney_Cubit.dart';
import '../data/cubits/WalletMoney/WalletMoney_State.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool coinHistory = true;

  @override
  void initState() {
    super.initState();
    context.read<WalletmoneyCubit>().getwalletmoney();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF8EC),
      body: SafeArea(
        child: Background1(
          child: NestedScrollView(
            physics: BouncingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                backgroundColor:Colors.transparent,
                elevation: 0,
                floating: true,
                snap: true,
                pinned: false,
                expandedHeight: 550,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 37),
                    child: Column(
                      children: [
                        Text(
                          "My Wallet",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
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
                        const SizedBox(height: 16),
                        BlocBuilder<WalletmoneyCubit, WalletmoneyState>(
                          builder: (context, state) {
                            if (state is WalletmoneyStateLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is WalletmoneyStateLoaded) {
                              final coins =
                                  state.walletResponseModel.data?.wallet;
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 37,
                                  vertical: 32,
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
                                        height: SizeConfig.screenHeight * 0.064,
                                      ),
                                    ),
                                    const Text(
                                      'Current Balance',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xffE9E9E9),
                                        fontFamily: 'segeo',
                                      ),
                                    ),
                                    Text(
                                      coins?.currentBalance ?? "0",
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontFamily: 'segeo',
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            const Text(
                                              'Total Earned',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontFamily: 'Segoe',
                                              ),
                                            ),
                                            Text(
                                              coins?.totalEarned ?? "0",
                                              style: const TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                fontFamily: 'Segoe',
                                              ),
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
                                                fontFamily: 'Segoe',
                                              ),
                                            ),
                                            Text(
                                              coins?.totalSpent ?? "0",
                                              style: const TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                fontFamily: 'Segoe',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          context.push('/buy_coins_screens'),
                                      label: Text(
                                        'Buy Coins',
                                        style: TextStyle(
                                          fontFamily: 'segeo',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          foreground: Paint()
                                            ..shader =
                                                const LinearGradient(
                                                  colors: [
                                                    Color(0xFFFAC11C),
                                                    Color(0xFFFB9B37),
                                                    Color(0xFFF69D0C),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ).createShader(
                                                  const Rect.fromLTWH(
                                                    0,
                                                    0,
                                                    200,
                                                    20,
                                                  ),
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
                              );
                            } else if (state is WalletmoneyStateFailure) {
                              return Center(child: Text(state.msg));
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
        
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => coinHistory = true),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
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
                            child: const Text(
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
                          onTap: () => setState(() => coinHistory = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
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
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: BlocBuilder<WalletmoneyCubit, WalletmoneyState>(
                      builder: (context, state) {
                        if (state is WalletmoneyStateLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is WalletmoneyStateLoaded) {
                          final coinsHistoryList =
                              state
                                  .walletResponseModel
                                  .data
                                  ?.creditedCoins
                                  ?.coinsHistory ??
                              [];
                          return CustomScrollView(
                            // physics: const BouncingScrollPhysics(),
                            slivers: [
                              coinHistory
                                  ? coinsHistoryList.isEmpty
                                        ? SliverToBoxAdapter(
                                            child: const Center(
                                              child: Text(
                                                "No coin history available",
                                                style: TextStyle(
                                                  fontFamily: 'segeo',
                                                  fontSize: 16,
                                                  color: Color(0xff666666),
                                                ),
                                              ),
                                            ),
                                          )
                                        : SliverList(
                                            delegate: SliverChildBuilderDelegate((
                                              context,
                                              index,
                                            ) {
                                              final historyItem =
                                                  coinsHistoryList[index];
                                              return Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                    ),
                                                padding: const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xffFFFFFF),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(6),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                          0xffF3E8FF,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              100,
                                                            ),
                                                      ),
                                                      child: Image.asset(
                                                        historyItem.type ==
                                                                "Debited"
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
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            historyItem
                                                                    .activity ??
                                                                'Unknown Activity',
                                                            style:
                                                                const TextStyle(
                                                                  color: Color(
                                                                    0xff555555,
                                                                  ),
                                                                  fontFamily:
                                                                      'segeo',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 14,
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                            historyItem.date ??
                                                                'No Date',
                                                            style:
                                                                const TextStyle(
                                                                  color: Color(
                                                                    0xff666666,
                                                                  ),
                                                                  fontFamily:
                                                                      'segeo',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
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
                                                            color: Color(
                                                              0xff333333,
                                                            ),
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
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              historyItem.coins
                                                                      ?.toString() ??
                                                                  "0",
                                                              style:
                                                                  const TextStyle(
                                                                    color: Color(
                                                                      0xff444444,
                                                                    ),
                                                                    fontFamily:
                                                                        'segeo',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
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
                                          )
                                  : SliverToBoxAdapter(
                                      child: const Center(
                                        child: Text(
                                          "Achievements not yet implemented",
                                          style: TextStyle(
                                            fontFamily: 'segeo',
                                            fontSize: 16,
                                            color: Color(0xff666666),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          );
                        } else if (state is WalletmoneyStateFailure) {
                          return Center(child: Text(state.msg));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

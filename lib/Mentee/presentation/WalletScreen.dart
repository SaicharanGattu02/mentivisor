import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/presentation/Widgets/CommonBackground.dart';
import 'package:mentivisor/Mentee/presentation/BuyCoinsScreens.dart';
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
    context.read<WalletmoneyCubit>().getwalletmoney();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF8EC),
      appBar: CustomAppBar1(title: "Wallet", actions: []),
      body: Background1(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 37),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "My Wallet",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  fontFamily: "segeo",
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "manage your coins and track your earnings",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff666666),
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  fontFamily: "segeo",
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<WalletmoneyCubit, WalletmoneyState>(
                builder: (context, state) {
                  if (state is WalletmoneyStateLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WalletmoneyStateLoaded) {
                    final coins = state.walletResponseModel.data?.wallet;

                    return Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFAC11C),
                                  Color(0xFFFB9B37),
                                  Color(0xFFF69D0C),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.monetization_on,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Current Balance',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'Segoe',
                                  ),
                                ),
                                Text(
                                  coins?.currentBalance ?? "0",
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Segoe',
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                          coins?.totalEarned ?? "",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'Segoe',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 32),
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
                                          coins?.totalSpent ?? "",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'Segoe',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      context.push('/buy_coins_screens'),
                                  icon: const Icon(
                                    Icons.add,
                                    size: 18,
                                    color: Color(0xFF8A56AC),
                                  ),
                                  label: const Text(
                                    'Buy Coins',
                                    style: TextStyle(
                                      fontFamily: 'Segoe',
                                      fontSize: 16,
                                      color: Color(0xFF8A56AC),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => coinHistory = true),
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
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        fontFamily: 'segeo',
                                        color: coinHistory
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => coinHistory = false),
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
                                    child: Text(
                                      "Achievements",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        fontFamily: 'segeo',
                                        color: !coinHistory
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: CustomScrollView(
                              slivers: [
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final coinsHistoryList = state
                                          .walletResponseModel
                                          .data
                                          ?.creditedCoins
                                          ?.coinsHistory?[index];
                                      coinsHistoryList?.type ??
                                          ('' == "Debited");

                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
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
                                                (coinsHistoryList?.type ??
                                                            '') ==
                                                        "Debited"
                                                    ? "assets/icons/VideoConference.png"
                                                    : "assets/icons/CoinVertical.png",
                                                width: 20,
                                                height: 20,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    coinsHistoryList
                                                            ?.activity ??
                                                        '',
                                                    style: TextStyle(
                                                      color: Color(0xff555555),
                                                      fontFamily: 'segeo',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    coinsHistoryList?.date ??
                                                        '',
                                                    style: TextStyle(
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
                                                  coinsHistoryList?.type ?? '',
                                                  style: TextStyle(
                                                    color: Color(0xff333333),
                                                    fontFamily: 'segeo',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
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
                                                      coinsHistoryList?.coins
                                                              .toString() ??
                                                          "0",
                                                      style: TextStyle(
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
                                    },
                                    childCount: state
                                        .walletResponseModel
                                        .data
                                        ?.creditedCoins
                                        ?.coinsHistory
                                        ?.length,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is WalletmoneyStateFailure) {
                    return Text(state.msg);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

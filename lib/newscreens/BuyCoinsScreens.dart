import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/CoinsPack/coins_pack_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/CoinsPack/coins_pack_state.dart';

class BuyCoinsScreens extends StatefulWidget {
  const BuyCoinsScreens({Key? key}) : super(key: key);

  @override
  _BuyCoinsScreenState createState() => _BuyCoinsScreenState();
}

class _BuyCoinsScreenState extends State<BuyCoinsScreens> {
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    // Call API after widget is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoinsPackCubit>().fetchCoinsPack();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buy Coins',
          style: TextStyle(
            fontFamily: 'segeo',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        leading: const BackButton(color: Color(0xff222222)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFFFF8EE),
      body: Column(
        children: [
          // Top illustration
          Container(
            margin: const EdgeInsets.all(16),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade200,
              image: const DecorationImage(
                image: AssetImage('assets/images/buycoinsimg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Section title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Current Offers',
                style: TextStyle(
                  fontFamily: 'segeo',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          /// ✅ FIXED: Wrap BlocBuilder with Expanded
          Expanded(
            child: BlocBuilder<CoinsPackCubit, CoinsPackState>(
              builder: (context, state) {
                if (state is CoinsPackStateLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CoinsPackStateLoaded) {
                  final packs = state.coinsPackRespModel.data ?? [];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GridView.builder(
                      itemCount: packs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.65,
                          ),


                      itemBuilder: (context, index) {
                        final coinspack = packs[index];
                        final selected = index == _selectedIndex;

                        return GestureDetector(
                          onTap: () => setState(() => _selectedIndex = index),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xffA351EE)
                                  : const Color(0xffFFF8EC),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/images/GoldCoins.png",
                                        width: 32,
                                        height: 32,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        coinspack.coins?.toString() ?? "0",
                                        style: const TextStyle(
                                          fontFamily: 'segeo',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const Text(
                                        'Coins',
                                        style: TextStyle(
                                          fontFamily: 'segeo',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? Colors.white
                                        : const Color(0xffA351EE),
                                    borderRadius: BorderRadius.circular(36),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${coinspack.discountPercent?.toString() ?? "0"}% off',
                                      style: TextStyle(
                                        fontFamily: 'segeo',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: selected
                                            ? const Color(0xff340063)
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                Text(
                                  'for ${coinspack.discountPercent?.toString() ?? "0"}  ${coinspack.offerPrice?.toString() ?? "0"}',
                                  style: TextStyle(
                                    fontFamily: 'segeo',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: selected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is CoinsPackStateFailure) {
                  return Center(
                    child: Text(state.msg ?? "Something went wrong"),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

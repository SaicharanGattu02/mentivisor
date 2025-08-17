import 'dart:developer' as AppLogger;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/CoinsPack/coins_pack_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/CoinsPack/coins_pack_state.dart';
import 'package:mentivisor/Mentee/data/cubits/Payment/payment_states.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../Components/CustomSnackBar.dart';
import '../data/cubits/Payment/payment_cubit.dart';

class BuyCoinsScreens extends StatefulWidget {
  const BuyCoinsScreens({Key? key}) : super(key: key);

  @override
  _BuyCoinsScreenState createState() => _BuyCoinsScreenState();
}

class _BuyCoinsScreenState extends State<BuyCoinsScreens> {
  late Razorpay _razorpay;
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(-1);
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoinsPackCubit>().fetchCoinsPack();
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    AppLogger.log(
      "✅ Payment successful: ${response.paymentId} ${response.signature}",
    );
    Map<String, dynamic> data = {
      "razorpay_order_id": response.orderId,
      "razorpay_payment_id": response.paymentId,
      "razorpay_signature": response.signature,
    };
    context.read<PaymentCubit>().verifyPayment(data);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    AppLogger.log("❌ Payment failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    AppLogger.log("💼 External wallet selected: ${response.walletName}");
  }

  void _openCheckout(String key, String order_id, int amount) {
    var options = {
      'key': '$key',
      'amount': amount,
      'currency': 'INR',
      // 'name': service_name,
      'order_id': '$order_id',
      'description': 'purchase',
      'timeout': 60,
      // 'prefill': {'contact': mobile, 'email': email},
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      AppLogger.log('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(
        title: "Buy Coins",
        actions: [],
        color: Color(0xffFFF8EC),
      ),
      backgroundColor: Color(0xffFFF8EC),
      body: Column(
        children: [
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
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.68,
                          ),
                      itemBuilder: (context, index) {
                        final coinspack = packs[index];
                        final selected = index == _selectedIndex;
                        return GestureDetector(
                          onTap: () => setState(() =>selectedIndexNotifier.value = index,),
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
                                  padding: EdgeInsets.all(10),
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: BlocConsumer<PaymentCubit, PaymentStates>(
            listener: (context, state) {
              isLoadingNotifier.value = state is PaymentLoading;
              if (state is PaymentCreated) {
                final payment_created_data = state.createPaymentModel;
                // call _openCheckout() here
              } else if (state is PaymentVerified) {
                context.pushReplacement(
                  '/success_screen'
                      '?title=${Uri.encodeComponent("Payment is Done Successfully")}'
                      '&subTitle=${Uri.encodeComponent("Please check your profile for the owned services")}'
                      '&next=/dashboard?initialTab=3',
                );
              } else if (state is PaymentFailure) {
                CustomSnackBar1.show(context, state.error);
              }
            },
            builder: (context, state) {
              return CustomAppButton1(text: 'Submit', onPlusTap: () {
                final selectedIndex = selectedIndexNotifier.value;
                if (selectedIndex == -1) {
                  CustomSnackBar1.show(context, "Please select a pack");
                  return;
                }
                // ✅ call create payment with selected pack
              });
            },
          ),
        ),
      ),
    );
  }
}

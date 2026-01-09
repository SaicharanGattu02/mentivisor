import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Components/CutomAppBar.dart';
import '../Models/PlanModel.dart';
import '../data/cubits/Subscription/SubscriptionCubit.dart';
import '../data/cubits/Subscription/SubscriptionState.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late SubscriptionCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = SubscriptionCubit();

    // Load your plans here
    cubit.loadPlans([
      PlanModel(
        productId: 'com.mentivisor.wallet.starter_pack',
        title: 'Starter Pack — ₹99',
        description: 'Get 100 coins to start your wallet journey.',
      ),
      PlanModel(
        productId: 'com.mentivisor.wallet.value_pack',
        title: 'Value Pack — ₹249 ',
        description: '400 coins total(50 bonus).Best value for regular users.',
      ),

      PlanModel(
        productId: 'com.mentivisor.wallet.pro_pack',
        title: 'Pro Pack — ₹499 ',
        description: '950 coins (150 bonus). More power, more rewards.',
      ),

      PlanModel(
        productId: 'com.mentivisor.wallet.elite_pack',
        title: 'Elite Pack — ₹999',
        description: '2200 coins (400 bonus). Ultimate pack for power users.',
      ),
    ]);
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar1(title: "Subscription Plans", actions: []),
      body: BlocBuilder<SubscriptionCubit, SubscriptionState>(
        bloc: cubit,
        builder: (context, state) {
          if (state is SubscriptionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SubscriptionLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                final bool purchased = state.purchases.any(
                  (p) => p.productID == product.id,
                );

                return Card(
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          product.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                        ),

                        const SizedBox(height: 8),

                        // Description
                        Text(
                          product.description,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.black87),
                        ),

                        const SizedBox(height: 16),

                        // Price & Action Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Price
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                product.price,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueAccent,
                                    ),
                              ),
                            ),

                            // Button
                            purchased
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      "Purchased",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      final plan = state.plans.firstWhere(
                                        (p) => p.productId == product.id,
                                      );
                                      cubit.buyPlan(plan);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                    ),
                                    child: const Text(
                                      "Buy Now",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
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
            );
          } else if (state is SubscriptionError) {
            return Center(
              child: Text(
                state.message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.redAccent),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

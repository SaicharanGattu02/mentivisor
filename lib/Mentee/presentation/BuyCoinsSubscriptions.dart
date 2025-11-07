import 'package:flutter/material.dart';

class BuyCoinsSubscriptions extends StatelessWidget {
  final List<Map<String, dynamic>> coinPlans = [
    {
      'coins': 200,
      'oldPrice': 500,
      'newPrice': 300,
      'discount': 45,
      'productId': 'com.yourapp.wallet.200coins'
    },
    {
      'coins': 1000,
      'oldPrice': 500,
      'newPrice': 300,
      'discount': 45,
      'productId': 'com.yourapp.wallet.1000coins'
    },
    {
      'coins': 1200,
      'oldPrice': 500,
      'newPrice': 300,
      'discount': 45,
      'productId': 'com.yourapp.wallet.1200coins'
    },
    {
      'coins': 1600,
      'oldPrice': 500,
      'newPrice': 300,
      'discount': 45,
      'productId': 'com.yourapp.wallet.1600coins'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Buy Coins',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Image.asset(
                'assets/wallet.png',
                height: 200,
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Current Offers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: coinPlans.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final plan = coinPlans[index];
                  return _buildCoinCard(context, plan);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinCard(BuildContext context, Map<String, dynamic> plan) {
    return GestureDetector(
      onTap: () {
        // Handle in-app purchase trigger here
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.monetization_on_rounded,
                  color: Colors.amber, size: 40),
              const SizedBox(height: 10),
              Text(
                '${plan['coins']} Coins',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF9156F0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${plan['discount']}% off',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'for ',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 13,
                      ),
                    ),
                    TextSpan(
                      text: '${plan['oldPrice']}',
                      style: const TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 13,
                      ),
                    ),
                    TextSpan(
                      text: '  ${plan['newPrice']}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

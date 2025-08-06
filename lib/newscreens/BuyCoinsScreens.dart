import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class BuyCoinsScreens extends StatefulWidget {
  const BuyCoinsScreens({Key? key}) : super(key: key);

  @override
  _BuyCoinsScreenState createState() => _BuyCoinsScreenState();
}

class _BuyCoinsScreenState extends State<BuyCoinsScreens> {
  // final List<CoinPackage> _packages = [
  //   CoinPackage(coins: 1600, original: 500, price: 300, discountPercent: 45),
  //   CoinPackage(coins: 200, original: 500, price: 300, discountPercent: 45),
  //   CoinPackage(coins: 1000, original: 500, price: 300, discountPercent: 45),
  //   CoinPackage(coins: 1200, original: 500, price: 300, discountPercent: 45),
  //   CoinPackage(coins: 1600, original: 500, price: 300, discountPercent: 45),
  //   CoinPackage(coins: 200, original: 500, price: 300, discountPercent: 45),
  //   CoinPackage(coins: 1000, original: 500, price: 300, discountPercent: 45),
  //   CoinPackage(coins: 1200, original: 500, price: 300, discountPercent: 45),
  // ];

  int _selectedIndex = -1;

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
          // Grid of packages: 4 columns
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                itemCount: 10,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.66,
                ),
                itemBuilder: (context, index) {
                  final selected = index == _selectedIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIndex = index),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selected ? Color(0xffA351EE) : Color(0xffFFF8EC),
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
                              borderRadius: BorderRadiusGeometry.circular(16),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.monetization_on,
                                  size: 28,
                                  color: Color(0xFFFFB300),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "10",
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
                            padding:  EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: selected ? Colors.white : Color(0xffA351EE),
                              borderRadius:  BorderRadius.circular(36)
                            ),
                            child: Center(
                              child: Text(
                                '18% off',
                                style: TextStyle(
                                  fontFamily: 'segeo',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: selected ? Color(0xff340063) : Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "for 500 300",
                            style: TextStyle(
                              fontFamily: 'segeo',
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: selected ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CoinPackage {
  final int coins;
  final int original;
  final int price;
  final int discountPercent;

  CoinPackage({
    required this.coins,
    required this.original,
    required this.price,
    required this.discountPercent,
  });
}

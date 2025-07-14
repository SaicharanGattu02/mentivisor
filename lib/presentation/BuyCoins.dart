import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BuyCoinsScreen extends StatelessWidget {
  const BuyCoinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xfff6faff),
              Color(0xffe0f2fe),
            ], // Replace with your desired gradient
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                  height: 40,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(width: 1, color: Color(0xffe2e8f0)),
                      padding: EdgeInsets
                          .zero, // Ensures no extra padding disturbs centering
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Buy Coins",
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A2A44),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Choose a bundle that works for you",
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B7280),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xffdcfce7),
                        Color(0xffd1fae5),
                      ], // Replace with your desired gradient
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      SvgPicture.asset(
                        "assets/svg_icons/coins.svg",
                        color: Color(0xFF065F46),
                        height: 20,
                        width: 20,
                      ),
                      const Text(
                        'Current Balance: 150 coins',
                        style: TextStyle(
                          color: Color(0xFF065F46),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'segeo',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _starterPackCard(),
                _valuePackCard(),
                _powerPackCard(),
                _premiumPackCard(),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xffe0f2fe),
                        Color(0xfff6faff),
                      ], // Replace with your desired gradient
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Why Buy Coins?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'segeo',
                        ),
                      ),
                      const SizedBox(height: 12),
                      _featureTile(
                        icon: Icons.bolt_outlined,
                        title: 'Instant Access',
                        subtitle: 'Book sessions immediately without waiting',
                        color: Colors.blue,
                      ),
                      _featureTile(
                        icon: Icons.star_border_outlined,
                        title: 'Premium Mentors',
                        subtitle: 'Access to top-rated mentors and experts',
                        color: Colors.purple,
                      ),
                      _featureTile(
                        icon: Icons.verified_outlined,
                        title: 'Exclusive Features',
                        subtitle: 'Unlock special features and priority support',
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
          
                const SizedBox(height: 16),
                const Text(
                  '🔒 Secure payment processing · 30-day money-back guarantee · Cancel anytime',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'segeo',
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _starterPackCard() {
    return _buildCard(
      title: 'Starter Pack',
      coins: '50',
      price: '\$  4.99',
      gradient: const LinearGradient(
        colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
      ),
      svgIcon: SvgPicture.asset(
        'assets/svg_icons/coins.svg',
        color: Colors.white,
      ),
    );
  }

  Widget _valuePackCard() {
    return _buildCard(
      title: 'Value Pack',
      coins: '120',
      price: '\$ 9.99',
      bonus: '+ 20 bonus coins!',
      mostPopular: true,
      gradient: const LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
      ),
      icon: Icons.star_border_rounded,
    );
  }

  Widget _powerPackCard() {
    return _buildCard(
      title: 'Power Pack',
      coins: '250',
      price: '\$ 19.99',
      bonus: '+ 50 bonus coins!',
      gradient: const LinearGradient(
        colors: [Color(0xFFF97316), Color(0xFFEA580C)],
      ),
      icon: Icons.flash_on,
    );
  }

  Widget _premiumPackCard() {
    return _buildCard(
      title: 'Premium Pack',
      coins: '500',
      price: '\$ 34.99',
      bonus: '+ 150 bonus coins!',
      gradient: const LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
      ),
      icon: Icons.workspace_premium,
    );
  }

  Widget _buildCard({
    required String title,
    required String coins,
    required String price,
    String? bonus,
    bool mostPopular = false,
    required LinearGradient gradient,
    IconData? icon,
    Widget? svgIcon,
  }) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: gradient,
                ),
                child: svgIcon ?? Icon(icon, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: 'segeo',
                ),
              ),
              const SizedBox(height: 6),
              Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg_icons/coins.svg',
                    color: Color(0xffeab308),
                    width: 20,
                    height: 20,
                  ),
                  Text(
                    coins,
                    style: const TextStyle(fontSize: 16, fontFamily: 'segeo'),
                  ),
                ],
              ),
              if (bonus != null)
                Text(
                  bonus,
                  style: const TextStyle(
                    color: Colors.green,
                    fontFamily: 'segeo',
                    fontSize: 12,
                  ),
                ),
              const SizedBox(height: 10),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'segeo',
                  color: Color(0xFF8B5CF6),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mostPopular
                        ? const Color(0xFF8B5CF6)
                        : Colors.white,
                    side: BorderSide(
                      color: mostPopular
                          ? Colors.transparent
                          : Colors.grey.shade300,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Purchase',
                    style: TextStyle(
                      color: mostPopular ? Colors.white : Colors.black,
                      fontFamily: 'segeo',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (mostPopular)
          Positioned(
            top: 0,
            left: 120,
            right: 120,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: const BoxDecoration(
                color: Color(0xFF8B5CF6),
                borderRadius: BorderRadius.all(Radius.circular(36)),
              ),
              child: Center(
                child: const Text(
                  'Most Popular',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontFamily: 'segeo',
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _featureTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.3),
              child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'segeo',
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'segeo',
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CouponsHomeScreen extends StatelessWidget {
  const CouponsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // If you need a top bar, add an AppBar here.
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEFF6FF), // #EFF6FF
              Color(0xFFF5F6FF), // #F5F6FF
              Color(0xFFFAF5FF), // #FAF5FF
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Earnings =====
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

                // Two stat cards
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        bgColor: const Color(0xFFFFE7B6), // warm yellow
                        title: 'Total Coins',
                        value: '28,000',
                        // replace with your art
                        trailing: Image.asset(
                          'images/groupcoins.png',
                          height: 36,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        bgColor: const Color(0xFFBFD1FF), // light blue
                        title: 'This Month',
                        value: '6800',
                        trailing: Image.asset(
                          'images/groupcoins.png',
                          height: 36,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // tiny notes under each card (aligned under their card)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(
                      child: Text(
                        '= with out commission ₹2800',
                        style: TextStyle(
                          fontFamily: 'segeo',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF7B7F8C),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '+ 15% from last month',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'segeo',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF7B7F8C),
                        ),
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
                      // put your illustration here
                      asset: 'images/bagsimg.png',
                    ),
                    _CategoryCard(
                      title: 'Restaurant',
                      asset: 'images/personimg.png',
                    ),
                    _CategoryCard(
                      title: 'Grocery',
                      asset: 'images/grosary.png',
                    ),
                    _CategoryCard(
                      title: 'Travel',
                      asset: 'images/travelscreen.png',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
  });

  final Color bgColor;
  final String title;
  final String value;
  final Widget trailing;

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
                  style: const TextStyle(
                    fontFamily: 'segeo',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'segeo',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF121212),
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
  const _CategoryCard({
    required this.title,
    required this.asset,
  });

  final String title;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Center(
              child: Image.asset(
                asset,
                fit: BoxFit.contain,
              ),
            ),
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
    );
  }
}

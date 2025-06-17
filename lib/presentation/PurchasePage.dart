import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class PurchasePage extends StatelessWidget {
  const PurchasePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Container(
        padding: EdgeInsets.all(16),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
              SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Complete Your Purchase',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "You're about to unlock premium content",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Purchase Summary',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/download.jpg',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Complete DSA Roadmap 2024',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Comprehensive guide covering all data structures and algorithms',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '4.8 rating',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '1250 downloads',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 30,
                      thickness: 0.5,
                      color: Colors.grey.shade300,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Cost:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg_icons/coins.svg",
                              color: Color(0xFFeab308),
                              height: 20,
                              width: 20,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '25 coins',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Details',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Current Balance:',
                          style: TextStyle(fontFamily: 'Inter'),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg_icons/coins.svg",
                              color: Color(0xFFeab308),
                              height: 20,
                              width: 20,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '145 coins',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'After Purchase:',
                          style: TextStyle(fontFamily: 'Inter'),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg_icons/coins.svg",
                              color: Color(0xFFeab308),
                              height: 20,
                              width: 20,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '120 coins',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffe0f2fe),
                      Color(0xfff6faff),
                    ], // Replace with your desired gradient
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'What You Get',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        fontFamily: 'Inter',
                        color: Color(0xFF7C3AED),
                      ),
                    ),
                    SizedBox(height: 14),
                    _benefitItem(Icons.download_outlined, 'Instant download access'),
                    _benefitItem(
                      Icons.verified_outlined,
                      '30-day money-back guarantee',
                    ),
                    _benefitItem(Icons.bolt_outlined, 'Lifetime access to updates'),
                    _benefitItem(Icons.star_border_purple500_outlined, 'Access to author Q&A'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    context.push("/purchase_success_screen");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      SvgPicture.asset(
                        "assets/svg_icons/coins.svg",
                        color: Colors.white,
                        height: 20,
                        width: 20,
                      ),
                      Text(
                        'Purchase for 25 coins',
                        style: TextStyle(color: Colors.white, fontFamily: 'Inter'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '🔒 Secure transaction • Cancel anytime • No hidden fees',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Inter',
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildCard({
    required Widget child,
    Color bgColor = Colors.white,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _benefitItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _benefitItem(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF7C3AED), size: 18),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontFamily: 'Inter', fontSize: 14)),
        ],
      ),
    );
  }
}

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WalletHistory extends StatefulWidget {
  const WalletHistory({super.key});

  @override
  State<WalletHistory> createState() => _WalletHistoryState();
}

class _WalletHistoryState extends State<WalletHistory> {
  String? _selectTransection;
  String? _selectTime;
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xfff0fdf4),
              Color(0xffeff6ff),
              Color(0xfff3e8ff),
            ], // Replace with your desired gradient
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: SingleChildScrollView(
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
                "Coin History",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A2A44),
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Track Your earnings and spending",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6B7280),
                ),
              ),
              SizedBox(height: 4),
              _buildStatCard(
                'Total Earned',
                '+50',
                const Color(
                  0xffbbf7d0,
                ), // Similar to Tailwind's `text-green-100`
                const [
                  Color(0xff22c55e), // Tailwind `from-green-500`
                  Color(0xff16a34a),
                ],
                icon: Icons.trending_up,
              ),

              _buildStatCard(
                'Total Spent',
                '-55',
                const Color(0xfffecaca), // Similar to Tailwind's `text-red-100`
                const [
                  Color(0xffef4444), // Tailwind `from-red-500`
                  Color(0xffdc2626), // Tailwind `to-red-600`
                ],
                icon: Icons.calendar_month, // Matching the calendar SVG icon
              ),

              _buildStatCard(
                'Purchased',
                '+120',
                const Color(
                  0xfffef9c3,
                ), // Similar to Tailwind's `text-yellow-100`
                const [
                  Color(0xfff59e0b), // Tailwind `from-yellow-500`
                  Color(0xffd97706), // Tailwind `to-yellow-600`
                ],
                icon: Icons.monetization_on, // Closest match to coins SVG icon
              ),
              SizedBox(height: 8),
              Container(
                width: w,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.filter_alt,
                          size: 18,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          textAlign: TextAlign.center,
                          "Filter by:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: w,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'All Transactions',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          items:
                              [
                                    'All Transactions',
                                    'Earned Only',
                                    'Spent Only',
                                    'Purchased Only',
                                  ]
                                  .map(
                                    (e) => DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          value: _selectTransection,
                          onChanged: (String? value) {
                            setState(() {
                              _selectTransection = value!;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFFCBD5E1),
                                width: 1,
                              ),
                              color: Colors.white,
                            ),
                            height: 40,
                            width: 192,
                          ),
                          iconStyleData: IconStyleData(
                            icon: Icon(Icons.keyboard_arrow_down_rounded),
                            iconSize: 20,
                            iconEnabledColor: Colors.grey.shade600,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white,
                            ),
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            height: 45,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>((
                                  Set<MaterialState> states,
                                ) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return Colors.grey.shade200;
                                  }
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.grey.shade300;
                                  }
                                  return null;
                                }),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: w,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'All Time',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          items:
                              [
                                    'All Time',
                                    'This Week',
                                    'This Month',
                                    'This Quarter',
                                  ]
                                  .map(
                                    (e) => DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          value: _selectTime,
                          onChanged: (String? value) {
                            setState(() {
                              _selectTime = value!;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFFCBD5E1),
                                width: 1,
                              ),
                              color: Colors.white,
                            ),
                            height: 40,
                            width: 192,
                          ),
                          iconStyleData: IconStyleData(
                            icon: Icon(Icons.keyboard_arrow_down_rounded),
                            iconSize: 20,
                            iconEnabledColor: Colors.grey.shade600,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white,
                            ),
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            height: 45,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>((
                                  Set<MaterialState> states,
                                ) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return Colors.grey.shade200;
                                  }
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.grey.shade300;
                                  }
                                  return null;
                                }),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: w,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Transaction History",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff020817),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: transaction.bgColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          transaction.icon,
                                          size: 20,
                                          color: transaction.iconColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: w * 0.4,
                                          child: Expanded(
                                            child: Text(
                                              transaction.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          transaction.date,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                /// Right section: points with icon
                                Row(
                                  children: [
                                    Icon(
                                      Icons.monetization_on_outlined,
                                      size: 18,
                                      color: transaction.amountColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      transaction.amount,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: transaction.amountColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: w,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xfff3e8ff),
                      Color(0xffeff6ff),

                      Color(0xfff0fdf4),
                    ], // Replace with your desired gradient
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Progress",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff6B21AB),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildProgressCard(
                      title: "Earning Streak",
                      progress: 0.7,
                      progressText: "7/10 days",
                      description:
                          "Earn coins for 3 more days to unlock a bonus!",
                      progressColor: LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Monthly Goal
                    _buildProgressCard(
                      title: "Monthly Goal",
                      progress: 0.85,
                      progressText: "170/200",
                      description:
                          "Earn 30 more coins this month for a special reward!",
                      progressColor: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.purple.shade600],
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

  Widget _buildStatCard(
    String title,
    String value,
    Color titleColor,
    List<Color> gradientColors, {
    String? svgAsset, // Optional SVG asset path
    IconData? icon, // Optional icon
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Text Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Right Icon or SVG
            svgAsset != null
                ? SvgPicture.asset(
                    svgAsset,
                    width: 32,
                    height: 32,
                    color: titleColor.withOpacity(0.8),
                  )
                : Icon(
                    icon ?? Icons.trending_up,
                    size: 32,
                    color: titleColor.withOpacity(0.8),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard({
    required String title,
    required double progress,
    required String progressText,
    required String description,
    required LinearGradient progressColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: progressColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              progressText,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }
}

class TransactionModel {
  final String title;
  final String date;
  final String amount;
  final Color bgColor;
  final IconData icon;
  final Color iconColor;
  final Color amountColor;

  TransactionModel({
    required this.title,
    required this.date,
    required this.amount,
    required this.bgColor,
    required this.icon,
    required this.iconColor,
    required this.amountColor,
  });
}

final transactions = [
  TransactionModel(
    title: "Session completed with Dr. Sarah Chen",
    date: "2024-01-15",
    amount: "+15",
    bgColor: Colors.green.shade100,
    icon: Icons.emoji_events_outlined,
    iconColor: Colors.green,
    amountColor: Colors.green,
  ),
  TransactionModel(
    title: "Booked session with Prof. Michael Rodriguez",
    date: "2024-01-14",
    amount: "-25",
    bgColor: Colors.red.shade100,
    icon: Icons.calendar_today_outlined,
    iconColor: Colors.red,
    amountColor: Colors.red,
  ),
  // Add the rest...
];

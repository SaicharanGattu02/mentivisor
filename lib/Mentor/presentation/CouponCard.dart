import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';

import '../../Components/CustomAppButton.dart';

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterSheet(
        initialValue: 'All Time',
        onApply: (value) {
          Navigator.pop(context, value);
        },
      ),
    );
  }

  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();
    CustomSnackBar1.show(context, "Code copied!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Coupons", actions: []),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEFF6FF), Color(0xFFF5F6FF), Color(0xFFFAF5FF)],
          ),
        ),
        padding: EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Recent",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w700,
                    color: Color(0xff121212),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    _openFilterSheet(context);
                  },
                  child: Image.asset(
                    "assets/images/filterimg.png",
                    height: 32,
                    width: 32,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "500",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Image.asset(
                              "assets/images/GoldCoins.png",
                              height: 24,
                              width: 24,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xff6595FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "New",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: const [
                            Icon(
                              Icons.calendar_month,
                              size: 16,
                              color: Color(0xff999999),
                            ),
                            SizedBox(width: 5),
                            Text(
                              "11 Jun 25",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xff575757),
                                fontFamily: "segeo",
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "Flipkart coupon",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff333333),
                            fontFamily: "segeo",
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () {
                            _copy(context, "MENTI 500");
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffF5F5F5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "MENTI 500",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff121212),
                                    fontFamily: "segeo",
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Image.asset(
                                  "assets/images/Copyimg.png",
                                  height: 16,
                                  width: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Worth of ₹ 1000",
                          style: TextStyle(
                            color: Color(0xff575757),
                            fontFamily: "segeo",
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left Side
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "500",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Image.asset(
                              "assets/images/GoldCoins.png",
                              height: 24,
                              width: 24,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Redeemed",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff333333),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: const [
                            Icon(
                              Icons.calendar_month,
                              size: 16,
                              color: Color(0xff999999),
                            ),
                            SizedBox(width: 5),
                            Text(
                              "11 Jun 25",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xff575757),
                                fontFamily: "segeo",
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Right Side
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "Flipkart coupon",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff333333),
                            fontFamily: "segeo",
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffF5F5F5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4),
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: "MENTI 500"),
                              );
                            },
                            child: Row(
                              children: [
                                const Text(
                                  "MENTI 500",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff121212),
                                    fontFamily: "segeo",
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Image.asset(
                                  "assets/images/Copyimg.png",
                                  height: 16,
                                  width: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Worth of ₹ 1000",
                          style: TextStyle(
                            color: Color(0xff575757),
                            fontFamily: "segeo",
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initialValue, required this.onApply});

  final String initialValue;
  final ValueChanged<String> onApply;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  final List<String> options = const [
    'All Time',
    'This Week',
    'This Month',
    'This Quarter',
  ];
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter',
            style: TextStyle(
              fontFamily: 'segeo',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xff444444),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Time',
            style: TextStyle(
              fontFamily: 'segeo',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF444444),
            ),
          ),
          const SizedBox(height: 8),
          ...options.map(
            (o) => InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => setState(() => selected = o),
              child: Row(
                children: [
                  Checkbox(
                    value: selected == o,
                    onChanged: (v) {
                      if (v == true) {
                        setState(() => selected = o);
                      }
                    },
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    side: BorderSide(color: Color(0xFF98A2B3), width: 1),
                    activeColor: Color(0xFF7F00FF),
                    checkColor: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    o,
                    style: TextStyle(
                      fontFamily: 'segeo',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF444444),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          SafeArea(
            child: CustomAppButton1(
              text: "Apply",
              onPlusTap: () => widget.onApply(selected),
            ),
          ),
        ],
      ),
    );
  }
}

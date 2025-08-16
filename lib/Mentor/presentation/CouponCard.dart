import 'package:flutter/material.dart';

import '../../Components/CustomAppButton.dart';
// import 'package:your_app/widgets/custom_app_button_1.dart'; // for CustomAppButton1 if needed

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent, // so inner rounded sheet is visible
      builder: (_) => _FilterSheet(
        initialValue: 'All Time',
        onApply: (value) {
          // TODO: apply your filter using `value` if you want
          Navigator.pop(context, value); // close the sheet
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Coupons",
          style: TextStyle(
            fontSize: 18,
            fontFamily: "segeo",
            fontWeight: FontWeight.w700,
            color: Color(0xff121212),
          ),
        ),
        leading: const Icon(Icons.arrow_back),
        centerTitle: true,
      ),

      body: Container(
        // 3-stop gradient background
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
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recent Header
            Row(
              children: [
                const Text(
                  "Recent",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff121212),
                  ),
                ),
                const Spacer(),
                // Tap filter image to open bottom sheet
                GestureDetector(
                  onTap: () => _openFilterSheet(context),
                  child: Image.asset(
                    "assets/images/filterimg.png",
                    height: 32,
                    width: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // --- Your existing cards stay unchanged below ---
            // First Coupon (New)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
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
                            const Text("500",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 6),
                            Image.asset("assets/images/GoldCoins.png", height: 24, width: 24),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xff6595FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text("New",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: const [
                            Icon(Icons.calendar_month, size: 16, color: Color(0xff999999)),
                            SizedBox(width: 5),
                            Text("11 Jun 25",
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
                        const Text("Flipkart coupon",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff333333),
                            fontFamily: "segeo",
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xffF5F5F5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children:  [
                              Text("MENTI 500",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff121212),
                                  fontFamily: "segeo",
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 10),
                              Image.asset("assets/images/Copyimg.png",height: 16,width: 16,),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text("Worth of ₹ 1000",
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

            // Second Coupon (Redeemed)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
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
                            const Text("500",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 6),
                            Image.asset("assets/images/GoldCoins.png", height: 24, width: 24),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text("Redeemed",
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
                            Icon(Icons.calendar_month, size: 16, color: Color(0xff999999)),
                            SizedBox(width: 5),
                            Text("11 Jun 25",
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
                        const Text("Flipkart coupon",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff333333),
                            fontFamily: "segeo",
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xffF5F5F5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Text("MENTI 500",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff121212),
                                  fontFamily: "segeo",
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 10),
               Image.asset("assets/images/Copyimg.png",height: 16,width: 16,),

                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text("Worth of ₹ 1000",
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

/// =====================
///  Bottom Sheet Widgets
/// =====================

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({
    required this.initialValue,
    required this.onApply,
  });

  final String initialValue;
  final ValueChanged<String> onApply;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  final List<String> options = const ['All Time', 'This Week', 'This Month', 'This Quarter'];
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // own rounded container inside transparent bottom sheet
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
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

          ...options.map((o) => _CheckRow(
            label: o,
            checked: selected == o,
            onChanged: (_) => setState(() => selected = o),
          )),
          const SizedBox(height: 8),

          // Your custom button (calls onApply)
          // If you don't have CustomAppButton1 imported, replace with ElevatedButton
          // CustomAppButton1(text: "Apply", onPlusTap: () => widget.onApply(selected)),
          SafeArea(
            child: CustomAppButton1(
              text: "Apply", onPlusTap: () {
            },
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.label,
    required this.checked,
    required this.onChanged,
  });

  final String label;
  final bool checked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(!checked),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Checkbox(
              value: checked,
              onChanged: (v) => onChanged(v ?? false),
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              side: const BorderSide(color: Color(0xFF98A2B3), width: 1),
              activeColor: const Color(0xFF7F00FF),
              checkColor: Colors.white,
            ),
            const SizedBox(width: 8),

            Text(
              label,
              style: const TextStyle(
                fontFamily: 'segeo',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF444444),
              ),
            ),
          ],
        ),
      ),
    );

  }
}

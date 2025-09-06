import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';

const TextStyle buttonTextStyle = TextStyle(
  fontFamily: 'segeo',
  fontSize: 14,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.2,
);

class CouponDetailsScreen extends StatelessWidget {
  const CouponDetailsScreen({super.key});

  void _showConfirmDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: 'Buy',
      barrierDismissible: true,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, __, ___) {
        // center the dialog
        return Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _ConfirmDialog(
              onNo: () => Navigator.of(context).pop(),
              onYes: () {
                Navigator.of(context).pop();
                // handle Yes action (purchase) here
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Purchased')));
              },
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: 'Shopping Coupons', actions: []),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F2FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/shoppingimgbannerimg.png',
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 14),
            // logo + title row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // replace with your logo asset
                Image.asset(
                  'assets/images/gmailimg.png',
                  width: 28,
                  height: 20,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Myntra',
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // description text - left aligned and with softer color
            const Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
              "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
              "when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: 'segeo',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.4,
                color: Color(0xFF666666),
              ),
            ),

            const SizedBox(height: 16),
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: DashedOutlinedButton(
                    height: 32,
                    radius: 24,
                    bgColor: Color(0xFFFFF6CF),
                    borderColor: Color(0xFF999999),
                    textColor: Color(0xFF333333),
                    text: 'Worth of ₹ 500',textStyle: TextStyle(fontSize: 12),
                    onTap: () {
                      // your tap handler
                    },
                  ),
                ),

                Expanded(
                  child: DashedOutlinedButton(
                    height: 32,
                    radius: 24,
                    bgColor: const Color(0xFFF5F5F5),
                    borderColor: const Color(0xFF999999),
                    textColor: const Color(0xFF333333),
                    text: 'For 1000 Coins',textStyle: TextStyle(fontSize: 12),
                    onTap: () {
                      // your tap handler
                    },
                  ),
                ),

                Expanded(
                  child: CustomAppButton1(text: "Buy Now", onPlusTap: (){

                  }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Custom confirm dialog to match design
class _ConfirmDialog extends StatelessWidget {
  final VoidCallback onNo;
  final VoidCallback onYes;

  const _ConfirmDialog({required this.onNo, required this.onYes});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(minWidth: 280, maxWidth: 520),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // tag icon inside rounded square circle (as in screenshot)
            Container(
              width: 56,
              height: 56,
              child: Center(
                child: Image.asset(
                  'assets/images/vectorbadge.png', // your tag icon asset
                  width: 28,
                  height: 28,
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Are you sure to buy Myntra Coupon',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: "segeo",
                color: Color(0xff666666),
              ),
            ),
            const SizedBox(height: 18),

            // buttons row
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      onPressed: onNo,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF8C3BFF)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        'No',
                        style: TextStyle(
                          color: Color(0xFF8C3BFF),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: onYes,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF8C3BFF), Color(0xFF5AA1FF)],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

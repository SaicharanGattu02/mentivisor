import 'package:flutter/material.dart';

import '../../Components/CustomAppButton.dart';

class CouponCongratsScreen extends StatelessWidget {
  const CouponCongratsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.8,
        shadowColor: const Color(0x11000000),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF222222),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Shopping Coupons',
          style: TextStyle(
            fontFamily: 'segeo',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
      ),
      // Body gradient
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [

              Color(0xFFEFF6FF), // #EFF6FF
              Color(0xFFF5F6FF), // #F5F6FF
              Color(0xFFFAF5FF), // #FAF5FF

            ],
          ),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/groupcoins.png', // put your big coins image here
                height: 140,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),

              const Text(
                'Woo!! Congratulations',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'segeo',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF121212),
                ),
              ),
              const SizedBox(height: 8),
               Text(
                'Myntra coupon worth of 500 is your',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'segeo',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff333333),
                ),
              ),
              const SizedBox(height: 16),

             Text(
                'Get your coupon within 24 hrs in coupon\nsession',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'segeo',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                  height: 1.35,
                )
              ),
            ],
          ),
        ),
      ),

      // Sticky bottom bar with gradient "Sure" button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding:  EdgeInsets.fromLTRB(16.0,0,16,24),
          child: CustomAppButton1(text: "Apply", onPlusTap: () {}),
        ),
      ),
    );
  }
}

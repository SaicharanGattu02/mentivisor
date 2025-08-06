import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CostPerMinuteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cost Per Minute',
          style: TextStyle(
            fontFamily: 'segeo',
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Color(0xffFAF5FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/images/clockimg.png",
                height: 220,
                width: 220,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Your cost per minute will be',

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'segeo',
              ),
            ),
            SizedBox(height: 10),
            Text(
              '20 Coins',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Color(0xff994DF8),
                fontFamily: 'segeo',
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: AlignmentGeometry.directional(-0.8, 1),
            child: Text(
              '**Note: 5 coins 1 rupee',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Color(0xff555555),
                fontFamily: 'segeo',
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFA258F7),
                        Color(0xFF726CF7),
                        Color(0xFF4280F6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text(
                      'Next',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'segeo',

                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

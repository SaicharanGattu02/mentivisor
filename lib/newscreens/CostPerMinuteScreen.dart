import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Components/CustomAppButton.dart';

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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '**Note: 5 coins 1 rupee',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Color(0xff555555),
                fontFamily: 'segeo',
              ),
            ),
            CustomAppButton1(
              text: "Next",
              onPlusTap: () {
                context.push(""); // Update with your actual route
              },
            ),
          ],
        ),
      ),
    );
  }
}

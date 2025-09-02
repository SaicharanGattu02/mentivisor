import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../Components/CustomAppButton.dart';
import '../../../Components/CutomAppBar.dart';

class CostPerMinuteScreen extends StatefulWidget {
  final String coins;
  CostPerMinuteScreen({super.key, required this.coins});
  @override
  State<CostPerMinuteScreen> createState() => _CostPerMinuteScreenState();
}

class _CostPerMinuteScreenState extends State<CostPerMinuteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: 'Cost Per Minute', actions: []),
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
              '${widget.coins} Coins',
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
        child: SafeArea(
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomAppButton1(
                text: "Okay",
                onPlusTap: () {
                  context.go('/mentor_review');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

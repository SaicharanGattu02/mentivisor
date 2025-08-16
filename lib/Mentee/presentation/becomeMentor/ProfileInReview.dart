import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../Components/CustomAppButton.dart';

class InReview extends StatefulWidget {
  const InReview({super.key});

  @override
  State<InReview> createState() => _InReviewState();
}

class _InReviewState extends State<InReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F5FF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/sand-clock.png",
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),
              const Text(
                "Your Profile is Under Review",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff333333),
                  fontFamily: 'segeo',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "We’re reviewing your profile details.\n"
                "You’ll be notified once it is approved.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff666666),
                  height: 1.5,
                  fontFamily: 'segeo',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: CustomAppButton1(
          text: "Back To Home",
          onPlusTap: () {
            context.pop();
          },
        ),
      ),
    );
  }
}

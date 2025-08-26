import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Mentee/presentation/authentication/profieSetup/ProfileSetupScreen.dart';
import 'package:mentivisor/utils/color_constants.dart';

import '../../../services/AuthService.dart';

class MentorReview extends StatelessWidget {
  const MentorReview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: AuthService.getName(),
        builder: (context, snapshot) {
          final userName = snapshot.data ?? "unKnown";
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/mentor-review.png",
                    height: 220,
                    width: 220,
                  ),
                ),
                Text(
                  'That’s all ${userName ?? "Un Known"} we got what we need will update you shortly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w700,
                    color: primarycolor,
                  ),
                ),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 36),
          child: CustomAppButton1(
            text: 'Done',
            onPlusTap: () {
              context.go('/dashboard');
            },
          ),
        ),
      ),
    );
  }
}

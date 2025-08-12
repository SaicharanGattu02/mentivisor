import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Mentee/presentation/authentication/profieSetup/ProfileSetupScreen.dart';

class SuccessScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const SuccessScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF3AE37A),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 60),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your Account Verified',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'segeo',
                fontWeight: FontWeight.bold,
                color: Color(0xff222222),
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Create Your profile to use all features',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "segeo",
                    color: Color(0xff374151),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomAppButton1(
                text: "Create Profile",
                onPlusTap: () {
                  context.pushReplacement("/profilesetup", extra: data);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

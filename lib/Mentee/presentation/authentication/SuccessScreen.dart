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
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                'Your Account is Created',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'segeo',
                  fontWeight: FontWeight.bold,
                  color: Color(0xff222222),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, 0, 16, 24),
          child: CustomAppButton1(
            text: "Done",
            onPlusTap: () {
              context.pushReplacement("/login", extra: data);
            },
          ),
        ),
      ),
    );
  }
}

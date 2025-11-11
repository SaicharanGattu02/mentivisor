import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/utils/media_query_helper.dart';

class AuthLandingScreen extends StatelessWidget {
  const AuthLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: SizeConfig.screenHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF6EAFE), // soft pink/lilac
                Color(0xFFEFF5FF), // very light blue
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              AspectRatio(
                aspectRatio: 3 / 4,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: SizeConfig.screenWidth * 0.68,
                    child: Image.asset(
                      'assets/images/onboarding_login.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: Color(0xFF14181F),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  children: const [
                    TextSpan(text: 'Please '),
                    TextSpan(
                      text: 'sign-in',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: ' or '),
                    TextSpan(
                      text: 'sign-up',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: ' to Explore all the features'),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              CustomAppButton1(
                text: "Sign up",
                onPlusTap: () {
                  context.push("/sign_up");
                },
              ),
              CustomOutlinedButton(
                text: "Sign in",
                radius: 24,
                onTap: () {
                  context.push("/login");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

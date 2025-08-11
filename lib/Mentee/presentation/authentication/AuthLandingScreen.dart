import 'package:flutter/material.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';

class AuthLandingScreen extends StatelessWidget {
  const AuthLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final buttonHeight = 64.0;
    final borderRadius = BorderRadius.circular(38);

    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, c) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Illustration
                            AspectRatio(
                              aspectRatio: 3 / 4,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: SizedBox(
                                  width: width * 0.68,
                                  child: Image.asset(
                                    'assets/images/onboarding_login.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Headline text
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: const Color(0xFF14181F),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                children: const [
                                  TextSpan(text: 'Please '),
                                  TextSpan(
                                    text: 'sign-in',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(text: ' or '),
                                  TextSpan(
                                    text: 'sign-up',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' to Explore all the features',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Buttons
                    CustomAppButton1(text: "Sign up", onPlusTap: () {}),
                    const SizedBox(height: 16),
                    CustomOutlinedButton(
                      text: "Sign in",
                      radius: 24,
                      onTap: () {},
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

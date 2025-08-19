import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // You can change theme color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Coming Soon 🚀",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "We’re working hard to bring you something amazing.\nStay tuned!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: CustomAppButton1(text: "Go Back", onPlusTap: () {
            context.pop();
          }),
        ),
      ),
    );
  }
}

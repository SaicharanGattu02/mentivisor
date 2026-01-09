import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserBlockedScreen extends StatelessWidget {
  const UserBlockedScreen({super.key});


  Future<void> launchInviteApp() async {
    late final Uri url;

      url = Uri.parse(
        "https://mentivisor.com/",
      );

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      debugPrint("❌ Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon / Illustration
                Icon(
                  Icons.block_outlined,
                  size: 120,
                  color: Colors.redAccent.withOpacity(0.8),
                ),

                const SizedBox(height: 40),

                // Main Title
                Text(
                  "Account Blocked",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Message
                Text(
                  "Your account has been temporarily blocked due to a violation of our community guidelines.\n\n"
                      "Please contact support for more information or to appeal this decision.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // Support Button
                ElevatedButton.icon(
                  onPressed: () {
                    launchInviteApp();
                  },
                  icon: const Icon(Icons.support_agent),
                  label: const Text("Contact Support"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                ),

                const SizedBox(height: 24),

                // Optional: Small footer
                Text(
                  "We’re here to help you get back on track!",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../Components/CustomAppButton.dart';
import '../../utils/color_constants.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xfff6faff),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SizedBox(
          height: media.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with gradient background
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff3b82f6), Color(0xff2563eb)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.mail_outline_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Join Mentivisor",
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Create your mentee account",
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 28),
              // Form container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      color: Colors.black12.withOpacity(0.05),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    buildLabel("Email Address"),
                    const SizedBox(height: 6),
                    buildTextField("Enter your email", Icons.email_outlined),
                    const SizedBox(height: 16),

                    buildLabel("Mobile Number"),
                    const SizedBox(height: 6),
                    buildTextField("Enter your Mobile Number", Icons.phone_android_outlined),
                    const SizedBox(height: 16),

                    buildLabel("College/Institution"),
                    const SizedBox(height: 6),
                    buildTextField("Enter your college name", Icons.house_siding_rounded),
                    const SizedBox(height: 16),

                    buildLabel("Password"),
                    const SizedBox(height: 6),
                    buildTextField("Enter your password", Icons.lock_outline, isPassword: true),
                    const SizedBox(height: 16),

                    buildLabel("Confirm Password"),
                    const SizedBox(height: 6),
                    buildTextField("Confirm your password", Icons.lock_outline),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomAppButton(
                text: "Create Account",
                icon: Icons.arrow_forward,
                onPlusTap: () {
                  // Your logic
                },
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Sign In",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      color: primarycolor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget buildTextField(String hint, IconData? icon, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon,color: Colors.black26,) : null,
        suffixIcon: isPassword ? const Icon(Icons.visibility_outlined,color: Colors.black26,) : null,
        hintText: hint,
      ),
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
      ),
    );
  }
}

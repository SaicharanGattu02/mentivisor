import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../Components/CustomAppButton.dart';
import '../../utils/color_constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              const Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: "Inter",
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sign in to your mentee account",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Inter",
                ),
              ),
              const SizedBox(height: 28),
              // Card Form
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      color: Colors.black12.withOpacity(0.05),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Email Address",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined,color: Colors.black26,),
                        hintText: 'Enter your Email',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      obscureText: true,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline,color: Colors.black26,),
                        suffixIcon: const Icon(Icons.visibility_outlined,color: Colors.black26,),
                        hintText: 'Enter your Password',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Sign In Button
              CustomAppButton(
                text: "Sign In",
                icon: Icons.arrow_forward,
                onPlusTap: () {
                  context.pushReplacement("/dashboard");
                },
              ),
              const SizedBox(height: 16),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Inter"
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      context.push("/sign_up");
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: primarycolor,
                        fontFamily: "Inter",
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
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
}

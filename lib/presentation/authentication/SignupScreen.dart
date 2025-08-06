import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/bloc/Register/Register_Cubit.dart';
import 'package:mentivisor/bloc/Register/Registor_State.dart';
import '../../Components/CustomAppButton.dart';
import '../../Components/ShakeWidget.dart';
import '../../Widgets/TextLableAndInputStyle.dart';
import '../../utils/color_constants.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();

  bool showEmailError = false;
  bool showMobileError = false;
  bool showPasswordError = false;

  String emailError = '';
  String mobileError = '';
  String passwordError = '';

  bool agree = false;

  void validateAndSubmit() {
    setState(() {
      showEmailError = false;
      showMobileError = false;
      showPasswordError = false;
      emailError = '';
      mobileError = '';
      passwordError = '';
    });

    final email = emailController.text.trim();
    final mobile = mobileController.text.trim();
    final password = passwordController.text.trim();

    bool isValid = true;

    if (email.isEmpty || !email.contains('@')) {
      emailError = 'Enter a valid email address';
      showEmailError = true;
      isValid = false;
    }
    if (mobile.isEmpty || mobile.length != 10) {
      mobileError = 'Enter a valid 10‑digit mobile number';
      showMobileError = true;
      isValid = false;
    }
    if (password.isEmpty || password.length < 6) {
      passwordError = 'Password must be at least 6 characters';
      showPasswordError = true;
      isValid = false;
    }
    if (!agree) {
      CustomSnackBar.show(context, 'You must agree to the terms');
      isValid = false;
    }

    if (isValid) {
      final data = {
        "email": email,
        "contact": mobile,
        "password": password,
      };
      context.read<RegisterCubit>().registerApi(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xfff6faff),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          height: media.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon + Title
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xffA258F7),
                      Color(0xff726CF7),
                      Color(0xff4280F6),
                    ],
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
                "Join Mentivisor",
                style: TextStyle(
                  fontFamily: 'segeo',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 28),

              // Input Card
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
                    CommonPasswordTextField(
                      hint: "Enter your email",
                      icon: Icons.email_outlined,
                      isPassword: false,
                      controller: emailController,
                      showError: showEmailError,
                      errorKey: 'email_error',
                      errorMsg: emailError,
                    ),

                    const SizedBox(height: 12),
                    CommonPasswordTextField(
                      hint: "Enter your mobile number",
                      icon: Icons.phone_android_outlined,
                      isPassword: false,
                      controller: mobileController,
                      showError: showMobileError,
                      errorKey: 'mobile_error',
                      errorMsg: mobileError,
                    ),
                    const SizedBox(height: 12),
                    CommonPasswordTextField(
                      hint: "Enter your password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      controller: passwordController,
                      showError: showPasswordError,
                      errorKey: 'password_error',
                      errorMsg: passwordError,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Terms & Conditions Checkbox
              Row(
                children: [
                  Checkbox(
                    value: agree,
                    onChanged: (val) => setState(() => agree = val ?? false),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => agree = !agree),
                      child: const Text(
                        "I agree to terms and conditions",
                        style: TextStyle(
                          fontFamily: 'segeo',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Get OTP Button
              BlocConsumer<RegisterCubit, RegisterState>(
                listener: (context, state) {
                  if (state is RegisterSucess) {
                    context.pushReplacement(
                      '/otp_verify?number=${mobileController.text}',
                    );
                  } else if (state is RegisterFailure) {
                    CustomSnackBar.show(context, state.message);
                  }
                },
                builder: (context, state) {
                  return CustomAppButton1(
                    isLoading: state is RegisterLoading,
                    text: "Get OTP",

                    onPlusTap: validateAndSubmit,
                  );
                },
              ),

              const SizedBox(height: 16),

              // Sign In Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontFamily: 'segeo',
                      fontSize: 15,
                      color: Colors.black87,

                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => context.push("/login"),
                    child: const Text(
                      "Sign In",
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

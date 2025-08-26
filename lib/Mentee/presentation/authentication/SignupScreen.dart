import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import '../../../Components/CustomAppButton.dart';
import '../../data/cubits/Register/Register_Cubit.dart';
import '../../data/cubits/Register/Registor_State.dart';
import '../Widgets/TextLableAndInputStyle.dart';

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
    // if (!agree) {
    //   CustomSnackBar.show(context, 'You must agree to the terms');
    //   isValid = false;
    // }

    if (isValid) {
      final data = {"email": email, "contact": mobile, "password": password};
      context.read<RegisterCubit>().registerApi(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6faff),
      body: SafeArea(
        child: SingleChildScrollView(physics: NeverScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF9333EA), Color(0xFF3B82F6)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.school, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Join Mentivisor",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 28),
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
                        hint: "Enter your Email",
                        icon: Icons.email_outlined,
                        isPassword: false,
                        keyboardType: TextInputType.emailAddress,
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
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              // Row(
              //   children: [
              //     Checkbox(
              //       value: agree,
              //       onChanged: (val) => setState(() => agree = val ?? false),
              //     ),
              //     Expanded(
              //       child: GestureDetector(
              //         onTap: () => setState(() => agree = !agree),
              //         child: const Text(
              //           "I agree to terms and conditions",
              //           style: TextStyle(fontFamily: 'segeo', fontSize: 14),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 8),
              BlocConsumer<RegisterCubit, RegisterState>(
                listener: (context, state) {
                  if (state is RegisterSucess) {
                    Map<String, dynamic> data = {
                      "email": emailController.text,
                      "contact": mobileController.text,
                      "password": passwordController.text,
                    };
                    context.push('/otp_verify', extra: data);
                  } else if (state is RegisterFailure) {
                    CustomSnackBar.show(context, state.message);
                  }
                },
                builder: (context, state) {
                  return CustomAppButton1(
                    isLoading: state is RegisterLoading,
                    text: "Get OTP",
                    onPlusTap: state is RegisterLoading
                        ? null
                        : validateAndSubmit,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

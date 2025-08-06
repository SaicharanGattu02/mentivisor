import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/bloc/Login/LoginCubit.dart';
import 'package:mentivisor/bloc/Login/LoginState.dart';

import '../../Components/CustomAppButton.dart';
import '../../Components/CustomSnackBar.dart';
import '../../services/AuthService.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool showEmailError = false;
  bool showPasswordError = false;
  String emailError = '';
  String passwordError = '';

  bool _obscurePassword = true; // To toggle password visibility

  void validateAndSubmit() {
    setState(() {
      showEmailError = false;
      showPasswordError = false;
      emailError = '';
      passwordError = '';
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    bool isValid = true;

    if (email.isEmpty || !email.contains('@')) {
      emailError = 'Enter a valid email address';
      showEmailError = true;
      isValid = false;
    }

    if (password.isEmpty || password.length < 6) {
      passwordError = 'Password must be at least 6 characters';
      showPasswordError = true;
      isValid = false;
    }

    if (isValid) {
      final Map<String, dynamic> data = {
        "username": emailController.text,
        "password": passwordController.text,
        "fcm_token": "dasfjgj",
      };
      context.read<LoginCubit>().logInApi(data);
    }
  }

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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  'assets/images/appicon_menty.png',
                  height: 84,
                  width: 92,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to your mentee account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email Address',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: emailController,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.black26,
                        ),
                        hintText: 'Enter your Email',
                      ),
                    ),

                    if (showEmailError)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          emailError,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: passwordController,
                      obscureText:
                          _obscurePassword, // Toggle the password visibility
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.black26,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.black26,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword =
                                  !_obscurePassword; // Toggle password visibility
                            });
                          },
                        ),
                        hintText: 'Enter your Password',
                      ),
                    ),

                    if (showPasswordError)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          passwordError,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (v) {
                            setState(() {
                              _rememberMe = v ?? false;
                            });
                          },
                        ),
                        const Text(
                          'Remember me',
                          style: TextStyle(
                            fontFamily: 'segeo',
                            fontSize: 12,
                            color: Color(0xff666666),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),
                    BlocConsumer<LoginCubit, LoginState>(
                      listener: (context, state) async {
                        if (state is LoginSucess) {
                          final tokens = state.logInModel;
                          await AuthService.saveTokens(
                            tokens.accessToken ?? "",
                            tokens.refreshToken ?? "",
                            tokens.expiresIn ?? 0,
                          );
                          context.pushReplacement('/selected_screen');
                        } else if (state is LoginFailure) {
                          CustomSnackBar.show(context, state.message);
                        }
                      },
                      builder: (context, state) {
                        return CustomAppButton1(
                          isLoading: state is LoginLoading,
                          text: "Next",
                          onPlusTap: validateAndSubmit,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => context.push('/sign_up'),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xff9333EA),
                        fontFamily: 'Inter',
                        fontSize: 13,
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

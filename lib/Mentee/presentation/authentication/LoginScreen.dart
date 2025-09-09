import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../Components/CustomAppButton.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../../services/AuthService.dart';
import '../../../services/SecureStorageService.dart';
import '../../../utils/AppLogger.dart';
import '../../../utils/color_constants.dart';
import '../../data/cubits/Login/LoginCubit.dart';
import '../../data/cubits/Login/LoginState.dart';

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

  bool _obscurePassword = true;
  @override
  void initState() {
    _loadRememberedCredentials();
    super.initState();
  }

  Future<void> validateAndSubmit() async {
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

    // Get the FCM token first
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    AppLogger.log("FCM Token: $fcmToken");

    if (fcmToken != null) {
      await SecureStorageService.instance.setString("fb_token", fcmToken);
    }

    if (isValid) {
      final Map<String, dynamic> data = {
        "username": emailController.text,
        "password": passwordController.text,
        "fcm_token": fcmToken ?? "",
      };
      context.read<LoginCubit>().logInApi(data);
    }
  }

  Future<void> _handleRememberMe(String email, String password) async {
    if (_rememberMe) {
      await SecureStorageService.instance.setString("saved_email", email);
      await SecureStorageService.instance.setString("saved_password", password);
      await SecureStorageService.instance.setBool("remember_me", true);
    } else {
      await SecureStorageService.instance.delete("saved_email");
      await SecureStorageService.instance.delete("saved_password");
      await SecureStorageService.instance.setBool("remember_me", false);
    }
  }

  Future<void> _loadRememberedCredentials() async {
    final remember =
        await SecureStorageService.instance.getBool("remember_me") ?? false;
    if (remember) {
      final savedEmail = await SecureStorageService.instance.getString(
        "saved_email",
      );
      final savedPassword = await SecureStorageService.instance.getString(
        "saved_password",
      );

      if (savedEmail != null && savedPassword != null) {
        setState(() {
          _rememberMe = true;
          emailController.text = savedEmail;
          passwordController.text = savedPassword;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6faff),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  // Gradient app icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: kCommonGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.school,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Welcome Back!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Sign in to your mentee account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.35,
                      color: Colors.black54,
                      fontFamily: 'segeo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // White card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          offset: const Offset(0, 12),
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email Address',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 48,
                          child: TextField(
                            controller: emailController,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Colors.black26,
                                size: 20,
                              ),
                              hintText: 'Enter your email',
                              hintStyle: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xffE5E7EB),
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xffE5E7EB),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xffE5E7EB),
                                  width: 1,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xffE5E7EB),
                                  width: 1,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xffE5E7EB),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (showEmailError) const SizedBox(height: 6),
                        if (showEmailError)
                          Text(
                            emailError,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                        const SizedBox(height: 16),

                        const Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 48,
                          child: TextField(
                            controller: passwordController,
                            obscureText: _obscurePassword,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Colors.black26,
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.black26,
                                  size: 22,
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                              hintText: 'Enter your password',
                              hintStyle: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xffE5E7EB),
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xffE5E7EB),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xffE5E7EB),
                                  width: 1,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xffE5E7EB),
                                  width: 1,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xffE5E7EB),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (showPasswordError) const SizedBox(height: 6),
                        if (showPasswordError)
                          Text(
                            passwordError,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            context.push('/forgot_password');
                          },
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF477EF6),
                              fontFamily: 'segeo',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: Checkbox(
                                value: _rememberMe,
                                onChanged: (v) {
                                  setState(() => _rememberMe = v ?? false);
                                },
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                activeColor: primarycolor,
                                side: BorderSide(color: primarycolor, width: 1),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Remember me',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF000000),
                                fontFamily: 'segeo',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        BlocConsumer<LoginCubit, LoginState>(
                          listener: (context, state) async {
                            if (state is LoginSucess) {
                              final data = state.logInModel;
                              await AuthService.saveTokens(
                                data.accessToken ?? "",
                                data.refreshToken ?? "",
                                data.expiresIn ?? 0,
                                data.role ?? "",
                                data.user?.id ?? 0,
                                data.user?.name ?? "",
                                data.user?.email ?? "",
                                data.user?.contact ?? 0,
                              );
                              await _handleRememberMe(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                              if (data.role == "Both") {
                                context.pushReplacement('/selected_screen');
                              } else if (data.role == "Mentee") {
                                context.pushReplacement('/dashboard');
                              }
                            } else if (state is LoginFailure) {
                              CustomSnackBar.show(context, state.message);
                            }
                          },
                          builder: (context, state) {
                            return SizedBox(
                              height: 52,
                              width: double.infinity,
                              child: CustomAppButton1(
                                isLoading: state is LoginLoading,
                                text: "Next",
                                onPlusTap: validateAndSubmit,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Footer
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Don't have an Account? ",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            fontFamily: 'segeo',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(
                            fontFamily: 'segeo',
                            fontSize: 13,
                            color: Color(0xffA258F7),
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.push('/sign_up'),
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
      ),
    );
  }
}

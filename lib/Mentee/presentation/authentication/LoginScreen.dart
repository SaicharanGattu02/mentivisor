import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../Components/CustomAppButton.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../../services/AuthService.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xfff6faff),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: kCommonGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.school, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Text(
                  'Sign in to your mentee account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w400,
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
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: emailController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.black26,
                          ),
                          hintText: 'Enter your Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xffE5E7EB),
                              width: 1,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xffE5E7EB),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xffE5E7EB),
                              width: 1,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xffE5E7EB),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xffE5E7EB),
                              width: 1,
                            ),
                          ),
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
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
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 15,
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xffE5E7EB),
                              width: 1,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xffE5E7EB),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xffE5E7EB),
                              width: 1,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xffE5E7EB),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xffE5E7EB),
                              width: 1,
                            ),
                          ),
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
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

                      // Row(
                      //   children: [
                      //     Checkbox(
                      //       value: _rememberMe,
                      //       onChanged: (v) {
                      //         setState(() {
                      //           _rememberMe = v ?? false;
                      //         });
                      //       },
                      //     ),
                      //     const Text(
                      //       'Remember me',
                      //       style: TextStyle(
                      //         fontFamily: 'segeo',
                      //         fontSize: 12,
                      //         color: Color(0xff666666),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 25),
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
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an Account? ",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontFamily: 'segeo',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: "SignUp",
                            style: TextStyle(
                              fontFamily: 'segeo',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..shader =
                                    const LinearGradient(
                                      colors: [
                                        Color(0xFFA258F7),
                                        Color(0xFFF726CF7),
                                        Color(0xFF4280F6),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(
                                      const Rect.fromLTWH(0, 0, 200, 20),
                                    ),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.push('/sign_up');
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../Components/CustomAppButton.dart';
import '../../../../Components/CustomSnackBar.dart';
import '../../../../Components/ShakeWidget.dart';
import '../../../../utils/media_query_helper.dart';
import '../../../data/cubits/ForgotPassword/forgot_passsword_cubit.dart';
import '../../../data/cubits/ForgotPassword/forgot_passsword_states.dart';

class ResetPassword extends StatefulWidget {
  final String num;
  const ResetPassword({super.key, required this.num});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  String? _errorMessage;

  bool _validateFields() {
    final newPass = newPassController.text.trim();
    final confirmPass = confirmPassController.text.trim();

    if (newPass.isEmpty) {
      setState(() => _errorMessage = "Please enter a new password");
      return false;
    }
    if (confirmPass.isEmpty) {
      setState(() => _errorMessage = "Please confirm your password");
      return false;
    }
    if (newPass != confirmPass) {
      setState(() => _errorMessage = "Passwords do not match");
      return false;
    }

    setState(() => _errorMessage = null);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F8FD),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.15),
              const Text(
                "Create Password",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff111827),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "New Password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: newPassController,
                      obscureText: _obscureNew,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNew
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() => _obscureNew = !_obscureNew);
                          },
                        ),
                        hintText: "Enter Password",
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xfff9f9f9),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Confirm Password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: confirmPassController,
                      obscureText: _obscureConfirm,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() => _obscureConfirm = !_obscureConfirm);
                          },
                        ),
                        hintText: "Enter Password",
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xfff9f9f9),
                      ),
                    ),

                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: ShakeWidget(
                          key: const Key('PasswordError'),
                          duration: const Duration(milliseconds: 700),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: BlocConsumer<ForgotPassswordCubit, ForgotPasswordStates>(
            listener: (context, state) {
              if (state is ForgotPasswordSuccess) {
                context.pushReplacement(
                  '/payment_success?title=${Uri.encodeComponent("Password updated successfully")}&next=/login',
                );
              } else if (state is ForgotPasswordFailure) {
                CustomSnackBar1.show(context, state.error);
              }
            },
            builder: (context, state) {
              final isLoading = state is ForgotPasswordLoading;
              return CustomAppButton1(
                isLoading: isLoading,
                text: 'Confirm',
                onPlusTap: isLoading
                    ? null
                    : () {
                        if (_validateFields()) {
                          final data = {
                            "phone": widget.num,
                            "password": confirmPassController.text.trim(),
                          };
                          context.read<ForgotPassswordCubit>().resetPassword(
                            data,
                          );
                        }
                      },
              );
            },
          ),
        ),
      ),
    );
  }
}

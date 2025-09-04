import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Mentee/data/cubits/ForgotPassword/forgot_passsword_states.dart';
import '../../../../Components/ShakeWidget.dart';
import '../../../data/cubits/ForgotPassword/forgot_passsword_cubit.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController phoneController = TextEditingController();
  bool _showError = false;

  void _validateAndSubmit() {
    String phone = phoneController.text.trim();

    if (phone.isEmpty ||
        phone.length != 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(phone)) {
      setState(() => _showError = true);
      return;
    }

    setState(() => _showError = false);

    final Map<String, dynamic> data = {"phone": phone};
    context.read<ForgotPassswordCubit>().forgotPassword(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F8FD),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff111827),
                  fontFamily: 'segeo',
                ),
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
                    "Phone no",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.phone_outlined,
                        color: Colors.grey,
                      ),
                      hintText: "Enter Phone no",

                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xfff9f9f9),
                    ),
                  ),

                  if (_showError)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: ShakeWidget(
                        key: Key('Num Error'),
                        duration: Duration(milliseconds: 700),
                        child: Text(
                          'Please enter a valid 10-digit phone number',
                          style: TextStyle(
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: BlocConsumer<ForgotPassswordCubit, ForgotPasswordStates>(
            listener: (context, state) {
              if (state is ForgotPasswordSuccess) {
                context.pushReplacement(
                  '/forgot_otp?num=${phoneController.text}',
                );
              } else if (state is ForgotPasswordFailure) {
                CustomSnackBar1.show(context, state.error);
              }
            },
            builder: (context, state) {
              return CustomAppButton1(
                isLoading: state is ForgotPasswordLoading,
                text: "Get OTP",
                onPlusTap: _validateAndSubmit,
              );
            },
          ),
        ),
      ),
    );
  }
}

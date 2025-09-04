import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../Components/CustomAppButton.dart';
import '../../../../Components/CustomSnackBar.dart';
import '../../../../Components/ShakeWidget.dart';
import '../../../../utils/color_constants.dart';
import '../../../../utils/media_query_helper.dart';
import '../../../data/cubits/ForgotPassword/forgot_passsword_cubit.dart';
import '../../../data/cubits/ForgotPassword/forgot_passsword_states.dart';

class ForgotOtp extends StatefulWidget {
  final String num;
  const ForgotOtp({super.key, required this.num});

  @override
  State<ForgotOtp> createState() => _ForgotOtpState();
}

class _ForgotOtpState extends State<ForgotOtp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();

  bool _showOtpError = false;

  int _remainingSeconds = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  bool _validateFields() {
    setState(() {
      final otp = otpController.text.trim();
      _showOtpError = otp.isEmpty || otp.length != 4;
    });
    return !_showOtpError;
  }

  void _startResendCountdown() {
    setState(() {
      _remainingSeconds = 30;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _resendOtp() {
    final Map<String, dynamic> data = {"phone": widget.num};
    context.read<ForgotPassswordCubit>().forgotPassword(data);
    _startResendCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F8FD),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 33.0, vertical: 47),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.15),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Enter OTP',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff444444),
                      fontFamily: 'segeo',
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'OTP sent to +91 ${widget.num}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        context.push('/forgot_password');
                      },
                      icon: Icon(Icons.edit, size: 24, color: primarycolor),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                /// OTP Input
                PinCodeTextField(
                  appContext: context,
                  length: 4,
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  onChanged: (_) {
                    if (_showOtpError) {
                      setState(() => _showOtpError = false);
                    }
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    selectedBorderWidth: 1,
                    borderWidth: 1,
                    fieldHeight: 50,
                    fieldWidth: 50,
                    selectedColor: Colors.white,
                    activeColor: Colors.grey,
                    inactiveColor: Colors.white,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    fieldOuterPadding: const EdgeInsets.all(5),
                  ),
                ),

                /// Error Message
                if (_showOtpError)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: ShakeWidget(
                        key: const Key('OTPEror'),
                        duration: const Duration(milliseconds: 700),
                        child: const Text(
                          'Please enter a valid 4-digit OTP',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 12),

                /// Resend OTP
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _remainingSeconds == 0 ? _resendOtp : null,
                    child: Text(
                      _remainingSeconds == 0
                          ? 'Resend OTP'
                          : 'Resend OTP in ${_remainingSeconds}s',
                      style: const TextStyle(
                        color: Color(0xff34495C),
                        fontFamily: 'segeo',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: BlocConsumer<ForgotPassswordCubit, ForgotPasswordStates>(
            listener: (context, state) {
              if (state is VerifyPasswordSuccess) {
                context.pushReplacement("/reset_password?num=${widget.num}");
              } else if (state is ForgotPasswordFailure) {
                CustomSnackBar1.show(context, state.error);
              }
            },
            builder: (context, state) {
              final isLoading = state is VerifyPasswordLoading;
              return CustomAppButton1(
                isLoading: isLoading,
                text: 'Verify OTP',
                onPlusTap: isLoading
                    ? null
                    : () {
                        if (_validateFields()) {
                          final data = {
                            "phone": widget.num,
                            "otp": otpController.text,
                          };
                          context.read<ForgotPassswordCubit>().verifyPassword(
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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Mentee/data/cubits/Verify_Otp/Verify_Otp_Cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/Verify_Otp/Verify_Otp_State.dart';
import 'package:mentivisor/utils/media_query_helper.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../Components/CustomAppButton.dart';
import '../../../Components/ShakeWidget.dart';
import '../../data/cubits/Register/Register_Cubit.dart';

class OTPVerificationScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const OTPVerificationScreen({required this.data, Key? key}) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();

  bool _showMpinError = false;
  bool _showMobileError = false;

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
      _showMpinError = otp.isEmpty || otp.length != 4;
    });
    return !(_showMobileError || _showMpinError);
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
    context.read<RegisterCubit>().registerApi(widget.data);
    _startResendCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F8FD),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 33.0, vertical: 47),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9333EA), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Join Mentivisor',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
               SizedBox(height: SizeConfig.screenHeight*0.15),
              const Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff444444),
                  fontFamily: 'segeo',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'OTP sent to +91 ${widget.data["contact"]}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontFamily: 'segeo',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
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
                  if (_showMpinError) setState(() => _showMpinError = false);
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
              if (_showMpinError)
                Padding(
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
              const SizedBox(height: 12),
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
              const Spacer(),
              BlocConsumer<VerifyOtpCubit, VerifyOtpState>(
                listener: (context, state) {
                  if (state is verifyotpSucess) {
                    context.push("/success_screen", extra: widget.data);
                  } else if (state is verifyotpFailure) {
                    CustomSnackBar1.show(context, state.message);
                  }
                },
                builder: (context, state) {
                  final isLoading = state is verifyotpLoading;
                  return CustomAppButton1(
                    isLoading: isLoading,
                    text: 'Verify OTP',
                    onPlusTap: isLoading
                        ? null
                        : () {
                      if (_validateFields()) {
                        Map<String, dynamic> data = {
                          "contact": widget.data["contact"],
                          "otp": otpController.text,
                          "fcm_token": "sjnsdsdhd",
                        };
                        context
                            .read<VerifyOtpCubit>()
                            .VerifyotpApi(data);
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


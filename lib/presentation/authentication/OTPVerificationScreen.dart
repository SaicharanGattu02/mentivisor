import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../Components/CustomAppButton.dart';
import '../../newscreens/SuccessScreen.dart';
import 'SuccessfullInScreen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String number;
  const OTPVerificationScreen({required this.number, Key? key}) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _otpControllers.length; i++) {
      _otpControllers[i].addListener(_onOtpChanged);
    }
  }

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged() {
    final isAllFilled = _otpControllers.every((c) => c.text.isNotEmpty);
    if (isAllFilled != _isButtonEnabled) {
      setState(() => _isButtonEnabled = isAllFilled);
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final otp = _otpControllers.map((c) => c.text).join();
      // TODO: verify OTP logic
      context.pushReplacement('/SuccessfullinScreen');
    }
  }

  void _resendOtp() {
    // TODO: resend OTP logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP resent successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                    child: const Icon(Icons.school, color: Colors.white, size: 32),
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
                const SizedBox(height: 24),
                const Text(
                  'Enter OTP',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: Color(0xff444444),
                    fontFamily: 'segeo',),
                ),
                const SizedBox(height: 4),
                Text(
                  'OTP sent to +91 88888... ${widget.number}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 48,
                      child: TextFormField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: const InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) return '';
                          if (!RegExp(r'^[0-9]$').hasMatch(val)) return '';
                          return null;
                        },
                        onChanged: (val) {
                          if (val.length == 1 && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          } else if (val.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _resendOtp,
                    child: const Text(
                      'Resend OTP',
                      style: TextStyle(
                        color: Color(0xff34495C),
                        fontFamily: 'segeo',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                CustomAppButton(
                  text: 'Submit OTP',
                  onPlusTap: _isButtonEnabled
                      ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => SuccessfullinScreen()),
                    );
                  }
                      : null,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String title;
  final String subTitle;
  final String? nextRoute;
  const PaymentSuccessScreen({
    super.key,
    required this.title,
    required this.subTitle,
    this.nextRoute,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/successfully.json',
                width: 200,
                height: 200,
                repeat: false,
              ),
              SizedBox(height: 10),
              Text(
                textAlign: TextAlign.center,
                widget.title ?? "Success!",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff333333),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                textAlign: TextAlign.center,
                widget.subTitle ?? "Success!",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff666666),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: CustomAppButton1(
            text: "Done",
            onPlusTap: () {
              if (widget.nextRoute != null && widget.nextRoute!.isNotEmpty) {
                context.pushReplacement(widget.nextRoute!);
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
    );
  }
}

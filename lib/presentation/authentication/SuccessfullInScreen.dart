import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentivisor/presentation/DashBoard.dart';

class SuccessfullinScreen extends StatelessWidget {
  const SuccessfullinScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF3AE37A),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your Account Verified',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xff222222),
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Create Your profile to use all features',
                  style: TextStyle(fontSize: 14, fontFamily: "segeo", color: Color(0xff374151)),
                ) ,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: GestureDetector(

                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Dashboard()),
                  ),


                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9333EA), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Create Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

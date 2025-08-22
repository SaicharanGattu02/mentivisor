import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/presentation/Widgets/CommonBackground.dart';
import 'package:mentivisor/services/AuthService.dart';

class BecomeMentorScreen extends StatefulWidget {
  BecomeMentorScreen({Key? key}) : super(key: key);

  @override
  State<BecomeMentorScreen> createState() => _BecomeMentorScreenState();
}

class _BecomeMentorScreenState extends State<BecomeMentorScreen> {
  TextEditingController _becomeMentorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAF5FF),
      appBar: CustomAppBar1(title: "Become mentor", actions: []),
      body: FutureBuilder(
        future: AuthService.getName(),
        builder: (context, snapshot) {
          final userName = snapshot.data ?? "unKnown";
          return Background(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 380,
                      width: 380,
                      child: Image.asset('assets/images/become_mentor.png'),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Hey ${userName}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'segeo',
                        color: Color(0xff2563EC),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Nice to see you become the mentor! Let’s start with these basic details',
                      style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'segeo',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Why you want to become mentor',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'segeo',
                        fontSize: 14,
                        color: Color(0xff444444),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: TextField(
                        controller: _becomeMentorController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Explain here',
                          filled: true,
                          fillColor: Colors.white, // inside background
                          contentPadding: EdgeInsets.all(16), // space inside

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 36),
          child: CustomAppButton1(
            text: 'Next',
            onPlusTap: () {
              if (_becomeMentorController.text.isEmpty) {
                CustomSnackBar1.show(
                  context,
                  "Please tell us why you want to become a mentor.",
                );
              } else {
                final Map<String, dynamic> data = {
                  "reason_for_become_mentor": _becomeMentorController.text
                      .trim(),
                };
                context.push("/interesting_screen", extra: data);
              }
            },
          ),
        ),
      ),
    );
  }
}

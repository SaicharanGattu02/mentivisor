import 'dart:developer' as AppLogger;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomSnackBar.dart';

import '../../../../Components/CustomAppButton.dart';
import '../../../../utils/color_constants.dart';

class ProfileSetupWizard extends StatefulWidget {
  final Map<String, dynamic> data;
  const ProfileSetupWizard({required this.data, Key? key}) : super(key: key);
  @override
  _ProfileSetupWizardState createState() => _ProfileSetupWizardState();
}

class _ProfileSetupWizardState extends State<ProfileSetupWizard> {
  final TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppLogger.log("Final data:${widget.data}");
    bioController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = [Color(0xFF9333EA), Color(0xFF3B82F6)];

    return Scaffold(
      backgroundColor: Color(0xFFF5F8FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 48),
              Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.school, color: Colors.white, size: 28),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Join Mentivisor',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'segeo',
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile Setup',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    '2 of 3',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: [
                    Container(height: 6, color: Colors.grey.shade300),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final progress = 0.66; // 25%
                        return Container(
                          height: 6,
                          width: constraints.maxWidth * progress,
                          decoration: BoxDecoration(
                            gradient: kCommonGradient,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              SizedBox(
                height: 320,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Tell us about yourself',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'segeo',
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Center(
                          child: Text(
                            'Write a brief bio that highlights your background',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'segeo',
                              color: Colors.black45,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: TextFormField(
                            controller: bioController,
                            maxLines: null,
                            expands: true,
                            maxLength: 300,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(12),
                              hintText:
                                  'Tell us about your academic background, interests, and what you hope to achieve...',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontFamily: 'segeo',
                                color: Colors.black38,
                              ),
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'segeo',
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  CustomAppButton1(
                    text: "Next",
                    radius: 10,
                    width: 100,
                    height: 42,
                    onPlusTap: () {
                      if(bioController.text.isEmpty){
                        CustomSnackBar1.show(context, "Please enter your bio.");
                      }else{
                        final Map<String,dynamic> data={
                          ...widget.data,
                          "bio":bioController.text.trim(),
                        };
                        context.push('/academic_journey',extra:data);
                      }

                    },
                  ),
                ],
              ),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import '../../../Components/CustomAppButton.dart';
import '../../../Components/CustomSnackBar.dart';
import '../../../utils/media_query_helper.dart';

class InterestingScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const InterestingScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<InterestingScreen> createState() => _InterestingScreenState();
}

class _InterestingScreenState extends State<InterestingScreen> {
  final TextEditingController _achievementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = SizeConfig.screenHeight;
    final width = SizeConfig.screenWidth;

    return Scaffold(
      backgroundColor: const Color(0xffFAF5FF),
      appBar: CustomAppBar1(title: "", actions: []),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.03),

            // Top image
            Center(
              child: Image.asset(
                'assets/images/interesting.png',
                height: height * 0.28,
                width: height * 0.28,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: height * 0.04),
            Text(
              "Wow, That’s interesting",
              style: theme.textTheme.titleLarge!.copyWith(
                color: Color(0xFF2563EC),
                fontWeight: FontWeight.w600,
                fontSize: 24,
                fontFamily: 'segeo',
              ),
            ),
            SizedBox(height: height * 0.015),

            Text(
              "Now tell your achievements",
              style: TextStyle(
                color: Color(0xff333333),
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'segeo',
              ),
            ),

            SizedBox(height: height * 0.03),

            TextFormField(
              controller: _achievementController,
              decoration: InputDecoration(
                hintText: "Example: State football champion",
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: height * 0.018,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  vertical: height * 0.018,
                  horizontal: width * 0.04,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: height * 0.015),

            Text(
              "You can write about any achievement that you consider to be significant.",
              style: TextStyle(
                fontSize: 12,
                fontFamily: "segeo",
                fontWeight: FontWeight.w400,
                color: Color(0xff555555),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 36),
          child: CustomAppButton1(
            text: 'Next',
            onPlusTap: () {
              if (_achievementController.text.isEmpty) {
                CustomSnackBar1.show(
                  context,
                  "Please tell us about your achievements to continue.",
                );
              } else {
                final Map<String, dynamic> data = {
                  ...widget.data,
                  "achivements": _achievementController.text.trim(),
                };
                context.push("/become_mentor_data", extra: data);
              }
            },
          ),
        ),
      ),
    );
  }
}

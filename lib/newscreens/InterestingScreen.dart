import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InterestingScreen extends StatelessWidget {
  const InterestingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Color(0xffFAF5FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffFAF5FF),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(

          children: [
            const SizedBox(height: 24),
            // Illustration
            Image.asset(
              'images/intrestingimg.png', // replace with your asset
              height: 220,
              width: 220,
            ),
             SizedBox(height: 32),


            // Title

            Align(
              alignment: AlignmentGeometry.directional(-1,-1),
              child: Text(
                "Wow, That’s interesting",
                style: theme.textTheme.titleLarge!
                    .copyWith(color: Color(0xFF2563EC), fontWeight: FontWeight.bold,fontSize: 24, fontFamily: 'segeo',),
                textAlign: TextAlign.start

              ),
            ),
            const SizedBox(height: 12),
            // Subtitle
            Align(
              alignment: AlignmentGeometry.directional(-1,-1),
              child: Text("Now tell your achievements",
                style: TextStyle(color: Color(0xff333333),fontSize: 14),
                textAlign: TextAlign.start,

              ),
            ),
            const SizedBox(height: 24),
            // Single-line input
            TextFormField(
              decoration: InputDecoration(
                hintText: "Example: state football champion",
                filled: true,
              
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "You can write about any achievement that you consider to be significant.",
              style: TextStyle(fontSize:12 ,color: Color(0xff555555)),

            ),

            const SizedBox(height: 132),
            InkWell(


              onTap: () {
                context.push("/language_selection");
              },

                // Next button action

              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFA258F7),
                      Color(0xFF726CF7),
                      Color(0xFF4280F6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text(
                    'Next',
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';

class SessionCompletedScreen extends StatefulWidget {
  const SessionCompletedScreen({Key? key}) : super(key: key);

  @override
  State<SessionCompletedScreen> createState() => _SessionCompletedScreenState();
}

class _SessionCompletedScreenState extends State<SessionCompletedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Session Completed',
          style: TextStyle(
            color: Color(0xff222222),
            fontWeight: FontWeight.w600,
            fontFamily: 'segeo',
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFeedbackCard(context, showFeedbackForm: true),
          const SizedBox(height: 16),
          _buildFeedbackCard(context),
          const SizedBox(height: 16),
          _buildFeedbackCard(context),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard(
    BuildContext context, {
    bool showFeedbackForm = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Career Growth Strategy',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w600,
                        color: Color(0xff333333),
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'With Dr. Sarah Chen',
                          style: TextStyle(
                            color: Color(0xff444444),
                            fontSize: 14,
                            fontFamily: 'segeo',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Spacer(),
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: const Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                                size: 30,
                              ),
                            ),
                            const Text(
                              'Session completed',
                              style: TextStyle(
                                color: Color(0xff444444),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'segeo',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Jul 25 4:00 pm',

                      style: TextStyle(
                        color: Color(0xff444444),
                        fontSize: 14,
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Rate your Experience",
            style: TextStyle(
              color: Color(0xff666666),
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),

          if (showFeedbackForm) ...[
            const SizedBox(height: 12),
            // Rating stars
            Row(
              children:
                  List.generate(
                        5,
                        (i) => Icon(
                          Icons.star_border,
                          size: 42,
                          color: Colors.grey.shade400,
                        ),
                      )
                      .map(
                        (icon) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: icon,
                        ),
                      )
                      .toList(),
            ),

            const SizedBox(height: 12),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Explain here (optional)',
                filled: true,
                fillColor: Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide:
                      BorderSide.none, // Remove the border line if desired
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: Colors.blue, // or any color you want on focus
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            InkWell(

                onTap: () {
                  context.push("/becomementorscreen");
                },





              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 24,
                ),
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
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Submit",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

          ],
        ],
      ),
    );
  }
}

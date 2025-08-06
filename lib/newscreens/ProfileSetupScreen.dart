import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileSetupScreen extends StatefulWidget {
  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F8FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo/Icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF9333EA), Color(0xFF3B82F6)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                SizedBox(height: 16),
                // Title
                Text(
                  'Join Mentivisor',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,

                  ),
                ),
                SizedBox(height: 24),
                Row(

                  children: [
                    Text(
                      'Profile Setup',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'segeo' ,
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),

                   Spacer(),
                    Text(
                      '1 of 4',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                // Progress bar with step indicator
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: 0.25,
                          minHeight: 6,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7F00FF)),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),

                  ],
                ),
                SizedBox(height: 32),
                // Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "What's your name?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'segeo'

                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This is how others will see you on the platform',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'segeo',
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      // Avatar placeholder with camera icon
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF9333EA), Color(0xFF3B82F6)],
                              ),
                            ),
                            child: Icon(
                              Icons.person,
                              color: Colors.white70,
                              size: 48,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Color(0xFF7F00FF),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Full Name',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'segeo',
                            fontWeight: FontWeight.w400,
                            color: Color(0xff666666),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 10),

                      // Name input
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Enter your full Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 14),

                // Navigation buttons
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Back',
                        style: TextStyle(fontSize: 12,color: Color(0xff222222), fontFamily: 'segeo'),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                            // replace with your route:
                            context.push('/profilesetupwizard');
                            // or with Navigator:
                            // Navigator.of(context).push(MaterialPageRoute(builder: (_) => NextScreen()));
                          },

                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'segeo',

                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

          ),

        ),
      ),

    );

  }
}

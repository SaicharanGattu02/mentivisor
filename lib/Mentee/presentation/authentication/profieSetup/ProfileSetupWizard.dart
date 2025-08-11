import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileSetupWizard extends StatefulWidget {
  @override
  _ProfileSetupWizardState createState() => _ProfileSetupWizardState();
}

class _ProfileSetupWizardState extends State<ProfileSetupWizard> {
  final TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
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

              // Header Icon
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

              // Title
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


              // Progress Header
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
                    '2 of 4',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),

              // Progress Bar
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32),

              // Bio Card (fixed height)
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

                        // Text field area
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
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                          ),
                        ),

                        // character counter pinned at bottom right
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '${bioController.text.length}/300',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'segeo',
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Back / Next buttons
              Row(
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
                  Spacer(),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      onTap: () {

                          // replace with your route:
                          context.push('/mentivisorprofilesetup');
                          // or with Navigator:
                          // Navigator.of(context).push(MaterialPageRoute(builder: (_) => NextScreen()));

                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                fontFamily: 'segeo',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward,
                              size: 18,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
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

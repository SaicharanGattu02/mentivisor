import 'package:flutter/material.dart';

class Acadamicjourneyscreen extends StatefulWidget {
  @override
  _Acadamicjourneyscreen createState() => _Acadamicjourneyscreen();
}

class _Acadamicjourneyscreen extends State<Acadamicjourneyscreen> {
  final _formKey = GlobalKey<FormState>();
  final _collegeController = TextEditingController();
  final _steamController = TextEditingController();
  String? _selectedYear;

  // Dummy years; replace with your actual options
  final List<String> _years = [
    'First Year',
    'Second Year',
    'Third Year',
    'Fourth Year',
    'Graduate',
  ];

  @override
  void dispose() {
    _collegeController.dispose();
    _steamController.dispose();
    super.dispose();
  }

  void _onComplete() {
    if (_formKey.currentState!.validate()) {
      // TODO: submit data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile completed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final purpleGradient = LinearGradient(
      colors: [Color(0xFF9333EA), Color(0xFF3B82F6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Top icon + title
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  gradient: purpleGradient,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(16),
                child: Icon(
                  Icons.school,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Join Mentivisor',
                style: TextStyle(
                  fontFamily: 'Segoe',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 24),

              // Step indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile Setup',
                    style: TextStyle(
                      fontFamily: 'Segoe',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '4 of 4',
                    style: TextStyle(
                      fontFamily: 'Segoe',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: 1.0,
                minHeight: 6,
                backgroundColor: Colors.grey[300],

              ),

              SizedBox(height: 24),

              // Form card
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blueAccent.withOpacity(0.5),
                          style: BorderStyle.solid,
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card header
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Academic Journey',
                                  style: TextStyle(
                                    fontFamily: 'Segoe',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Tell us about your current studies and goals',
                                  style: TextStyle(
                                    fontFamily: 'Segoe',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24),

                          // College/Institution field
                          Text(
                            'College/Institution',
                            style: TextStyle(
                              fontFamily: 'Segoe',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          TextFormField(
                            controller: _collegeController,
                            style: TextStyle(
                              fontFamily: 'Segoe',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your college name',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (val) => val!.isEmpty
                                ? 'Please enter your college'
                                : null,
                          ),

                          SizedBox(height: 16),

                          // Current Year/Level dropdown
                          Text(
                            'Current Year/Level',
                            style: TextStyle(
                              fontFamily: 'Segoe',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          DropdownButtonFormField<String>(
                            value: _selectedYear,
                            items: _years
                                .map(
                                  (y) => DropdownMenuItem(
                                value: y,
                                child: Text(
                                  y,
                                  style: TextStyle(
                                    fontFamily: 'Segoe',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            )
                                .toList(),
                            decoration: InputDecoration(
                              hintText: 'Select your current year',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (v) => setState(() {
                              _selectedYear = v;
                            }),
                            validator: (val) =>
                            val == null ? 'Please select a year' : null,
                          ),

                          SizedBox(height: 16),

                          // Steam field
                          Text(
                            'Stream',
                            style: TextStyle(
                              fontFamily: 'Segoe',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          TextFormField(
                            controller: _steamController,
                            style: TextStyle(
                              fontFamily: 'Segoe',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your stream',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (val) =>
                            val!.isEmpty ? 'Please enter your stream' : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Back / Complete buttons
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontFamily: 'Segoe',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff444444),
                      ),
                    ),
                  ),
                 Spacer(),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: purpleGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),

                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _onComplete,
                          borderRadius: BorderRadius.circular(8),
                          child: Center(
                            child: Text(
                              'Complete Setup  →',
                              style: TextStyle(
                                fontFamily: 'Segoe',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Components/CustomAppButton.dart';

class BookSessionScreen extends StatefulWidget {
  @override
  _BookSessionScreenState createState() => _BookSessionScreenState();
}

class _BookSessionScreenState extends State<BookSessionScreen> {
  bool showDetails = false;
  String? selectedDate;
  String? selectedTime;

  void _toggleDetails() {
    setState(() {
      showDetails = !showDetails;
    });
  }

  void _showReportSheet(BuildContext context) {
    String? localSelectedTime;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedDate ?? 'Select a date',
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: 'Segoe', // Corrected typo
                      fontWeight: FontWeight.w600,
                      color: Color(0xff222222),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Select time from the available time slots',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Segoe',
                      fontWeight: FontWeight.w600,
                      color: Color(0xff444444),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildTimeSlot('2:00 PM', localSelectedTime, (time) {
                        setModalState(() {
                          localSelectedTime = time;
                        });
                      }),
                      _buildTimeSlot('4:30 PM', localSelectedTime, (time) {
                        setModalState(() {
                          localSelectedTime = time;
                        });
                      }),
                      _buildTimeSlot('7:00 PM', localSelectedTime, (time) {
                        setModalState(() {
                          localSelectedTime = time;
                        });
                      }),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      child: CustomAppButton1(
                        text: 'Pick the Time',
                        onPlusTap: () {
                          if (localSelectedTime != null && selectedDate != null) {
                            setState(() {
                              selectedTime = localSelectedTime;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Selected time: $localSelectedTime on Jul $selectedDate'),
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a date and time'),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTimeSlot(String time, String? selectedTime, Function(String) onTap) {
    final isSelected = selectedTime == time;
    return GestureDetector(
      onTap: () => onTap(time),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFdcfce7),
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: Colors.green, width: 2) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 14, fontFamily: 'Segoe'),
            ),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.check, color: Colors.green, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Book Session'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Available Date in July',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xffA258F7),
                          Color(0xff726CF7),
                          Color(0xff4280F6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: 'This Week',
                          items: <String>['This Week', 'Next Week'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [
                                    Color(0xffA258F7),
                                    Color(0xff726CF7),
                                    Color(0xff4280F6),
                                  ],
                                ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                                child: Text(
                                  value,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            // Handle dropdown change if needed
                          },
                          icon: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xffA258F7),
                                Color(0xff726CF7),
                                Color(0xff4280F6),
                              ],
                            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                            child: const Icon(Icons.arrow_drop_down),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var day in ['12', '13', '14', '15', '16', '17', '18'])
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = day;
                        });
                        _showReportSheet(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xffF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Jul\n$day'),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Session Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/zoommeetimg.png', // Standardized path
                      height: 36,
                      width: 36,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'G-Meet',
                      style: TextStyle(fontSize: 16, fontFamily: 'Segoe'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Session Topic',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Segoe',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 250,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Describe what you\'d like to discuss in this session...',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.attach_file, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  'Add Attachment',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _toggleDetails,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.4),
                            child: Image.asset(
                              'assets/images/profileimg.png', // Standardized path
                              height: 60,
                              width: 60,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Dr. Sarah Chen',
                                style: TextStyle(
                                  color: Color(0xff333333),
                                  fontFamily: 'Segoe',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Mechanical from VIB Collage NZB',
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontFamily: 'Segoe',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (showDetails) ...[
                      const SizedBox(height: 16),
                      Divider(
                        color: Colors.grey.withOpacity(0.3),
                        thickness: 1,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text('Session Cost'),
                          const Spacer(),
                          Image.asset(
                            'assets/images/GoldCoins.png',
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 15),
                          const Text(
                            '₹25',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('Your Balance'),
                          const Spacer(),
                          Image.asset(
                            'assets/images/GoldCoins.png',
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 15),
                          const Text(
                            '₹150',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Divider(
                        color: Colors.grey.withOpacity(0.3),
                        thickness: 1,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('Remained'),
                          const Spacer(),
                          Image.asset(
                            'assets/images/GoldCoins.png',
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 15),
                          const Text(
                            '₹125',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: CustomAppButton1(
            text: 'Book Session',
            onPlusTap: () {
              if (selectedDate != null && selectedTime != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Session booked for Jul $selectedDate at $selectedTime'),
                  ),
                );
              } else {
                _showReportSheet(context);
              }
            },
          ),
        ),
      ),
    );
  }
}

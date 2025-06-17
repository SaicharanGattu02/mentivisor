import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class SessionHistory extends StatefulWidget {
  const SessionHistory({super.key});

  @override
  State<SessionHistory> createState() => _SessionHistoryState();
}

class _SessionHistoryState extends State<SessionHistory> {
  String? _selectSessions;


  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.all(16),
        child: Container(
          padding:  EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xfffaf5ff), Color(0xffeff6ff), Color(0xffe0e7ff)],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: w * 0.3,
                      child: const Text(
                        'Session History',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'Select Sessions',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          items: ['All Sessions', 'Completed', 'Upcoming']
                              .map(
                                (e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          value: _selectSessions,
                          onChanged: (String? value) {
                            setState(() {
                              _selectSessions = value;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Color(0xFFCBD5E1)),
                              color: Colors.white,
                            ),
                          ),
                          iconStyleData: IconStyleData(
                            icon: Icon(Icons.keyboard_arrow_down_rounded),
                            iconSize: 26,
                            iconEnabledColor: Colors.grey.shade700,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white,
                            ),
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            height: 45,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildStatCard(
                  'Total Sessions',
                  '4',
                  Color(0xff9333EA),
                  Icons.calendar_month,
                ),
                _buildStatCard(
                  'Average Rating',
                  '3.0',
                  Color(0xffCA8A04),
                  Icons.star_border,
                ),
                _buildStatCard(
                  'Goals Completed',
                  '6/12',
                  Color(0xff16A34A),
                  Icons.add_circle_outline,
                ),
                _buildStatCard(
                  'Progress Rate',
                  '50%',
                  Color(0xff2563EB),
                  Icons.auto_graph_rounded,
                ),
                const SizedBox(height: 16),
                Container(
                  width: w,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        itemCount: 1,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            width: w,
                            margin: const EdgeInsets.only(top: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xfffaf5ff),
                                  Color(0xffeff6ff),
                                  Color(0xffe0e7ff),
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 24,
                                      backgroundImage: AssetImage(
                                        'assets/placeholder.png',
                                      ), // replace with actual path
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: w * 0.35,
                                                child: Expanded(
                                                  child: Text(
                                                    'Technical Interview Prep',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xff111827),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Color(0xffDBEAFE),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Text(
                                                  'upcoming',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xff1D4ED8),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'with Dr. Sarah Chen',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff6B7280),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: const [
                                              Icon(
                                                Icons.calendar_today,
                                                size: 14,
                                                color: Color(0xff6B7280),
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                '1/15/2024',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xff6B7280),
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                              Icon(
                                                Icons.access_time,
                                                size: 14,
                                                color: Color(0xff6B7280),
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                '45 mins',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xff6B7280),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Session Goals',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff374151),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: const BoxDecoration(
                                              color: Color(0xffD1D5DB),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Mock coding interview',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff6B7280),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff2563EB),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    child: const Text(
                                      'Join Session',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF4B5563),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: color, // e.g., Colors.purple[600]
                  fontSize: 28, // text-2xl
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Icon(
            icon,
            color: color, // e.g., Colors.purple[500]
            size: 32, // equivalent to w-8 h-8
          ),
        ],
      ),
    );
  }
}

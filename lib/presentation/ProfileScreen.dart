import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xfff6faff),
              Color(0xffe0f2fe),
            ], // Replace with your desired gradient
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(radius: 40, backgroundColor: Colors.grey[300]),
                    Text(
                      'Dr. Sarah Chen',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Senior Software Engineer at Google',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: "Inter",
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow[700], size: 16),
                        SizedBox(width: 4),
                        Text(
                          '4.9 (127 reviews)',
                          style: TextStyle(fontFamily: "Inter"),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.access_time, color: Colors.blue, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '< 2 hours',
                          style: TextStyle(fontFamily: "Inter"),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.language, color: Colors.green, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'English, Mandarin, Spanish',
                          style: TextStyle(fontFamily: "Inter"),
                        ),
                      ],
                    ),
                    Text(
                      '25 coins/session',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Inter",
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.push("/book_sessions_screen");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9333ea),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white,
                      ),
                      label: Text(
                        'BOOK SESSION',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Inter",
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // About Section
              _buildSection(
                title: 'About',
                child: Text(
                  'Passionate about helping aspiring engineers break into top tech companies. With 8+ years at Google and mentoring 200+ students, I specialize in technical interviews, career transitions, and leadership development.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Inter",
                    height: 1.8,
                  ),
                ),
              ),

              // Expertise Section
              _buildSection(
                title: 'Expertise',
                child: Wrap(
                  spacing: 8,
                  children: [
                    _buildChip('Machine Learning'),
                    _buildChip('Career Growth'),
                    _buildChip('Technical Leadership'),
                    _buildChip('System Design'),
                  ],
                ),
              ),

              // Achievements Section
              _buildSection(
                title: 'Achievements',
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.4,
                  children: [
                    _buildAchievementCard('🏆', 'Top Mentor 2023'),
                    _buildAchievementCard('⏰', '500+ Hours Mentored'),
                    _buildAchievementCard('🤖', 'ML Expert'),
                    _buildAchievementCard('🎯', 'Interview Ace'),
                  ],
                ),
              ),

              // Available Slots Section
              _buildSection(
                title: 'Available Slots',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TODAY',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildTimeSlot('2:00 PM'),
                        _buildTimeSlot('4:30 PM'),
                        _buildTimeSlot('7:00 PM'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'TOMORROW',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildTimeSlot1('9:00 AM'),
                        _buildTimeSlot1('11:30 AM'),
                        _buildTimeSlot1('3:00 PM'),
                        _buildTimeSlot1('6:00 PM'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '12 more slots this week',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              // Recent Reviews Section
              _buildSection(
                title: 'Recent Reviews',
                child: Column(
                  children: [
                    _buildReview(
                      name: 'Alex Kumar',
                      rating: 5,
                      timeAgo: '2 days ago',
                      review:
                          'Sarah helped me crack my Google interview! Her mock interviews were incredibly helpful.',
                    ),
                    SizedBox(height: 16),
                    _buildReview(
                      name: 'Maria Garcia',
                      rating: 5,
                      timeAgo: '1 week ago',
                      review:
                          'Amazing mentor! Very patient and provides actionable feedback. Highly recommend!',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildAchievementCard(String icon, String title) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFfefce8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          Text(icon, style: TextStyle(fontSize: 20)),
          SizedBox(width: 8),
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(String time) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFdcfce7),
        borderRadius: BorderRadius.circular(36),
      ),
      child: Text(time, style: TextStyle(color: Color(0xFF15803d))),
    );
  }

  Widget _buildTimeSlot1(String time) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFdbeafe),
        borderRadius: BorderRadius.circular(36),
      ),
      child: Text(time, style: TextStyle(color: Color(0xFF1d4ed8))),
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: "Inter",
        ),
      ),
      side: BorderSide(color: Color(0xFFf3e8ff)),
      backgroundColor: Color(0xFFf3e8ff),
      labelStyle: TextStyle(color: Color(0xFF7e22ce), fontFamily: "Inter"),
      padding: EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildReview({
    required String name,
    required int rating,
    required String timeAgo,
    required String review,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 4, height: 80, color: Color(0xFF6B48FF)),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Inter",
                    ),
                  ),
                  Spacer(),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "Inter",
                    ),
                  ),
                ],
              ),
              Row(
                children: List.generate(
                  rating,
                  (index) =>
                      Icon(Icons.star, color: Colors.yellow[700], size: 16),
                ),
              ),
              SizedBox(height: 4),
              Text(review, style: TextStyle(fontSize: 12, fontFamily: "Inter")),
            ],
          ),
        ),
      ],
    );
  }
}

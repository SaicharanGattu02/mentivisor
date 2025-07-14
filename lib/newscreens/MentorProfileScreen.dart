import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MentorProfileScreen extends StatelessWidget {
  const MentorProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Mentor profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            Container(

              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade100,
                    backgroundImage: AssetImage('assets/images/mentor_avatar.png'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Dr. Sarah Chen',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Senior Software Engineer at Google',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 12),
                  // Ratings and response time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text('4.9 (127 reviews)', style: TextStyle(fontSize: 12)),
                      SizedBox(width: 16),
                      Icon(Icons.access_time, color: Colors.grey, size: 16),
                      SizedBox(width: 4),
                      Text('< 2 hours', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Languages
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(Icons.language, color: Colors.green, size: 16),
                      SizedBox(width: 4),
                      Text('English, Mandarin, Spanish', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Coins/session and button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.
                    start,
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.deepPurple, size: 16),
                      const SizedBox(width: 4),
                      const Text('25 coins/session', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: Colors.purple)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width:200,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.calendar_today_outlined,color: Colors.white ),
                      label: const Text('Book Session',style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(

                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // About section
            const Text('About', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade100, blurRadius: 4, offset: const Offset(0,2)),
                ],
              ),
              child: const Text(
                'Passionate about helping aspiring engineers break into top tech companies. With 8+ years at Google and mentoring 200+ students, I specialize in technical interviews, career transitions, and leadership development.',
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
            ),
            const SizedBox(height: 24),
            // Expertise
            const Text('Expertise', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTag('Machine Learning'),
                _buildTag('Career Growth'),
                _buildTag('Technical Leadership'),
                _buildTag('System Design'),
              ],
            ),
            const SizedBox(height: 24),
            // Available Slots
            const Text('Available Slots', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _buildSlotsCard('Today', ['2:00 PM', '4:30 PM', '7:00 PM']),
            const SizedBox(height: 12),
            _buildSlotsCard('Tomorrow', ['9:00 AM', '11:30 AM', '3:00 PM', '5:00 PM']),
            const SizedBox(height: 8),
            const Text('12 more slots available this week', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 24),
            // Recent Reviews Placeholder
            const Text('Recent Reviews', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            // Add ListView of review widgets here
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(color: Colors.deepPurple,)),
    );
  }

  Widget _buildSlotsCard(String day, List<String> times) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 4, offset: const Offset(0,2))],
      ),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(day, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: times.map((t,) => Chip(label: Text(t))).toList(),
          ),
        ],
      ),
    );
  }
}

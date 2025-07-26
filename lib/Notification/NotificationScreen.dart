import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(color: Colors.black87),
        title: const Text(
          'Notification',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontFamily: 'segeo',
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Session Section ─────────────────────
          const Text(
            'Session',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'segeo',
            ),
          ),
          const SizedBox(height: 8),
          NotificationCard(
            icon: Icons.video_call,
            iconBgColor: Colors.greenAccent.withOpacity(0.2),
            iconColor: Colors.green,
            title: 'Hey today date is 12 jun 25',
            subtitle: 'Please join the session with Asif at 5:00pm',
          ),
          const SizedBox(height: 16),

          // ── Reminder Section ────────────────────
          const Text(
            'Reminder',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'segeo',
            ),
          ),
          const SizedBox(height: 8),
          NotificationCard(
            icon: Icons.calendar_today,
            iconBgColor: Colors.redAccent.withOpacity(0.2),
            iconColor: Colors.red,
            title: 'Hey today date is 12 jun 25',
            subtitle: 'Complete the 30 minutes study',
          ),
          const SizedBox(height: 16),

          // ── Session Section ─────────────────────
          const Text(
            'Session',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'segeo',
            ),
          ),
          const SizedBox(height: 8),
          NotificationCard(
            icon: Icons.desktop_mac,
            iconBgColor: Colors.blueAccent.withOpacity(0.2),
            iconColor: Colors.blue,
            title: 'Hey Rohit your session has been cancelled',
            subtitle: 'Hello I am sorry to cancel the meet for so and so reason',
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;

  const NotificationCard({
    Key? key,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'segeo',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontFamily: 'segeo',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

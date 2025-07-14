import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpcomingSessionsScreen extends StatelessWidget {
  const UpcomingSessionsScreen({Key? key}) : super(key: key);

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
          'Upcoming Sessions',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSessionCard(context),
          const SizedBox(height: 16),
          _buildSessionCard(context),
        ],
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Career Growth Strategy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text('With Dr. Sarah Chen', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 8),
                Text('Today at 4:00 pm • G Meet', style: TextStyle(color: Colors.grey, fontSize: 12)),
                SizedBox(height: 12),
                // Chat button
                _ChatButton(),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Join button & illustration
          Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Join Session'),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 60,
                width: 60,
                child: Image.asset('assets/images/session_illustration.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChatButton extends StatelessWidget {
  const _ChatButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.chat_bubble_outline, size: 16),
      label: const Text('Chat with Sarah Chen', style: TextStyle(fontSize: 12, fontFamily: 'segeo',)),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black, side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
    );
  }
}
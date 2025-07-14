
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ReportBottomSheet.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({Key? key}) : super(key: key);

  void _showReportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const ReportBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: const Text('Post', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "images/communityimage.png",
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'A Complete Guide for the Data Science Road Map',
              style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'sugeo'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry...',
              style: TextStyle(fontSize: 14, fontFamily: 'sugeo'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.thumb_up_alt_outlined, size: 18),
                const SizedBox(width: 6),
                const Text('100',),
                const SizedBox(width: 24),
                const Icon(Icons.comment_outlined, size: 18),
                const SizedBox(width: 6),
                const Text('100'),
                const Spacer(),
                TextButton(
                  onPressed: () => _showReportSheet(context),
                  child: Text('Report'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Comments', style: TextStyle(fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'sugeo')),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Write your comment...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                // children: [
                //   _commentTile('Ramesh', '8:12 am', 'Seen many students struggle for clear road map for the data'),
                //   const SizedBox(height: 8),
                //   _commentTile('Suresh', '1 day ago', 'Seen many students struggle to clear road map for the data science i made it simple and clear.'),
                // ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../MenteeListScreen.dart';

class MenteeCard extends StatelessWidget {
  final Mentee mentee;
  const MenteeCard({required this.mentee});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/images/image.png",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mentee.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        mentee.email,
                        style: TextStyle(color: Color(0xff666666)),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Last interaction was ${mentee.interactionDate}',
                        style: TextStyle(color: Color(0xff666666)),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

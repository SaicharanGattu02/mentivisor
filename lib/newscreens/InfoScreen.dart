import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  // List of the card titles
  final List<String> _titles = [
    'Study Zone',
    'Study Zone',
    'ECC events competitions and challenges',
    'Community',
    'Wallet',
    'Downloads',
    'Productivity Tools',
    'Session Completed',
    'Upcoming sessions',
    'Become Mentor',
    'Update Mentor',
  ];

  // Common subtitle for all items
  final String _subtitle =
      'Where every one can upload the notes with tags and can view the uploads';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF5FF), // pastel background
      appBar: AppBar(
        backgroundColor: Color(0xffFAF5FF),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Info',
          style: TextStyle(color: Color(0xff222222), fontWeight: FontWeight.w600,fontSize: 16, fontFamily: 'segeo'),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1,color: Color(0xffE6E6E6),),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 12),
        children: [
          // Exclusive Services info box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exclusive Services',

                      style: TextStyle(color: Color(0xff222222), fontWeight: FontWeight.w600,fontSize: 16, fontFamily: 'segeo'),

                  ),
                  SizedBox(height: 8),
                  Text(
                    'You can advertise your services here in the exclusive content by contacting example@gmail.com',
                    style: TextStyle(color: Color(0xff666666), fontWeight: FontWeight.w400,fontSize: 14, fontFamily: 'segeo'),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // List of other info cards
          ..._titles.map((title) => Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 6),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'segeo',
                      fontWeight: FontWeight.w600,

                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    _subtitle,
                      style: TextStyle(color: Color(0xff666666), fontWeight: FontWeight.w400,fontSize: 14, fontFamily: 'segeo',  height: 1.3),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';

class Mentorinfoscreen extends StatelessWidget {

  final List<String> _titles = [

    'Feedbacks',
    'Availability',
    'Earnings',
    'Coin History',
    'Coupon Redeemed',
    'Session Completed ',
    'Upcoming sessions',
    'Update Mentor',
    'My Mentee',

  ];

  final String _subtitle =
      'Lorem is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the better.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF5FF),
      appBar: CustomAppBar1(title: "Info", actions: []),
      body: SafeArea(
        child: ListView(
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

                      'Upcoming Session',
                      style: TextStyle(color: Color(0xff222222), fontWeight: FontWeight.w600,fontSize: 16, fontFamily: 'segeo'),
                    ),
                    SizedBox(height: 8),
                    Text(

                      'Lorem is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the better.',
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
      ),
    );
  }
}

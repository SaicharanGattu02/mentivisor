import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class ExclusiveInfoServices extends StatelessWidget {
  // Replace with your real data or pass in via constructor
  final String bannerUrl =
      'https://via.placeholder.com/412x180.png?text=Traveling+Banner';
  final String userName = 'Suraj';
  final String title = 'A Travel Tricking';
  final String description = '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum venenatis justo sed quam dignissim tincidunt. Nunc eget lorem ac enim lacinia facilisis. Nunc congue orci vitae ligula pretium facilisis. Nulla ut odio eget magna molestie ornare. Nullam eget ligula dictum ex venenatis maximus.
Ut vitae viverra lorem. Maecenas et lectus sapien pharetra cursus sit amet ac dolor. Vestibulum vel imperdiet urna. Ut rhoncus metus ante sollicitudin, nec luctus ligula feugiat. Duis gravida ornare mi a consequat. Nam ac lorem laoreet, efficitur nisi dignissim, aliquam libero.
  ''';
  final String linkUrl = 'https://yourlink.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F5FA),
      body: SafeArea(
        child: Column(
          children: [
            // AppBar-like row
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    'Exclusive Services',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  fontFamily: 'segeo',),
                  ),
                ),
                SizedBox(width: 48), // balance the back arrow
              ],
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner image
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.asset(
                          "assets/images/bannerimg.png",

                          height: 192,

                          width: 480,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar + name
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: AssetImage(
                                    'assets/images/bannerimg.png',
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  userName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'segeo',
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 12),

                            // Title
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff222222),
                                fontWeight: FontWeight.w700,
                                fontFamily: 'segeo',
                              ),
                            ),

                            SizedBox(height: 8),

                            // Description text
                            Text(
                              description,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff666666),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'segeo',
                              ),
                            ),

                            SizedBox(height: 12),

                            // Clickable link
                            GestureDetector(
                              onTap: () {
                                // TODO: launch linkUrl with url_launcher
                              },
                              child: Text(
                                'Visit this link to access the exclusive service.\nClick here',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
                                  color: Color(0xff9D5AF7),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'segeo',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer info
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
              child: Text(
                'To post your services mail to rohit@gmail.com',
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

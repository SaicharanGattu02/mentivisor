import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

// Dummy SizeConfig and primarycolor for completeness
class SizeConfig {
  static double screenHeight = 800;
  static double screenWidth = 400;
}

const Color primarycolor = Color(0xFF4076ED);

class MentorHomeScreen extends StatefulWidget {
  const MentorHomeScreen({Key? key}) : super(key: key);

  @override
  State<MentorHomeScreen> createState() => _MentorHomeScreenState();
}

class _MentorHomeScreenState extends State<MentorHomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  final List<String> bannerData = [
    'assets/images/buycoinsimg.png',
    'assets/images/buycoinsimg.png',
    'assets/images/buycoinsimg.png',
    'assets/images/buycoinsimg.png',
  ];

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  void _toggleDrawerOrExit() {
    final scaffoldState = _scaffoldKey.currentState;
    if (scaffoldState != null && scaffoldState.isDrawerOpen) {
      // Drawer is open → close it
      Navigator.of(context).pop();
      // If you truly wanted to exit instead, replace the pop() with:
      // exit(0);
    } else {
      // Drawer is closed → open it
      scaffoldState?.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: primarycolor),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.of(context).pop(),
            ),
            // Add more drawer items here...
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xffF7F9FE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: _toggleDrawerOrExit,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Hello!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: "Inter",
              ),
            ),
            Text(
              'Vijay',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: "Inter",
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications clicked')),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFAF5FF),
              Color(0xFFF5F6FF),
              Color(0xFFEFF6FF),
            ],
          ),
        ),
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: SizeConfig.screenHeight * 0.2,
                viewportFraction: 1,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                enableInfiniteScroll: true,
                enlargeCenterPage: false,
                pauseAutoPlayOnTouch: true,
                scrollDirection: Axis.horizontal,
                aspectRatio: 16 / 9,
                onPageChanged: (i, _) => _currentIndex.value = i,
              ),
              items: bannerData.map((assetPath) {
                return InkWell(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      color: Colors.grey.shade200,
                      child: Image.asset(
                        assetPath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<int>(
              valueListenable: _currentIndex,
              builder: (context, currentIndex, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(bannerData.length, (index) {
                    final isFirst = index == 0;
                    final isLast = index == bannerData.length - 1;
                    final isNear = (index - currentIndex).abs() <= 1;

                    if (!isFirst && !isLast && !isNear) {
                      return const SizedBox.shrink();
                    }
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: SizeConfig.screenHeight * 0.008,
                      width: currentIndex == index
                          ? SizeConfig.screenWidth * 0.05
                          : SizeConfig.screenWidth * 0.014,
                      decoration: BoxDecoration(
                        color: currentIndex == index
                            ? primarycolor
                            : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    );
                  }),
                );
              },
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Upcoming Session',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'segeo',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildSessionCard(),
                      childCount: 5,
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

  Widget _buildSessionCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '5th Jun 2025',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'segeo',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'G-Meet with Ramesh',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'segeo',
                        ),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'images/communityimage.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF4076ED).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '2 Jun 2025 at 5:00 PM',
                style: TextStyle(
                  color: Color(0xFF4076ED),
                  fontSize: 12,
                  fontFamily: 'segeo',
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Session Topics',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'segeo',
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the.....',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'segeo',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFF4E9FF),
                          Color(0xFFE1E4FF),
                          Color(0xFFE2EEFF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.message, size: 16),
                      label: const Text(
                        'Message from Ramesh',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'segeo',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    backgroundColor: const Color(0xFFF5F5F5),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF333333),
                      fontFamily: 'segeo',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/utils/color_constants.dart';
import '../../Mentee/presentation/Community/CommunityScreen.dart';
import 'MentorHomeScreen.dart';
import 'MySessionsScreen.dart';

class MentorDashboard extends StatefulWidget {
  const MentorDashboard({Key? key}) : super(key: key);

  @override
  State<MentorDashboard> createState() => _MentorDashboardState();
}

class _MentorDashboardState extends State<MentorDashboard> {
  late PageController _pageController;
  int _selectedIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
    setState(() => _selectedIndex = index);
  }

  Future<bool> _onWillPop() async {
    SystemNavigator.pop();
    return false;
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Drawer Header
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFE5E8F9),
                ), // Light gradient background
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                        'assets/profile_image.png',
                      ), // Replace with your image
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Profile', // Text for the profile section
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Drawer Menu Items
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Profile'),
                onTap: () {
                  // Navigate to Profile screen
                },
              ),
              ListTile(
                leading: Icon(Icons.group),
                title: Text('My Mentees'),
                onTap: () {
                  context.pop();
                  context.push("/mentees_list");
                },
              ),
              ListTile(
                leading: Icon(Icons.feedback),
                title: Text('Feedback'),
                onTap: () {
                  // Navigate to Feedback screen
                },
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Coin History'),
                onTap: () {
                  // Navigate to Coin History screen
                },
              ),
              ListTile(
                leading: Icon(Icons.card_giftcard),
                title: Text('Coupon'),
                onTap: () {
                  // Navigate to Coupon screen
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('Info'),
                onTap: () {
                  // Navigate to Info screen
                },
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Update Mentor Profile'),
                onTap: () {
                  // Navigate to Update Mentor Profile screen
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.red),
                title: Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () {
                  // Handle logout
                },
              ),
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
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.black,
              ),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications clicked')),
              ),
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (i) {
            HapticFeedback.lightImpact();
            setState(() => _selectedIndex = i);
          },
          children: [
            MentorHomeScreen(),
            MySessionsScreen(),
            Communityscreen(),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 10,
            color: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue, // Selected icon color
        unselectedItemColor: Colors.black54, // Unselected icon color
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              height: 32,
              width: 56,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _selectedIndex == 0
                    ? primarycolor1.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                  size: 24,
                ),
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              height: 32,
              width: 56,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _selectedIndex == 1
                    ? primarycolor1.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  _selectedIndex == 1
                      ? Icons.video_camera_front
                      : Icons.video_camera_front_outlined,
                  size: 24,
                ),
              ),
            ),
            label: 'My Session',
          ),
          BottomNavigationBarItem(
            icon: Container(
              height: 32,
              width: 56,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _selectedIndex == 2
                    ? primarycolor1.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  _selectedIndex == 2
                      ? Icons.access_time
                      : Icons.access_time_outlined,
                  size: 24,
                ),
              ),
            ),
            label: 'Availability',
          ),
          BottomNavigationBarItem(
            icon: Container(
              height: 32,
              width: 56,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _selectedIndex == 3
                    ? primarycolor1.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  _selectedIndex == 3 ? Icons.money : Icons.money_outlined,
                  size: 24,
                ),
              ),
            ),
            label: 'Earnings',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

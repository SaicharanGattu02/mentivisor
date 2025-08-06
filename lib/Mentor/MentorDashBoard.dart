import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/utils/color_constants.dart';
import '../bloc/internet_status/internet_status_bloc.dart';
import '../newscreens/CommunityScreen.dart';
import '../newscreens/MenteeHomeScreens.dart';
import '../studyzone/StudyzoneScreens.dart';
import '../EEC/EccScreen.dart';
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
            EccScreen(),
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
                    ? Colors.blue.withOpacity(0.1)
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
                    ? Colors.blue.withOpacity(0.1)
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
                    ? Colors.blue.withOpacity(0.1)
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
                    ? Colors.blue.withOpacity(0.1)
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/utils/color_constants.dart';
import '../bloc/internet_status/internet_status_bloc.dart';
import '../newscreens/CommunityScreen.dart';
import '../newscreens/NewHomeScreens.dart';
import '../studyzone/StudyzoneScreens.dart';
import '../EEC/EccScreen.dart';
import 'MentorHomeScreen.dart';

class MentorDashboard extends StatefulWidget {
  const MentorDashboard({Key? key}) : super(key: key);

  @override
  State<MentorDashboard> createState() => _MentorDashboardState();
}

class _MentorDashboardState extends State<MentorDashboard> {
  late PageController _pageController;
  int _selectedIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (i) {
            HapticFeedback.lightImpact();
            setState(() => _selectedIndex = i);
          },
          children:  [
            MentorHomeScreen(),      // Home
            StudyZoneScreen(),    // Study Zone
            EccScreen(),          // ECC
            Communityscreen(),    // Community
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
        selectedItemColor: Colors.green ,
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1 ? Icons.menu_book : Icons.menu_book_outlined,
              size: 24,
            ),
            label: 'My Session',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2 ? Icons.school : Icons.school_outlined,
              size: 24,
            ),
            label: 'Availability',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 3 ? Icons.group : Icons.group_outlined,
              size: 24,
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

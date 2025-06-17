import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/presentation/MyWalletScreen.dart';
import 'package:mentivisor/utils/color_constants.dart';
import '../bloc/internet_status/internet_status_bloc.dart';
import 'Home.dart';
import 'ProfileScreen.dart';
import 'SessionHistory.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late PageController pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // _selectedIndex = widget.initialTab ?? 0;
    pageController = PageController(initialPage: _selectedIndex);
  }

  void onItemTapped(int selectedItems) {
    pageController.jumpToPage(selectedItems);
    setState(() {
      _selectedIndex = selectedItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: PageView(
          onPageChanged: (value) {
            HapticFeedback.lightImpact();
            setState(() {
              _selectedIndex = value;
            });
          },
          controller: pageController,
          children: [
            Home(),
            MyWalletScreen(),
            SessionHistory(),
            ProfileScreen(),
          ],
          physics: const NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
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
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primarycolor,
        unselectedItemColor: Colors.black,
        selectedFontSize: 12.0,
        unselectedFontSize: 9.0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(
              _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
              size: 24,
            ),
          ),
          BottomNavigationBarItem(
            label: "Wallet",
            icon: Icon(
              _selectedIndex == 1 ? Icons.account_balance_wallet : Icons.account_balance_wallet_outlined,
              size: 24,
            ),
          ),
          BottomNavigationBarItem(
            label: "Sessions",
            icon: Icon(
              _selectedIndex == 2 ? Icons.history : Icons.history_outlined,
              size: 24,
            ),
          ),
          BottomNavigationBarItem(
            label: "More",
            icon: Icon(
              _selectedIndex == 3 ? Icons.person : Icons.person_outline,
              size: 24,
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }

}

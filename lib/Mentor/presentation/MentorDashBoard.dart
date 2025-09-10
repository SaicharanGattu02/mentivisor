import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorProfile/mentor_profile_cubit.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorProfile/mentor_profile_states.dart';
import 'package:mentivisor/Mentor/presentation/widgets/AppDrawer.dart';
import 'package:mentivisor/utils/color_constants.dart';
import '../../Mentee/presentation/Community/CommunityScreen.dart';
import '../data/Cubits/MentorDashboardCubit/mentor_dashboard_cubit.dart';
import 'CouponsHomeScreen.dart';
import 'MentorHomeScreen.dart';
import 'MySessionsScreen.dart';
import 'SlotsBookingScreen.dart';

class MentorDashboard extends StatefulWidget {
  final int? selectedIndex;
  const MentorDashboard({Key? key, this.selectedIndex}) : super(key: key);

  @override
  State<MentorDashboard> createState() => _MentorDashboardState();
}

class _MentorDashboardState extends State<MentorDashboard> {
  late PageController _pageController;
  late int _selectedIndex;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ?? 0;
    _pageController = PageController(initialPage: _selectedIndex);
    context.read<MentorProfileCubit1>().getMentorProfile();
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
    setState(() => _selectedIndex = index);
  }

  Future<bool> _onWillPop() async {
    // 1) Close drawer if open
    final scaffoldState = _scaffoldKey.currentState;
    if (scaffoldState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop(); // closes drawer
      return false; // don't exit
    }

    // 2) If not on 0th index, go to 0th and don't exit
    if (_selectedIndex != 0) {
      _onItemTapped(0); // this jumpToPage + setState
      return false;
    }

    // 3) Already on 0th index → exit
    SystemNavigator.pop();
    return false; // we handled it
  }


  void _toggleDrawerOrExit() {
    final scaffoldState = _scaffoldKey.currentState;
    if (scaffoldState != null && scaffoldState.isDrawerOpen) {
      Navigator.of(context).pop();
    } else {
      scaffoldState?.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const AppDrawer(),
        appBar: AppBar(
          backgroundColor: const Color(0xffF7F9FE),
          automaticallyImplyLeading: false,
          title: BlocBuilder<MentorProfileCubit1, MentorProfileStates>(
            builder: (context, state) {
              final user_data = state is MentorProfile1Loaded
                  ? state.mentorProfileModel.data
                  : null;
              return Row(
                // FIX: Row has no `spacing`; using SizedBox keeps the same look.
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.menu, color: Colors.black, size: 34),
                    onPressed: _toggleDrawerOrExit,
                  ),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello!',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          height: 1,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        user_data?.name ?? "User",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          height: 1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            IconButton(
              icon: Image.asset(
                "assets/images/mente.png",
                height: 21,
                width: 26,
              ),
              onPressed: () {
                context.pushReplacement('/dashboard');
              },
            ),
            IconButton(
              icon: Image.asset(
                "assets/icons/notifications.png",
                height: 21,
                width: 26,
              ),
              onPressed: () {
                context.push('/notifications');
              },
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
            const MentorHomeScreen(),
            const MySessionsScreen(),
            const Slotsbookingscreen(),
            const CouponsHomeScreen(),
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
        selectedItemColor: primarycolor,
        unselectedItemColor: Colors.black54,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              height: 32,
              width: 56,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _selectedIndex == 0
                    ? primarycolor1.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Image.asset(
                  _selectedIndex == 0
                      ? "assets/icons/homefilled.png"
                      : "assets/icons/homeoutline.png",
                ),
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              height: 32,
              width: 56,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _selectedIndex == 1
                    ? primarycolor1.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Image.asset(
                  _selectedIndex == 1
                      ? "assets/icons/sessionfilled.png"
                      : "assets/icons/sessionoutline.png",
                ),
              ),
            ),
            label: 'My Session',
          ),
          BottomNavigationBarItem(
            icon: Container(
              height: 32,
              width: 56,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _selectedIndex == 2
                    ? primarycolor1.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Image.asset(
                  _selectedIndex == 2
                      ? "assets/icons/ClockUserfilled.png"
                      : "assets/icons/ClockUseroutline.png",
                ),
              ),
            ),
            label: 'Availability',
          ),
          BottomNavigationBarItem(
            icon: Container(
              height: 32,
              width: 56,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _selectedIndex == 3
                    ? primarycolor1.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Image.asset(
                  _selectedIndex == 3
                      ? "assets/icons/coinsfilled.png"
                      : "assets/icons/coinsoutline.png",
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

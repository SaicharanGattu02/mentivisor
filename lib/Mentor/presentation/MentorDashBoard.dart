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
    context.read<MentorProfileCubit1>().getMentorProfile();
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
      Navigator.of(context).pop();
      // If you truly wanted to exit instead, replace the pop() with:
      // exit(0);
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
                spacing: 6,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.menu, color: Colors.black, size: 34),
                    onPressed: _toggleDrawerOrExit,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
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
                        style: TextStyle(
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

            // IconButton(
            //   icon: Image.asset(
            //     "assets/images/crownonly.png",
            //     height: 21,
            //     width: 26,
            //   ),
            //   onPressed: () {
            //     context.push('/dashboard');
            //   },
            // ),


            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.black,
              ),
              onPressed: () {

              }
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
          children: [MentorHomeScreen(), MySessionsScreen(), Communityscreen(),CouponsHomeScreen()],
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

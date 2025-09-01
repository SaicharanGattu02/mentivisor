import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Mentee/presentation/studyzone/MeteeStudyzoneScreens.dart';
import '../../bloc/internet_status/internet_status_bloc.dart';
import 'Community/CommunityScreen.dart';
import '../../utils/color_constants.dart';
import 'Ecc/EccScreen.dart';
import 'MenteeHomeScreens.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

class Dashboard extends StatefulWidget {
  final int? selectedIndex;
  const Dashboard({super.key, this.selectedIndex});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late PageController _pageController;
  int _selectedIndex = 0;

  // Controls the bottom bar visibility
  final ValueNotifier<bool> _showBottomBar = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ?? 0;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          _pageController.jumpToPage(0);
          return false; // Prevent app from exiting
        } else {
          SystemNavigator.pop(); // Exit app
          return true;
        }
      },
      child: Scaffold(
        // extendBody: true,
        body: BlocListener<InternetStatusBloc, InternetStatusState>(
          listener: (context, state) {
            if (state is InternetStatusLostState) {
              context.push('/no_internet');
            } else if (state is InternetStatusBackState) {
              context.pop();
            }
          },
          // Wrap the PageView with our scroll listener wrapper
          child: _HideNavbarOnScroll(
            controller: _showBottomBar,
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) {
                HapticFeedback.lightImpact();
                setState(() => _selectedIndex = i);
              },
              children: const [
                MenteeHomeScreen(),
                MenteeStudyZone(),
                EccScreen(),
                Communityscreen(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: ValueListenableBuilder<bool>(
          valueListenable: _showBottomBar,
          builder: (context, show, _) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                // slide + size for extra smoothness
                final slide = Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(animation);
                return ClipRect(
                  // prevent overflow during transition
                  child: SizeTransition(
                    sizeFactor: animation,
                    axisAlignment: -1.0,
                    child: SlideTransition(position: slide, child: child),
                  ),
                );
              },
              child: show
                  ? _buildBottomNav()
                  : const SizedBox.shrink(
                      key: ValueKey('hidden'),
                    ), // zero height
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: primarycolor,
      unselectedItemColor: Colors.black,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 0,
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            _selectedIndex == 0
                ? "assets/icons/homefilled.png"
                : "assets/icons/homeoutline.png",
            width: 20,
            height: 20,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            _selectedIndex == 1
                ? "assets/icons/studyzonefilled.png"
                : "assets/icons/studyzoneoutline.png",
            width: 20,
            height: 20,
          ),
          label: 'Study Zone',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            _selectedIndex == 2
                ? "assets/icons/eccfilled.png"
                : "assets/icons/eccoutline.png",
            width: 20,
            height: 20,
          ),
          label: 'ECC',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            _selectedIndex == 3
                ? "assets/icons/studyzonefilled.png"
                : "assets/icons/studyzoneoutline.png",
            width: 20,
            height: 20,
          ),
          label: 'Community',
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _showBottomBar.dispose();
    super.dispose();
  }
}

/// Listens to scroll direction bubbling up from any ScrollView inside `child`.
/// Hides on scroll down, shows on scroll up.
class _HideNavbarOnScroll extends StatelessWidget {
  final Widget child;
  final ValueNotifier<bool> controller;
  const _HideNavbarOnScroll({required this.child, required this.controller});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        final direction = notification.direction;
        if (direction == ScrollDirection.reverse) {
          // Scrolling down
          if (controller.value) controller.value = false;
        } else if (direction == ScrollDirection.forward) {
          // Scrolling up
          if (!controller.value) controller.value = true;
        }
        // If idle, do nothing
        return false; // let it continue bubbling
      },
      child: child,
    );
  }
}

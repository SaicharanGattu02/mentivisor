import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Mentee/presentation/studyzone/MeteeStudyzoneScreens.dart';
import 'package:mentivisor/services/AuthService.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../bloc/internet_status/internet_status_bloc.dart';
import '../../services/SocketService.dart';
import '../../utils/DeepLinkMapper.dart';
import '../data/cubits/HomeDialog/home_dialog_cubit.dart';
import '../data/cubits/HomeDialog/home_dialog_states.dart';
import 'Community/CommunityScreen.dart';
import '../../utils/color_constants.dart';
import 'Ecc/EccScreen.dart';
import 'MenteeHomeScreens.dart';
import 'package:flutter/rendering.dart';

import 'Widgets/custom_ad_dialog.dart';

class Dashboard extends StatefulWidget {
  final int? selectedIndex;
  const Dashboard({super.key, this.selectedIndex});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late PageController _pageController;
  int _selectedIndex = 0;
  StreamSubscription<Uri>? _linkSubscription;
  // Controls the bottom bar visibility
  final ValueNotifier<bool> _showBottomBar = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ?? 0;
    _pageController = PageController(initialPage: _selectedIndex);
    getUserId();
  }

  Future<void> initDeepLinks() async {
    final appLinks = AppLinks();
    debugPrint('DeepLink: initDeepLinks started');
    try {
      final initialUri = await appLinks.getInitialLink();
      debugPrint('DeepLink: getInitialLink -> $initialUri');
      final loc = DeepLinkMapper.toLocation(initialUri);
      if (loc != null) {
        debugPrint('DeepLink: navigating to $loc');
        context.push(loc);
      } else {
        debugPrint('DeepLink: no mapped location for $initialUri');
      }
    } catch (e) {
      debugPrint('DeepLink: Initial app link error: $e');
    }

    // 2) Handle links while the app is running
    // _linkSubscription = appLinks.uriLinkStream.listen((uri) {
    //   debugPrint('DeepLink: uriLinkStream -> $uri');
    //   final loc = DeepLinkMapper.toLocation(uri);
    //   if (loc != null) {
    //     debugPrint('DeepLink: navigating to $loc');
    //     context.push(loc);
    //   } else {
    //     debugPrint('DeepLink: no mapped location for $uri');
    //   }
    // }, onError: (e) => debugPrint('DeepLink: Link stream error: $e'));
  }

  @override
  void dispose() {
    debugPrint('DeepLink: dispose, cancelling subscription');
    _linkSubscription?.cancel();
    _pageController.dispose();
    _showBottomBar.dispose();
    super.dispose();
  }

  Future<void> getUserId() async {
    final userId = await AuthService.getUSerId();
    AppLogger.info("userId: ${userId}");
    SocketService.connect(userId.toString());
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
    setState(() => _selectedIndex = index);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
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
        body: BlocListener<HomeDialogCubit, HomeDialogState>(
          listener: (context, state) {
            if (state is HomeDialogLoaded) {
              final homeNotify = state.homeDilogModel.data;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => CustomAdDialog(
                  image: homeNotify?.image,
                  title: homeNotify?.title,
                  description: homeNotify?.description,
                  url: homeNotify?.url,
                ),
              );
            }
          },
          child: BlocListener<InternetStatusBloc, InternetStatusState>(
            listener: (context, state) {
              if (state is InternetStatusLostState) {
                context.push('/no_internet');
              } else if (state is InternetStatusBackState) {}
            },
            // Wrap the PageView with our scroll listener wrapper
            // child: _HideNavbarOnScroll(
            //   controller: _showBottomBar,
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
            // ),
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
}

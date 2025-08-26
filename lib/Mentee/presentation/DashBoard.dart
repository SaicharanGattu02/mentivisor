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

class Dashboard extends StatefulWidget {
  final int?selectedIndex;
  const Dashboard({Key? key,this.selectedIndex}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late PageController _pageController;
  int _selectedIndex = 0;

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

  Future<bool> _onWillPop() async {
    SystemNavigator.pop();
    return false;
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
        body:  BlocListener<InternetStatusBloc, InternetStatusState>(
          listener: (context, state) {
            if (state is InternetStatusLostState) {
              context.push('/no_internet');
            } else if (state is InternetStatusBackState) {
              context.pop();
            }
          },
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (i) {
              HapticFeedback.lightImpact();
              setState(() => _selectedIndex = i);
            },
            children: [
              MenteeHomeScreen(),
              MenteeStudyZone(),
              EccScreen(),
              Communityscreen(),
            ],
          ),
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
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon:Image.asset( _selectedIndex == 0 ? "assets/icons/homefilled.png":"assets/icons/homeoutline.png",width: 20,height: 20,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon:Image.asset( _selectedIndex == 1 ? "assets/icons/studyzonefilled.png":"assets/icons/studyzoneoutline.png",width: 20,height: 20,),
            label: 'Study Zone',
          ),
          BottomNavigationBarItem(
            icon:Image.asset( _selectedIndex == 2 ? "assets/icons/eccfilled.png":"assets/icons/eccoutline.png",width: 20,height: 20,),
            label: 'ECC',
          ),
          BottomNavigationBarItem(
            icon:Image.asset( _selectedIndex == 3 ? "assets/icons/studyzonefilled.png":"assets/icons/studyzoneoutline.png",width: 20,height: 20,),
            label: 'Community',
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

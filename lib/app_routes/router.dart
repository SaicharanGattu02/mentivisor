import 'dart:ui';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/EEC/AddEventScreen.dart';
import 'package:mentivisor/EEC/EccScreen.dart';
import 'package:mentivisor/Notification/NotificationScreen.dart';
import 'package:mentivisor/newscreens/AchievementScreen.dart';
import 'package:mentivisor/newscreens/AddPostScreen.dart';
import 'package:mentivisor/newscreens/AddResourceScreen.dart';
import 'package:mentivisor/newscreens/BecomeMentorScreen.dart';
import 'package:mentivisor/newscreens/ChartScreen.dart';
import 'package:mentivisor/newscreens/CommunityScreen.dart';
import 'package:mentivisor/newscreens/CostPerMinuteScreen.dart';
import 'package:mentivisor/newscreens/MentorProfileScreen.dart';
import 'package:mentivisor/newscreens/NewHomeScreens.dart';
import 'package:mentivisor/newscreens/PostDetailScreen.dart';
import 'package:mentivisor/newscreens/ProfileSetupScreen.dart';
import 'package:mentivisor/newscreens/SubTopicSelectionScreen.dart';
import 'package:mentivisor/newscreens/SuccessScreen.dart';
import 'package:mentivisor/newscreens/TopicSelectionScreen.dart';
import 'package:mentivisor/newscreens/ViewEventScreen.dart';
import 'package:mentivisor/presentation/BuyCoins.dart';
import 'package:mentivisor/presentation/Home.dart';
import 'package:mentivisor/presentation/MyWalletScreen.dart';
import 'package:mentivisor/presentation/PurchasePage.dart';
import 'package:mentivisor/presentation/PurchaseSuccessPage.dart';
import 'package:mentivisor/profileview/EditProfileScreen.dart';
import 'package:mentivisor/profileview/ProductivityToolsScreen.dart';
import 'package:mentivisor/studyzone/ResourceDetailScreen.dart';
import '../Components/NoInternet.dart';
import '../newscreens/ExclusiveServices.dart';
import '../newscreens/ExclusiveServicesInfo.dart';
import '../newscreens/InfoScreen.dart';
import '../newscreens/InterestingScreen.dart';
import '../newscreens/LanguageSelectionScreen.dart';
import '../newscreens/ProfileSetupWizard.dart';
import '../newscreens/SessionCompletedScreen.dart';
import '../presentation/BookSessionScreen.dart';
import '../presentation/DailyCheckinDialog.dart';
import '../presentation/DashBoard.dart';
import '../presentation/Details.dart';
import '../presentation/SessionHistory.dart';
import '../presentation/Splash.dart';
import 'package:mentivisor/presentation/MentivisorProfileSetup.dart';
import 'package:mentivisor/presentation/ProfileScreen.dart';
import 'package:mentivisor/presentation/StudyZoneScreen.dart';
import 'package:mentivisor/presentation/authentication/SignupScreen.dart';

import '../presentation/WalletHistory.dart';
import '../presentation/authentication/EnterMobileNumber.dart';
import '../presentation/authentication/LoginScreen.dart';
import '../presentation/authentication/OTPVerificationScreen.dart';
import '../presentation/authentication/SelecterScreen.dart';
import '../presentation/authentication/SuccessfullInScreen.dart';
import '../profileview/ProfileScreen.dart';
import '../studyzone/StudyzoneScreens.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(HomeScreennew(), state),
    ),

    GoRoute(
      path: '/InterestingScreen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(InterestingScreen(), state),
    ),
    GoRoute(
      path: '/becomementorscreen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(BecomeMentorScreen(), state),
    ),

    // GoRoute(
    //   path: '/',
    //   pageBuilder: (context, state) =>
    //       buildSlideTransitionPage(HomeScreennew(), state),
    // ),
    GoRoute(
      path: '/profilesetup',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(ProfileSetupScreen(), state),
    ),

    GoRoute(
      path: '/otp_verify',
      pageBuilder: (context, state) {
        final num=state.uri.queryParameters['number']??"";
        return  buildSlideTransitionPage(OTPVerificationScreen(number:num ,), state);
}

    ),

    GoRoute(
      path: '/SuccessfullinScreen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(SuccessfullinScreen(), state),
    ),

    GoRoute(
      path: '/emailinput',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(EmailInputScreen(), state),
    ),

    GoRoute(
      path: '/loginscreen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(LoginScreen(), state),
    ),
    GoRoute(
      path: '/selectedscreen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(Selecterscreen(), state),
    ),
    GoRoute(
      path: '/editprofile',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(EditProfileScreen(), state),
    ),
    GoRoute(
      path: '/eccscreen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(EccScreen(), state),
    ),

    GoRoute(
      path: '/addeventscreen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(AddEventScreen(), state),
    ),

    GoRoute(
      path: '/addpostscreen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(AddPostScreen(), state),
    ),
    GoRoute(
      path: '/chartscreen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(ChartScreen(), state),
    ),

    GoRoute(
      path: '/communityscreen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(Communityscreen(), state),
    ),

    GoRoute(
      path: '/addresourcescreen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(AddResourceScreen(), state),
    ),

    GoRoute(
      path: '/resourcedetailscreen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(ResourceDetailScreen(), state),
    ),

    GoRoute(
      path: '/study_zone',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(StudyZonemainScreen(), state),
    ),

    GoRoute(
      path: '/infoscreen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(InfoScreen(), state),
    ),
    GoRoute(
      path: '/executiveservices',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(ExclusiveServices(), state),
    ),
    GoRoute(
      path: '/executiveinfoservices',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(ExclusiveInfoServices(), state),
    ),

    GoRoute(
      path: '/topicselection',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(TopicSelectionScreen(), state),
    ),
    GoRoute(
      path: '/success_screen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(SuccessScreen(), state),
    ),
    GoRoute(
      path: '/costperminute_screen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(CostPerMinuteScreen(), state),
    ),
    GoRoute(
      path: '/subtopicselect_screen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(SubTopicSelectionScreen(), state),
    ),
    GoRoute(
      path: '/language_selection',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(LanguageSelectionScreen(), state),
    ),
    GoRoute(
      path: '/no_internet',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(Nointernet(), state),
    ),
    GoRoute(
      path: '/session_history',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(SessionHistory(), state),
    ),
    GoRoute(
      path: '/dashboard',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(Dashboard(), state),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(LoginScreen(), state),
    ),

    GoRoute(
      path: '/sign_up',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(SignupScreen(), state),
    ),
    GoRoute(
      path: '/mentor_profile',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(MentivisorProfileSetup(), state),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(ProfileScreen(), state),
    ),

    GoRoute(
      path: '/wallet_screen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(SplashScreen(), state),
    ),
    GoRoute(
      path: '/wallet_history',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(WalletHistory(), state),
    ),
    GoRoute(
      path: '/details',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(Details(), state),
    ),
    GoRoute(
      path: '/buy_coins',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(BuyCoinsScreen(), state),
    ),
    GoRoute(
      path: '/purchase_screen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(PurchasePage(), state),
    ),
    GoRoute(
      path: '/purchase_success_screen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(PurchaseSuccessPage(), state),
    ),
    GoRoute(
      path: '/book_sessions_screen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(BookSessionScreen(), state),
    ),
  ],
);

Page<dynamic> buildSlideTransitionPage(Widget child, GoRouterState state) {
  // if (Platform.isIOS) {
  //   // Use default Cupertino transition on iOS
  //   return CupertinoPage(key: state.pageKey, child: child);
  // }

  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

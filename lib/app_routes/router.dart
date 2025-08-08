import 'dart:ui';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Mentee/presentation/DownloadsScreen.dart';
import 'package:mentivisor/Mentor/presentation/CancelSessionScreen.dart';
import 'package:mentivisor/Mentee/presentation/Community/AddPostScreen.dart';
import 'package:mentivisor/Mentee/presentation/studyzone/AddResourceScreen.dart';
import 'package:mentivisor/newscreens/BecomeMentorScreen.dart';
import 'package:mentivisor/newscreens/ChartScreen.dart';
import 'package:mentivisor/Mentee/presentation/Community/CommunityScreen.dart';
import 'package:mentivisor/newscreens/CostPerMinuteScreen.dart';
import 'package:mentivisor/newscreens/ProfileSetupScreen.dart';
import 'package:mentivisor/newscreens/SubTopicSelectionScreen.dart';
import 'package:mentivisor/newscreens/TopicSelectionScreen.dart';
import 'package:mentivisor/Mentee/presentation/CampusMentorList.dart';
import 'package:mentivisor/Mentee/presentation/Ecc/ViewEventScreen.dart';
import 'package:mentivisor/presentation/BuyCoins.dart';
import 'package:mentivisor/presentation/PurchasePage.dart';
import 'package:mentivisor/presentation/PurchaseSuccessPage.dart';
import 'package:mentivisor/profileview/EditProfileScreen.dart';
import '../Components/NoInternet.dart';
import '../Mentee/Models/StudyZoneCampusModel.dart';
import '../Mentee/Models/ECCModel.dart';
import '../Mentee/presentation/Ecc/AddEventScreen.dart';
import '../Mentee/presentation/MentorProfileScreen.dart';
import '../Mentee/presentation/ProductivityToolsScreen.dart';
import '../Mentee/presentation/WalletScreen.dart';
import '../Mentee/presentation/authentication/LoginScreen.dart';
import '../Mentee/presentation/authentication/OTPVerificationScreen.dart';
import '../Mentee/presentation/authentication/SelecterScreen.dart';
import '../Mentee/presentation/authentication/SignupScreen.dart';
import '../Mentee/presentation/authentication/SuccessScreen.dart';
import '../Mentee/presentation/studyzone/ResourceDetailScreen.dart';
import '../Mentor/presentation/MenteeListScreen.dart';
import '../Mentor/presentation/MentorDashBoard.dart';
import '../Mentor/presentation/SessionDetailScreen.dart';
import '../newscreens/AcadamicJourneyScreen.dart';
import '../Mentee/presentation/BuyCoinsScreens.dart';
import '../newscreens/ExclusiveServices.dart';
import '../newscreens/ExclusiveServicesInfo.dart';
import '../newscreens/InfoScreen.dart';
import '../newscreens/InterestingScreen.dart';
import '../newscreens/LanguageSelectionScreen.dart';
import '../newscreens/ProfileSetupWizard.dart';
import '../presentation/BookSessionScreen.dart';
import '../Mentee/presentation/DashBoard.dart';
import '../presentation/Details.dart';
import '../presentation/SessionHistory.dart';
import '../presentation/Splash.dart';
import 'package:mentivisor/presentation/ProfileScreen.dart';
// import '../presentation/WalletHistory.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(SplashScreen(), state);
      },
    ),

    GoRoute(
      path: '/chart_screen',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(ChartScreen(), state);
      },
    ),
    GoRoute(
      path: '/downloads',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(DownloadsScreen(), state);
      },
    ),
    GoRoute(
      path: '/add_resource',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(AddResourceScreen(), state),
    ),
    GoRoute(
      path: '/productivity_screen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(ProductivityScreen(), state),
    ),
    GoRoute(
      path: '/campus_mentor_list',
      pageBuilder: (context, state) {
        final scope = state.uri.queryParameters['scope'] ?? "";
        return buildSlideTransitionPage(Campusmentorlist(scope: scope), state);
      },
    ),
    GoRoute(
      path: '/resource_details_screen',
      pageBuilder: (context, state) {
        final studyZoneData = state.extra as StudyZoneCampusData;
        return buildSlideTransitionPage(
          ResourceDetailScreen(studyZoneCampusData: studyZoneData),
          state,
        );
      },
    ),
    GoRoute(
      path: '/mentor_profile',
      pageBuilder: (context, state) {
        final idString = state.uri.queryParameters['id'];
        final id = int.tryParse(idString ?? '') ?? 0;

        return buildSlideTransitionPage(MentorProfileScreen(id: id), state);
      },
    ),
    GoRoute(
      path: '/mentivisorprofilesetup',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(Acadamicjourneyscreen(), state),
    ),
    GoRoute(
      path: '/profilesetupwizard',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(ProfileSetupWizard(), state),
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

    GoRoute(
      path: '/profilesetup',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(ProfileSetupScreen(), state),
    ),

    GoRoute(
      path: '/otp_verify',
      pageBuilder: (context, state) {
        final num = state.uri.queryParameters['number'] ?? "";
        return buildSlideTransitionPage(
          OTPVerificationScreen(number: num),
          state,
        );
      },
    ),
    GoRoute(
      path: '/selected_screen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(Selecterscreen(), state),
    ),
    GoRoute(
      path: '/editprofile',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(EditProfileScreen(), state),
    ),
    GoRoute(
      path: '/addeventscreen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(AddEventScreen(), state),
    ),

    GoRoute(
      path: '/view_event',
      pageBuilder: (context, state) {
        final eccList = state.extra as ECCList; // Cast the extra data
        return buildSlideTransitionPage(
          ViewEventScreen(eccList: eccList),
          state,
        );
      },
    ),

    GoRoute(
      path: '/addpostscreen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(AddPostScreen(), state),
    ),

    GoRoute(
      path: '/communityscreen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(Communityscreen(), state),
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
      path: '/profile',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(ProfileScreen(), state),
    ),

    GoRoute(
      path: '/wallet_screen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(WalletScreen(), state),
    ),
    GoRoute(
      path: '/buy_coins_screens',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(BuyCoinsScreens(), state),
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

    //// Mentor routes
    GoRoute(
      path: '/mentor_dashboard',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(MentorDashboard(), state);
      },
    ),
    GoRoute(
      path: '/cancel_session',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(CancelSessionScreen(), state);
      },
    ),
    GoRoute(
      path: '/session_details',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(SessionDetailScreen(), state);
      },
    ),

    GoRoute(
      path: '/mentees_list',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(MenteeListScreen(), state);
      },
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

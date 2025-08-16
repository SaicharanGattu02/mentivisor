import 'dart:ui';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Mentee/presentation/DownloadsScreen.dart';
import 'package:mentivisor/Mentee/presentation/Widgets/CustomerServiceScreen.dart';
import 'package:mentivisor/Mentee/presentation/authentication/AuthLandingScreen.dart';
import 'package:mentivisor/Mentor/presentation/CancelSessionScreen.dart';
import 'package:mentivisor/Mentee/presentation/Community/AddPostScreen.dart';
import 'package:mentivisor/Mentee/presentation/studyzone/AddResourceScreen.dart';
import 'package:mentivisor/Mentee/presentation/becomeMentor/BecomeMentorScreen.dart';
import 'package:mentivisor/newscreens/ChartScreen.dart';
import 'package:mentivisor/Mentee/presentation/Community/CommunityScreen.dart';
import 'package:mentivisor/Mentee/presentation/becomeMentor/CostPerMinuteScreen.dart';
import 'package:mentivisor/Mentee/presentation/authentication/profieSetup/ProfileSetupScreen.dart';
import 'package:mentivisor/Mentee/presentation/becomeMentor/ExpertiseSelection.dart';
import 'package:mentivisor/Mentee/presentation/CampusMentorList.dart';
import 'package:mentivisor/Mentee/presentation/Ecc/ViewEventScreen.dart';
import 'package:mentivisor/presentation/BuyCoins.dart';
import 'package:mentivisor/presentation/PurchasePage.dart';
import 'package:mentivisor/presentation/PurchaseSuccessPage.dart';
import 'package:mentivisor/presentation/Splash.dart';
import '../Components/NoInternet.dart';
import '../Mentee/Models/StudyZoneCampusModel.dart';
import '../Mentee/Models/ECCModel.dart';
import '../Mentee/presentation/Ecc/AddEventScreen.dart';
import '../Mentee/presentation/ExclusiveServicesInfo.dart';
import '../Mentee/presentation/MentorProfileScreen.dart';
import '../Mentee/presentation/ProductivityToolsScreen.dart';
import '../Mentee/presentation/Profile/EditProfileScreen.dart';
import '../Mentee/presentation/Profile/ProfileScreen.dart';
import '../Mentee/presentation/UpcomingSessionsScreen.dart';
import '../Mentee/presentation/WalletScreen.dart';
import '../Mentee/presentation/authentication/LoginScreen.dart';
import '../Mentee/presentation/authentication/OTPVerificationScreen.dart';
import '../Mentee/presentation/authentication/SelecterScreen.dart';
import '../Mentee/presentation/authentication/SignupScreen.dart';
import '../Mentee/presentation/authentication/SuccessScreen.dart';
import '../Mentee/presentation/authentication/profieSetup/AcadamicJourneyScreen.dart';
import '../Mentee/presentation/becomeMentor/BecomeMentorData.dart';
import '../Mentee/presentation/becomeMentor/LanguageSelectionScreen.dart';
import '../Mentee/presentation/becomeMentor/MentorReview.dart';
import '../Mentee/presentation/studyzone/ResourceDetailScreen.dart';
import '../Mentor/presentation/MenteeListScreen.dart';
import '../Mentor/presentation/MentorDashBoard.dart';
import '../Mentor/presentation/SessionDetailScreen.dart';
import '../Mentee/presentation/BuyCoinsScreens.dart';
import '../Mentee/presentation/ExclusiveServices.dart';
import '../newscreens/InfoScreen.dart';
import '../Mentee/presentation/becomeMentor/InterestingScreen.dart';
import '../Mentee/presentation/authentication/profieSetup/ProfileSetupWizard.dart';
import '../Mentee/presentation/SessionCompletedScreen.dart';
import '../Mentee/presentation/BookSessionScreen.dart';
import '../Mentee/presentation/DashBoard.dart';
import '../presentation/Details.dart';
import '../presentation/SessionHistory.dart';


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
      path: '/profile_setup',
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return buildSlideTransitionPage(ProfileSetupScreen(data: data), state);
      },
    ),

    GoRoute(
      path: '/otp_verify',
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return buildSlideTransitionPage(
          OTPVerificationScreen(data: data),
          state,
        );
      },
    ),
    GoRoute(
      path: '/success_screen',
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return buildSlideTransitionPage(SuccessScreen(data: data), state);
      },
    ),
    GoRoute(
      path: '/profile_about',
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return buildSlideTransitionPage(ProfileSetupWizard(data: data), state);
      },
    ),
    GoRoute(
      path: '/academic_journey',
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return buildSlideTransitionPage(
          Acadamicjourneyscreen(data: data),
          state,
        );
      },
    ),

    GoRoute(
      path: '/auth_landing',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(AuthLandingScreen(), state);
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
      path: '/session_completed',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(SessionCompletedScreen(), state),
    ),
    GoRoute(
      path: '/mentor_review',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(MentorReview(), state),
    ),
    GoRoute(
      path: '/upcoming_session',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(UpcomingSessionsScreen(), state),
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
      path: '/interesting_screen',
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return buildSlideTransitionPage(InterestingScreen(data: data), state);
      },
    ),
    GoRoute(
      path: '/becomementorscreen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(BecomeMentorScreen(), state),
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
      path: '/productivity_screen',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(ProductivityScreen(), state);
      },
    ),

    GoRoute(
      path: '/addpostscreen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(AddPostScreen(), state),
    ),

    GoRoute(
      path: '/customersscreen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(CustomerServiceScreen(), state),
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
      path: '/cost_per_minute_screen',
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return buildSlideTransitionPage(CostPerMinuteScreen(data: data), state);
      },
    ),

    GoRoute(
      path: '/subtopicselect_screen',
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return buildSlideTransitionPage(
          SubTopicSelectionScreen(data: data),
          state,
        );
      },
    ),

    GoRoute(
      path: '/language_selection',
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return buildSlideTransitionPage(
          LanguageSelectionScreen(data: data),
          state,
        );
      },
    ),

    GoRoute(
      path: '/become_mentor_data',
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return buildSlideTransitionPage(BecomeMentorData(data: data), state);
      },
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

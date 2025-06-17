import 'dart:ui';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Components/NoInternet.dart';
import '../presentation/BookSessionScreen.dart';
import '../presentation/DashBoard.dart';
import '../presentation/Splash.dart';
import 'package:mentivisor/presentation/MentivisorProfileSetup.dart';
import 'package:mentivisor/presentation/ProfileScreen.dart';
import 'package:mentivisor/presentation/StudyZoneScreen.dart';
import 'package:mentivisor/presentation/authentication/SignupScreen.dart';

import '../presentation/authentication/LoginScreen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(StudyZoneScreen(), state),
    ),
    GoRoute(
      path: '/nointernet',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(Nointernet(), state),
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
      path: '/study_zone',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(StudyZoneScreen(), state),
    ),
    GoRoute(
      path: '/booking_session',
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

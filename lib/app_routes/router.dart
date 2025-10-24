import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Mentee/presentation/Community/CommunityDetails.dart';
import 'package:mentivisor/GroupChatScreen.dart';
import 'package:mentivisor/Mentee/data/cubits/Chat/GroupRoomCubit.dart';
import 'package:mentivisor/Mentee/presentation/DownloadsScreen.dart';
import 'package:mentivisor/Mentee/presentation/MenteeHomeScreens.dart';
import 'package:mentivisor/Mentee/presentation/PdfViewerPage.dart';
import 'package:mentivisor/Mentee/presentation/Widgets/CustomerServiceScreen.dart';
import 'package:mentivisor/Mentee/presentation/authentication/AuthLandingScreen.dart';
import 'package:mentivisor/Mentor/presentation/AddExpertiseScreen.dart';
import 'package:mentivisor/Mentor/presentation/CancelSessionScreen.dart';
import 'package:mentivisor/Mentee/presentation/Community/AddPostScreen.dart';
import 'package:mentivisor/Mentee/presentation/studyzone/AddResourceScreen.dart';
import 'package:mentivisor/Mentee/presentation/becomeMentor/BecomeMentorScreen.dart';
import 'package:mentivisor/Mentor/presentation/FeedbackScreen.dart';
import 'package:mentivisor/Mentee/presentation/Community/CommunityScreen.dart';
import 'package:mentivisor/Mentee/presentation/becomeMentor/CostPerMinuteScreen.dart';
import 'package:mentivisor/Mentee/presentation/authentication/profieSetup/ProfileSetupScreen.dart';
import 'package:mentivisor/Mentee/presentation/becomeMentor/ExpertiseSelection.dart';
import 'package:mentivisor/Mentee/presentation/CampusMentorList.dart';
import 'package:mentivisor/Mentee/presentation/Ecc/ViewEventScreen.dart';
import 'package:mentivisor/Mentor/presentation/MentorInfoScreen.dart';
import 'package:mentivisor/Mentor/presentation/PendingSubExpertiseScreen.dart';
import 'package:mentivisor/Mentor/presentation/SubExpertisesScreen.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import '../ChatScreen.dart';
import '../Components/NoInternet.dart';
import '../Mentee/Models/MentorProfileModel.dart';
import '../Mentee/data/cubits/Chat/private_chat_cubit.dart';
import '../Mentee/presentation/CommingSoon.dart';
import '../Mentee/presentation/Ecc/AddEventScreen.dart';
import '../Mentee/presentation/ExclusiveServicesInfo.dart';
import '../Mentee/presentation/MenteeInfoScreen.dart';
import '../Mentee/presentation/Profile/MentorProfileScreen.dart';
import '../Mentee/presentation/Notifications.dart';
import '../Mentee/presentation/PaymentSuccessfully.dart';
import '../Mentee/presentation/ProductivityToolsScreen.dart';
import '../Mentee/presentation/Profile/EditProfileScreen.dart';
import '../Mentee/presentation/Profile/CommonProfile.dart';
import '../Mentee/presentation/Profile/ProfileScreen.dart';
import '../Mentee/presentation/UpcomingSessionsScreen.dart';
import '../Mentee/presentation/WalletScreen.dart';
import '../Mentee/presentation/authentication/ForgotPassword/ForgotVerifyOtp.dart';
import '../Mentee/presentation/authentication/ForgotPassword/ForgotPassword.dart';
import '../Mentee/presentation/authentication/ForgotPassword/ResetPassword.dart';
import '../Mentee/presentation/authentication/LoginScreen.dart';
import '../Mentee/presentation/authentication/OTPVerificationScreen.dart';
import '../Mentee/presentation/authentication/SelecterScreen.dart';
import '../Mentee/presentation/authentication/SignupScreen.dart';
import '../Mentee/presentation/authentication/SuccessScreen.dart';
import '../Mentee/presentation/authentication/profieSetup/AcadamicJourneyScreen.dart';
import '../Mentee/presentation/becomeMentor/BecomeMentorData.dart';
import '../Mentee/presentation/becomeMentor/LanguageSelectionScreen.dart';
import '../Mentee/presentation/becomeMentor/MentorReview.dart';
import '../Mentee/presentation/becomeMentor/ProfileInReview.dart';
import '../Mentee/presentation/becomeMentor/ProfileRejected.dart';
import '../Mentee/presentation/studyzone/ResourceDetailScreen.dart';
import '../Mentor/presentation/CoinHistoryScreen.dart';
import '../Mentor/presentation/RedeemedCoupons.dart';
import '../Mentor/presentation/CouponCongratsScreen.dart';
import '../Mentor/presentation/CouponList.dart';
import '../Mentor/presentation/CouponsHomeScreen.dart';
import '../Mentor/presentation/ExpertiseScreen.dart';
import '../Mentor/presentation/MenteeListScreen.dart';
import '../Mentor/presentation/MentorDashBoard.dart';
import '../Mentor/presentation/MentorProfile/EditMentorProfileScreen.dart';
import '../Mentor/presentation/MentorProfile/MentorProfileScreen.dart';
import '../Mentor/presentation/Notification.dart';
import '../Mentor/presentation/ProofOfExpertise.dart';
import '../Mentor/presentation/SessionDetailScreen.dart';
import '../Mentee/presentation/BuyCoinsScreens.dart';
import '../Mentee/presentation/ExclusiveServices.dart';
import '../Mentor/presentation/CouponDetailsScreen.dart';
import '../Mentor/presentation/SlotsBookingScreen.dart';
import '../Splash.dart';
import '../Mentee/presentation/becomeMentor/InterestingScreen.dart';
import '../Mentee/presentation/authentication/profieSetup/ProfileSetupWizard.dart';
import '../Mentee/presentation/SessionCompletedScreen.dart';
import '../Mentee/presentation/BookSessionScreen.dart';
import '../Mentee/presentation/DashBoard.dart';
import '../services/AuthService.dart';
import '../utils/CrashlyticsNavObserver.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  // debugLogDiagnostics: false,
  // observers: [CrashlyticsNavObserver()],
  // overridePlatformDefaultLocation: false,
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(SplashScreen(), state);
      },
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final receiverId = state.uri.queryParameters['receiverId']!;
        final sessionId = state.uri.queryParameters['sessionId']!;
        return FutureBuilder<String?>(
          future: AuthService.getUSerId(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            final currentUserId = snapshot.data ?? "";
            return BlocProvider(
              create: (_) =>
                  PrivateChatCubit(currentUserId, receiverId, sessionId),
              child: ChatScreen(
                currentUserId: currentUserId,
                receiverId: receiverId,
                sessionId: sessionId,
              ),
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/group_chat',
      builder: (context, state) {
        return FutureBuilder<List<dynamic>>(
          future: Future.wait([
            AuthService.getCollegeID(),
            AuthService.getUSerId(),
            AuthService.getCollegeName(),
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final collegeID = snapshot.data?[0] as String? ?? "";
            final currentUserId = snapshot.data?[1] as String? ?? "";
            final collegeName = snapshot.data?[2] as String? ?? "";
            final campusType = state.uri.queryParameters['campus_type'] ?? "";

            // 👇 logic: if Beyond Campus, use 0 as college ID
            final effectiveCollegeId = (campusType == 'On Campus Chat')
                ? collegeID
                : "0";

            debugPrint(
              "📍 [ROUTE] Navigating to Group Chat => campusType: $campusType | collegeId: $effectiveCollegeId",
            );

            return BlocProvider(
              create: (_) => GroupRoomCubit(
                currentUserId: currentUserId,
                collegeId: effectiveCollegeId,
              ),
              child: GroupChatScreen(
                currentUserId: currentUserId,
                groupName: collegeName,
                collegeId: effectiveCollegeId,
                campus_type: campusType,
              ),
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/coinhistory',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(CoinHistoryScreen(), state),
    ),
    GoRoute(
      path: '/forgot_password',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(ForgotPassword(), state),
    ),
    GoRoute(
      path: '/forgot_otp',
      pageBuilder: (context, state) {
        final num = state.uri.queryParameters['num'] ?? "";
        return buildSlideTransitionPage(ForgotOtp(num: num), state);
      },
    ),
    GoRoute(
      path: '/reset_password',
      pageBuilder: (context, state) {
        final num = state.uri.queryParameters['num'] ?? "";
        return buildSlideTransitionPage(ResetPassword(num: num), state);
      },
    ),

    GoRoute(
      path: '/community_post/:id',
      redirect: (ctx, st) {
        final id = st.pathParameters['id'];
        if (id == null) return '/'; // fallback
        // Pass id to the next route
        return '/community_details/$id';
      },
    ),

    GoRoute(
      path: '/community_details/:communityId',
      pageBuilder: (context, state) {
        final communityIdStr = state.pathParameters['communityId'];
        final id = communityIdStr != null
            ? int.tryParse(communityIdStr) ?? 0
            : 0;
        final scope = state.uri.queryParameters['scope'] ?? "";
        return buildSlideTransitionPage(
          CommunityDetails(communityId: id, scope: scope),
          state,
        );
      },
    ),

    GoRoute(
      path: '/coupons',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(RedeemedCouponsScreen(), state),
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
      path: '/payment_success',
      pageBuilder: (context, state) {
        final title = state.uri.queryParameters['title'] ?? "";
        final subTitle = state.uri.queryParameters['subTitle'] ?? "";
        final nextRoute = state.uri.queryParameters['nextRoute'] ?? "";
        return buildSlideTransitionPage(
          PaymentSuccessScreen(
            title: title,
            subTitle: subTitle,
            nextRoute: nextRoute,
          ),
          state,
        );
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
      path: '/info',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(InfoScreen(), state);
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
      path: '/study_zone/:id',
      redirect: (ctx, st) {
        final id = st.pathParameters['id'];
        if (id == null) return '/'; // fallback
        // Pass id to the next route
        return '/resource_details_screen/$id';
      },
    ),

    GoRoute(
      path: '/resource_details_screen/:resourceId',
      pageBuilder: (context, state) {
        final id = int.parse(state.pathParameters['resourceId']!);
        final scope = state.uri.queryParameters['scope'] ?? "";
        return buildSlideTransitionPage(
          ResourceDetailScreen(resourceId: id, scope: scope),
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
      path: '/profile/:id',
      redirect: (ctx, st) {
        final id = st.pathParameters['id'];
        if (id == null) return '/'; // fallback
        // Pass id to the next route
        return '/common_profile/$id';
      },
    ),

    GoRoute(
      path: '/common_profile/:id',
      pageBuilder: (context, state) {
        final idString = state.pathParameters['id'];
        final id = int.tryParse(idString ?? '') ?? 0;
        return buildSlideTransitionPage(ProfileDetails(id: id), state);
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
      path: '/in_review',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(InReview(), state),
    ),
    GoRoute(
      path: '/profile_rejected',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(ProfileRejected(), state),
    ),
    GoRoute(
      path: '/edit_profile',
      pageBuilder: (context, state) {
        final collegeId =
            int.tryParse(state.uri.queryParameters['collegeId'] ?? '') ?? 0;
        return buildSlideTransitionPage(
          EditProfileScreen(collegeId: collegeId),
          state,
        );
      },
    ),
    GoRoute(
      path: '/addeventscreen',
      pageBuilder: (context, state) {
        final type = state.uri.queryParameters['type'] ?? "";
        return buildSlideTransitionPage(AddEventScreen(type: type), state);
      },
    ),

    GoRoute(
      path: '/ecc/:id',
      redirect: (ctx, st) {
        final id = st.pathParameters['id'];
        if (id == null) return '/'; // fallback
        // Pass id to the next route
        return '/view_event/$id';
      },
    ),

    GoRoute(
      path: '/view_event/:eventId',
      pageBuilder: (context, state) {
        final id = int.parse(state.pathParameters['eventId']!);
        final scope = state.uri.queryParameters['scope'] ?? "";
        return buildSlideTransitionPage(
          ViewEventScreen(eventId: id, scope: scope),
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
      path: '/notifications',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(Notifications(), state);
      },
    ),

    GoRoute(
      path: '/notifications_mentor',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(NotificationMentor(), state);
      },
    ),

    GoRoute(
      path: '/addpostscreen',
      pageBuilder: (context, state) {
        final type = state.uri.queryParameters['type'] ?? "";
        return buildSlideTransitionPage(AddPostScreen(type: type), state);
      },
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
      path: '/executiveservices',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(ExclusiveServices(), state),
    ),

    GoRoute(
      path: '/service_details',
      pageBuilder: (context, state) {
        final idString = state.uri.queryParameters['id'];
        final title = state.uri.queryParameters['title'] ?? "";
        final id = int.tryParse(idString ?? '') ?? 0;

        return buildSlideTransitionPage(
          ExclusiveServiceDetails(id: id, title: title),
          state,
        );
      },
    ),

    GoRoute(
      path: '/cost_per_minute_screen',
      pageBuilder: (context, state) {
        final coins = state.uri.queryParameters['coins'] ?? "";
        final path = state.uri.queryParameters['path'] ?? "";
        return buildSlideTransitionPage(
          CostPerMinuteScreen(coins: coins, path: path),
          state,
        );
      },
    ),

    GoRoute(
      path: '/subtopicselect_screen',
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return buildSlideTransitionPage(SubTopicSelection(data: data), state);
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
      path: '/dashboard',
      pageBuilder: (context, state) {
        final selectedIndexString = state.uri.queryParameters['selectedIndex'];
        final selectedIndex = int.tryParse(selectedIndexString ?? '') ?? 0;
        return buildSlideTransitionPage(
          Dashboard(selectedIndex: selectedIndex),
          state,
        );
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
      pageBuilder: (context, state) {
        final MentorIdString = state.uri.queryParameters['mentor_id'];
        final mentorId = int.tryParse(MentorIdString ?? '') ?? 0;
        final slotIdString = state.uri.queryParameters['slot_id'];
        final slotId = int.tryParse(slotIdString ?? '') ?? 0;
        return buildSlideTransitionPage(
          BuyCoinsScreens(mentor_id: mentorId, slot_id: slotId),
          state,
        );
      },
    ),
    GoRoute(
      path: '/comming_soon',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(ComingSoon(), state),
    ),

    GoRoute(
      path: '/book_sessions_screen',
      pageBuilder: (context, state) {
        final data = state.extra as MentorData;
        return buildSlideTransitionPage(BookSessionScreen(data: data), state);
      },
    ),
    GoRoute(
      path: '/mentor_dashboard',
      pageBuilder: (context, state) {
        final selectedIndex = int.tryParse(
          state.uri.queryParameters['selectedIndex'] ?? '0',
        );
        final selectedFilter = state.uri.queryParameters['filter'];
        return buildSlideTransitionPage(
          MentorDashboard(selectedIndex: selectedIndex,selectedFilter: selectedFilter, // ✅ Pass it down
          ),
          state,
        );
      },
    ),

    GoRoute(
      path: '/cancel_session',
      pageBuilder: (context, state) {
        final sessionIdParam = state.uri.queryParameters['sessionId'];
        final sessionId = int.tryParse(sessionIdParam ?? "0") ?? 0;
        return buildSlideTransitionPage(
          CancelSessionScreen(sessionId: sessionId),
          state,
        );
      },
    ),
    GoRoute(
      path: '/session_details',
      pageBuilder: (context, state) {
        final sessionIdParam = state.uri.queryParameters['sessionId'];
        final sessionId = int.tryParse(sessionIdParam ?? "0") ?? 0;
        final pastParam = state.uri.queryParameters['past'] ?? "false";
        final past = pastParam.toLowerCase() == "true";

        return buildSlideTransitionPage(
          SessionDetailScreen(sessionId: sessionId, past: past),
          state,
        );
      },
    ),
    GoRoute(
      path: '/mentees_list',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(MenteeListScreen(), state);
      },
    ),
    GoRoute(
      path: '/couponscongrats',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(CouponCongratsScreen(), state),
    ),
    GoRoute(
      path: '/feedback',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(const FeedbackScreen(), state);
      },
    ),
    GoRoute(
      path: '/couponshome',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(CouponsHomeScreen(), state);
      },
    ),

    GoRoute(
      path: '/coupon_details',
      pageBuilder: (context, state) {
        final categoryId = state.uri.queryParameters['couponId'] ?? '';
        return buildSlideTransitionPage(
          CouponDetailsScreen(couponId: categoryId),
          state,
        );
      },
    ),
    GoRoute(
      path: '/coupon_list',
      pageBuilder: (context, state) {
        final categoryId = state.uri.queryParameters['categoryId'] ?? '';
        return buildSlideTransitionPage(
          CouponsList(categoryId: categoryId),
          state,
        );
      },
    ),

    GoRoute(
      path: '/mentor_profile_screen',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(MentorProfileScreen1(), state);
      },
    ),

    GoRoute(
      path: '/slot_bookings_screen',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(Slotsbookingscreen(), state);
      },
    ),
    GoRoute(
      path: '/mentees_home',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(MenteeHomeScreen(), state);
      },
    ),

    GoRoute(
      path: '/mentees_Info',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(Mentorinfoscreen(), state);
      },
    ),
    GoRoute(
      path: '/edit_mentor_profile',
      pageBuilder: (context, state) {
        final collegeId =
            int.tryParse(state.uri.queryParameters['collegeId'] ?? '') ?? 0;
        return buildSlideTransitionPage(
          EditMentorProfileScreen(collegeId: collegeId),
          state,
        );
      },
    ),

    GoRoute(
      path: '/update_expertise',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(ExpertiseScreen(), state);
      },
    ),

    GoRoute(
      path: '/add_expertise',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(AddExpertiseScreen(), state);
      },
    ),

    GoRoute(
      path: '/proof_expertise',
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return buildSlideTransitionPage(ProofOfExpertise(data: data), state);
      },
    ),

    GoRoute(
      path: '/expertise_details',
      pageBuilder: (context, state) {
        final id = int.tryParse(state.uri.queryParameters['id'] ?? '') ?? 0;
        final categoryTitle = state.uri.queryParameters['categoryTitle'] ?? '';
        return buildSlideTransitionPage(
          SubExpertisesScreen(categoryTitle: categoryTitle, id: id),
          state,
        );
      },
    ),

    GoRoute(
      path: '/pending_sub_expertise',
      pageBuilder: (context, state) {
        final id = int.tryParse(state.uri.queryParameters['id'] ?? '') ?? 0;
        final categoryTitle = state.uri.queryParameters['categoryTitle'] ?? '';
        final status = state.uri.queryParameters['status'] ?? '';
        return buildSlideTransitionPage(
          PendingSubExpertisesScreen(
            id: id,
            categoryTitle: categoryTitle,
            status: status,
          ),
          state,
        );
      },
    ),

    GoRoute(
      path: '/pdf_viewer',
      pageBuilder: (context, state) {
        final file_url = state.uri.queryParameters['file_url'];
        return buildSlideTransitionPage(
          PdfViewerPage(file_url: file_url),
          state,
        );
      },
    ),
  ],
  errorBuilder: (context, state) {
    final err = state.error ?? 'Unknown router error';
    FirebaseCrashlytics.instance.recordError(
      err,
      StackTrace.current,
      fatal: false,
      information: [
        DiagnosticsNode.message('matchedLocation: ${state.matchedLocation}'),
        DiagnosticsNode.message('uri: ${state.uri}'),
        DiagnosticsNode.message('pathParams: ${state.pathParameters}'),
        DiagnosticsNode.message('queryParams: ${state.uri.queryParameters}'),
      ],
    );

    return const Scaffold(body: Center(child: Text('Something went wrong')));
  },
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

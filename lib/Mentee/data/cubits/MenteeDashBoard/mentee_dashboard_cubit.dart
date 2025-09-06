import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../services/AuthService.dart';
import '../../../Models/CompusMentorListModel.dart';
import '../../../Models/GetBannersRespModel.dart';
import '../../../Models/GuestMentorsModel.dart';
import '../../../Models/MenteeProfileModel.dart';
import '../CampusMentorList/campus_mentor_list_cubit.dart';
import '../CampusMentorList/campus_mentor_list_state.dart';
import '../GetBanners/GetBannersCubit.dart';
import '../GetBanners/GetBannersState.dart';
import '../GuestMentors/guest_mentors_cubit.dart';
import '../GuestMentors/guest_mentors_states.dart';
import '../MenteeProfile/GetMenteeProfile/MenteeProfileCubit.dart';
import '../MenteeProfile/GetMenteeProfile/MenteeProfileState.dart';
import 'mentee_dashboard_state.dart';

class MenteeDashboardCubit extends Cubit<MenteeDashboardState> {
  final Getbannerscubit bannersCubit;
  final MenteeProfileCubit profileCubit;
  final GuestMentorsCubit guestMentorsCubit;
  final CampusMentorListCubit campusMentorCubit;

  MenteeDashboardCubit({
    required this.bannersCubit,
    required this.profileCubit,
    required this.guestMentorsCubit,
    required this.campusMentorCubit,
  }) : super(MenteeDashboardInitial());

  Future<void> fetchDashboard(String scope) async {
    // final scopeIsEmpty = scope.trim().isEmpty;
    //
    // if (scopeIsEmpty) {
      // Full dashboard load
      emit(MenteeDashboardLoading());

      GetBannersRespModel? bannersModel;
      MenteeProfileModel? profileModel;
      GuestMentorsModel? guestMentorsModel;
      CompusMentorListModel? campusMentorsModel;

      try {
        // Run independent calls in parallel for speed
        await Future.wait([
          bannersCubit.getbanners(),
          profileCubit.fetchMenteeProfile(),
        ]);

        // Read results
        final bannersState = bannersCubit.state;
        if (bannersState is GetbannersStateLoaded) {
          bannersModel = bannersState.getbannerModel;
        }

        final profileState = profileCubit.state;
        if (profileState is MenteeProfileLoaded) {
          profileModel = profileState.menteeProfileModel;
        }

        // Decide which mentors list to load
        final isGuest = await AuthService.isGuest;
        if (isGuest) {
          await guestMentorsCubit.fetchGuestMentorList();
          final guestState = guestMentorsCubit.state;
          if (guestState is GuestMentorsLoaded) {
            guestMentorsModel = guestState.guestMentorsModel;
          }
        } else {
          await campusMentorCubit.fetchCampusMentorList(scope, "");
          final campusState = campusMentorCubit.state;
          if (campusState is CampusMentorListStateLoaded) {
            campusMentorsModel = campusState.campusMentorListModel;
          }
        }

        emit(
          MenteeDashboardLoaded(
            getbannerModel: bannersModel ?? GetBannersRespModel(),
            menteeProfileModel: profileModel ?? MenteeProfileModel(),
            guestMentorsModel: guestMentorsModel ?? GuestMentorsModel(),
            campusMentorListModel: campusMentorsModel ?? CompusMentorListModel(),
          ),
        );
      } catch (e) {
        emit(MenteeDashboardFailure("Dashboard error: ${e.toString()}"));
      }
    // } else {
    //   // Only update campus mentors for the given scope
    //   try {
    //     await campusMentorCubit.fetchCampusMentorList(scope, "");
    //     final campusState = campusMentorCubit.state;
    //
    //     CompusMentorListModel? campusMentorsModel;
    //     if (campusState is CampusMentorListStateLoaded) {
    //       campusMentorsModel = campusState.campusMentorListModel;
    //     }
    //
    //     // Preserve previously loaded data if present
    //     final current = state;
    //     if (current is MenteeDashboardLoaded) {
    //       emit(
    //         current.copyWith(
    //           campusMentorListModel:
    //           campusMentorsModel ?? current.campusMentorListModel,
    //         ),
    //       );
    //     } else {
    //       // Fallback if nothing loaded yet
    //       emit(
    //         MenteeDashboardLoaded(
    //           getbannerModel: GetBannersRespModel(),
    //           menteeProfileModel: MenteeProfileModel(),
    //           guestMentorsModel: GuestMentorsModel(),
    //           campusMentorListModel:
    //           campusMentorsModel ?? CompusMentorListModel(),
    //         ),
    //       );
    //     }
    //   } catch (e) {
    //     emit(MenteeDashboardFailure("Campus mentors error: ${e.toString()}"));
    //   }
    // }
  }

}

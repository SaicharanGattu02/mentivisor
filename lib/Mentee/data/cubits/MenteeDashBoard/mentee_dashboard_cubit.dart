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
  final GuestMentorsCubit guestMentorsCubit;
  final CampusMentorListCubit campusMentorCubit;

  MenteeDashboardCubit({
    required this.bannersCubit,
    required this.guestMentorsCubit,
    required this.campusMentorCubit,
  }) : super(MenteeDashboardInitial());

  Future<void> fetchDashboard(String scope) async {
    emit(MenteeDashboardLoading());
    GetBannersRespModel? bannersModel;
    GuestMentorsModel? guestMentorsModel;
    CompusMentorListModel? campusMentorsModel;

    try {
      await Future.wait([bannersCubit.getbanners()]);

      final bannersState = bannersCubit.state;
      if (bannersState is GetbannersStateLoaded) {
        bannersModel = bannersState.getbannerModel;
      }

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
          guestMentorsModel: guestMentorsModel ?? GuestMentorsModel(),
          campusMentorListModel: campusMentorsModel ?? CompusMentorListModel(),
        ),
      );
    } catch (e) {
      emit(MenteeDashboardFailure("Dashboard error: ${e.toString()}"));
    }
  }
}

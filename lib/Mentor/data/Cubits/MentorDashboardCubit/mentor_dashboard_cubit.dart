import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/GetBanners/GetBannersState.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorDashboardCubit/mentor_dashbaord_states.dart';
import 'package:mentivisor/Mentor/data/Cubits/Sessions/SessionsCubit.dart';
import '../../../../Mentor/Models/MentorProfileModel.dart';
import '../../../../Mentee/Models/GetBannersRespModel.dart';
import '../../../../Mentee/data/cubits/GetBanners/GetBannersCubit.dart';
import '../../../../Mentee/data/cubits/MentorProfile/MentorProfileState.dart';
import '../../../Models/SessionsModel.dart';
import '../MentorProfile/mentor_profile_cubit.dart';
import '../MentorProfile/mentor_profile_states.dart';
import '../Sessions/SessionsStates.dart';


class MentorDashboardCubit extends Cubit<MentorDashBoardState> {
  final Getbannerscubit getbannerscubit;
  final SessionCubit sessionCubit;
  final MentorProfileCubit1 mentorProfileCubit1;

  MentorDashboardCubit({
    required this.getbannerscubit,
    required this.sessionCubit,
    required this.mentorProfileCubit1,
  }) : super(MentorDashBoardInitially());

  Future<void> fetchDashboard() async {
    emit(MentorDashBoardLoading());
    GetBannersRespModel? getBannersRespModel;
    SessionsModel? sessionsModel;
    MentorprofileModel? mentorprofileModel;

    try {
      await getbannerscubit.getbanners();
      final bannerState = getbannerscubit.state;
      if (bannerState is GetbannersStateLoaded) {
        getBannersRespModel = bannerState.getbannerModel;
      }


      await sessionCubit.getSessions("");
      final sessionState = sessionCubit.state;
      if (sessionState is SessionLoaded) {
        sessionsModel = sessionState.sessionsModel;
      }


      await mentorProfileCubit1.getMentorProfile();
      final profileState = mentorProfileCubit1.state;
      if (profileState is MentorProfile1Loaded) {
        mentorprofileModel = profileState.mentorProfileModel;
      }

      if (getBannersRespModel != null || sessionsModel != null || mentorprofileModel != null) {
        emit(
          MentorDashBoardLoaded(
            getBannersRespModel: getBannersRespModel,
            sessionsModel: sessionsModel,
            mentorProfileModel: mentorprofileModel,
          ),
        );
      } else {
        emit(MentorDashBoardFailure('All API calls failed.'));
      }
    } catch (e) {
      emit(MentorDashBoardFailure('Dashboard error: ${e.toString()}'));
    }
  }
}

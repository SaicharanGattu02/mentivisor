import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/GetBanners/GetBannersState.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorDashboardCubit/mentor_dashbaord_states.dart';
import 'package:mentivisor/Mentor/data/Cubits/Sessions/SessionsCubit.dart';

import '../../../../Mentee/Models/GetBannersRespModel.dart';
import '../../../../Mentee/data/cubits/GetBanners/GetBannersCubit.dart';
import '../../../Models/SessionsModel.dart';

class MentorDashboardCubit extends Cubit<MentorDashBoardState> {
  final Getbannerscubit getbannerscubit;
  final SessionCubit sessionCubit;

  MentorDashboardCubit({
    required this.getbannerscubit,
    required this.sessionCubit,
  }) : super(MentorDashBoardInitially());

  Future<void> fetchDashboard() async {
    emit(MentorDashBoardLoading());
    GetBannersRespModel? getBannersRespModel;
    SessionsModel? sessionsModel;

    try {
      try {
        await getbannerscubit.getbanners();
        final state = getbannerscubit.state;
        if (state is GetbannersStateLoaded) {
          getBannersRespModel = state.getbannerModel;
        } else if (state is GetbannersStateFailure) {}
      } catch (e) {

      }

      try {
        await sessionCubit.getSessions("upcoming");
        final state = getbannerscubit.state;
        if (state is GetbannersStateLoaded) {
          getBannersRespModel = state.getbannerModel;
        } else if (state is GetbannersStateFailure) {}
      } catch (e) {

      }


      if (getBannersRespModel != null || sessionsModel != null) {
        emit(
          MentorDashBoardLoaded(
            getBannersRespModel: getBannersRespModel,
            sessionsModel: sessionsModel,
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

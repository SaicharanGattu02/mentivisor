import '../../../Models/CompusMentorListModel.dart';
import '../../../Models/GetBannersRespModel.dart';
import '../../../Models/GuestMentorsModel.dart';
import '../../../Models/MenteeProfileModel.dart';

abstract class MenteeDashboardState {}

class MenteeDashboardInitial extends MenteeDashboardState {}

class MenteeDashboardLoading extends MenteeDashboardState {}

class MenteeDashboardLoaded extends MenteeDashboardState {
  final GetBannersRespModel getbannerModel;
  final GuestMentorsModel guestMentorsModel;
  final CompusMentorListModel campusMentorListModel;

  MenteeDashboardLoaded({
    required this.getbannerModel,
    required this.guestMentorsModel,
    required this.campusMentorListModel,
  });

  MenteeDashboardLoaded copyWith({
    GetBannersRespModel? getbannerModel,
    GuestMentorsModel? guestMentorsModel,
    CompusMentorListModel? campusMentorListModel,
  }) {
    return MenteeDashboardLoaded(
      getbannerModel: getbannerModel ?? this.getbannerModel,
      guestMentorsModel: guestMentorsModel ?? this.guestMentorsModel,
      campusMentorListModel:
      campusMentorListModel ?? this.campusMentorListModel,
    );
  }
}

class MenteeDashboardFailure extends MenteeDashboardState {
  final String message;
  MenteeDashboardFailure(this.message);
}


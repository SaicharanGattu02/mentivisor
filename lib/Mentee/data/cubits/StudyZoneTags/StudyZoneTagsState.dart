import '../../../Models/StudyZoneTagsModel.dart';



abstract class StudyZoneTagsState {}

class StudyZoneTagsInitial extends StudyZoneTagsState {}

class StudyZoneTagsLoading extends StudyZoneTagsState {}

class StudyZoneTagsLoaded extends StudyZoneTagsState {
  final StudyZoneTagsModel studyZoneTagsModel;
  StudyZoneTagsLoaded({required this.studyZoneTagsModel});
}

class StudyZoneTagsFailure extends StudyZoneTagsState {
  final String msg;
  StudyZoneTagsFailure({required this.msg});
}

import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class StudyZoneReportState {}

class StudyZoneReportInitial extends StudyZoneReportState {}

class StudyZoneReportLoading extends StudyZoneReportState {}

class StudyZoneReportSuccess extends StudyZoneReportState {
  final StudyZoneReportModel studyZoneReportModel;
  StudyZoneReportSuccess(this.studyZoneReportModel);
}

class StudyZoneReportFailure extends StudyZoneReportState {
  final String message;
  StudyZoneReportFailure({required this.message});
}

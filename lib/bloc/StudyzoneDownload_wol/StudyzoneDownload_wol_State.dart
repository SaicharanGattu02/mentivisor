import 'package:mentivisor/Models/StudyZoneDownloadModel_wo_log.dart';

abstract class StudyzonedownloadWolState {}

class StudyzonedownloadwolIntially extends StudyzonedownloadWolState {}

class StudyzondownloadwolStateLoading extends StudyzonedownloadWolState {}

class StudyzonedownloadwolStateLoaded extends StudyzonedownloadWolState {
  StudyZoneDownloadModel_wo_log studyZoneDownloadModel_wo_log;
  StudyzonedownloadwolStateLoaded({required this.studyZoneDownloadModel_wo_log});
}

class StudyzonedownloadwolStateFailure extends StudyzonedownloadWolState {
  final String msg;
  StudyzonedownloadwolStateFailure({required this.msg});


}
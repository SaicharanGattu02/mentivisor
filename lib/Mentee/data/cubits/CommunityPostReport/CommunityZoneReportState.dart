import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class CommunityZoneReportState {}

class CommunityZoneReportInitial extends CommunityZoneReportState {}

class CommunityZoneReportLoading extends CommunityZoneReportState {}

class CommunityZoneReportSuccess extends CommunityZoneReportState {
  final SuccessModel successModel;
  CommunityZoneReportSuccess(this.successModel);
}

class CommunityZoneReportFailure extends CommunityZoneReportState {
  final String message;
  CommunityZoneReportFailure({required this.message});
}

import '../../../../Models/SuccessModel.dart';

abstract class GroupChatReportState {}

class GroupChatReportIntailly extends GroupChatReportState {}

class GroupChatReportLoading extends GroupChatReportState {}

class GroupChatReportSuccess extends GroupChatReportState {
  final SuccessModel successModel;
  GroupChatReportSuccess(this.successModel);
}

class GroupChatReportFailure extends GroupChatReportState {
  final String message;
  GroupChatReportFailure({required this.message});
}

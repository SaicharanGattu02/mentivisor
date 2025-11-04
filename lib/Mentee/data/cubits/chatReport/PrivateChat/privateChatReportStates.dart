import '../../../../Models/SuccessModel.dart';

abstract class PrivateChatReportState {}

class PrivateChatReportIntailly extends PrivateChatReportState {}

class PrivateChatReportLoading extends PrivateChatReportState {}

class PrivateChatReportSuccess extends PrivateChatReportState {
  final SuccessModel successModel;
  PrivateChatReportSuccess(this.successModel);
}

class PrivateChatReportFailure extends PrivateChatReportState {
  final String message;
  PrivateChatReportFailure({required this.message});
}

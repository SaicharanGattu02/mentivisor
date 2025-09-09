// STATES
import '../../../Models/UploadFileInChatModel.dart';

abstract class UploadFileInChatStates {}

class UploadFileInChatInitial extends UploadFileInChatStates {}

class UploadFileInChatLoading extends UploadFileInChatStates {}

class UploadFileInChatSuccess extends UploadFileInChatStates {
  final UploadFileInChatModel result;

  UploadFileInChatSuccess(this.result);
}

class UploadFileInChatFailure extends UploadFileInChatStates {
  final String error;

  UploadFileInChatFailure(this.error);
}
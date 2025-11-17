
import '../../../Models/SuccessModel.dart';

abstract class DownloadActionStates {}

class DownloadActionInitial extends DownloadActionStates {}

class DownloadActionLoading extends DownloadActionStates {}

class DownloadActionSuccess extends DownloadActionStates {
  final SuccessModel successModel;
  DownloadActionSuccess(this.successModel);
}

class DownloadActionFailure extends DownloadActionStates {
  final String error;
  DownloadActionFailure(this.error);
}

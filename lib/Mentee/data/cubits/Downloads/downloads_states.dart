import 'package:mentivisor/Mentee/Models/DownloadsModel.dart';

abstract class DownloadStates {}

class DownloadInitially extends DownloadStates {}

class DownloadLoading extends DownloadStates {}

class DownloadLoadingMore extends DownloadStates {
  final DownloadsModel downloadsModel;
  final bool hasNextPage;

  DownloadLoadingMore(this.downloadsModel, this.hasNextPage);
}

class DownloadLoaded extends DownloadStates {
  final DownloadsModel downloadsModel;
  final bool hasNextPage;

  DownloadLoaded(this.downloadsModel, this.hasNextPage);
}

class DownloadFailure extends DownloadStates {
  final String error;

  DownloadFailure(this.error);
}

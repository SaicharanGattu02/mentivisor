import 'package:flutter_bloc/flutter_bloc.dart';

import '../Downloads/downloads_repository.dart';
import 'DownloadActionStates.dart';

class DownloadActionCubit extends Cubit<DownloadActionStates> {
  final DownloadsRepository downloadsRepository;

  DownloadActionCubit(this.downloadsRepository)
    : super(DownloadActionInitial());

  Future<void> downloadAction(String id) async {
    emit(DownloadActionLoading());
    try {
      final response = await downloadsRepository.deleteDownload(id);

      if (response != null && response.status == true) {
        emit(DownloadActionSuccess(response));
      } else {
        emit(
          DownloadActionFailure(response?.message ?? "Something went wrong"),
        );
      }
    } catch (e) {
      emit(DownloadActionFailure(e.toString()));
    }
  }
}

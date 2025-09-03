import 'package:flutter_bloc/flutter_bloc.dart';
import 'downloads_repository.dart';
import 'downloads_states.dart';
import '../../../Models/DownloadsModel.dart';

class DownloadsCubit extends Cubit<DownloadStates> {
  final DownloadsRepository downloadsRepository;

  DownloadsCubit(this.downloadsRepository) : super(DownloadInitially());

  DownloadsModel downloadsModel = DownloadsModel(data: Data(downloads: []));

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  Future<void> getDownloads() async {
    emit(DownloadLoading());
    _currentPage = 1;
    _hasNextPage = true;

    try {
      final response = await downloadsRepository.getDownloads(_currentPage);
      if (response != null && response.status == true) {
        downloadsModel = response;
        _hasNextPage =
            (response.data?.downloads?.isNotEmpty ?? false) &&
            (response.data?.currentPage ?? 1) < (response.data?.lastPage ?? 1);
        emit(DownloadLoaded(downloadsModel, _hasNextPage));
      } else {
        emit(DownloadFailure("Something went wrong"));
      }
    } catch (e) {
      emit(DownloadFailure(e.toString()));
    }
  }

  // Pagination
  Future<void> fetchMoreDownloads() async {
    if (_isLoadingMore || !_hasNextPage) return;

    _isLoadingMore = true;
    _currentPage++;
    emit(DownloadLoadingMore(downloadsModel, _hasNextPage));

    try {
      final newData = await downloadsRepository.getDownloads(_currentPage);
      final newDownloads = newData?.data?.downloads ?? [];

      if (newDownloads.isNotEmpty) {
        downloadsModel.data?.downloads?.addAll(newDownloads);
        _hasNextPage =
            (_currentPage < (newData?.data?.lastPage ?? _currentPage));

        emit(DownloadLoaded(downloadsModel, _hasNextPage));
      } else {
        _hasNextPage = false;
        emit(DownloadLoaded(downloadsModel, _hasNextPage));
      }
    } catch (e) {
      emit(DownloadFailure(e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }
}

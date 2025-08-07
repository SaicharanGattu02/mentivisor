import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/Downloads/downloads_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/Downloads/downloads_states.dart';

import '../../../Models/DownloadsModel.dart';

class DownloadsCubit extends Cubit<DownloadStates> {
  final DownloadsRepository downloadsRepository;

  DownloadsCubit(this.downloadsRepository) : super(DownloadInitially());

  DownloadsModel downloadsModel = DownloadsModel();

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  // Method to get the first page of downloads
  Future<void> getDownloads() async {
    emit(DownloadLoading()); // Emit loading state
    _currentPage = 1; // Reset to the first page on initial load
    try {
      final response = await downloadsRepository.getDownloads(_currentPage);
      if (response != null && response.status == true) {
        downloadsModel = response;
        _hasNextPage =
            response.downloads?.isNotEmpty ??
            false; // Check if next page exists
        emit(DownloadLoaded(response, _hasNextPage)); // Emit data to UI
      } else {
        emit(DownloadFailure("Something went wrong"));
      }
    } catch (e) {
      emit(DownloadFailure(e.toString())); // Emit failure state if error occurs
    }
  }

  // Method to fetch more downloads (pagination)
  Future<void> fetchMoreDownloads() async {
    if (_isLoadingMore || !_hasNextPage)
      return; // Prevent multiple simultaneous fetches
    _isLoadingMore = true;
    _currentPage++; // Increase current page number
    emit(
      DownloadLoadingMore(downloadsModel, _hasNextPage),
    ); // Emit loading more state

    try {
      final newData = await downloadsRepository.getDownloads(
        _currentPage,
      ); // Fetch data for the current page
      if (newData != null && newData.downloads?.isNotEmpty == true) {
        // Combine the old and new downloads
        final combinedDownloads = List<Downloads>.from(
          downloadsModel.downloads ?? [],
        )..addAll(newData.downloads!);

        // Update the model with combined downloads
        downloadsModel = DownloadsModel(
          status: newData.status,
          downloads: combinedDownloads,
        );

        _hasNextPage =
            newData.downloads?.isNotEmpty ??
            false; // Check if there is a next page
        emit(
          DownloadLoaded(downloadsModel, _hasNextPage),
        ); // Emit updated data to the UI
      }
    } catch (e) {
      emit(DownloadFailure(e.toString())); // Emit failure state if error occurs
    } finally {
      _isLoadingMore = false; // Reset loading state
    }
  }
}

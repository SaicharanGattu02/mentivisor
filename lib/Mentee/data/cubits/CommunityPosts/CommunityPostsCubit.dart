import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityPosts/CommunityPostsRepository.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityPosts/CommunityPostsStates.dart';

import '../../../Models/CommunityPostsModel.dart';

class CommunityPostsCubit extends Cubit<CommunityPostsStates> {
  final CommunityPostsRepo communityPostsRepo;

  CommunityPostsCubit(this.communityPostsRepo)
    : super(CommunityPostsInitially());

  CommunityPostsModel communityPostsModel = CommunityPostsModel();

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  // Method to get community posts (initial fetch)
  Future<void> getCommunityPosts() async {
    emit(CommunityPostsLoading());
    _currentPage = 1; // Reset to first page on initial load
    try {
      final response = await communityPostsRepo.getCommunityPosts(_currentPage);
      if (response != null && response.status == true) {
        communityPostsModel = response;
        _hasNextPage =
            response.data?.nextPageUrl != null; // Check if next page exists
        emit(CommunityPostsLoaded(response, _hasNextPage)); // Emit data to UI
      } else {
        emit(CommunityPostsFailure("Something went wrong"));
      }
    } catch (e) {
      emit(CommunityPostsFailure(e.toString()));
    }
  }

  // Method to fetch more community posts (pagination)
  Future<void> fetchMoreCommunityPosts() async {
    if (_isLoadingMore || !_hasNextPage)
      return; // Prevent multiple simultaneous fetches
    _isLoadingMore = true;
    _currentPage++; // Increase current page number
    emit(
      CommunityPostsLoadingMore(communityPostsModel, _hasNextPage),
    ); // Emit loading more state

    try {
      final newData = await communityPostsRepo.getCommunityPosts(
        _currentPage,
      ); // Fetch data for the current page
      if (newData != null && newData.data?.communityposts?.isNotEmpty == true) {
        // Combine the old and new posts
        final combinedPosts = List<CommunityPosts>.from(
          communityPostsModel.data?.communityposts ?? [],
        )..addAll(newData.data!.communityposts!);

        // Update the model with combined posts
        final updatedData = Data(
          currentPage: newData.data?.currentPage,
          communityposts: combinedPosts,
          firstPageUrl: newData.data?.firstPageUrl,
          from: newData.data?.from,
          lastPage: newData.data?.lastPage,
          lastPageUrl: newData.data?.lastPageUrl,
          links: newData.data?.links,
          nextPageUrl: newData.data?.nextPageUrl,
          path: newData.data?.path,
          perPage: newData.data?.perPage,
          prevPageUrl: newData.data?.prevPageUrl,
          to: newData.data?.to,
          total: newData.data?.total,
        );

        communityPostsModel = CommunityPostsModel(
          status: newData.status,
          data: updatedData,
        );

        _hasNextPage =
            newData.data?.nextPageUrl != null; // Check if there is a next page
        emit(
          CommunityPostsLoaded(communityPostsModel, _hasNextPage),
        ); // Emit updated data to the UI
      }
    } catch (e) {
      emit(CommunityPostsFailure(e.toString())); // Emit failure if error occurs
    } finally {
      _isLoadingMore = false; // Reset loading state
    }
  }
}

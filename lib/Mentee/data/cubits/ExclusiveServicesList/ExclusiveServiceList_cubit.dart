import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/ExclusiveServicesList/ExclusiveServicesList_repo.dart';
import 'package:mentivisor/Mentee/data/cubits/ExclusiveServicesList/ExclusiveServicesList_state.dart';
import 'package:mentivisor/Mentee/Models/ExclusiveServicesModel.dart';

class ExclusiveservicelistCubit extends Cubit<ExclusiveserviceslistState> {
  final ExclusiveserviceslistRepo exclusiveserviceslistRepo;

  ExclusiveservicelistCubit(this.exclusiveserviceslistRepo)
    : super(ExclusiveserviceStateIntially());

  ExclusiveServicesModel exclusiveServicesModel = ExclusiveServicesModel();
  String _searchQuery = '';
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;
  bool get isSearching => state is ExclusiveserviceStateLoading;
  Future<void> getExclusiveServiceList(String search) async {
    emit(ExclusiveserviceStateLoading());

    _searchQuery = search; // ✅ FIX #1 (CRITICAL)
    _currentPage = 1;
    _hasNextPage = true;

    debugPrint("GET LIST → SEARCH: '$_searchQuery' | PAGE: $_currentPage");

    try {
      final response = await exclusiveserviceslistRepo.getexclusivelist(
        _searchQuery,
        _currentPage,
      );

      if (response != null && response.status == true) {
        exclusiveServicesModel = response;
        _hasNextPage = response.data?.nextPageUrl != null;

        emit(
          ExclusiveserviceStateLoaded(
            exclusiveServicesModel: exclusiveServicesModel,
            hasNextPage: _hasNextPage,
          ),
        );
      } else {
        emit(ExclusiveserviceStateFailure(msg: "No data found"));
      }
    } catch (e) {
      emit(ExclusiveserviceStateFailure(msg: "An error occurred: $e"));
    }
  }

  Future<void> fetchMoreExclusiveServiceList(String search) async {
    if (_isLoadingMore || !_hasNextPage) return;

    _isLoadingMore = true;
    _currentPage++;

    emit(
      ExclusiveserviceStateLoadingMore(
        exclusiveServicesModel: exclusiveServicesModel,
        hasNextPage: _hasNextPage,
      ),
    );

    debugPrint("LOAD MORE → SEARCH: '$_searchQuery' | PAGE: $_currentPage");

    try {
      final newData = await exclusiveserviceslistRepo.getexclusivelist(
        _searchQuery, // ✅ FIX #2 (NEVER use UI value)
        _currentPage,
      );

      if (newData != null && newData.data?.data?.isNotEmpty == true) {
        final combinedList = List<ExclusiveServiceData>.from(
          exclusiveServicesModel.data?.data ?? [],
        )..addAll(newData.data!.data!);

        exclusiveServicesModel = ExclusiveServicesModel(
          status: newData.status,
          data: ServiceList(
            currentPage: newData.data?.currentPage,
            data: combinedList,
            nextPageUrl: newData.data?.nextPageUrl,
            total: newData.data?.total,
          ),
        );

        _hasNextPage = newData.data?.nextPageUrl != null;

        emit(
          ExclusiveserviceStateLoaded(
            exclusiveServicesModel: exclusiveServicesModel,
            hasNextPage: _hasNextPage,
          ),
        );
      }
    } catch (e) {
      emit(ExclusiveserviceStateFailure(msg: "An error occurred: $e"));
    } finally {
      _isLoadingMore = false;
    }
  }
}

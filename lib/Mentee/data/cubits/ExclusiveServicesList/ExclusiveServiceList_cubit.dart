import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/ExclusiveServicesList/ExclusiveServicesList_repo.dart';
import 'package:mentivisor/Mentee/data/cubits/ExclusiveServicesList/ExclusiveServicesList_state.dart';
import 'package:mentivisor/Mentee/Models/ExclusiveServicesModel.dart';

class ExclusiveservicelistCubit extends Cubit<ExclusiveserviceslistState> {
  final ExclusiveserviceslistRepo exclusiveserviceslistRepo;

  ExclusiveservicelistCubit(this.exclusiveserviceslistRepo)
      : super(ExclusiveserviceStateIntially());

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;
  ExclusiveServicesModel exclusiveServicesModel = ExclusiveServicesModel();

  // Fetch the list of exclusive services
  Future<void> getExclusiveServiceList(String search) async {
    emit(ExclusiveserviceStateLoading());

    try {
      final response = await exclusiveserviceslistRepo.getexclusivelist(
        search,
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
        emit(ExclusiveserviceStateFailure(msg: "No data found."));
      }
    } catch (e) {
      emit(ExclusiveserviceStateFailure(msg: "An error occurred: $e"));
    }
  }

  // Fetch more data for pagination
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

    try {
      final newData = await exclusiveserviceslistRepo.getexclusivelist(
        search,
        _currentPage,
      );

      if (newData != null && newData.data?.data?.isNotEmpty == true) {
        final combinedServices = List<ExclusiveServiceData>.from(
          exclusiveServicesModel.data?.data ?? [],
        )..addAll(newData.data!.data!);

        final updatedData = ServiceList(
          currentPage: newData.data?.currentPage,
          data: combinedServices,
          nextPageUrl: newData.data?.nextPageUrl,
          total: newData.data?.total,
        );

        exclusiveServicesModel = ExclusiveServicesModel(
          status: newData.status,
          data: updatedData,
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

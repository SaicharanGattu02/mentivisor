import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/ECC/ecc_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/ECC/ecc_states.dart';

import '../../../Models/ECCModel.dart';

class ECCCubit extends Cubit<ECCStates> {
  final ECCRepository eccRepository;
  ECCCubit(this.eccRepository) : super(ECCIntially());

  ECCModel eccModel = ECCModel();

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  Future<void> getECC(String scope,String updates,String search,) async {
    emit(ECCLoading());
    _currentPage = 1;
    try {
      final response = await eccRepository.getEcc( scope, updates,search,_currentPage);
      if (response != null && response.status == true) {
        eccModel = response;
        _hasNextPage = response.data?.nextPageUrl != null;
        // emit(ECCLoaded(eccModel, _hasNextPage));
      } else {
        emit(ECCFailure("Something went wrong"));
      }
    } catch (e) {
      emit(ECCFailure(e.toString()));
    }
  }

  Future<void> fetchMoreECC(String scope,String updates,String search,) async {
    if (_isLoadingMore || !_hasNextPage) return;
    _isLoadingMore = true;
    _currentPage++;
    emit(ECCLoadingMore(eccModel, _hasNextPage));
    try {
      final newData = await eccRepository.getEcc( scope, updates,search,_currentPage);
      if (newData != null && newData.data?.ecclist?.isNotEmpty == true) {
        final combinedList = List<ECCList>.from(eccModel.data?.ecclist ?? [])
          ..addAll(newData.data!.ecclist!);

        final updatedData = Data(
          currentPage: newData.data?.currentPage,
          ecclist: combinedList,
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

        eccModel = ECCModel(status: newData.status, data: updatedData);

        _hasNextPage = newData.data?.nextPageUrl != null;
        emit(ECCLoaded(eccModel, _hasNextPage));
      }
    } catch (e) {
      emit(ECCFailure(e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }
}

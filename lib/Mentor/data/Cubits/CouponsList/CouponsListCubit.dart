import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/Coupons/CouponCategoryRepository.dart';
import 'CouponsListStates.dart';
import '../../../Models/CouponListModel.dart';

class CouponsListCubit extends Cubit<CouponsListStates> {
  final CouponsRepo couponsRepo;

  CouponsListCubit(this.couponsRepo) : super(CouponsListInitially());

  CouponListModel couponListModel = CouponListModel();

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  bool get hasNextPage => _hasNextPage;
  bool get isLoadingMore => _isLoadingMore;


  Future<void> fetchCouponsList(String categoryId) async {
    emit(CouponsListLoading());
    _currentPage = 1;

    try {
      final response = await couponsRepo.couponList(categoryId, _currentPage);

      if (response != null && response.status == true) {
        couponListModel = response;
        _hasNextPage = response.couponsList?.nextPageUrl != null;
        emit(CouponsListLoaded(couponListModel, _hasNextPage));
      } else {
        emit(CouponsListFailure("Failed to load coupons."));
      }
    } catch (e) {
      emit(CouponsListFailure("An error occurred: $e"));
    }
  }

  /// 🔹 Fetch more coupons (pagination)
  Future<void> fetchMoreCouponsList(String categoryId) async {
    if (_isLoadingMore || !_hasNextPage) return;

    _isLoadingMore = true;
    _currentPage++;

    emit(CouponsListLoadingMore(couponListModel, _hasNextPage));

    try {
      final newResponse = await couponsRepo.couponList(categoryId, _currentPage);

      if (newResponse != null &&
          newResponse.couponsList?.data?.isNotEmpty == true) {
        // Merge old and new data
        final combinedList = List<Data>.from(
          couponListModel.couponsList?.data ?? [],
        )..addAll(newResponse.couponsList!.data!);

        // Build updated CouponsList object
        final updatedCouponsList = CouponsList(
          currentPage: newResponse.couponsList?.currentPage,
          data: combinedList,
          firstPageUrl: newResponse.couponsList?.firstPageUrl,
          from: newResponse.couponsList?.from,
          lastPage: newResponse.couponsList?.lastPage,
          lastPageUrl: newResponse.couponsList?.lastPageUrl,
          links: newResponse.couponsList?.links,
          nextPageUrl: newResponse.couponsList?.nextPageUrl,
          path: newResponse.couponsList?.path,
          perPage: newResponse.couponsList?.perPage,
          prevPageUrl: newResponse.couponsList?.prevPageUrl,
          to: newResponse.couponsList?.to,
          total: newResponse.couponsList?.total,
        );

        // Update the main model
        couponListModel = CouponListModel(
          status: newResponse.status,
          message: newResponse.message,
          couponsList: updatedCouponsList,
        );

        _hasNextPage = newResponse.couponsList?.nextPageUrl != null;
        emit(CouponsListLoaded(couponListModel, _hasNextPage));
      } else {
        _hasNextPage = false;
        emit(CouponsListLoaded(couponListModel, _hasNextPage));
      }
    } catch (e) {
      emit(CouponsListFailure("An error occurred: $e"));
    } finally {
      _isLoadingMore = false;
    }
  }
}

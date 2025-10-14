import 'package:flutter_bloc/flutter_bloc.dart';
import 'CouponCategoryRepository.dart';
import 'CouponsCategoryStates.dart';
import '../../../Models/CouponCategoryModel.dart';

class CategoryCouponscubit extends Cubit<CouponsCategoryStates> {
  final CouponsRepo couponsRepo;

  CategoryCouponscubit(this.couponsRepo) : super(CouponsCategoryInitially());

  CouponCategoryModel couponCategoryModel = CouponCategoryModel();

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  Future<void> getCouponsCategory() async {
    emit(CouponsCategoryLoading());
    _currentPage = 1;
    try {
      final response = await couponsRepo.couponsCategory(_currentPage);
      if (response != null && response.status == true) {
        couponCategoryModel = response;
        _hasNextPage = response.couponsCategory?.nextPageUrl != null;
        emit(CouponsCategoryLoaded(couponCategoryModel, _hasNextPage));
      } else {
        emit(CouponsCategoryFailure("Failed to load categories."));
      }
    } catch (e) {
      emit(CouponsCategoryFailure("An error occurred: $e"));
    }
  }

  Future<void> fetchMoreCouponsCategory() async {
    if (_isLoadingMore || !_hasNextPage) return;
    _isLoadingMore = true;
    _currentPage++;

    emit(CouponsCategoryLoadingMore(couponCategoryModel, _hasNextPage));
    try {
      final newResponse = await couponsRepo.couponsCategory(_currentPage);
      if (newResponse != null &&
          newResponse.couponsCategory?.data?.isNotEmpty == true) {
        final combinedList = List<Data>.from(
          couponCategoryModel.couponsCategory?.data ?? [],
        )..addAll(newResponse.couponsCategory!.data!);

        final updatedCategory = CouponsCategory(
          currentPage: newResponse.couponsCategory?.currentPage,
          data: combinedList,
          firstPageUrl: newResponse.couponsCategory?.firstPageUrl,
          from: newResponse.couponsCategory?.from,
          lastPage: newResponse.couponsCategory?.lastPage,
          lastPageUrl: newResponse.couponsCategory?.lastPageUrl,
          links: newResponse.couponsCategory?.links,
          nextPageUrl: newResponse.couponsCategory?.nextPageUrl,
          path: newResponse.couponsCategory?.path,
          perPage: newResponse.couponsCategory?.perPage,
          prevPageUrl: newResponse.couponsCategory?.prevPageUrl,
          to: newResponse.couponsCategory?.to,
          total: newResponse.couponsCategory?.total,
        );

        couponCategoryModel = CouponCategoryModel(
          status: newResponse.status,
          couponsCategory: updatedCategory,
        );

        _hasNextPage = newResponse.couponsCategory?.nextPageUrl != null;
        emit(CouponsCategoryLoaded(couponCategoryModel, _hasNextPage));
      }
    } catch (e) {
      emit(CouponsCategoryFailure("An error occurred: $e"));
    } finally {
      _isLoadingMore = false;
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/Coupons/CouponCategoryRepository.dart';
import 'RedeemedCouponsStates.dart';
import '../../../Models/RedeemedCouponsModel.dart';

class RedeemedCouponCubit extends Cubit<RedeemedCouponStates> {
  final CouponsRepo couponsRepo;

  RedeemedCouponCubit(this.couponsRepo) : super(RedeemedCouponInitially());

  RedeemedCouponsModel redeemedCouponsModel = RedeemedCouponsModel();

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  Future<void> fetchRedeemedCoupons(String filters) async {
    emit(RedeemedCouponLoading());
    _currentPage = 1;
    try {
      final response = await couponsRepo.redeemedCoupons(filters, _currentPage);
      if (response != null && response.status == true) {
        redeemedCouponsModel = response;
        _hasNextPage = response.data?.nextPageUrl != null;
        emit(RedeemedCouponLoaded(redeemedCouponsModel, _hasNextPage));
      } else {
        emit(RedeemedCouponFailure("Failed to load coupons."));
      }
    } catch (e) {
      emit(RedeemedCouponFailure("An error occurred: $e"));
    }
  }

  Future<void> fetchMoreRedeemedCoupons(String filters) async {
    if (_isLoadingMore || !_hasNextPage) return;
    _isLoadingMore = true;
    _currentPage++;

    emit(RedeemedCouponLoadingMore(redeemedCouponsModel, _hasNextPage));
    try {
      final newResponse = await couponsRepo.redeemedCoupons(filters, _currentPage);
      if (newResponse != null && newResponse.data?.data?.isNotEmpty == true) {
        final combinedList = List<Data>.from(
          redeemedCouponsModel.data?.data ?? [],
        )..addAll(newResponse.data!.data!);

        final updatedCoupons = Coupons(
          currentPage: newResponse.data?.currentPage,
          data: combinedList,
          firstPageUrl: newResponse.data?.firstPageUrl,
          from: newResponse.data?.from,
          lastPage: newResponse.data?.lastPage,
          lastPageUrl: newResponse.data?.lastPageUrl,
          links: newResponse.data?.links,
          nextPageUrl: newResponse.data?.nextPageUrl,
          path: newResponse.data?.path,
          perPage: newResponse.data?.perPage,
          prevPageUrl: newResponse.data?.prevPageUrl,
          to: newResponse.data?.to,
          total: newResponse.data?.total,
        );

        redeemedCouponsModel = RedeemedCouponsModel(
          status: newResponse.status,
          message: newResponse.message,
          data: updatedCoupons,
        );

        _hasNextPage = newResponse.data?.nextPageUrl != null;
        emit(RedeemedCouponLoaded(redeemedCouponsModel, _hasNextPage));
      }
    } catch (e) {
      emit(RedeemedCouponFailure("An error occurred: $e"));
    } finally {
      _isLoadingMore = false;
    }
  }
}

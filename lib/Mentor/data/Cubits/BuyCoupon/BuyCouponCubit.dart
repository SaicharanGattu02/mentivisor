import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/Coupons/CouponCategoryRepository.dart';
import 'BuyCouponStates.dart';

class BuyCouponCubit extends Cubit<BuyCouponStates> {
  final CouponsRepo couponsRepo;

  BuyCouponCubit(this.couponsRepo) : super(BuyCouponInitially());

  Future<void> buyCoupons(int categoryId) async {
    emit(BuyCouponLoading());

    try {
      final response = await couponsRepo.buyCoupon(categoryId);

      if (response != null && response.status == true) {
        emit(BuyCouponLoaded(response));
      } else {
        emit(BuyCouponFailure(response?.message ??"Failed Buying Coupon."));
      }
    } catch (e) {
      emit(BuyCouponFailure("An error occurred: $e"));
    }
  }
}

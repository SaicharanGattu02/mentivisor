import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/Coupons/CouponCategoryRepository.dart';
import 'CouponsDetailsStates.dart';
import '../../../Models/CouponListModel.dart';

class CouponsDetailCubit extends Cubit<CouponsDetailsStates> {
  final CouponsRepo couponsRepo;

  CouponsDetailCubit(this.couponsRepo) : super(CouponsDetailsInitially());

  Future<void> fetchCouponsDetails(String categoryId) async {
    emit(CouponsDetailsLoading());

    try {
      final response = await couponsRepo.couponDetails(categoryId);

      if (response != null && response.status == true) {
        emit(CouponsDetailsLoaded(response));
      } else {
        emit(CouponsDetailsFailure("Failed to load coupons."));
      }
    } catch (e) {
      emit(CouponsDetailsFailure("An error occurred: $e"));
    }
  }
}

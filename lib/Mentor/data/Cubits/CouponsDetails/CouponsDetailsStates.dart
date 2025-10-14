import 'package:mentivisor/Mentor/Models/CouponDetailsModel.dart';

abstract class CouponsDetailsStates {}

class CouponsDetailsInitially extends CouponsDetailsStates {}

class CouponsDetailsLoading extends CouponsDetailsStates {}

class CouponsDetailsLoaded extends CouponsDetailsStates {
  final CouponDetailsModel couponDetailsModel;

  CouponsDetailsLoaded(this.couponDetailsModel);
}

class CouponsDetailsFailure extends CouponsDetailsStates {
  final String error;
  CouponsDetailsFailure(this.error);
}

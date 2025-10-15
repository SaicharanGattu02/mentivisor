import '../../../Models/RedeemedCouponsModel.dart';

abstract class RedeemedCouponStates {}

class RedeemedCouponInitially extends RedeemedCouponStates {}

class RedeemedCouponLoading extends RedeemedCouponStates {}

class RedeemedCouponLoaded extends RedeemedCouponStates {
  final RedeemedCouponsModel redeemedCouponsModel;
  final bool hasNextPage;

  RedeemedCouponLoaded(this.redeemedCouponsModel, this.hasNextPage);
}

class RedeemedCouponLoadingMore extends RedeemedCouponStates {
  final RedeemedCouponsModel redeemedCouponsModel;
  final bool hasNextPage;

  RedeemedCouponLoadingMore(this.redeemedCouponsModel, this.hasNextPage);
}

class RedeemedCouponFailure extends RedeemedCouponStates {
  final String error;
  RedeemedCouponFailure(this.error);
}

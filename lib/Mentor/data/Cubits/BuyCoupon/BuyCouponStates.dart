import 'package:mentivisor/Mentor/Models/BuyCouponModel.dart';

abstract class BuyCouponStates {}

class BuyCouponInitially extends BuyCouponStates {}

class BuyCouponLoading extends BuyCouponStates {}

class BuyCouponLoaded extends BuyCouponStates {
  final BuyCouponModel buyCouponModel;

  BuyCouponLoaded(this.buyCouponModel);
}

class BuyCouponFailure extends BuyCouponStates {
  final String error;
  BuyCouponFailure(this.error);
}

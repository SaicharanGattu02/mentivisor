import '../../../Models/CouponCategoryModel.dart';

abstract class CouponsCategoryStates {}

class CouponsCategoryInitially extends CouponsCategoryStates {}

class CouponsCategoryLoading extends CouponsCategoryStates {}

class CouponsCategoryLoaded extends CouponsCategoryStates {
  final CouponCategoryModel couponCategoryModel;
  final bool hasNextPage;

  CouponsCategoryLoaded(this.couponCategoryModel, this.hasNextPage);
}

class CouponsCategoryLoadingMore extends CouponsCategoryStates {
  final CouponCategoryModel couponCategoryModel;
  final bool hasNextPage;

  CouponsCategoryLoadingMore(this.couponCategoryModel, this.hasNextPage);
}

class CouponsCategoryFailure extends CouponsCategoryStates {
  final String error;
  CouponsCategoryFailure(this.error);
}

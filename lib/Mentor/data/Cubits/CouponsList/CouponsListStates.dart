import 'package:mentivisor/Mentor/Models/CouponListModel.dart';


abstract class CouponsListStates {}

class CouponsListInitially extends CouponsListStates {}

class CouponsListLoading extends CouponsListStates {}

class CouponsListLoaded extends CouponsListStates {
  final CouponListModel couponListModel;
  final bool hasNextPage;

  CouponsListLoaded(this.couponListModel, this.hasNextPage);
}

class CouponsListLoadingMore extends CouponsListStates {
  final CouponListModel couponListModel;
  final bool hasNextPage;

  CouponsListLoadingMore(this.couponListModel, this.hasNextPage);
}

class CouponsListFailure extends CouponsListStates {
  final String error;
  CouponsListFailure(this.error);
}

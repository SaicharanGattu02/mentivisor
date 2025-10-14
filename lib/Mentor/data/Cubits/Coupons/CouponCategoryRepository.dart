import 'package:mentivisor/Mentor/Models/SessionsModel.dart';
import 'package:mentivisor/Mentor/data/MentorRemoteDataSource.dart';

import '../../../Models/CouponCategoryModel.dart';
import '../../../Models/CouponDetailsModel.dart';
import '../../../Models/CouponListModel.dart';
import '../../../Models/MentorEarningsModel.dart';

abstract class CouponsRepo {
  Future<CouponCategoryModel?> couponsCategory(int page);
  Future<CouponListModel?> couponList(String categoryId,int page);
  Future<CouponDetailsModel?> couponDetails(String couponId);
}

class CouponsRepoImpl implements CouponsRepo {
  MentorRemoteDataSource mentorRemoteDataSource;
  CouponsRepoImpl({required this.mentorRemoteDataSource});

  @override
  Future<CouponCategoryModel?> couponsCategory(int page) async {
    return await mentorRemoteDataSource.couponsCategory(page);
  }

  @override
  Future<CouponListModel?> couponList(String categoryId,int page) async {
    return await mentorRemoteDataSource.couponList(categoryId,page);
  }

  @override
  Future<CouponDetailsModel?> couponDetails(String couponId) async {
    return await mentorRemoteDataSource.couponDetails(couponId);
  }
}

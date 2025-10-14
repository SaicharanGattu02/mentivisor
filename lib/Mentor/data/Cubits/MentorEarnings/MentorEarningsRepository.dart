import 'package:mentivisor/Mentor/Models/SessionsModel.dart';
import 'package:mentivisor/Mentor/data/MentorRemoteDataSource.dart';

import '../../../Models/CouponCategoryModel.dart';
import '../../../Models/CouponListModel.dart';
import '../../../Models/MentorEarningsModel.dart';

abstract class MentorEarningsRepo {
  Future<MentorEarningsModel?> getMentorEarnings();
}

class MentorEarningsRepoImpl implements MentorEarningsRepo {
  MentorRemoteDataSource mentorRemoteDataSource;
  MentorEarningsRepoImpl({required this.mentorRemoteDataSource});

  @override
  Future<MentorEarningsModel?> getMentorEarnings() async {
    return await mentorRemoteDataSource.mentorEarnings();
  }
}

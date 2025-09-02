import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import '../../../Models/AvailableSlotsModel.dart';
import '../../MentorRemoteDataSource.dart';

abstract class MentorAvailabilityRepo {
  Future<SuccessModel?> addMentorAvailability(Map<String, dynamic> data);
  Future<AvailableSlotsModel?> getMentorAvailability();
}

class MentorAvailabilityImpl implements MentorAvailabilityRepo {
  final MentorRemoteDataSource mentorRemoteDataSource;
  MentorAvailabilityImpl({required this.mentorRemoteDataSource});

  @override
  Future<SuccessModel?> addMentorAvailability(Map<String, dynamic> data) async {
    return await mentorRemoteDataSource.addMentorAvailability(data);
  }

  @override
  Future<AvailableSlotsModel?> getMentorAvailability() async {
    return await mentorRemoteDataSource.getMentorAvailability();
  }
}

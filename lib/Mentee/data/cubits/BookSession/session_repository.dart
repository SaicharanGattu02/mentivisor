import 'package:mentivisor/Mentee/Models/DailySlotsModel.dart';
import 'package:mentivisor/Mentee/Models/SelectSlotModel.dart';
import 'package:mentivisor/Mentee/Models/SessionBookingModel.dart';
import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import 'package:mentivisor/Mentee/Models/WeeklySlotsModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

abstract class SessionBookingRepo {
  Future<WeeklySlotsModel?> getWeeklySlots(int mentorId, {String week = ''});
  Future<DailySlotsModel?> getDailySlots(int mentor_id, String date);
  Future<SelectSlotModel?> selectSlot(int mentor_id, int slot_id);
  Future<SessionBookingModel?> sessionBooking(Map<String,dynamic> data
  );
}

class SessionBookingRepoImpl implements SessionBookingRepo {
  RemoteDataSource remoteDataSource;
  SessionBookingRepoImpl({required this.remoteDataSource});
  @override
  Future<WeeklySlotsModel?> getWeeklySlots(int mentorId, {String week = ''}) async {
    return await remoteDataSource.getWeeklySlots(mentorId,week: week);
  }

  @override
  Future<DailySlotsModel?> getDailySlots(int mentor_id, String date) async {
    return await remoteDataSource.getDailySlots(mentor_id, date);
  }

  @override
  Future<SelectSlotModel?> selectSlot(int mentor_id, int slot_id) async {
    return await remoteDataSource.selectSlot(mentor_id, slot_id);
  }

  @override
  Future<SessionBookingModel?> sessionBooking(
      Map<String,dynamic> data
  ) async {
    return await remoteDataSource.sessionBooking(data);
  }
}

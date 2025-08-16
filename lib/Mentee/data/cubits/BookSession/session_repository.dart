import 'package:mentivisor/Mentee/Models/DailySlotsModel.dart';
import 'package:mentivisor/Mentee/Models/SelectSlotModel.dart';
import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import 'package:mentivisor/Mentee/Models/WeeklySlotsModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

abstract class SessionBookingRepo {
  Future<WeeklySlotsModel?> getWeeklySlots(int mentor_id);
  Future<DailySlotsModel?> getDailySlots(int mentor_id, String date);
  Future<SelectSlotModel?> selectSlot(int mentor_id, int slot_id);
  Future<SuccessModel?> sessionBooking(
    int mentor_id,
    int slot_id,
    Map<String, dynamic> data,
  );
}

class SessionBookingRepoImpl implements SessionBookingRepo {
  RemoteDataSource remoteDataSource;
  SessionBookingRepoImpl({required this.remoteDataSource});
  @override
  Future<WeeklySlotsModel?> getWeeklySlots(int mentor_id) async {
    return await remoteDataSource.getWeeklySlots(mentor_id);
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
  Future<SuccessModel?> sessionBooking(
    int mentor_id,
    int slot_id,
    Map<String, dynamic> data,
  ) async {
    return await remoteDataSource.sessionBooking(mentor_id, slot_id, data);
  }
}

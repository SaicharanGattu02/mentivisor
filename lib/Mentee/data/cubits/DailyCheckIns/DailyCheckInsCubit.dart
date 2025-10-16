import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/DailyCheckIns/DailyCheckInsRepo.dart';
import 'package:mentivisor/Mentee/data/cubits/DailyCheckIns/DailyCheckInsStates.dart';

class DailyCheckInsCubit extends Cubit<DailyCheckInsStates> {
  final DailyCheckInsRepo dailyCheckInsRepo;

  DailyCheckInsCubit(this.dailyCheckInsRepo) : super(DailyCheckInsIntailly());

  Future<void> getDailyCheckIns() async {
    emit(DailyCheckInsLoading());
    try {
      final response = await dailyCheckInsRepo.dailyCheckIns();
      if (response != null && response.success == true) {
        emit(DailyCheckInsSuccess(response));
      } else {
        emit(DailyCheckInsFailure(response?.message ?? "Failed to load data"));
      }
    } catch (e) {
      emit(DailyCheckInsFailure(e.toString()));
    }
  }
}

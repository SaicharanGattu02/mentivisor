import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/Years/years_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/Years/years_states.dart';

class YearsCubit extends Cubit<YearsStates> {
  YearsRepository yearsRepository;
  YearsCubit(this.yearsRepository) : super(YearsInitially());

  Future<void> getYears() async {
    emit(YearsLoading());
    try {
      final response = await yearsRepository.getYears();
      if (response != null && response.status == true) {
        emit(YearsLoaded(response));
      } else {
        emit(YearsFailure("Something went wrong"));
      }
    } catch (e) {
      emit(YearsFailure(e.toString()));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/Campuses/campuses_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/Campuses/campuses_states.dart';

class CampusesCubit extends Cubit<CampusesStates> {
  CampusesRepository campusesRepository;
  CampusesCubit(this.campusesRepository) : super(CampusesInitially());

  Future<void> getCampuses() async {
    emit(CampusesLoading());
    try {
      final response = await campusesRepository.getCampuses();
      if (response != null && response.status == true) {
        emit(CampusesLoaded(response));
      } else {
        emit(CampusesFailure("Something went wrong"));
      }
    } catch (e) {
      emit(CampusesFailure(e.toString()));
    }
  }
}

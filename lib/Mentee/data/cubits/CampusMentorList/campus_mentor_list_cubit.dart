import 'package:flutter_bloc/flutter_bloc.dart';
import 'campus_mentor_list_repo.dart';
import 'campus_mentor_list_state.dart';

class CampusMentorListCubit extends Cubit<CampusMentorListState> {
  final CampusMentorListRepository campusMentorListRepository;

  CampusMentorListCubit(this.campusMentorListRepository) : super(CampusMentorListStateInitial());

  Future<void> fetchCampusMentorList(String scope, String search) async {
    emit(CampusMentorListStateLoading());
    try {
      final result = await campusMentorListRepository.getCampusMentorList(
        scope,
        search,
      );
      if (result != null && result.status == true) {
        emit(CampusMentorListStateLoaded(campusMentorListModel: result));
      } else {
        emit(CampusMentorListStateFailure(msg: "No data found."));
      }
    } catch (e) {
      emit(CampusMentorListStateFailure(msg: "An error occurred: $e"));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/GuestMentors/guest_mentors_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/GuestMentors/guest_mentors_states.dart';

class GuestMentorsCubit extends Cubit<GuestMentorsState> {
  final GuestMentorsRepository guestMentorsRepository;

  GuestMentorsCubit(this.guestMentorsRepository) : super(GuestMentorsInitial());

  Future<void> fetchGuestMentorList() async {
    emit(GuestMentorsLoading());
    try {
      final result = await guestMentorsRepository.getGuestMentorsList();
      if (result != null && result.status == true) {
        emit(GuestMentorsLoaded(guestMentorsModel: result));
      } else {
        emit(GuestMentorsFailure(msg: "No data found."));
      }
    } catch (e) {
      emit(GuestMentorsFailure(msg: "An error occurred: $e"));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/Tags/tags_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/Tags/tags_states.dart';

import 'home_dialog_repository.dart';
import 'home_dialog_states.dart';

class HomeDialogCubit extends Cubit<HomeDialogState> {
  HomeDialogRepository homeDialogRepository;
  HomeDialogCubit(this.homeDialogRepository) : super(HomeDialogInitially());

  Future<void> getHomeDialog( ) async {
    emit(HomeDialogLoading());
    try {
      final response = await homeDialogRepository.getHomeDialog();
      if (response != null && response.status == true) {
        emit(HomeDialogLoaded(response));
      } else {
        emit(HomeDialogFailure("Something went wrong"));
      }
    } catch (e) {
      emit(HomeDialogFailure(e.toString()));
    }
  }
}

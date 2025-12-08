import 'package:flutter_bloc/flutter_bloc.dart';

class ExpertiseExpansionCubit extends Cubit<int?> {
  ExpertiseExpansionCubit() : super(null);

  void toggle(int index) {
    // If same index clicked → collapse
    if (state == index) {
      emit(null);
    } else {
      emit(index);
    }
  }
}

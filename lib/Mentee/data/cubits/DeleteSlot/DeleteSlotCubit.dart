import 'package:flutter_bloc/flutter_bloc.dart';

import 'DeleteSlotRepo.dart';
import 'DeleteSlotStates.dart';

class DeleteSlotCubit extends Cubit<DeleteSlotStates> {
  final DeleteSlotRepo deleteSlotRepo;

  DeleteSlotCubit(this.deleteSlotRepo)
      : super(DeleteSlotInitial());

  Future<void> deleteSlot(String slotId) async {
    try {
      emit(DeleteSlotLoading());

      final response =
      await deleteSlotRepo.deleteSlot(slotId: slotId);

      if (response != null && response.status == true) {
        emit(DeleteSlotLoaded(response));
      } else {
        emit(DeleteSlotFailure(
          response?.message ?? "Failed to delete slot",
        ));
      }
    } catch (e) {
      emit(DeleteSlotFailure(
          "Something went wrong while deleting the slot"));
    }
  }
}

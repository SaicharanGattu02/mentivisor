import 'package:flutter_bloc/flutter_bloc.dart';

import '../chatReportRepo.dart';
import 'groupChatReportStates.dart';

class groupChatReportCubit extends Cubit<GroupChatReportState> {
  final ChatReportRepo chatReportRepo;

  groupChatReportCubit(this.chatReportRepo) : super(GroupChatReportIntailly());

  Future<void> groupChatReport(Map<String, dynamic> data) async {
    emit(GroupChatReportLoading());
    try {
      final res = await chatReportRepo.groupChatReport(data);
      if (res != null && res.status == true) {
        emit(GroupChatReportSuccess(res));
      } else {
        emit(GroupChatReportFailure(message: res?.message ?? "Login failed"));
      }
    } catch (e) {
      emit(GroupChatReportFailure(message: "An error occurred: $e"));
    }
  }
}

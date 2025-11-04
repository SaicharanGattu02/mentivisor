import 'package:flutter_bloc/flutter_bloc.dart';

import '../chatReportRepo.dart';
import 'privateChatReportStates.dart';

class privateChatReportCubit extends Cubit<PrivateChatReportState> {
  final ChatReportRepo chatReportRepo;

  privateChatReportCubit(this.chatReportRepo)
    : super(PrivateChatReportIntailly());

  Future<void> postStudyZoneReport(Map<String, dynamic> data) async {
    emit(PrivateChatReportLoading());
    try {
      final res = await chatReportRepo.privateChatReport(data);
      if (res != null && res.status == true) {
        emit(PrivateChatReportSuccess(res));
      } else {
        emit(PrivateChatReportFailure(message: res?.message ?? "Login failed"));
      }
    } catch (e) {
      emit(PrivateChatReportFailure(message: "An error occurred: $e"));
    }
  }
}

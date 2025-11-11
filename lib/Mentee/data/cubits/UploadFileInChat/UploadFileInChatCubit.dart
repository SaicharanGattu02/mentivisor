// CUBIT
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Models/UploadFileInChatModel.dart';
import 'UploadFileInChatRepo.dart';
import 'UploadFileInChatStates.dart';

class UploadFileInChatCubit extends Cubit<UploadFileInChatStates> {
  final UploadFileInChatRepo uploadFileInChatRepo;

  UploadFileInChatCubit(this.uploadFileInChatRepo)
    : super(UploadFileInChatInitial());

  Future<void> uploadFileInChat(
    Map<String, dynamic> data,
    String user_id,
    String session_id,
  ) async {
    emit(UploadFileInChatLoading());
    try {
      final UploadFileInChatModel? response = await uploadFileInChatRepo
          .uploadFileInChat(data, user_id, session_id);
      if (response != null && (response.success == true)) {
        emit(UploadFileInChatSuccess(response));
      } else {
        emit(UploadFileInChatFailure(response?.message??""));
      }
    } catch (e) {
      emit(
        UploadFileInChatFailure(
          "Error occurred while uploading file: ${e.toString()}",
        ),
      );
    }
  }
}

// CUBIT
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Models/UploadFileInChatModel.dart';
import 'UploadFileInChatRepo.dart';
import 'UploadFileInChatStates.dart';

class UploadFileInChatCubit extends Cubit<UploadFileInChatStates> {
  final UploadFileInChatRepo uploadFileInChatRepo;

  UploadFileInChatCubit(this.uploadFileInChatRepo)
    : super(UploadFileInChatInitial());

  Future<void> uploadFileInChat(Map<String, dynamic> data) async {
    emit(UploadFileInChatLoading());
    try {
      final UploadFileInChatModel? response = await uploadFileInChatRepo
          .uploadFileInChat(data);
      if (response != null && (response.success == true)) {
        emit(UploadFileInChatSuccess(response));
      } else {
        emit(UploadFileInChatFailure("Something went wrong"));
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

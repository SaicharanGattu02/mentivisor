import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/bloc/StudyzoneDownload_wol/StudyzoneDownload_wol_Repository.dart';
import 'package:mentivisor/bloc/StudyzoneDownload_wol/StudyzoneDownload_wol_State.dart';

class StudyzonedownloadWolCubit extends Cubit<StudyzonedownloadWolState> {
  StudyzonedownloadWolRepository studyzonedownloadWolRepository;

  StudyzonedownloadWolCubit(this.studyzonedownloadWolRepository) : super(StudyzonedownloadwolIntially());

  Future<void> Studyzonedownloadwol() async {

    emit(StudyzondownloadwolStateLoading());
    try {
      final res = await studyzonedownloadWolRepository.studyzonedownloadwithoutlogin();
      if (res != null) {
        emit(StudyzonedownloadwolStateLoaded(studyZoneDownloadModel_wo_log: res));
      } else {
        emit(StudyzonedownloadwolStateFailure(msg: "No states found."));
      }
    } catch (e) {
      emit(StudyzonedownloadwolStateFailure(msg: "An error occurred: $e"));
    }
  }

}
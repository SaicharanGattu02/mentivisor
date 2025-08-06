import 'package:mentivisor/Models/StudyZoneDownloadModel_wo_log.dart';

import '../../services/remote_data_source.dart';

abstract class StudyzonedownloadWolRepository {
  Future<StudyZoneDownloadModel_wo_log?> studyzonedownloadwithoutlogin();
}

class StudyZonedownloadwolImpl implements StudyzonedownloadWolRepository {
  final RemoteDataSource remoteDataSource;

  StudyZonedownloadwolImpl({required this.remoteDataSource});

  @override
  Future<StudyZoneDownloadModel_wo_log?> studyzonedownloadwithoutlogin() async {
    return await remoteDataSource.studtzonedownloadwithoutlogin();
  }

}
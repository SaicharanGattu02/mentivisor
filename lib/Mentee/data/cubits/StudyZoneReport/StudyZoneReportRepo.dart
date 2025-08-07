import '../../../Models/StudyZoneCampusModel.dart';
import '../../../Models/SuccessModel.dart';
import '../../remote_data_source.dart';

abstract class StudyZoneReportRepository {
  Future<SuccessModel?> postStudyZoneReport(Map<String, dynamic> data);
}

class StudyZoneReportImpl implements StudyZoneReportRepository {
  RemoteDataSource remoteDataSource;

  StudyZoneReportImpl({required this.remoteDataSource});

  @override
  Future<SuccessModel?> postStudyZoneReport(Map<String, dynamic> data) async {
    return await remoteDataSource.postStudyZoneReport(data);
  }
}

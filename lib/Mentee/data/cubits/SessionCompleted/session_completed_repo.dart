import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import '../../../Models/CompletedSessionModel.dart';
import '../../../Models/ReviewSubmitModel.dart';
import '../../remote_data_source.dart';

abstract class SessionCompletedRepository {
  Future<CompletedSessionModel?> getSessionComplete();
  Future<ReviewSubmitModel?> submitReview(Map<String, dynamic> data, int id);
  Future<SuccessModel?> sessionReportSubmit(Map<String, dynamic> data);
}

class SessionCompletedImpl implements SessionCompletedRepository {
  final RemoteDataSource remoteDataSource;
  SessionCompletedImpl({required this.remoteDataSource});

  @override
  Future<CompletedSessionModel?> getSessionComplete() async {
    return await remoteDataSource.sessionsComplete();
  }

  @override
  Future<ReviewSubmitModel?> submitReview(Map<String, dynamic> data, int id) async {
    return await remoteDataSource.sessionSubmitReview(data, id);
  }
  @override
  Future<SuccessModel?> sessionReportSubmit(Map<String, dynamic> data) async {
    return await remoteDataSource.postSessionReport(data);
  }
}

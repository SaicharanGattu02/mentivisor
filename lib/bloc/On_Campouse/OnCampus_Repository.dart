import '../../Models/OnCampouseRespModel.dart';
import '../../services/remote_data_source.dart';

abstract class OncampusRepository{
  Future<MentorOnCamposeRespModel?> getoncampose();
}

class BooksImpl implements OncampusRepository{
  final RemoteDataSource remoteDataSource;

  BooksImpl({required this.remoteDataSource});

  @override
  Future<MentorOnCamposeRespModel?> getoncampose() async {
    return await remoteDataSource.mentoroncampose();
  }
}
import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import '../../remote_data_source.dart';

abstract class BecomeMentorRepository {
  Future<SuccessModel?> postBecomeMentor(Map<String, dynamic> data);
}

class BecomeMentorImpl implements BecomeMentorRepository {
  final RemoteDataSource remoteDataSource;
  BecomeMentorImpl({required this.remoteDataSource});

  @override
  Future<SuccessModel?> postBecomeMentor(Map<String, dynamic> data) async {
    return await remoteDataSource.becomeMentor(data);
  }
}

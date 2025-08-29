import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import '../../../Models/BecomeMentorSuccessModel.dart';
import '../../remote_data_source.dart';

abstract class BecomeMentorRepository {
  Future<BecomeMentorSuccessModel?> postBecomeMentor(Map<String, dynamic> data);
}

class BecomeMentorImpl implements BecomeMentorRepository {
  final RemoteDataSource remoteDataSource;
  BecomeMentorImpl({required this.remoteDataSource});

  @override
  Future<BecomeMentorSuccessModel?> postBecomeMentor(Map<String, dynamic> data) async {
    return await remoteDataSource.becomeMentor(data);
  }
}

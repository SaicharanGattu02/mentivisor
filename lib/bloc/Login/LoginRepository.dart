import 'package:mentivisor/Models/LoginResponseModel.dart';

import '../../services/remote_data_source.dart';

abstract class LoginRepository {
  Future<LogInModel?> loginOtpApi(Map<String, dynamic> data);
}

class LogInRepositoryImpl implements LoginRepository {
  final RemoteDataSource remoteDataSource;
  LogInRepositoryImpl({required this.remoteDataSource});

  Future<LogInModel?> loginOtpApi(Map<String, dynamic> data) async {
    return await remoteDataSource.login(data);
  }
}

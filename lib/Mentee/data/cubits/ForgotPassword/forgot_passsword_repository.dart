import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import '../../remote_data_source.dart';

abstract class ForgotPassswordRepository {
  Future<SuccessModel?> forgotPassword(Map<String, dynamic> data);
  Future<SuccessModel?> resetPassword(Map<String, dynamic> data);
  Future<SuccessModel?> forgotVerify(Map<String, dynamic> data);
}

class ForgotPassswordImpl implements ForgotPassswordRepository {
  RemoteDataSource remoteDataSource;
  ForgotPassswordImpl({required this.remoteDataSource});

  @override
  Future<SuccessModel?> forgotPassword(Map<String, dynamic> data) async {
    return await remoteDataSource.forgotPassword(data);
  }
  @override
  Future<SuccessModel?> resetPassword(Map<String, dynamic> data) async {
    return await remoteDataSource.resetPassword(data);
  }
  @override
  Future<SuccessModel?> forgotVerify(Map<String, dynamic> data) async {
    return await remoteDataSource.forgotVerify(data);
  }
}

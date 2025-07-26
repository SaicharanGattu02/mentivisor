import '../../Models/OtpVerifyModel.dart';
import '../../services/remote_data_source.dart';

abstract class VerifyOtpRepository {
  Future<Otpverifymodel?> verifyotpApi(Map<String, dynamic> data);
}

class verifyotpImpl implements VerifyOtpRepository {
  final RemoteDataSource remoteDataSource;
  verifyotpImpl({required this.remoteDataSource});

  @override
  Future<Otpverifymodel?> verifyotpApi(Map<String, dynamic> data) async{
    return await remoteDataSource. Verifyotp(data);


  }
}
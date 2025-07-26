import 'package:mentivisor/Models/RegisterModel.dart';

import '../../services/remote_data_source.dart';

abstract class RegisterRepository {
  Future<RegisterModel?> RegisterApi(Map<String, dynamic> data);
}

class RegisterImpl implements RegisterRepository {
  final RemoteDataSource remoteDataSource;
  RegisterImpl({required this.remoteDataSource});

  @override
  Future<RegisterModel?> RegisterApi(Map<String, dynamic> data) async{
    return await remoteDataSource.Register(data);


  }
}

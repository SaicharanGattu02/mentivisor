import 'package:mentivisor/Models/Years_ResponseModel.dart';

import '../../services/remote_data_source.dart';

abstract class YearsRepository {
  Future<YearsResponsemodel?> getyears();
}

class YearsImpl implements YearsRepository {
  final RemoteDataSource remoteDataSource;

  YearsImpl({required this.remoteDataSource});

  @override
  Future<YearsResponsemodel?> getyears() async {
    return await remoteDataSource.getyears();
  }

}
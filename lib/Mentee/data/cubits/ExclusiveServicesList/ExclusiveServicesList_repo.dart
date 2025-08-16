import 'package:mentivisor/Mentee/Models/ExclusiveServicesModel.dart';

import '../../remote_data_source.dart';

abstract class ExclusiveserviceslistRepo {
  Future<ExclusiveServicesModel?> getexclusivelist(String search,int page);
}

class ExclusiveImpl implements ExclusiveserviceslistRepo {
  final RemoteDataSource remoteDataSource;
  ExclusiveImpl({required this.remoteDataSource});
  @override
  Future<ExclusiveServicesModel?> getexclusivelist(String search,int page) async {
    return await remoteDataSource.exclusiveServiceList(search,page);
  }
}
import 'package:mentivisor/Mentee/Models/ExclusiveServicesModel.dart';

import '../../../Models/ExclusiveservicedetailsModel.dart';
import '../../remote_data_source.dart';

abstract class ExclusiveservicedetailsRepository {
  Future<ExclusiveservicedetailsModel?> exclusiveServiceDetails(int id);
}

class ExclusivedetailsImpl implements ExclusiveservicedetailsRepository {
  final RemoteDataSource remoteDataSource;
  ExclusivedetailsImpl({required this.remoteDataSource});
  @override
  Future<ExclusiveservicedetailsModel?> exclusiveServiceDetails(int id) async {
    return await remoteDataSource.exclusiveServiceDetails(id);
  }



}
import '../../../Models/GetExpertiseModel.dart';
import '../../remote_data_source.dart';

abstract class ExpertiseRepo {
  Future<GetExpertiseModel?> getExpertiseCategory(String search, int page);
  Future<GetExpertiseModel?> getExpertiseSubCategory(int id);
}

class ExpertiseImpl extends ExpertiseRepo {
  RemoteDataSource remoteDataSource;
  ExpertiseImpl({required this.remoteDataSource});
  @override
  Future<GetExpertiseModel?> getExpertiseCategory(
    String search,
    int page,
  ) async {
    return await remoteDataSource.getExpertiseCategory(search, page);
  }

  @override
  Future<GetExpertiseModel?> getExpertiseSubCategory(int id) async {
    return await remoteDataSource.getExpertiseSubCategory(id);
  }
}

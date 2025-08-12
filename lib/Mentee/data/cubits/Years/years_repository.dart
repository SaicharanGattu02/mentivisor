import 'package:mentivisor/Mentee/Models/YearsModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

abstract class YearsRepository {
  Future<YearsModel?> getYears();
}

class YearsRepositoryImpl implements YearsRepository {
  RemoteDataSource remoteDataSource;
  YearsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<YearsModel?> getYears() async {
    return await remoteDataSource.getYears();
  }
}

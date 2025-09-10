import 'package:mentivisor/Mentee/Models/ECCModel.dart';
import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

import '../../../Models/ViewEccDetailsModel.dart';

abstract class ECCRepository {
  Future<ECCModel?> getEcc(String scope,String updates,String search,int page);
  Future<SuccessModel?> addEcc(Map<String, dynamic> data);
  Future<ViewEccDetailsModel?> viewEccDetails( int eventId);
}

class ECCRepositoryImpl implements ECCRepository {
  RemoteDataSource remoteDataSource;
  ECCRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ECCModel?> getEcc(String scope,String updates,String search,int page) async {
    return await remoteDataSource.getEcc( scope, updates,search,page);
  }
  @override
  Future<ViewEccDetailsModel?> viewEccDetails( int eventId) async {
    return await remoteDataSource.viewEccDetails(eventId);
  }

  @override
  Future<SuccessModel?> addEcc(Map<String, dynamic> data) async {
    return await remoteDataSource.addEcc(data);
  }
}

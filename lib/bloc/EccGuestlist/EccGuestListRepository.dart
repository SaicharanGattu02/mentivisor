import 'package:mentivisor/Models/EccGuestlist_Model.dart';

import '../../services/remote_data_source.dart';

abstract class Eccguestlistrepository {
  Future<EccGuestlist_Model?> eccguestlist();
}

class eccguestlistImpl implements Eccguestlistrepository {
  final RemoteDataSource remoteDataSource;

  eccguestlistImpl({required this.remoteDataSource});

  @override
  Future<EccGuestlist_Model?> eccguestlist() async {
    return await remoteDataSource.eccguestlist();
  }
}
import 'package:mentivisor/Mentee/Models/MenteeCustmor_supportModel.dart';

import '../../remote_data_source.dart';

abstract class MenteeCustomersupportRepo {
  Future<MenteeCustmor_supportModel?> getmenteecustomersupport();
}

class MenteecustomersupportImpl implements MenteeCustomersupportRepo {
  final RemoteDataSource remoteDataSource;
  MenteecustomersupportImpl({required this.remoteDataSource});
  @override
  Future<MenteeCustmor_supportModel?> getmenteecustomersupport() async {
    return await remoteDataSource.getcustomersupport();
  }



}
import '../../../Models/SuccessModel.dart';
import '../../remote_data_source.dart';

abstract class DeleteSlotRepo {
  Future<SuccessModel?> deleteSlot({
    required String slotId,
  });
}
class DeleteSlotRepoImpl implements DeleteSlotRepo {
  final RemoteDataSource remoteDataSource;

  DeleteSlotRepoImpl({required this.remoteDataSource});

  @override
  Future<SuccessModel?> deleteSlot({
    required String slotId,
  }) async {
    return await remoteDataSource.deleteSlot(slotId: slotId);
  }
}

import '../../../Models/TermsAndCondition.dart';
import '../../remote_data_source.dart';

abstract class TermsAndConditionRepo {
  Future<TermsAndConditionModel?> getTermsAndCondition();
}
class TermsAndConditionRepoImpl implements TermsAndConditionRepo {
  final RemoteDataSource remoteDataSource;

  TermsAndConditionRepoImpl({required this.remoteDataSource});

  @override
  Future<TermsAndConditionModel?> getTermsAndCondition() async {
    return await remoteDataSource.getTermsAndCondition();
  }
}

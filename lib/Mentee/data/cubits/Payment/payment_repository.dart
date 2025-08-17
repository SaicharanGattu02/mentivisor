import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import '../../../Models/CreatePaymentModel.dart';
import '../../remote_data_source.dart';

abstract class PaymentRepository {
  Future<CreatePaymentModel?> createPayment(Map<String, dynamic> data);
  Future<SuccessModel?> verifyPayment(Map<String, dynamic> data);
}

class PaymentRepositoryImpl implements PaymentRepository {
  RemoteDataSource remoteDataSource;
  PaymentRepositoryImpl({required this.remoteDataSource});
  @override
  Future<CreatePaymentModel?> createPayment(Map<String, dynamic> data) async {
    return await remoteDataSource.createPayment(data);
  }

  @override
  Future<SuccessModel?> verifyPayment(Map<String, dynamic> data) async {
    return await remoteDataSource.verifyPayment(data);
  }
}

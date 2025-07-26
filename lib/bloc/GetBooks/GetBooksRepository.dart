import '../../Models/GetBooksRespModel.dart';
import '../../services/remote_data_source.dart';

abstract class Getbooksrepository{
  Future<GetBooksRespModel?> getbooks();
}

class BooksImpl implements Getbooksrepository{
  final RemoteDataSource remoteDataSource;

  BooksImpl({required this.remoteDataSource});

  @override
  Future<GetBooksRespModel?> getbooks() async {
    return await remoteDataSource.getbooks();
  }
}
import 'package:mentivisor/Models/GetBannersRespModel.dart';

import '../../Models/GetBooksRespModel.dart';

abstract class Getbooksstate {}

class GetbookStateIntially extends Getbooksstate {}

class GetbookStateStateLoading extends Getbooksstate {}

class GetbookStateLoaded extends Getbooksstate {
  GetBooksRespModel getBooksRespModel;
  GetbookStateLoaded({required this.getBooksRespModel});
}

class GetbooksStateFailure extends Getbooksstate {
  final String msg;
  GetbooksStateFailure({required this.msg});


}
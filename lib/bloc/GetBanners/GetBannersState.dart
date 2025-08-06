import 'package:mentivisor/Models/GetBannersRespModel.dart';

abstract class Getbannersstate {
}

class GetbannersStateIntially extends Getbannersstate {
}

class GetbannersStateLoading extends Getbannersstate {
}

class GetbannersStateLoaded extends Getbannersstate {
  GetBannersRespModel getbannerModel;
  GetbannersStateLoaded({required this.getbannerModel});
}

class GetbannersStateFailure extends Getbannersstate {
  final String msg;
  GetbannersStateFailure({required this.msg});
}
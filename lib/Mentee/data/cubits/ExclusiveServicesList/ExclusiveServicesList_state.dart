import 'package:mentivisor/Mentee/Models/ExclusiveServicesModel.dart';

abstract class ExclusiveserviceslistState {}

class ExclusiveserviceStateIntially extends ExclusiveserviceslistState {}

class ExclusiveserviceStateLoading extends ExclusiveserviceslistState {}

class ExclusiveserviceStateLoaded extends ExclusiveserviceslistState {
  final ExclusiveServicesModel exclusiveServicesModel;
  final bool hasNextPage;

  ExclusiveserviceStateLoaded({
    required this.exclusiveServicesModel,
    required this.hasNextPage,
  });
}

class ExclusiveserviceStateLoadingMore extends ExclusiveserviceslistState {
  final ExclusiveServicesModel exclusiveServicesModel;
  final bool hasNextPage;

  ExclusiveserviceStateLoadingMore({
    required this.exclusiveServicesModel,
    required this.hasNextPage,
  });
}

class ExclusiveserviceStateFailure extends ExclusiveserviceslistState {
  final String msg;

  ExclusiveserviceStateFailure({required this.msg});
}

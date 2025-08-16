import 'package:mentivisor/Mentee/Models/ExclusiveServicesModel.dart';

import '../../../Models/ExclusiveservicedetailsModel.dart';

abstract class ExclusiveservicedetailsState {}

class ExclusiveservicedetailsStateIntially
    extends ExclusiveservicedetailsState {}

class ExclusiveservicedetailsStateLoading
    extends ExclusiveservicedetailsState {}

class ExclusiveservicedetailsStateLoaded extends ExclusiveservicedetailsState {
  final ExclusiveservicedetailsModel exclusiveservicedetailsModel;

  ExclusiveservicedetailsStateLoaded({required this.exclusiveservicedetailsModel});
}

class ExclusiveservicedetailsFailure extends ExclusiveservicedetailsState {
  final String msg;

  ExclusiveservicedetailsFailure({required this.msg});
}

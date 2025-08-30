import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class AddEccStates {}

class AddEccInitially extends AddEccStates {}

class AddEccLoading extends AddEccStates {}

class AddEccSuccess extends AddEccStates {
  SuccessModel successModel;
  AddEccSuccess(this.successModel);
}

class AddEccFailure extends AddEccStates {
  String error;
  AddEccFailure(this.error);
}

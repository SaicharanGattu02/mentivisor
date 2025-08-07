import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class AddEccStates {}

class AddEccInitially extends AddEccStates {}

class AddEccLoading extends AddEccStates {}

class AddEccLoaded extends AddEccStates {
  SuccessModel successModel;
  AddEccLoaded(this.successModel);
}

class AddEccFailure extends AddEccStates {
  String error;
  AddEccFailure(this.error);
}

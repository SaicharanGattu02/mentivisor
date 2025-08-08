import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class AddResourceStates {}

class AddResourceInitially extends AddResourceStates {}

class AddResourceLoading extends AddResourceStates {}

class AddResourceLoaded extends AddResourceStates {
  SuccessModel successModel;
  AddResourceLoaded(this.successModel);
}

class AddResourceFailure extends AddResourceStates {
  String error;
  AddResourceFailure(this.error);
}

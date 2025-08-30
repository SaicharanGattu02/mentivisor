import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class AddCommunityPostStates {}

class AddCommunityPostInitially extends AddCommunityPostStates {}

class AddCommunityPostLoading extends AddCommunityPostStates {}

class AddCommunityPostSuccess extends AddCommunityPostStates {
  SuccessModel successModel;
  AddCommunityPostSuccess(this.successModel);
}

class AddCommunityPostFailure extends AddCommunityPostStates {
  String error;
  AddCommunityPostFailure(this.error);
}

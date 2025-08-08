import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class AddCommunityPostStates {}

class AddCommunityInitially extends AddCommunityPostStates {}

class AddCommunityLoading extends AddCommunityPostStates {}

class AddCommunityLoaded extends AddCommunityPostStates {
  SuccessModel successModel;
  AddCommunityLoaded(this.successModel);
}

class AddCommunityFailure extends AddCommunityPostStates {
  String error;
  AddCommunityFailure(this.error);
}

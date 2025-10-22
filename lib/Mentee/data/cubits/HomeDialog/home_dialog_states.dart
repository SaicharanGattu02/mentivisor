
import 'package:mentivisor/Mentee/Models/GetHomeDilogModel.dart';

import '../../../Models/StudyZoneTagsModel.dart';

abstract class HomeDialogState {}

class HomeDialogInitially extends HomeDialogState {}

class HomeDialogLoading extends HomeDialogState {}

class HomeDialogLoaded extends HomeDialogState {
  GetHomeDilogModel homeDilogModel;
  HomeDialogLoaded( this.homeDilogModel);
}

class HomeDialogFailure extends HomeDialogState {
  String error;
  HomeDialogFailure(this.error);
}

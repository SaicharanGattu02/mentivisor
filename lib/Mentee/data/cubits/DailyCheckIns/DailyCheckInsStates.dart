import 'package:mentivisor/Mentee/Models/checkInModel.dart';

abstract class DailyCheckInsStates {}

class DailyCheckInsIntailly implements DailyCheckInsStates {}

class DailyCheckInsLoading implements DailyCheckInsStates {}

class DailyCheckInsSuccess implements DailyCheckInsStates {
  final checkInModel _checkInModel;
  DailyCheckInsSuccess(this._checkInModel);
}

class DailyCheckInsFailure implements DailyCheckInsStates {
  final String error;
  DailyCheckInsFailure(this.error);
}

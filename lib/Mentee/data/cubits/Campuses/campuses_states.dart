import 'package:mentivisor/Mentee/Models/CampusesModel.dart';

abstract class CampusesStates {}

class CampusesInitially extends CampusesStates {}

class CampusesLoading extends CampusesStates {}

class CampusesLoaded extends CampusesStates {
  CampusesModel campusesModel;
  CampusesLoaded(this.campusesModel);
}

class CampusesFailure extends CampusesStates {
  String error;
  CampusesFailure(this.error);
}

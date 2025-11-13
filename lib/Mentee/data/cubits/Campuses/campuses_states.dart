import 'package:mentivisor/Mentee/Models/CampusesModel.dart';

abstract class CampusesStates {}

class CampusesInitially extends CampusesStates {}

class CampusesLoading extends CampusesStates {}

class CampusesLoaded extends CampusesStates {
  final CampusesModel campusesModel;
  final bool hasNextPage;

  CampusesLoaded(this.campusesModel, this.hasNextPage);
}

class CampusesLoadingMore extends CampusesStates {
  final CampusesModel campusesModel;
  final bool hasNextPage;
  CampusesLoadingMore(this.campusesModel, this.hasNextPage);
}


class CampusesFailure extends CampusesStates {
  String error;
  CampusesFailure(this.error);
}

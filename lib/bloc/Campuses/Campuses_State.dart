import '../../Models/GetCompusModel.dart';

abstract class CampusesState {}

class CampusesStateIntially extends CampusesState {}

class CampusesStateLoading extends CampusesState {}

class CampusesStateLoaded extends CampusesState {
  GetCompusModel getCompusModel;
  CampusesStateLoaded({required this.getCompusModel});
}

class CampusesStateFailure extends CampusesState {
  final String msg;
  CampusesStateFailure({required this.msg});


}

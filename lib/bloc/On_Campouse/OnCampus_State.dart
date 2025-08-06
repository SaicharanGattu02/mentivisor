import '../../Models/OnCampouseRespModel.dart';

abstract class OncampusState {}

class GetoncamposeStateIntially extends OncampusState {}

class GetoncamposeStateLoading extends OncampusState {}

class GetoncamposeStateLoaded extends OncampusState {
  MentorOnCamposeRespModel getonCampusemodel;
  GetoncamposeStateLoaded({required this.getonCampusemodel});
}

class GetoncamposeStateFailure extends OncampusState {
  final String msg;
  GetoncamposeStateFailure({required this.msg});


}
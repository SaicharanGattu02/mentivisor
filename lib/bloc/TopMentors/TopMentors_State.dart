import 'package:mentivisor/Models/TopMentersResponseModel.dart';

abstract class TopmentorsState {}

class TopmentorStateIntially extends TopmentorsState {}

class TopmentorStateLoading extends TopmentorsState {}

class TopmentorStateLoaded extends TopmentorsState {
  Topmentersresponsemodel topmentersresponsemodel;
  TopmentorStateLoaded({required this.topmentersresponsemodel});
}

class TopmentorStateFailure extends TopmentorsState {
  final String msg;
  TopmentorStateFailure({required this.msg});


}
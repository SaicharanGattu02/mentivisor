import '../../../Models/CompusMentorListModel.dart';

abstract class CampusMentorListState {}

class CampusMentorListStateInitial extends CampusMentorListState {}

class CampusMentorListStateLoading extends CampusMentorListState {}

class CampusMentorListStateLoaded extends CampusMentorListState {
  final CompusMentorListModel campusMentorListModel;
  CampusMentorListStateLoaded({required this.campusMentorListModel});
}

class CampusMentorListStateFailure extends CampusMentorListState {
  final String msg;

  CampusMentorListStateFailure({required this.msg});
}

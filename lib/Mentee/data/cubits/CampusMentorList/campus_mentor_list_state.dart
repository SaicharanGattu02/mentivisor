import '../../../Models/CompusMentorListModel.dart';

abstract class CampusMentorListState {}

class CampusMentorListStateInitial extends CampusMentorListState {}

class CampusMentorListStateLoading extends CampusMentorListState {}

class CampusMentorListStateLoaded extends CampusMentorListState {
  final CompusMentorListModel campusMentorListModel;
  final bool hasNextPage;
  CampusMentorListStateLoaded(this.campusMentorListModel, this.hasNextPage);
}

class CampusMentorListStateFailure extends CampusMentorListState {
  final String msg;

  CampusMentorListStateFailure({required this.msg});
}

class CampusMentorListStateLoadingMore extends CampusMentorListState {
  final CompusMentorListModel campusMentorListModel;
  final bool hasNextPage;
  CampusMentorListStateLoadingMore(this.campusMentorListModel,this.hasNextPage);
}

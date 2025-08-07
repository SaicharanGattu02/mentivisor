
import '../../../Models/StudyZoneCampusModel.dart';

abstract class StudyZoneCampusState {}

class StudyZoneCampusInitial extends StudyZoneCampusState {}

class StudyZoneCampusLoading extends StudyZoneCampusState {}

class StudyZoneCampusLoaded extends StudyZoneCampusState {
  final StudyZoneCampusModel studyZoneCampusModel;
  final bool hasNextPage;

  StudyZoneCampusLoaded(this.studyZoneCampusModel, this.hasNextPage);
}

class StudyZoneCampusLoadingMore extends StudyZoneCampusState {
  final StudyZoneCampusModel studyZoneCampusModel;
  final bool hasNextPage;

  StudyZoneCampusLoadingMore(this.studyZoneCampusModel, this.hasNextPage);
}

class StudyZoneCampusFailure extends StudyZoneCampusState {
  final String message;

  StudyZoneCampusFailure({required this.message});
}

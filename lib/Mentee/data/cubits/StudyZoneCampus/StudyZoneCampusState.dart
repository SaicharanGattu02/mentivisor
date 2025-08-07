
import '../../../Models/StudyZoneCampusModel.dart';

abstract class StudyZoneCampusState {}

class StudyZoneCampusInitial extends StudyZoneCampusState {}

class StudyZoneCampusLoading extends StudyZoneCampusState {}

class StudyZoneCampusLoaded extends StudyZoneCampusState {
  final StudyZoneCampusModel studyZoneCampusModel;

  StudyZoneCampusLoaded({required this.studyZoneCampusModel});
}

class StudyZoneCampusFailure extends StudyZoneCampusState {
  final String message;

  StudyZoneCampusFailure({required this.message});
}

import '../../Models/OnCampouseRespModel.dart';

abstract class OncampusState {}

class GetbookStateIntially extends OncampusState {}

class GetbookStateStateLoading extends OncampusState {}

class GetbookStateLoaded extends OncampusState {
  MentorOnCamposeRespModel getBooksRespModel;
  GetbookStateLoaded({required this.getBooksRespModel});
}

class GetbooksStateFailure extends OncampusState {
  final String msg;
  GetbooksStateFailure({required this.msg});


}
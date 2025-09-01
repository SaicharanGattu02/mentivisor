import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class MentorProfileUpdateState {}

class MentorProfileUpdateInitial extends MentorProfileUpdateState {}

class MentorProfileUpdateLoading extends MentorProfileUpdateState {}

class MentorProfileUpdateSuccess extends MentorProfileUpdateState {
  final SuccessModel successModel;

  MentorProfileUpdateSuccess({required this.successModel});
}

class MentorProfileUpdateFailure extends MentorProfileUpdateState {
  final String message;

  MentorProfileUpdateFailure({required this.message});
}

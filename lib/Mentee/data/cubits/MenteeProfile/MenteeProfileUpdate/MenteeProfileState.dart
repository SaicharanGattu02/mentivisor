import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class MenteeProfileUpdateState {}

class MenteeProfileUpdateInitial extends MenteeProfileUpdateState {}

class MenteeProfileUpdateLoading extends MenteeProfileUpdateState {}

class MenteeProfileUpdateSuccess extends MenteeProfileUpdateState {
  final SuccessModel successModel;

  MenteeProfileUpdateSuccess({required this.successModel});
}

class MenteeProfileUpdateFailure extends MenteeProfileUpdateState {
  final String message;

  MenteeProfileUpdateFailure({required this.message});
}

import 'package:mentivisor/Mentee/Models/MenteeProfileModel.dart';

abstract class MenteeProfileState {}

class MenteeProfileInitial extends MenteeProfileState {}

class MenteeProfileLoading extends MenteeProfileState {}

class MenteeProfileLoaded extends MenteeProfileState {
  final MenteeProfileModel menteeProfileModel;
  MenteeProfileLoaded({required this.menteeProfileModel});
}

class MenteeProfileFailure extends MenteeProfileState {
  final String message;
  MenteeProfileFailure({required this.message});
}

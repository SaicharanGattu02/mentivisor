import 'package:mentivisor/Mentee/Models/MenteeProfileModel.dart';

import '../../../Models/CommonProfileModel.dart';

abstract class CommonProfileState {}

class CommonProfileInitial extends CommonProfileState {}

class CommonProfileLoading extends CommonProfileState {}

class CommonProfileLoaded extends CommonProfileState {
  final CommonProfileModel mentorProfileModel;

  CommonProfileLoaded({required this.mentorProfileModel});
}

class CommonProfileFailure extends CommonProfileState {
  final String message;

  CommonProfileFailure({required this.message});
}

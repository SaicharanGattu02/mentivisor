import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Models/MenteeModels/MentorProfileModel.dart';


abstract class MentorProfileState {}

class MentorProfileInitial extends MentorProfileState {}

class MentorProfileLoading extends MentorProfileState {}

class MentorProfileLoaded extends MentorProfileState {
  final MentorProfileModel mentorProfileModel;

  MentorProfileLoaded({required this.mentorProfileModel});
}

class MentorProfileFailure extends MentorProfileState {
  final String message;

  MentorProfileFailure({required this.message});
}

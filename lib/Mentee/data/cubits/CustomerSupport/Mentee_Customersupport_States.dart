import 'package:mentivisor/Mentee/Models/MenteeCustmor_supportModel.dart';

abstract class MenteeCustomersupportStates {}

class MenteeCustomersupportIntially extends MenteeCustomersupportStates {}

class MenteeCustomersupportLoading extends MenteeCustomersupportStates {}

class MenteeCustomersupportLoaded extends MenteeCustomersupportStates {
  final MenteeCustmor_supportModel menteeCustmor_supportModel;

  MenteeCustomersupportLoaded(this.menteeCustmor_supportModel);
}

class MenteeCustomersupportFailure extends MenteeCustomersupportStates {
  final String msg;

  MenteeCustomersupportFailure({required this.msg});
}

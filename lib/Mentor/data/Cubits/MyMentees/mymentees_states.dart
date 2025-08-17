import 'package:mentivisor/Mentor/Models/MyMenteesModel.dart';

abstract class MyMenteeStates {}

class MyMenteeInitially extends MyMenteeStates {}

class MyMenteeLoading extends MyMenteeStates {}

class MyMenteeLoaded extends MyMenteeStates {
  MyMenteesModel myMenteesModel;
  MyMenteeLoaded(this.myMenteesModel);
}

class MyMenteeFailure extends MyMenteeStates {
  String error;
  MyMenteeFailure(this.error);
}

import 'package:mentivisor/Mentor/Models/MyMenteesModel.dart';

abstract class MyMenteesStates {}

class MyMenteeInitially extends MyMenteesStates {}

class MyMenteeLoading extends MyMenteesStates {}

class MyMenteeLoaded extends MyMenteesStates {
  final MyMenteesModel myMenteesModel;
  final bool hasNextPage;

  MyMenteeLoaded(this.myMenteesModel, this.hasNextPage);
}

class MyMenteeLoadingMore extends MyMenteesStates {
  final MyMenteesModel myMenteesModel;
  final bool hasNextPage;

  MyMenteeLoadingMore(this.myMenteesModel, this.hasNextPage);
}

class MyMenteeFailure extends MyMenteesStates {
  final String error;

  MyMenteeFailure(this.error);
}

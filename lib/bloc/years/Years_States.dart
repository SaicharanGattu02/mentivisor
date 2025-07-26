import 'package:mentivisor/Models/Years_ResponseModel.dart';

abstract class YearsStates {}

class YearsStatesIntially extends YearsStates {}

class YearsStatesLoading extends YearsStates {}

class YearsStatesLoaded extends YearsStates {
  YearsResponsemodel getyearsModel;
  YearsStatesLoaded({required this.getyearsModel});
}

class YearsStatesFailure extends YearsStates {
  final String msg;
  YearsStatesFailure({required this.msg});

}
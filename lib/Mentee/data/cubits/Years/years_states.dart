import 'package:mentivisor/Mentee/Models/YearsModel.dart';

abstract class YearsStates {}

class YearsInitially extends YearsStates {}

class YearsLoading extends YearsStates {}

class YearsLoaded extends YearsStates {
  YearsModel yearsModel;
  YearsLoaded(this.yearsModel);
}

class YearsFailure extends YearsStates {
  String error;
  YearsFailure(this.error);
}

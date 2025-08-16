import 'package:mentivisor/Mentee/Models/SelectSlotModel.dart';

abstract class SelectSlotsStates {}

class SelectSlotInitially extends SelectSlotsStates {}

class SelectSlotLoading extends SelectSlotsStates {}

class SelectSlotLoaded extends SelectSlotsStates {
  SelectSlotModel selectSlotModel;
  SelectSlotLoaded(this.selectSlotModel);
}

class SelectSlotFailure extends SelectSlotsStates {
  String error;
  SelectSlotFailure(this.error);
}

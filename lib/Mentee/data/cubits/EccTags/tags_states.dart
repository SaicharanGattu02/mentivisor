import 'package:mentivisor/Mentee/Models/TagsModel.dart';

abstract class EccTagsState {}

class EccTagsInitially extends EccTagsState {}

class EccTagsLoading extends EccTagsState {}

class EccTagsLoaded extends EccTagsState {
  TagsModel tagsModel;
  EccTagsLoaded(this.tagsModel);
}

class EccTagsFailure extends EccTagsState {
  String error;
  EccTagsFailure(this.error);
}

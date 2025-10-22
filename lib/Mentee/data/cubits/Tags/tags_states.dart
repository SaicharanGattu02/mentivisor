
import '../../../Models/StudyZoneTagsModel.dart';

abstract class TagsState {}

class TagsInitially extends TagsState {}

class TagsLoading extends TagsState {}

class TagsLoaded extends TagsState {
  StudyZoneTagsModel tagsModel;
  TagsLoaded( this.tagsModel);
}

class TagsFailure extends TagsState {
  String error;
  TagsFailure(this.error);
}

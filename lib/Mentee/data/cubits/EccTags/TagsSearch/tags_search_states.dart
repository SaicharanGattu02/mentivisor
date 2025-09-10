import 'package:mentivisor/Mentee/Models/TagsModel.dart';

abstract class EccTagsSearchState {}

class EccTagsSearchInitially extends EccTagsSearchState {}

class EccTagsSearchLoading extends EccTagsSearchState {}

class EccTagsSearchLoaded extends EccTagsSearchState {
  TagsModel tagsModel;
  EccTagsSearchLoaded(this.tagsModel);
}

class EccTagsSearchFailure extends EccTagsSearchState {
  String error;
  EccTagsSearchFailure(this.error);
}

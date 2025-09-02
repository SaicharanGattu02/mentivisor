import 'package:mentivisor/Mentee/Models/TagsModel.dart';

abstract class TagsSearchState {}

class TagsSearchInitially extends TagsSearchState {}

class TagsSearchLoading extends TagsSearchState {}

class TagsSearchLoaded extends TagsSearchState {
  TagsModel tagsModel;
  TagsSearchLoaded(this.tagsModel);
}

class TagsSearchFailure extends TagsSearchState {
  String error;
  TagsSearchFailure(this.error);
}

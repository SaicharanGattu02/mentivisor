import 'package:mentivisor/Mentee/Models/CommunityZoneTagsModel.dart';

abstract class CommunityTagsStates {}

class CommunityTagsInitially extends CommunityTagsStates {}

class CommunityTagsLoading extends CommunityTagsStates {}

class CommunityTagsFailure extends CommunityTagsStates {
  final String error;
  CommunityTagsFailure(this.error);
}

class CommunityTagsLoaded extends CommunityTagsStates {
  final List<String> allTags;
  final List<String> selectedTags;

  CommunityTagsLoaded({
    required this.allTags,
    required this.selectedTags,
  });

  CommunityTagsLoaded copyWith({
    List<String>? allTags,
    List<String>? selectedTags,
  }) {
    return CommunityTagsLoaded(
      allTags: allTags ?? this.allTags,
      selectedTags: selectedTags ?? this.selectedTags,
    );
  }
}

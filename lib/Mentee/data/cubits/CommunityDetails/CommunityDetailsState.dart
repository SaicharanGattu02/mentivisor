
import '../../../Models/CommunityDetailsModel.dart';


abstract class CommunityDetailsState {}

class CommunityDetailsInitially extends CommunityDetailsState {}

class CommunityDetailsLoading extends CommunityDetailsState {}

class CommunityDetailsLoaded extends CommunityDetailsState {
  final CommunityDetailsModel communityDetailsModel;

  CommunityDetailsLoaded({required this.communityDetailsModel});
}

class CommunityDetailsFailure extends CommunityDetailsState {
  final String message;

  CommunityDetailsFailure({required this.message});
}

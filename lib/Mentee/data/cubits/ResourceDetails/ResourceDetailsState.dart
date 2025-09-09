
import '../../../Models/ResourceDetailsModel.dart';
import '../../../Models/StudyZoneCampusModel.dart';

abstract class ResourceDetailsState {}

class ResourceDetailsInitially extends ResourceDetailsState {}

class ResourceDetailsLoading extends ResourceDetailsState {}

class ResourceDetailsLoaded extends ResourceDetailsState {
  final ResourceDetailsModel resourceDetailsModel;

  ResourceDetailsLoaded({required this.resourceDetailsModel});
}

class ResourceDetailsFailure extends ResourceDetailsState {
  final String message;

  ResourceDetailsFailure({required this.message});
}

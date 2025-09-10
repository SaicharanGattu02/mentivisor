
import '../../../Models/ViewEccDetailsModel.dart';

abstract class ViewEventDetailsState {}

class ViewEventDetailsInitially extends ViewEventDetailsState {}

class ViewEventDetailsLoading extends ViewEventDetailsState {}

class ViewEventDetailsLoaded extends ViewEventDetailsState {
  final ViewEccDetailsModel viewEccDetailsModel;

  ViewEventDetailsLoaded({required this.viewEccDetailsModel});
}

class ViewEventDetailsFailure extends ViewEventDetailsState {
  final String message;

  ViewEventDetailsFailure({required this.message});
}

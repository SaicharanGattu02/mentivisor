import '../../../Models/GuestMentorsModel.dart';

abstract class GuestMentorsState {}

class GuestMentorsInitial extends GuestMentorsState {}

class GuestMentorsLoading extends GuestMentorsState {}

class GuestMentorsLoaded extends GuestMentorsState {
  final GuestMentorsModel guestMentorsModel;
  GuestMentorsLoaded({required this.guestMentorsModel});
}

class GuestMentorsFailure extends GuestMentorsState {
  final String msg;
  GuestMentorsFailure({required this.msg});
}

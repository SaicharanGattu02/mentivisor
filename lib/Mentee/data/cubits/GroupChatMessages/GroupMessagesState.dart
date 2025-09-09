import '../../../Models/GroupChatMessagesModel.dart';

abstract class GroupMessagesState {}

class GroupMessagesInitial extends GroupMessagesState {}

class GroupMessagesLoading extends GroupMessagesState {}

class GroupMessagesLoaded extends GroupMessagesState {
  final GroupChatMessagesModel chat;
  final bool hasNextPage;
  GroupMessagesLoaded(this.chat, this.hasNextPage);
}

class GroupMessagesLoadingMore extends GroupMessagesState {
  final GroupChatMessagesModel chat;
  final bool hasNextPage;
  GroupMessagesLoadingMore(this.chat, this.hasNextPage);
}

class GroupMessagesFailure extends GroupMessagesState {
  final String message;
  GroupMessagesFailure(this.message);
}

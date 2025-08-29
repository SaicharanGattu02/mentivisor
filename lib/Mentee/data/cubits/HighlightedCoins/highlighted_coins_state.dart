import '../../../Models/HighlatedCoinsModel.dart';

abstract class HighlightedCoinsState {
}

class GetHighlightedCoinsIntially extends HighlightedCoinsState {
}

class GetHighlightedCoinsLoading extends HighlightedCoinsState {
}

class GetHighlightedCoinsLoaded extends HighlightedCoinsState {
  HighlightedCoinsModel highlightedCoinsModel;
  GetHighlightedCoinsLoaded({required this.highlightedCoinsModel});
}

class GetHighlightedCoinsFailure extends HighlightedCoinsState {
  final String msg;
  GetHighlightedCoinsFailure({required this.msg});
}
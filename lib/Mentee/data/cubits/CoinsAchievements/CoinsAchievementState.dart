import '../../../../Mentor/Models/CoinsAchievementModel.dart';

abstract class CoinsAchievementState {}

class CoinsAchievementIntially extends CoinsAchievementState {}

class CoinsAchievementLoading extends CoinsAchievementState {}

class CoinsAchievementLoaded extends CoinsAchievementState {
  final CoinsAchievementModel coinsAchievementModel;
  final bool hasNextPage;
  CoinsAchievementLoaded(this.coinsAchievementModel, this.hasNextPage);
}

class CoinsAchievementLoadingMore extends CoinsAchievementState {
  final CoinsAchievementModel coinsAchievementModel;
  final bool hasNextPage;
  CoinsAchievementLoadingMore(this.coinsAchievementModel, this.hasNextPage);
}

class CoinsAchievementFailure extends CoinsAchievementState {
  final String msg;
  CoinsAchievementFailure({required this.msg});
}

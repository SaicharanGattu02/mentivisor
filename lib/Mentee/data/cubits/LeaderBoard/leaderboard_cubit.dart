import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/LeaderBoard/leaderboard_repo.dart';
import 'package:mentivisor/Mentee/data/cubits/LeaderBoard/leaderboard_states.dart';

class LeaderboardCubit extends Cubit<LeaderBoardStates> {
  LeaderBoardRepo leaderBoardRepo;
  LeaderboardCubit(this.leaderBoardRepo) : super(LeaderBoardInitially());

  Future<void> getLeaderBoard(String college) async {
    emit(LeaderBoardLoading());
    try {
      final response = await leaderBoardRepo.getLeaderBoard(college);
      if (response != null && response.status == true) {
        emit(LeaderBoardLoaded(response));
      } else {
        emit(LeaderBoardFailure("Fetching leaderboard Failed!"));
      }
    } catch (e) {
      emit(
        LeaderBoardFailure(
          "Fetching leaderboard Failed and throwing exception!",
        ),
      );
    }
  }
}

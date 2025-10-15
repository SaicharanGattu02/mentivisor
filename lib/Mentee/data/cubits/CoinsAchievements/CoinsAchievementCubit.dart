import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Mentor/Models/CoinsAchievementModel.dart';
import '../WalletMoney/Walletmoney_Repository.dart';
import 'CoinsAchievementState.dart';

class CoinsAchievementCubit extends Cubit<CoinsAchievementState> {
  final WalletmoneyRepository walletmoneyRepository; // Using same repo for now

  CoinsAchievementCubit(this.walletmoneyRepository)
    : super(CoinsAchievementIntially());

  CoinsAchievementModel coinsAchievementModel = CoinsAchievementModel();

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  Future<void> getCoinsAchievements(int id) async {
    emit(CoinsAchievementLoading());
    _currentPage = 1;

    try {
      final res = await walletmoneyRepository.getCoinsAchievements(
        _currentPage,
      );
      if (res != null) {
        coinsAchievementModel = res;
        _hasNextPage = res.achievement?.nextPageUrl != null;
        emit(CoinsAchievementLoaded(coinsAchievementModel, _hasNextPage));
      } else {
        emit(CoinsAchievementFailure(msg: "No data found."));
      }
    } catch (e) {
      emit(CoinsAchievementFailure(msg: "An error occurred: $e"));
    }
  }

  /// 🔹 Load more (pagination)
  Future<void> fetchMoreCoinsAchievements(int id) async {
    if (_isLoadingMore || !_hasNextPage) return;
    _isLoadingMore = true;
    _currentPage++;

    emit(CoinsAchievementLoadingMore(coinsAchievementModel, _hasNextPage));

    try {
      final newRes = await walletmoneyRepository.getCoinsAchievements(
        _currentPage,
      );

      if (newRes != null && newRes.achievement?.data?.isNotEmpty == true) {
        // Combine old + new data
        final combinedData = List<Data>.from(
          coinsAchievementModel.achievement?.data ?? [],
        )..addAll(newRes.achievement!.data!);

        // Updated Achievement object
        final updatedAchievement = Achievement(
          currentPage: newRes.achievement?.currentPage,
          data: combinedData,
          firstPageUrl: newRes.achievement?.firstPageUrl,
          from: newRes.achievement?.from,
          lastPage: newRes.achievement?.lastPage,
          lastPageUrl: newRes.achievement?.lastPageUrl,
          links: newRes.achievement?.links,
          nextPageUrl: newRes.achievement?.nextPageUrl,
          path: newRes.achievement?.path,
          perPage: newRes.achievement?.perPage,
          prevPageUrl: newRes.achievement?.prevPageUrl,
          to: newRes.achievement?.to,
          total: newRes.achievement?.total,
        );

        // Updated CoinsAchievementModel
        coinsAchievementModel = CoinsAchievementModel(
          status: newRes.status,
          message: newRes.message,
          achievement: updatedAchievement,
        );

        _hasNextPage = newRes.achievement?.nextPageUrl != null;
        emit(CoinsAchievementLoaded(coinsAchievementModel, _hasNextPage));
      }
    } catch (e) {
      emit(CoinsAchievementFailure(msg: e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }
}

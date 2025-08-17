import 'package:flutter_bloc/flutter_bloc.dart';
import 'WalletMoney_State.dart';
import 'Walletmoney_Repository.dart';
import '../../../Models/WalletModel.dart';

class WalletmoneyCubit extends Cubit<WalletmoneyState> {
  final WalletmoneyRepository walletmoneyRepository;

  WalletmoneyCubit(this.walletmoneyRepository)
      : super(WalletmoneyStateIntially());

  WalletModel walletModel = WalletModel();

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  /// 🔹 First call (reset pagination)
  Future<void> getWallet(int id) async {
    emit(WalletmoneyStateLoading());
    _currentPage = 1;
    try {
      final res = await walletmoneyRepository.getWallet(id, _currentPage);
      if (res != null) {
        walletModel = res;
        _hasNextPage = res.data?.transactions?.nextPageUrl != null;
        emit(WalletmoneyStateLoaded(walletModel, _hasNextPage));
      } else {
        emit(WalletmoneyStateFailure(msg: "No data found."));
      }
    } catch (e) {
      emit(WalletmoneyStateFailure(msg: "An error occurred: $e"));
    }
  }

  /// 🔹 Fetch more (pagination)
  Future<void> fetchMoreWallet(int id) async {
    if (_isLoadingMore || !_hasNextPage) return;
    _isLoadingMore = true;
    _currentPage++;
    emit(WalletmoneyStateLoadingMore(walletModel, _hasNextPage));
    try {
      final newData = await walletmoneyRepository.getWallet(id, _currentPage);
      if (newData != null &&
          newData.data?.transactions?.transectionsData?.isNotEmpty == true) {
        final combinedList = List<TransectionsData>.from(
          walletModel.data?.transactions?.transectionsData ?? [],
        )..addAll(newData.data!.transactions!.transectionsData!);

        final updatedTransactions = Transactions(
          currentPage: newData.data?.transactions?.currentPage,
          transectionsData: combinedList,
          firstPageUrl: newData.data?.transactions?.firstPageUrl,
          from: newData.data?.transactions?.from,
          lastPage: newData.data?.transactions?.lastPage,
          lastPageUrl: newData.data?.transactions?.lastPageUrl,
          links: newData.data?.transactions?.links,
          nextPageUrl: newData.data?.transactions?.nextPageUrl,
          path: newData.data?.transactions?.path,
          perPage: newData.data?.transactions?.perPage,
          prevPageUrl: newData.data?.transactions?.prevPageUrl,
          to: newData.data?.transactions?.to,
          total: newData.data?.transactions?.total,
        );

        final updatedData = Data(
          wallet: newData.data?.wallet ?? walletModel.data?.wallet,
          transactions: updatedTransactions,
        );

        walletModel = WalletModel(
          status: newData.status,
          data: updatedData,
        );

        _hasNextPage = newData.data?.transactions?.nextPageUrl != null;
        emit(WalletmoneyStateLoaded(walletModel, _hasNextPage));
      }
    } catch (e) {
      emit(WalletmoneyStateFailure(msg: e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }
}

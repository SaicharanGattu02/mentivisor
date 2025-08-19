import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/MyMentees/mymentees_repository.dart';
import 'package:mentivisor/Mentor/Models/MyMenteesModel.dart';
import 'mymentees_states.dart';

class MyMenteeCubit extends Cubit<MyMenteesStates> {
  final MyMenteesRepo myMenteesRepo;

  MyMenteeCubit(this.myMenteesRepo) : super(MyMenteeInitially());

  MyMenteesModel myMenteesModel = MyMenteesModel();

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  Future<void> getMyMentees() async {
    emit(MyMenteeLoading());
    _currentPage = 1;
    try {
      final response = await myMenteesRepo.getMyMentees(_currentPage);
      if (response != null && response.status == true) {
        myMenteesModel = response;
        _hasNextPage = response.data?.nextPageUrl != null;
        emit(MyMenteeLoaded(myMenteesModel, _hasNextPage));
      } else {
        emit(MyMenteeFailure(response?.message ?? "No data available"));
      }
    } catch (e) {
      emit(MyMenteeFailure("Error occurred while fetching mentees: ${e.toString()}"));
    }
  }

  Future<void> getMoreMyMentees() async {
    if (_isLoadingMore || !_hasNextPage) return;
    _isLoadingMore = true;
    _currentPage++;
    emit(MyMenteeLoadingMore(myMenteesModel, _hasNextPage));
    try {
      final newData = await myMenteesRepo.getMyMentees(_currentPage);
      if (newData != null && newData.data?.menteeData != null && newData.data!.menteeData!.isNotEmpty) {
        final combinedList = List<MenteeData>.from(myMenteesModel.data?.menteeData ?? [])
          ..addAll(newData.data!.menteeData!);

        myMenteesModel = MyMenteesModel(
          status: newData.status,
          message: newData.message,
          data: Data(
            currentPage: newData.data?.currentPage,
            menteeData: combinedList,
            firstPageUrl: newData.data?.firstPageUrl,
            from: newData.data?.from,
            lastPage: newData.data?.lastPage,
            lastPageUrl: newData.data?.lastPageUrl,
            links: newData.data?.links,
            nextPageUrl: newData.data?.nextPageUrl,
            path: newData.data?.path,
            perPage: newData.data?.perPage,
            prevPageUrl: newData.data?.prevPageUrl,
            to: newData.data?.to,
            total: newData.data?.total,
          ),
        );
        _hasNextPage = newData.data?.nextPageUrl != null;
        emit(MyMenteeLoaded(myMenteesModel, _hasNextPage));
      }
    } catch (e) {
      emit(MyMenteeFailure("Error occurred while fetching more mentees: ${e.toString()}"));
    } finally {
      _isLoadingMore = false;
    }
  }
}

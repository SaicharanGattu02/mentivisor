import 'package:flutter_bloc/flutter_bloc.dart';
import '../CommunityPosts/CommunityPostsRepository.dart';
import 'CommunityZoneReportState.dart';

class CommunityZoneReportCubit extends Cubit<CommunityZoneReportState> {
  final CommunityPostsRepo communityPostsRepo;

  CommunityZoneReportCubit(this.communityPostsRepo)
    : super(CommunityZoneReportInitial());

  Future<void> postCommunityZoneReport(Map<String, dynamic> data) async {
    emit(CommunityZoneReportLoading());
    try {
      final res = await communityPostsRepo.communityZoneReport(data);
      if (res != null && res.status == true) {
        emit(CommunityZoneReportSuccess(res));
      } else {
        emit(
          CommunityZoneReportFailure(message: res?.message ?? "Login failed"),
        );
      }
    } catch (e) {
      emit(CommunityZoneReportFailure(message: "An error occurred: $e"));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Models/GetExpertiseModel.dart';
import '../expertise_repository.dart';
import 'expertise_sub_category_state.dart';

class ExpertiseSubCategoryCubit extends Cubit<ExpertiseSubCategoryStates> {
  final ExpertiseRepo expertiseRepo;
  ExpertiseSubCategoryCubit(this.expertiseRepo)
    : super(ExpertiseSubCategoryInitial());

  GetExpertiseModel expertiseModel = GetExpertiseModel();

  Future<void> getExpertiseSubCategories(int id) async {
    emit(ExpertiseSubCategoryLoading());

    try {
      final response = await expertiseRepo.getExpertiseSubCategory(id);

      if (response != null && response.status == true) {
        emit(ExpertiseSubCategoryLoaded(expertiseModel));
      } else {
        emit(ExpertiseSubCategoryFailure("Something went wrong"));
      }
    } catch (e) {
      emit(ExpertiseSubCategoryFailure(e.toString()));
    }
  }
}

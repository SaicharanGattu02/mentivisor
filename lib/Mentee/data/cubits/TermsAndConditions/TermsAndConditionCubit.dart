import 'package:flutter_bloc/flutter_bloc.dart';

import 'TermsAndConditionRepo.dart';
import 'TermsAndConditionStates.dart';

class TermsAndConditionCubit extends Cubit<TermsAndConditionStates> {
  final TermsAndConditionRepo termsAndConditionRepo;

  TermsAndConditionCubit(this.termsAndConditionRepo)
      : super(TermsAndConditionInitial());

  Future<void> getTermsAndCondition() async {
    try {
      emit(TermsAndConditionLoading());

      final response =
      await termsAndConditionRepo.getTermsAndCondition();

      if (response != null && response.status == true) {
        emit(TermsAndConditionLoaded(response));
      } else {
        emit(TermsAndConditionFailure("Something went wrong"));
      }
    } catch (e) {
      emit(TermsAndConditionFailure("Failed to load terms & conditions!"));
    }
  }
}
